
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
            PreparedStatement st = this.conexion.prepareStatement("INSERT INTO USERLOGIN(ID,\"LNAME\",\"FNAME\",\"MNAME\",\"BIRTH_DATE\",\"USER_ROLE\",\"USER_NAME\",\"USER_PASSWORD\") VALUES(?,?,?,?,?,?,?,?)");
                st.setInt(1, empleado.getID());
                st.setString(2, empleado.getLNAME());
                st.setString(3, empleado.getFNAME());
                st.setString(4, empleado.getMNAME());
                st.setDate(5, (Date) empleado.getBIRTH_DATE());
                st.setString(6, empleado.getUSER_ROLE());
                st.setString(7, empleado.getUSER_NAME());
                st.setString(8, empleado.getUSER_PASSWORD());
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
            PreparedStatement st = this.conexion.prepareStatement("UPDATE USERLOGIN SET FNAME = ?, LNAME = ?, MNAME = ?, BIRTH_DATE = ?, USER_ROLE = ?, USER_NAME = ?, USER_PASSWORD = ? WHERE ID = ?");
                st.setInt(1, empleado.getID());
                st.setString(2, empleado.getLNAME());
                st.setString(3, empleado.getFNAME());
                st.setString(4, empleado.getMNAME());
                st.setDate(5, (Date) empleado.getBIRTH_DATE());
                st.setString(6, empleado.getUSER_ROLE());
                st.setString(7, empleado.getUSER_NAME());
                st.setString(8, empleado.getUSER_PASSWORD());
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
    public List<Empleados> listar(String fname) throws Exception {
        List<Empleados> lista = null;
        try {
            this.Conectar();
            String query = fname.isEmpty() ? "SELECT * FROM USERLOGIN" : "SELECT * FROM USERLOGIN WHERE FNAME LIKE ?";
            PreparedStatement st = this.conexion.prepareStatement(query);
            if (!fname.isEmpty()) {
                st.setString(1, "%" + fname + "%");
            }

            lista = new ArrayList<>();
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Empleados empleado = new Empleados();
                empleado.setID(rs.getInt("ID"));
                empleado.setLNAME(rs.getString("FNAME"));
                empleado.setFNAME(rs.getString("LNAME"));
                empleado.setMNAME(rs.getString("MNAME"));
                empleado.setBIRTH_DATE(rs.getDate("BIRTH_DATE "));
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
    public Empleados getUserById(int empleadoId) throws Exception {
        Empleados empleado = null;
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("SELECT * FROM USERLOGIN WHERE ID = ? FETCH FIRST 1 ROWS ONLY");
            st.setInt(1, empleadoId);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                empleado = new Empleados();
                empleado.setID(rs.getInt("ID"));
                empleado.setLNAME(rs.getString("FNAME"));
                empleado.setFNAME(rs.getString("LNAME"));
                empleado.setMNAME(rs.getString("MNAME"));
                empleado.setBIRTH_DATE(rs.getDate("BIRTH_DATE "));
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

    /*@Override
    public void sancionar(Empleados user) throws Exception {
        try {
            this.Conectar();
            PreparedStatement st = this.conexion.prepareStatement("UPDATE users SET sanctions = ?, sanc_money = ? WHERE id = ?");
            st.setInt(1, user.getSanctions());
            st.setInt(2, user.getSanc_money());
            st.setInt(3, user.getId());
            st.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            this.Cerrar();
        }
    }*/
}

