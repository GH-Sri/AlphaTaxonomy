import sys
import csv

if __name__ == '__main__':

    companysic = {}

    with open(sys.argv[2]) as companylistfile:
        companylist = csv.DictReader(companylistfile)
        
        for company in companylist:
            companysic[company['Name']] = company['SIC']
        
    industrys = set(range(1, 101))

    with open(sys.argv[1]) as companysectorindustryfile:
        companyindustryreader = csv.DictReader(companysectorindustryfile)
        
        for company in companyindustryreader:
            name = company['Name']
            industry = int(company['Industry'])
            
            for cname, sic in companysic.items():
                if name in cname or cname in name:
                    with open('Industry{industry}-company-list.txt'.format(
                            industry=industry), mode='a+') as f:
                        if not sic:
                            sic = 0
    
                        f.write('{name}, {sic}\n'.format(name=name, sic=sic))
