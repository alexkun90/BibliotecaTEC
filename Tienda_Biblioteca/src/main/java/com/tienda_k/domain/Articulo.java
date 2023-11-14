/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.domain;



import jakarta.persistence.*;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import lombok.Data;

@Data 
@Entity
@Table(name="articulo")

public class Articulo implements Serializable {
    
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_articulo")
    private Long idArticulo;
    
    private String descripcion;
    private String detalle;
    private double precio;
    private int existencias;
    private String imagen;
    private boolean activo;

    @JoinColumn(name = "id_categoria", referencedColumnName = "id_categoria")
    @ManyToOne
    private Categoria categoria;
    
    public Articulo() {
    }

    public Articulo(String descripcion, String detalle, double precio, int existencias, String imagen, boolean activo, Categoria categoria) {
        this.descripcion = descripcion;
        this.detalle = detalle;
        this.precio = precio;
        this.existencias = existencias;
        this.imagen = imagen;
        this.activo = activo;
        this.categoria = categoria;
    }
    
    
    
    
    
    
}
