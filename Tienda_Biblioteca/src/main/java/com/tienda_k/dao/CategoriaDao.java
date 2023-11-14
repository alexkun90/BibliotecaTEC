/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.tienda_k.dao;

import com.tienda_k.domain.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 *
 * @author Laboratorios
 */
public interface CategoriaDao extends JpaRepository <Categoria,Long> { //Mejora, no usar Crud 
    
    
}
