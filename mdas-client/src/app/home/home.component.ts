import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

    displayCompanyList: boolean = false;
    displayTreeMap: boolean = false;

    showDialog() {
        this.displayCompanyList = true;
    }
    
    showTreeMap(){
        this.displayTreeMap = true;
    }
    
  constructor() { }

  ngOnInit() {
  }

}
