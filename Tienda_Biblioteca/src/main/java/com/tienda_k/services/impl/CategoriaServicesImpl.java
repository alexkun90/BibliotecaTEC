/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.services.impl;

import com.tienda_k.dao.CategoriaDao;
import com.tienda_k.domain.Categoria;
import com.tienda_k.services.CategoriaService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Laboratorios
 */
@Service
public class CategoriaServicesImpl implements CategoriaService {
    
    @Autowired

    private CategoriaDao categoriaDao;

    @Override
    @Transactional(readOnly=true)
    public List<Categoria> getCategorias(boolean activos) {
        var lista =categoriaDao.findAll();
        if (activos) {
            lista.removeIf(e -> !e.isActivo());
        }
       return lista;
    }

    @Override
    @Transactional(readOnly=true)
    public Categoria getCategoria(Categoria categoria) {
        return categoriaDao.findById(categoria.getIdCategoria()).orElse(null);
    }

    @Override
    @Transactional()
    public void save(Categoria categoria) {
        categoriaDao.save(categoria);
    }

    @Override
    @Transactional()
    public void delete(Categoria categoria) {
        categoriaDao.delete(categoria);
    }
    
}
