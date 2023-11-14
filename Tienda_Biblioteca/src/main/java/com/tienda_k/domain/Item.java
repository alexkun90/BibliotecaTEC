/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.domain;

/**
 *
 * @author gblan
 */
import lombok.Data;

@Data
public class Item extends Articulo {

    private int cantidad; //Almacenar la cantidad de items de un articulo

    public Item() {
    }

    public Item(Articulo articulo) {
        super.setIdArticulo(articulo.getIdArticulo());
        super.setCategoria(articulo.getCategoria());
        super.setDescripcion(articulo.getDescripcion());
        super.setDetalle(articulo.getDetalle());
        super.setPrecio(articulo.getPrecio());
        super.setExistencias(articulo.getExistencias());
        super.setActivo(articulo.isActivo());
        super.setImagen(articulo.getImagen());
        this.cantidad = 0;
    }
}
