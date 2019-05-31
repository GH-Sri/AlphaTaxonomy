ME=$(basename $0)

start_deploy () {
  #Get resources created by terraform
  api_name=$(terraform output -module=api api_gateway_id)
  deploy_token=$(terraform output -module=data deploy_token)
  at_website_bucket=$(terraform output -module=s3 at_website_bucket)
  curl -X POST http://jenkins.apps.openshift-nonprod.gh-mdas.com/job/ui-deploy-params/buildWithParameters \
	    --user admin:$deploy_token  \
	      --data-urlencode DEPLOY_BUCKET="${at_website_bucket}" \
                --data-urlencode ENDPOINT="${api_name}"
  echo "Waiting on build of site"
  sleep 4m
  aws s3 sync s3://at-mdas-website-storage/ s3://${at_website_bucket}/
}

output_links () {
  #Get resources created by terraform run for inspection
  db_link=$(terraform output -module=rds glue_db_endpoint)
  db_password=$(terraform output -module=rds glue_db_password)
  db_username=$(terraform output -module=rds glue_db_username)
  db_name=$(terraform output -module=rds glue_db_name)
  s3_website=$(terraform output -module=s3 at_website)
  at_website_bucket=$(terraform output -module=s3 at_website_bucket)
  jupiter_notebook=$(terraform output -module=sagemaker sagemaker_instance_name)
  default_region=$(terraform output -module=data default_region)
  data_viz=$(terraform output -module=data data_viz)
  printf "GLUE DB: ${db_link} \nDB NAME: ${db_name} \nUSERNAME: ${db_username} \nPASSWORD: ${db_password}\n"
  printf "WEBSITE: ${data_viz}\n"
  echo "JUPITER NOTEBOOK: https://${jupiter_notebook}.notebook.${default_region}.sagemaker.aws/notebooks/data-science-notebook/NLP%20Pipeline%20Notebook.ipynb"
}

setup_sagemaker () {
  #Setup variables based on terraform run
  repo_url=$(terraform output -module=sagemaker sagemaker_github_url)
  sagemaker_arn=$(terraform output -module=sagemaker sagemaker_secret_arn)
  sagemaker_name=$(terraform output -module=sagemaker sagemaker_instance_name)
  sagemaker_role=$(terraform output -module=sagemaker sagemaker_role_arn)
  #Setup github repo
  aws sagemaker list-code-repositories --output text | grep data-notebook
  RESULT=$?
  if [ $RESULT -eq 1 ]
  then
    aws sagemaker create-code-repository --code-repository-name 'data-notebook' --git-config RepositoryUrl="$repo_url",Branch='master',SecretArn="$sagemaker_arn"
  fi
  #Setup notebook instance
  #Creating t2.ml.medium because of restrictions on fresh AWS account, would recommend ml.m4.4xlarge if the request to AWS to allow that instance type has been made
  aws sagemaker list-notebook-instances --output text | grep ${sagemaker_name}
  RESULT=$?
  if [ $RESULT -eq 1 ]
  then
    aws sagemaker create-notebook-instance --notebook-instance-name ${sagemaker_name} --instance-type 'ml.t2.medium' --default-code-repository 'data-notebook' --volume-size-in-gb 10 --role-arn ${sagemaker_role}
  fi
}
#Check to make sure everything needed to run the script exists
check_requirements () {
  #TODO: Check to make sure terraform is version 0.11.12 or greater
  dependency_array=(
  aws
  terraform
  printf
  zip
  unzip
  )
  echo 'Checking script dependencies'
  for item in "${dependecy_array[@]}"
  do
    if command -v $item
    then
      echo "Exists: $item"
    else
      echo "Missing: $item please install required software"
      exit 1
    fi
  done
  echo 'Checking terraform version'
  if terraform -v | grep 0.11.1[2-4]
  then
    echo "Terraform version compatible"
  else
    echo "Terraform version not compatible, visit https://releases.hashicorp.com/terraform/ and use version 0.11.12 - 0.11.14"
    exit 1
  fi
  if [ -z "$AWS_ACCESS_KEY_ID" ]
  then
    echo "Please set the environment variable AWS_ACCESS_KEY_ID"
    exit 1
  fi
  if [ -z "$AWS_SECRET_ACCESS_KEY" ]
  then
    echo "Please set the environment variable AWS_SECRET_ACCESS_KEY"
  fi 
}

