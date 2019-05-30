package com.mdas.api.controller;

import com.mdas.api.model.Company;
import com.mdas.api.repository.CompanyRepository;
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

    @GetMapping("/company")
    public Page<Company> getCompanies(Pageable pageable) {
        return companyRepository.findAll(pageable);
	}

}