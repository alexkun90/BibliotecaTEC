
package com.mycompany.ilib;

import com.mycompany.db.Database;
import com.mycompany.interfaces.DAOEmplo;
import com.mycompany.models.Empleados;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;   


public class DAOEmpleadosImpl extends Database implements DAOEmplo {
    @Override
    public void registrar(Empleados empleado) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("INSERT INTO USERLOGIN(FNAME, LNAME, MNAME, BIRTH_DATE, USER_NAME, USER_PASSWORD) VALUES(?,?,?,?,?,?)");
            st.setString(1, empleado.getFNAME());
            st.setString(2, empleado.getLNAME());
            st.setString(3, empleado.getMNAME());
            // Ajusta según la forma en que manejes las fechas en tu aplicación
            st.setDate(4, new java.sql.Date(empleado.getBIRTH_DATE().getTime()));
            st.setString(5, empleado.getUSER_NAME());
            st.setString(6, empleado.getUSER_PASSWORD());
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }

    @Override
    public void modificar(Empleados empleado) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("UPDATE USERLOGIN SET FNAME = ?, LNAME = ?, MNAME = ?, BIRTH_DATE = ?, USER_NAME = ?, USER_PASSWORD = ? WHERE ID = ?");
            st.setString(1, empleado.getFNAME());
            st.setString(2, empleado.getLNAME());
            st.setString(3, empleado.getMNAME());
            st.setDate(4, new java.sql.Date(empleado.getBIRTH_DATE().getTime()));
            st.setString(5, empleado.getUSER_NAME());
            st.setString(6, empleado.getUSER_PASSWORD());
            st.setInt(7, empleado.getID());
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }

    @Override
    public void eliminar(int empleadoId) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("DELETE FROM USERLOGIN WHERE ID = ?");
            st.setInt(1, empleadoId);
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }

    @Override
    public List<Empleados> listar(String name) throws Exception {
        List<Empleados> lista = null;
        try {
            this.Conectar();
            String query = name.isEmpty() ? "SELECT * FROM USERLOGIN" : "SELECT * FROM USERLOGIN WHERE FNAME LIKE ?";
            PreparedStatement st = this.conexion.prepareStatement(query);
            if (!name.isEmpty()) {
                st.setString(1, "%" + name + "%");
            }

            lista = new ArrayList<>();
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Empleados empleado = new Empleados();
                empleado.setID(rs.getInt("ID"));
                empleado.setFNAME(rs.getString("FNAME"));
                empleado.setLNAME(rs.getString("LNAME"));
                empleado.setMNAME(rs.getString("MNAME"));
                empleado.setBIRTH_DATE(rs.getDate("BIRTH_DATE"));
                empleado.setUSER_ROLE(rs.getString("USER_ROLE"));
                empleado.setUSER_NAME(rs.getString("USER_NAME"));
                empleado.setUSER_PASSWORD(rs.getString("USER_PASSWORD"));
                lista.add(empleado);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
        return lista;
    }

    @Override
    public Empleados getEmpleadoById(int empleadoId) throws Exception {
        Empleados empleado = null;
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("SELECT * FROM USERLOGIN WHERE ID = ? FETCH FIRST 1 ROWS ONLY");
            st.setInt(1, empleadoId);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                empleado = new Empleados();
                empleado.setID(rs.getInt("ID"));
                empleado.setFNAME(rs.getString("FNAME"));
                empleado.setLNAME(rs.getString("LNAME"));
                empleado.setMNAME(rs.getString("MNAME"));
                empleado.setBIRTH_DATE(rs.getDate("BIRTH_DATE"));
                empleado.setUSER_ROLE(rs.getString("USER_ROLE"));
                empleado.setUSER_NAME(rs.getString("USER_NAME"));
                empleado.setUSER_PASSWORD(rs.getString("USER_PASSWORD"));
            }
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
        return empleado;
    }
}
