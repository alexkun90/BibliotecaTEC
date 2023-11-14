/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tienda_k.services;

import com.tienda_k.dao.UsuarioDao;
import com.tienda_k.domain.Rol;
import com.tienda_k.domain.Usuario;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("userDetailsService")
public class UsuarioService implements UserDetailsService{
    @Autowired
    private UsuarioDao usuarioDao;
    
    @Override
    @Transactional(readOnly=true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        //Busca el usuario por el username en la tabla
        Usuario usuario = usuarioDao.findByUsername(username);
        
        //Si no existe el usuario lanza una excepciÃ³n
        if(usuario == null){
            throw new UsernameNotFoundException(username);
        }
        
        //Si estÃ¡ acÃ¡ es porque existe el usuario... sacamos los roles que tiene
        var roles = new ArrayList<GrantedAuthority>();
        
        for(Rol rol: usuario.getRoles()){   //Se sacan los roles
            roles.add(new SimpleGrantedAuthority(rol.getNombre()));
        }
        //Se devuelve User (clase de userDetails)
        return new User(usuario.getUsername(), usuario.getPassword(), roles);
    }    
}
