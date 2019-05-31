import sys
import csv

if __name__ == '__main__':

    companysic = {}

    with open(sys.argv[2]) as companylistfile:
        companylist = csv.DictReader(companylistfile)
        
        for company in companylist:
            companysic[company['Name']] = company['SIC']
        
    sectors = set(range(1, 11))

    with open(sys.argv[1]) as companysectorindustryfile:
        companysectorreader = csv.DictReader(companysectorindustryfile)
        
        for company in companysectorreader:
            name = company['Name']
            sector = int(company['Sector'])
            
            for cname, sic in companysic.items():
                if name in cname or cname in name:
                    with open('Sector{sector}-company-list.txt'.format(
                            sector=sector), mode='a+') as f:
                        if not sic:
                            sic = 0
    
                        f.write('{name}, {sic}\n'.format(name=name, sic=sic))
