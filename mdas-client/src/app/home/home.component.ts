import { Component, OnInit, HostListener, ViewChild } from '@angular/core';
import { MatSort, MatTableDataSource } from '@angular/material';
import { Router } from '@angular/router';
import { CompanyListService } from './company-list.service';
import { CompanyOverview } from '../company-overview/company-overview';
import { SectorIndustryWeight } from './sector-industry-weight';
import { TreemapService } from './treemap.service';

export interface MaterialDatatable {
    sector: string;
    name: string;
    marketcap: string;
    companycount: number;
}

const ELEMENT_DATA: MaterialDatatable[] = [
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
    { sector: "Sector 9", name: "Industry 86", marketcap: "$1,315,961,533,575.11", companycount: 55 },
];


@Component({
    selector: 'app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

    //glue fields
    displayCompanyList: boolean = false;
    displayTreeMap: boolean = false;

    //datatable fields
    companies: CompanyOverview[];
    cols: any[];
    selectedCompany: CompanyOverview;

    //Material datatable
    displayedColumns: string[] = ['sector', 'name', 'marketcap', 'companycount'];
    // dataSource = new MatTableDataSource(ELEMENT_DATA);

    @ViewChild(MatSort) sort: MatSort;

    //treemap fields
    title = 'SECTOR / INDUSTRY';
    type = 'TreeMap';
    windowOffset = .9;
    // width = window.innerWidth * this.windowOffset;
    // height = 600;

    data = [
        ["Sectors", "null", 0, 0]
    ];
    //dataSource = new MatTableDataSource(this.data);

    //columnNames = ["Industry", "Sector", "Market trade volume (size)", "Market increase/decrease (color)"];
    options = {
        headerHeight: 30,
        highlightOnMouseOver: true,
        maxDepth: 1,
        maxPostDepth: 1,
        maxColor: '#676767',
        midColor: '#296b7d',
        minColor: '#46b6d5',
        // colors: ['#676767', '#296b7d', '#33869d', '#41abc8'],
        // maxHighlightColor: '#edf8fb',
        // midHighlightColor: '#9ebcda',
        // minHighlightColor: '#8c6bb1',
        showScale: false,
        showTooltips: true,
        textStyle: {
            color: '#000',
            fontName: 'Verdana',
            fontSize: '20px',
            bold: true,
            italic: false
        },
        titleTextStyle: {
            color: '#32f5de',
            fontName: 'Times New Roman',
            fontSize: '50px',
            bold: true,
            italic: false
        },
        useWeightedAverageForAggregation: true,
        width: window.innerWidth * this.windowOffset, // Google Chart Variable
        height: 600,
    };

    @ViewChild('companyTable')
    table: any;

    sectorIndustryWeights: SectorIndustryWeight[];

    sectorKeys: any[] = [];
    industryKeys: any[] = [];

    selections: any[] = [0];
    lastSelection: any;

    constructor(
        private companyService: CompanyListService,
        private treemapService: TreemapService,
        private router: Router) {
    }
    dataSource = new MatTableDataSource(ELEMENT_DATA);

    ngOnInit() {
        //initialize Material Sort
        this.dataSource.sort = this.sort;

        //initialize treemap
        this.treemapService.getData().then(sectorIndustryWeights => {
            this.data = [
                ["Sectors", null, 0, 0]
            ];
            this.sectorIndustryWeights = sectorIndustryWeights;
            // this.sectorKeys = [];
            // this.industryKeys = [];
            // let companyArray = [];
            // for (let sectorIndustryWeight of this.sectorIndustryWeights) {
            //     if (!this.sectorKeys.includes(sectorIndustryWeight.sector)) {
            //         this.sectorKeys.push(sectorIndustryWeight.sector);
            //         this.data.push([sectorIndustryWeight.sector, "Sectors", sectorIndustryWeight.sectorweight, 0]);
            //     }
            //     if (!this.industryKeys.includes(sectorIndustryWeight.industry)) {
            //         this.industryKeys.push(sectorIndustryWeight.industry);
            //         this.data.push([sectorIndustryWeight.industry, sectorIndustryWeight.sector, sectorIndustryWeight.industryweight, 0]);
            //     }
            //     let marketcap = sectorIndustryWeight.marketcap;
            //     marketcap = marketcap.replace(/[$,]+/g, "");
            //     marketcap = parseInt(marketcap);
            //     this.data.push([sectorIndustryWeight.company, sectorIndustryWeight.industry, marketcap, 0]);
            // }

            console.log("API Call");
            console.log(this.sectorIndustryWeights);
            var dataNew = [];
            for (let count in this.sectorIndustryWeights) {
                var marketcap = Number(this.sectorIndustryWeights[count].marketcap.replace(/[^0-9.-]+/g, ""));
                dataNew[count] = [
                    this.sectorIndustryWeights[count].name,
                    this.sectorIndustryWeights[count].sector,
                    marketcap,
                    marketcap
                ];
            }
            dataNew.unshift(
                ["Sectors", null, 0, 0],
                ["Sector 1", "Sectors", 0, 0],
                ["Sector 2", "Sectors", 0, 0],
                ["Sector 3", "Sectors", 0, 0],
                ["Sector 4", "Sectors", 0, 0],
                ["Sector 5", "Sectors", 0, 0],
                ["Sector 6", "Sectors", 0, 0],
                ["Sector 7", "Sectors", 0, 0],
                ["Sector 8", "Sectors", 0, 0],
                ["Sector 9", "Sectors", 0, 0],
                ["Sector 10", "Sectors", 0, 0]);

            this.data = dataNew;
            console.log("Formatted Data");
            console.log(this.data);
        });

        //initialize table
        this.companies = [];
        this.companyService.getCompanyList().then(companies => {
            console.log(companies);
            this.companies = companies;
            this.cols = [
                { field: 'name', header: 'Name' },
                { field: 'sector', header: 'Sector' },
                { field: 'industry', header: 'Industry' },
                { field: 'marketcap', header: 'Market Cap' }
            ];
            console.log(this.companies);

            // Material Table Columns
            //tableColumns = ['name', 'sector', 'industry'];
        });
    }

    // Responsive Treemap
    // @HostListener('window:resize', ['$event'])
    // onResize(event, options) {
    //     if (event) {
    //         // options.width = window.innerWidth * this.windowOffset;
    //         // options["width"] = ["" + window.innerWidth * this.windowOffset + ""];
    //     }
    // }

    onRowSelect(event) {
        this.router.navigate(['company', this.selectedCompany.name]);
    }

    //Treemap methods

    //event[0].row = the node number. Get the company name from here
    onSelect(event) {
        let rowIndex = event[0].row;
        if (this.lastSelection == rowIndex) {
            // go to table
            let filterField = '';
            if (this.selections.length == 1) {
                filterField = 'sector';
            }
            else if (this.selections.length == 2) {
                filterField = 'industry';
            }
            if (filterField != '') {
                let value = this.data[rowIndex][0]
                console.log(this.table);
                this.displayCompanyList = true;
            }
        }
        else {
            //need to add an element to selections if we left-clicked, remove one if right-clicked
            if (this.selections.includes(rowIndex)) {
                let x = this.selections.pop();
                console.log('pop ' + x)
            }
            else {
                this.selections.push(rowIndex);
                this.lastSelection = rowIndex;
                console.log('push ' + rowIndex);
            }
            let nameIndex = 0;
            let parentIndex = 1;
            console.log(this.data[rowIndex][nameIndex] + " = " + this.data[rowIndex][parentIndex]);
            if (this.industryKeys.includes(this.data[rowIndex][parentIndex])) {
                let companyName = this.data[rowIndex][nameIndex];
                this.router.navigate(['company', companyName]);
            }
        }
    }


    showDialog() {
        this.displayCompanyList = true;
    }

    showTreeMap() {
        this.displayTreeMap = true;
    }




}
