/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.tienda_k.services;

import com.tienda_k.domain.Categoria;
import java.util.List;

/**
 *
 * @author Laboratorios
 */
public interface CategoriaService {
    //Se obtiene un listado de categorias en un List
    public List<Categoria> getCategorias(boolean activos);
    
    //Se obtiene un Categoria, a partir del id de un categoria
    
    public Categoria getCategoria(Categoria categoria );
    
    //Se inserta un nuevo categorias si el id del categoria esta vacio 
    //Se actualiza un categoria si el id no esta vacio 
    public void save(Categoria categoria);

    //Se elimina un categoria si el id no esta vacio 
    public void delete(Categoria categoria);
}
