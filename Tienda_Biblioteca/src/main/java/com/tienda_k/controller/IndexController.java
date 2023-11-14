/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.controller;

import com.tienda_k.domain.Cliente;
import com.tienda_k.services.ArticuloService;
import com.tienda_k.services.ClienteService;
import java.util.Arrays;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@Slf4j

public class IndexController {

    @Autowired
    private ArticuloService articuloService;

    @GetMapping("/")

    public String inicio(Model model) {
        var articulos = articuloService.getArticulos(true);
        model.addAttribute("articulos", articulos);

        return "index";

    }
}
