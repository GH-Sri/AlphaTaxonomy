
First run ``` helm install --name jenkins -f ./values.yaml stable/jenkins```

Then run ```kubectl create -f service-account.yaml``` and ```kubectl create -f ingress.yaml```

```oc adm policy add-scc-to-user anyuid system:serviceaccount:myproject:mysvcacct```
```oc adm policy add-scc-to-user privileged -nmanagement -z jenkins```

Get the admin pass by running: ```printf $(kubectl get secret --namespace management jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo```
