/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.services.impl;

import com.tienda_k.dao.ArticuloDao;
import com.tienda_k.domain.Articulo;
import com.tienda_k.services.ArticuloService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Laboratorios
 */
@Service
public class ArticuloServicesImpl implements ArticuloService {

    @Autowired

    private ArticuloDao articuloDao;

    @Override
    @Transactional(readOnly = true)
    public List<Articulo> getArticulos(boolean activos) {
        var lista = articuloDao.findAll();
        if (activos) {
            lista.removeIf(e -> !e.isActivo());
        }
        return lista;
    }

    @Override
    @Transactional(readOnly = true)
    public Articulo getArticulo(Articulo articulo) {
        return articuloDao.findById(articulo.getIdArticulo()).orElse(null);
    }

    @Override
    @Transactional()
    public void save(Articulo articulo) {
        articuloDao.save(articulo);
    }

    @Override
    @Transactional()
    public void delete(Articulo articulo) {
        articuloDao.delete(articulo);
    }

}
