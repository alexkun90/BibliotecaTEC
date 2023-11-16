package com.mycompany.ilib;

import com.mycompany.db.Database;
import com.mycompany.interfaces.DAOMultas;
import com.mycompany.models.Multas;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DAOMultasImpl extends Database implements DAOMultas{
    
    public void registrar(Multas multa) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("INSERT INTO multas(id_multa, id_users, monto, fecha_vencimiento, estado_multa) VALUES(?,?,?,?,?)");
            st.setInt(1, multa.getId_multa());
            st.setInt(2, multa.getId_users());
            st.setFloat(3, multa.getMonto());
            st.setString(4, multa.getFecha_vencimiento());
            st.setString(5, multa.getEstado_multa());
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }
    
}
