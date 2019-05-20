package com.mdas.data.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Entity
@Table(name = "companylist2")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name="symbol")
    private String symbol;   

    @Column(name="name")
    private String name;     

    @Column(name="lastsale")
    private String lastsale; 

    @Column(name="marketcap")
    private String marketcap; 

    @Column(name="ipoyear")
    private String ipoyear;

    @Column(name="sector")
    private String sector; 

    @Column(name="industry")
    private String industry;           

    @Column(name="summary_quote")
    private String summary_quote; 

    @Column(name="cik")
    private String cik; 

    @Column(name="description")
    private String description;

    @Column(name="title")
    private String title;

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    } 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    } 

    public String getLastsale() {
        return lastsale;
    }

    public void setLastsale(String lastsale) {
        this.lastsale = lastsale;
    } 

    public String getMarketcap() {
        return marketcap;
    }

    public void setMarketcap(String marketcap) {
        this.marketcap = marketcap;
    } 

    public String getIpoyear() {
        return ipoyear;
    }

    public void setIpoyear(String ipoyear) {
        this.ipoyear = ipoyear;
    } 

    public String getSector() {
        return sector;
    }

    public void setSector(String sector) {
        this.sector = sector;
    } 

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    } 

    public String getQuote() {
        return summary_quote;
    }

    public void setQuote(String summary_quote) {
        this.title = title;
    } 

    public String getCik() {
        return cik;
    }

    public void setCik(String cik) {
        this.cik = cik;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
