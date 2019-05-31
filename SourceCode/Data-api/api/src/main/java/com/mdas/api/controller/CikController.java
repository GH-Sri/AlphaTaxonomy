package com.mdas.api.controller;

import com.mdas.api.model.Cik;
import com.mdas.api.repository.CikRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;

@RestController
public class CikController {

    @Autowired
    private CikRepository cikRepository;

    @GetMapping("/cik")
    public Page<Cik> getCiks(Pageable pageable) {
        return cikRepository.findAll(pageable);
	}

}