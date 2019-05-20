package com.mdas.api.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Entity
@Table(name = "company")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name="companyid")
    private String companyid;   

    @Column(name="sectorid")
    private String sectorid; 

    @Column(name="industryid")
    private String industryid;      

    @Column(name="nasdaqindustry")
    private String nasdaqindustry;

    @Column(name="name")
    private String name;   

    @Column(name="ticker")
    private String ticker; 

    @Column(name="MarketCap10yr")
    private String marketcap;

    @Column(name="eps10yr")
    private String eps;  

    @Column(name="perf10yr")
    private String performance; 

    @Column(name="perfvssector10yr")
    private String persec;

    @Column(name="perfvsindustry10yr")
    private String perind;

    @Column(name="nasdaqperfvssector10yr")
    private String npersec;

    @Column(name="nasdaqperfvsindustry10yr")
    private String nperind;

    public String getCompanyId() {
        return companyid;
    }

    public void setCompanyId(String companyid) {
        this.companyid= companyid;
    } 

    public String getSectorId() {
        return sectorid;
    }

    public void setSectorId(String sectorid) {
        this.sectorid = sectorid;
    } 

    public String getIndustryId() {
        return industryid;
    }

    public void setIndustryId(String industryid) {
        this.industryid = industryid;
    } 

    public String getNasdaqIndustry() {
        return nasdaqindustry;
    }

    public void setNasdaqIndustry(String nasdaqindustry) {
        this.nasdaqindustry = nasdaqindustry;
    } 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    } 

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    } 

    public String getMarketCap() {
        return marketcap;
    }

    public void setMarketCap(String marketcap) {
        this.marketcap = marketcap;
    } 

    public String getEps() {
        return eps;
    }

    public void setEps(String eps) {
        this.eps = eps;
    } 

    public String getPerformance() {
        return performance;
    }

    public void setPerformance(String performance) {
        this.performance = performance;
    }

    public String getPerformanceVsSector() {
        return persec;
    }

    public void setPerformanceVsSector(String persec) {
        this.persec = persec;
    }

    public String getPerformanceVsIndustry() {
        return perind;
    }

    public void setPerformanceVsIndustry(String perind) {
        this.perind = perind;
    }

    public String getNasdaqPerformanceVsSector() {
        return npersec;
    }

    public void setNasdaqPerformanceVsSector(String npersec) {
        this.npersec = npersec;
    }

    public String getNasdaqPerformanceVsIndustry() {
        return nperind;
    }

    public void set10YrNasdaqPerformanceVsIndustry(String nperind) {
        this.nperind = nperind;
    }
}