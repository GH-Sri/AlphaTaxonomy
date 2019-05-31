package com.mdas.api.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Entity
@Table(name = "cik")
public class Cik {

	@Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name="companyid")
    private int companyid;   

    @Column(name="cik")
    private int cik;

    public int getCompanyId() {
        return companyid;
    }

    public void setCompanyId(int companyid) {
        this.companyid = companyid;
    } 

    public int getCik() {
        return cik;
    }

    public void setCik(int cik) {
        this.cik = cik;
    } 

}