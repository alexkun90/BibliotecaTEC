/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.tienda_k.services;

import com.tienda_k.domain.Cliente;
import java.util.List;

/**
 *
 * @author Laboratorios
 */
public interface ClienteService {
    //Se obtiene un listado de clientes en un List
    public List<Cliente> getClientes();
    
    //Se obtiene un Cliente, a partir del id de un cliente
    
    public Cliente getCliente(Cliente cliente );
    
    //Se inserta un nuevo clientes si el id del cliente esta vacio 
    //Se actualiza un cliente si el id no esta vacio 
    public void save(Cliente cliente);

    //Se elimina un cliente si el id no esta vacio 
    public void delete(Cliente cliente);
}
