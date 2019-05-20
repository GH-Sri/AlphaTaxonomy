package com.mdas.data.controller;

import com.mdas.data.model.Company;
import com.mdas.data.repository.CompanyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;

@RestController
public class CompanyController {

    @Autowired
    private CompanyRepository companyRepository;

    @GetMapping("/companies")
    public Page<Company> getCompanies(Pageable pageable) {
        return companyRepository.findAll(pageable);
	}

}