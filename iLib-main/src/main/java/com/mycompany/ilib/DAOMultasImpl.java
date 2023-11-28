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
    
    public void modificar(Multas multa) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("UPDATE multas SET id_multa = ?, id_users = ?, monto = ?, fecha_vencimiento = ?, estado_multa = ?  WHERE id_multa = ?");
            st.setInt(1, multa.getId_multa());
            st.setInt(2, multa.getId_users());
            st.setFloat(3, multa.getMonto());
            st.setString(4, multa.getFecha_vencimiento());
            st.setString(5, multa.getEstado_multa());
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }
    
    public void eliminar(int multaid) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("DELETE FROM multas WHERE id_multa = ?");
            st.setInt(1, multaid);
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }
    
    public List<Multas> listar(String mult) throws Exception {
        List<Multas> lista = null;
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("SELECT * FROM multas ORDER BY id_multa DESC");

            lista = new ArrayList<>();
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Multas multa = new Multas();
                multa.setId_multa(rs.getInt("id_multa"));
                multa.setId_users(rs.getInt("id_users"));
                multa.setFecha_vencimiento(rs.getString("fecha_vencimiento"));
                multa.setEstado_multa(rs.getString("estado_multa"));
                multa.setMonto(rs.getFloat("monto"));
                lista.add(multa);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
        return lista;
    }
    
    public Multas getMultaById(int multaId) throws Exception {
        Multas multa = null;
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("SELECT * FROM multas WHERE id_multa = ? FETCH FIRST 1 ROWS ONLY");
            st.setInt(1, multaId);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                multa = new Multas();
                multa.setId_multa(rs.getInt("id_multa"));
                multa.setId_users(rs.getInt("id_users"));
                multa.setFecha_vencimiento(rs.getString("fecha_vencimiento"));
                multa.setEstado_multa(rs.getString("estado_multa"));
                multa.setMonto(rs.getFloat("monto"));
            }
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
        return multa;
    }
    
}
