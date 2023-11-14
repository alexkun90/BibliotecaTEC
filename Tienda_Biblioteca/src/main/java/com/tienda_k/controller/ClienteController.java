/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.controller;

import com.tienda_k.domain.Cliente;
import com.tienda_k.services.ClienteService;
import java.util.Arrays;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/cliente")
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @GetMapping("/listado")
    public String inicio(Model model) {
        var clientes = clienteService.getClientes();
        var totalCredito = 0;
        for (Cliente c: clientes) {
            totalCredito += c.getCredito().getLimite();
        }
        model.addAttribute( "totalClientes",clientes.size());
        model.addAttribute("totalCredito",totalCredito);
        model.addAttribute("clientes", clientes);
        return "/cliente/listado";
    }

    @GetMapping("/nuevo")
    public String clienteNuevo(Cliente cliente) {
        return "cliente/modifica";

    }

    @PostMapping("/guardar")
    public String clienteGuardar(Cliente cliente) {
        clienteService.save(cliente);
        return "redirect:/cliente/listado";
    }

    @GetMapping("/eliminar/{idCliente}")
    public String clienteEliminar(Cliente cliente) {
        clienteService.delete(cliente);
        return "redirect:/cliente/listado";
    }

    @GetMapping("/modificar/{idCliente}")
    public String clienteModificar(Cliente cliente, Model model) {
        cliente = clienteService.getCliente(cliente);
        model.addAttribute("cliente",cliente);
        return "/cliente/modifica";
    }

}
