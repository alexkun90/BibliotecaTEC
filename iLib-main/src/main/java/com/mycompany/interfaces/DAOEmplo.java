package com.mycompany.interfaces;

import com.mycompany.models.Empleados;
import java.util.List;
public interface DAOEmplo {
    
    public void registrar(Empleados empleado) throws Exception;
    public void modificar(Empleados empleado) throws Exception;
    //public void sancionar(Empleados empleado) throws Exception;
    public void eliminar(int empleadoId) throws Exception;
    public List<Empleados> listar(String name) throws Exception;
    public Empleados getEmpleadoById(int empleadoId) throws Exception;
}
