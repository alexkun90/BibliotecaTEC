/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.tienda_k.dao;

import com.tienda_k.domain.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 *
 * @author Laboratorios
 */
public interface UsuarioDao extends JpaRepository <Usuario,Long> { //Mejora, no usar Crud 
    
    Usuario findByUsername(String username);
}