#Sets up AWS Lambda
setup_lambda () {
  #Lambda scripts to package
  lambda_array=(
  get-companyinfo
    get-competitorinfo-by-company
    get-sectorindustryweights
    get-words-by-industry
    get-detailedcompanylist
    get-companylist
    get-industryweights-by-company
    get-sectorweights-by-company
    get-words-by-sector
    s3-trigger-etl-jobs
  )
  #Syncs down lambda scripts from S3
  aws s3 sync s3://at-mdas-code/ aws_lambda/
  for item in "${lambda_array[@]}"
  do
    if [ -f "aws_lambda/${item}.zip" ]
    then
      rm -f "aws_lambda/${item}.zip"
    fi
    #Packages zips for lambda deployment
    cd "aws_lambda/${item}" ; zip -r "../../aws_lambda/${item}.zip" "./"
    cd ../..
  done
}

#Sets up AWS Glue
setup_glue () {
  #Source of glue scripts
  glue_source='aws-glue-scripts-375630183866-us-east-1'
  #List of glue scripts to grab
  glue_array=(
    HistoricalStockPriceDataAllExchanges_csv 
    company_sector_industry_csv 
    industry_name_csv 
    sector_words_csv
    companylist_csv
    industry_weights_csv
    sector_name_csv
    cleaned_data_agg_csv
    competitors_csv
    industry_words_csv
    sector_weights_csv
  )
  
  #Check to make sure directory we want to write to exists
  if [ ! -d 'aws_glue/glue_scripts' ]
  then
    mkdir 'aws_glue/glue_scripts'
  fi
  
  #Grab scripts for AWS Glue
  for item in "${glue_array[@]}"
  do
    aws s3 cp "s3://${glue_source}/${item}" ./aws_glue/glue_scripts/ 
  done
  
  #Sync scripts to new glue bucket
  glue_bucket=$(terraform output -module=s3 glue_script_bucket)
  aws s3 sync ./aws_glue/glue_scripts/ "s3://${glue_bucket}/"
}

#Outputs how to run the script
help () {
  echo "This script provisions an AWS environment from a fresh AWS account. As such it makes some assumptions about the state of the account. Given the service limits on "
  echo "new accounts there are restrictions on the number and size of instances for services that we can spin up such as nothing larger than ml.t2.medium for SageMaker etc."
  echo "The script expects you to have exported the key you made in your AWS account in the typical format of AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables"
  echo "The key you create should have the aws managed policy with the following arn attached to the user arn:aws:iam::aws:policy/AdministratorAccess"
  echo
  echo "Usage: This script takes a single argument with three four options ex. ${ME} start"
  echo "start: the recommended option, runs the quick start and sets up the environment and prints out all the useful resource endpoints"
  echo "start_long: completely redoes all the data involved in the whole process, which given the size limitations on the instances takes quite some time to complete."
  echo "destroy: completely tears down all infrastructure stood up with this script as well as does cleanup of buckets to help terraform destroy easier, occasionally terraform does get stuck so running destroy again should fix it"
  echo "help: where you are now, displays the arguments to the script and some information"
  echo "generate_presigned: Creates a temporary login token that will allow access to the notebook for 5 minutes from creation for 12 hours. Will not link directly to notebook but will allow access for those without aws credentials to follow the link"
}

sync_bucket () {
  at_data=$(terraform output -module=s3 at_data_bucket)
  aws s3 sync s3://at-mdas-data/ s3://${at_data}/
}

#Assists terraform by preping for teardown
destroy_all () {
  notebook_instance=$(terraform output -module=sagemaker sagemaker_instance_name)
  at_website=$(terraform output -module=s3 at_website_bucket)
  at_data=$(terraform output -module=s3 at_data_bucket)
  glue_scripts=$(terraform output -module=s3 glue_script_bucket)
  bucket_list=(
    $at_website
    $at_data
    $glue_scripts
  )
  for item in "${bucket_list}"
  do
    aws s3 rm s3://${item}/ --recursive
  done
  aws sagemaker delete-notebook-instance --notebook-instance-name ${notebook_instance}
  aws sagemaker delete-code-repository --code-repository-name 'data-notebook' 
  terraform destroy
}

create_presign () {
  notebook_instance=$(terraform output -module=sagemaker sagemaker_instance_name)
  aws sagemaker create-presigned-notebook-instance-url --notebook-instance-name ${notebook_instance}
}

#Runs the shortened deployment without data processing
start_short () {
  #Checks required software
  check_requirements
  #Gets files needed for lambda creation
  setup_lambda
  
  #Runs the deployment of AWS resources
  terraform init
  terraform plan
  terraform apply -auto-approve
  setup_glue
  setup_sagemaker
  start_deploy
  #Outputs useful resource info
  sync_bucket
  output_links
}

#Runs the whole environment setup 
start_long () {
  echo 'hi'
}

#Start
case $1 in
  start)
    start_short
  ;;
  start_long)
    start_long
  ;;
  destroy)
    destroy_all
  ;;
  help)
    help
  ;;
  generate_presigned)
    create_presign
  ;;
  *)
    echo "Unknown option, for help run $ME help"
  ;;
esac
