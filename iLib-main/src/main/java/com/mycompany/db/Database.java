package com.mycompany.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


public class Database {
    
    protected Connection conexion;
    private final String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    
    private final String USER = "hr";
    private final String PASS = "hr";
    
     public void Conectar() throws ClassNotFoundException, SQLException {
        try {
            // Primero, cargar el controlador
            Class.forName(JDBC_DRIVER);
            
            // Luego, establecer la conexión
            conexion = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException ex) {
            // Cambiar el tipo de excepción lanzada
            throw new SQLException("Error al conectar a la base de datos Oracle", ex);
        }
    }

    public void Cerrar() throws SQLException {
        if (conexion != null) {
            if (!conexion.isClosed()) {
                conexion.close();
            }
        }
    }
}