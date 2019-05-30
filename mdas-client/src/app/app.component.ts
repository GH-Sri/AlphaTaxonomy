import { Component, HostListener, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/platform-browser';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'AlphaTaxonomy';
  
  constructor(@Inject(DOCUMENT) private document: Document) {}
  
  @HostListener("window:scroll", [])
  onWindowScroll(){
      if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
          document.getElementById("toTopButton").style.display = "block";
          document.getElementById("ResetButton").style.display = "block";
          document.getElementById("LogoButton").style.display = "none";
      } else {
          document.getElementById("LogoButton").style.display = "block";
          document.getElementById("ResetButton").style.display = "none";
          document.getElementById("toTopButton").style.display = "none";
      }
  }
  
  goToTop() {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
    } 

  reset() {
    window.location.href = "http://" + window.location.host;
    document.getElementById("ResetSpinner").style.display = "block";
  } 
}
