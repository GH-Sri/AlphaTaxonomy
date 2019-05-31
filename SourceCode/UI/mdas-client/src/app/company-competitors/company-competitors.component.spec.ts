import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CompanyCompetitorsComponent } from './company-competitors.component';

describe('CompanyCompetitorsComponent', () => {
  let component: CompanyCompetitorsComponent;
  let fixture: ComponentFixture<CompanyCompetitorsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CompanyCompetitorsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CompanyCompetitorsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
