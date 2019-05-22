import { Component, HostListener, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/platform-browser';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'AlphaTaxonomy';
  
  constructor(
          @Inject(DOCUMENT) private document: Document) {}
  
  @HostListener("window:scroll", [])
  onWindowScroll(){
      if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
          document.getElementById("toTopButton").style.display = "block";
      } else {
          document.getElementById("toTopButton").style.display = "none";
      }
  }
  
  topFunction() {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
    } 
}
