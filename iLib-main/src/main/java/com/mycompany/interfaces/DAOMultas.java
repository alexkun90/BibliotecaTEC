
package com.mycompany.interfaces;
import com.mycompany.models.Multas;
import java.util.List;


public interface DAOMultas {
    public void registrar(Multas multa) throws Exception;
    public void modificar(Multas multa) throws Exception;
    public void eliminar(int multaid) throws Exception;
    public List<Multas> listar(String mult) throws Exception;
    public Multas getMultaById(int multaId) throws Exception;
}
