import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CompanyPerformanceComponent } from './company-performance.component';

describe('CompanyPerformanceComponent', () => {
  let component: CompanyPerformanceComponent;
  let fixture: ComponentFixture<CompanyPerformanceComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CompanyPerformanceComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CompanyPerformanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
