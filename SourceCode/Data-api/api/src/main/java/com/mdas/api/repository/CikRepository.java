package com.mdas.api.repository;

import com.mdas.api.model.Cik;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CikRepository extends JpaRepository<Cik, String> {
}