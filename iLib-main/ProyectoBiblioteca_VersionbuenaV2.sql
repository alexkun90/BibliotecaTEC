-- Crear la secuencia para el campo autoincremental
CREATE SEQUENCE books_seq;

-- Estructura de tabla para la tabla `books`
CREATE TABLE books (
  id NUMBER DEFAULT books_seq.NextVal Primary Key,
  title VARCHAR2(255) NOT NULL,
  publication_date VARCHAR2(255) NOT NULL,
  author VARCHAR2(255) NOT NULL,
  category VARCHAR2(255) NOT NULL,
  "edit" VARCHAR2(255) NOT NULL,
  lang VARCHAR2(255) NOT NULL,
  pages VARCHAR2(255) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  ejemplares VARCHAR2(255) NOT NULL,
  stock NUMBER NOT NULL,
  available NUMBER NOT NULL
);

-- Crear la secuencia para el campo autoincremental
CREATE SEQUENCE lendings_seq;

-- Estructura de tabla para la tabla `lendings`
CREATE TABLE lendings_table (
 id NUMBER DEFAULT lendings_seq.NextVal Primary Key,
  user_id NUMBER NOT NULL,
  book_id NUMBER NOT NULL,
  date_out VARCHAR2(255) NOT NULL,
  date_return VARCHAR2(255)
);

-- Crear la secuencia para el campo autoincremental
CREATE SEQUENCE users_seq;

-- Estructura de tabla para la tabla `users`
CREATE TABLE users (
  id NUMBER DEFAULT users_seq.NextVal Primary Key,
  name VARCHAR2(30) NOT NULL,
  last_name_p VARCHAR2(30) NOT NULL,
  last_name_m VARCHAR2(30) NOT NULL,
  domicilio VARCHAR2(250),
  tel VARCHAR2(25),
  sanctions NUMBER DEFAULT 0,
  sanc_money NUMBER DEFAULT 0 NOT NULL
);


CREATE SEQUENCE book_USERLOGIN_seq;

CREATE TABLE book_USERLOGIN(
  id NUMBER DEFAULT book_USERLOGIN_seq.NextVal Primary Key,
  id_userlogin NUMBER NOT NULL,
  id_book NUMBER NOT NULL
);
-- Crear las restricciones de clave forneaa
ALTER TABLE lendings_table ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE lendings_table ADD CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(id);
ALTER TABLE book_USERLOGIN ADD CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(id);
ALTER TABLE book_USERLOGIN ADD CONSTRAINT fk_USERLOGIN FOREIGN KEY (id_userlogin) REFERENCES USERLOGIN(ID);

--Crear Tabla UserLogin

CREATE TABLE USERLOGIN(
ID INT Primary Key NOT NULL,
LNAME VARCHAR2(20),
FNAME VARCHAR(20),
MNAME VARCHAR2(20),
BIRTH_DATE DATE   ,
USER_ROLE VARCHAR2(20),
USER_NAME VARCHAR(20),
USER_PASSWORD VARCHAR2(20)
)
DROP TABLE USERLOGIN;



-- Esto es el borrado de la base de datos.

ALTER TABLE lendings_table DROP CONSTRAINT fk_user;
ALTER TABLE lendings_table DROP CONSTRAINT fk_book;
 
 
  DROP TABLE lendings_table;
  DROP TABLE users;
  DROP TABLE books;
  DROP SEQUENCE books_seq;
 DROP SEQUENCE users_seq;
 DROP SEQUENCE lendings_seq;

--INSERTACION FAKE

INSERT INTO users(name, last_name_p, last_name_m, domicilio, tel) VALUES('Adrian','Ortega','Salas','ejemplo','2222222');
INSERT INTO users(name, last_name_p, last_name_m, domicilio, tel) VALUES('Noa','Nobita','Perez','ejemplo2','3333333');
INSERT INTO users(name, last_name_p, last_name_m, domicilio, tel) VALUES('Loas','Santos','Suarez','ejemplo3','23445222');

INSERT INTO books(title, publication_date, author, category, "edit", lang, pages, description, ejemplares, stock, available) VALUES('PRUEBA','14-11-23','ORTEGA','MIEDO','Roos','EN','123','PRUEBA','HOLA',100,99);

--CONSULTAS DE PRUEBA 
SELECT * FROM USERLogin;
SELECT * FROM Books;
SELECT * FROM lendings_table;

--Creacion del usuario C##admin contraseÃ±a: 123
  
/*
    sqlplus /nolog
    conn system/su_contraseÃ±a
    
  CREATE USER C##biblio IDENTIFIED BY 123;
  GRANT DBA TO C##admin;
  CREATE TABLESPACE ts_admin DATAFILE 'ts_admin.dbf' SIZE 20M;
  ALTER USER C##admin DEFAULT TABLESPACE ts_admin;
  ALTER USER C##admin QUOTA UNLIMITED ON ts_admin;
*/



CREATE SEQUENCE multas_seq;

CREATE TABLE multas(
id_multa NUMBER DEFAULT multas_seq.NextVal PRIMARY KEY,
id_users NUMBER,
monto DECIMAL(10, 2),
fecha_vencimiento DATE,
estado_multa VARCHAR(20));

CREATE SEQUENCE usuario_multa_seq;

CREATE TABLE usuario_multas (
    ID_usuario NUMBER,
    ID_multa NUMBER DEFAULT usuario_multa_seq.NextVal PRIMARY KEY
);

ALTER TABLE usuario_multas ADD CONSTRAINT fk_ID_USUARIO FOREIGN KEY (ID_usuario) REFERENCES users(id);
ALTER TABLE usuario_multas ADD CONSTRAINT fk_ID_MULTA FOREIGN KEY (ID_multa) REFERENCES multas(id_multa);


CREATE SEQUENCE autores_seq;

CREATE TABLE autores (
    id_autor NUMBER DEFAULT multas_seq.NextVal PRIMARY Key,
    author VARCHAR(255) NOT NULL
);

CREATE SEQUENCE categorias_seq;

CREATE TABLE Categoria (
    ID_categoria NUMBER DEFAULT categorias_seq.NextVal PRIMARY KEY,
    Nombre_Genero VARCHAR(50),
    Descripcion_Genero VARCHAR(50)
);

CREATE SEQUENCE libros_autores_seq;

CREATE TABLE libros_autores (
    id NUMBER DEFAULT libros_autores_seq.NextVal PRIMARY KEY,
    id_autor NUMBER
);

CREATE SEQUENCE libros_generos_seq;

CREATE TABLE libros_generos (
    id NUMBER DEFAULT libros_generos_seq.NextVal PRIMARY KEY,
    Nombre_Genero VARCHAR(50)
);

CREATE SEQUENCE editorial_seq;

CREATE TABLE editorial (
    ID_editorial NUMBER DEFAULT editorial_seq.NextVal PRIMARY KEY,
    Nombre_editorial VARCHAR(100),
    Direccion_editorial VARCHAR(255),
    Informacion_contacto_editorial VARCHAR(255)
);

CREATE SEQUENCE editorial_libro_seq;

CREATE TABLE editoriales_libros (
    ID_editorial NUMBER DEFAULT editorial_libro_seq.NextVal PRIMARY KEY,
    ID_edilibro NUMBER
);

CREATE SEQUENCE autores_libro_seq;

CREATE TABLE autores_libros (
    ID_autor_libro NUMBER DEFAULT autores_libro_seq.NextVal PRIMARY KEY,
    ID_autor NUMBER,
    id NUMBER
);

CREATE SEQUENCE idiomas_seq;

CREATE TABLE idiomas (
    ID_idioma NUMBER DEFAULT idiomas_seq.NextVal PRIMARY KEY,
    lang VARCHAR(255)
);

--Triggers---------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_available_books
AFTER INSERT OR DELETE ON lendings_table
FOR EACH ROW
DECLARE
    v_available NUMBER;
BEGIN
    IF INSERTING THEN
        -- Actualizar disponible al prestar un libro
        SELECT available
        INTO v_available
        FROM books
        WHERE id = :new.book_id;

        IF v_available > 0 THEN
            UPDATE books
            SET available = available - 1
            WHERE id = :new.book_id;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No hay ejemplares disponibles para prestar.');
        END IF;
    ELSIF DELETING THEN
        -- Actualizar disponible al devolver un libro
        UPDATE books
        SET available = available + 1
        WHERE id = :old.book_id;
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------

--Triggers---------------------------------------------------------------


CREATE OR REPLACE TRIGGER tr_books
BEFORE INSERT OR UPDATE OR DELETE ON books
FOR EACH ROW
DECLARE
    v_category_valid BOOLEAN;
BEGIN
    IF INSERTING OR UPDATING THEN
        
        v_category_valid := :NEW.category IN ('Ficción', 'No Ficción', 'Ciencia', 'Historia', 'Otro');
        IF NOT v_category_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'La categoría no es válida.');
        END IF;
        
       
        IF TO_NUMBER(:NEW.stock) IS NULL OR TO_NUMBER(:NEW.ejemplares) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'El stock y los ejemplares deben ser números válidos.');
        END IF;
    END IF;
    
   
END;
/


------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_lendings
BEFORE INSERT OR UPDATE OR DELETE ON lendings_table
FOR EACH ROW
DECLARE
    v_user_exists NUMBER;
    v_book_exists NUMBER;
BEGIN
    IF INSERTING OR UPDATING THEN
     
        SELECT COUNT(*) INTO v_user_exists FROM users WHERE id = :NEW.user_id;
        IF v_user_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'El ID de usuario no existe en la tabla users.');
        END IF;
        

        SELECT COUNT(*) INTO v_book_exists FROM books WHERE id = :NEW.book_id;
        IF v_book_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'El ID de libro no existe en la tabla books.');
        END IF;


        IF :NEW.date_return IS NOT NULL AND TO_DATE(:NEW.date_return, 'DD-MM-YYYY') <= TO_DATE(:NEW.date_out, 'DD-MM-YYYY') THEN
            RAISE_APPLICATION_ERROR(-20003, 'La fecha de devolución debe ser posterior a la fecha de salida.');
        END IF;
    END IF;
    
 
END;
/




-------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER tr_users
BEFORE INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
DECLARE
    v_sanc_money_limit NUMBER := 100; 
BEGIN
    IF INSERTING OR UPDATING THEN

        IF LENGTH(TRIM(:NEW.name)) = 0 OR LENGTH(TRIM(:NEW.last_name_p)) = 0 OR LENGTH(TRIM(:NEW.last_name_m)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nombre y apellidos no pueden estar vacíos.');
        END IF;
        
        IF :NEW.sanctions < 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'El número de sanciones no puede ser negativo.');
        END IF;
        
        IF :NEW.sanc_money < 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'El monto de dinero sancionado no puede ser negativo.');
        END IF;


        IF :NEW.sanc_money > v_sanc_money_limit THEN
            :NEW.sanc_money := v_sanc_money_limit; -- Limitar a la sanción máxima permitida
            RAISE_APPLICATION_ERROR(-20004, 'Se ha alcanzado el límite de sanción monetaria.');
        END IF;
    END IF;
    
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_multas
BEFORE INSERT OR UPDATE OR DELETE ON multas
FOR EACH ROW
BEGIN
    -- Validación de la fecha de vencimiento en el formato DD-MM-YYYY
    IF TO_DATE(:NEW.fecha_vencimiento, 'DD-MM-YYYY') <= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'La fecha de vencimiento debe ser posterior a la fecha actual.');
    END IF;

    IF :NEW.estado_multa NOT IN ('PENDIENTE', 'PAGADA', 'MOROSO') THEN
        RAISE_APPLICATION_ERROR(-20002, 'El estado de la multa no es válido.');
    END IF;

    -- Validación del monto no negativo
    IF :NEW.monto < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El monto de la multa no puede ser negativo.');
    END IF;

END;
/


--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_editorial
BEFORE INSERT OR UPDATE OR DELETE ON editorial
FOR EACH ROW
BEGIN
    -- Validación del nombre de la editorial no nulo
    IF INSERTING OR UPDATING THEN
        IF :NEW.Nombre_editorial IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'El nombre de la editorial no puede ser nulo.');
        END IF;
    END IF;

END;
/



--Vistas--------------------------------------------------------------------------------

CREATE VIEW basic_book_info AS
SELECT id, title, author, category
FROM books;

----------------------------------------------------------------------

CREATE VIEW basic_lending_info AS
SELECT id, user_id, book_id
FROM lendings_table;

-----------------------------------------------------------------------

CREATE VIEW basic_user_info AS
SELECT id, name, last_name_p, last_name_m
FROM users;

-----------------------------------------------------------------------

CREATE VIEW basic_penalty_info AS
SELECT id_multa, id_users, monto, fecha_vencimiento, estado_multa
FROM multas;

----------------------------------------------------------------------

CREATE VIEW user_penalty_info AS
SELECT user_id, id_multa
FROM usuario_multas;

--Procedimientos Almacenados-------------------------------------------
--1 SP:procedimiento almacenado que despliegue nombres y apellidos de los usuarios que no tienen deudas
CREATE OR REPLACE PROCEDURE usuarios_sin_deudas AS
BEGIN
  FOR usuario IN (SELECT name, last_name_p, last_name_m
                  FROM users
                  WHERE sanciones = 0 AND sanc_money = 0) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || usuario.name || ', Apellido Paterno: ' || usuario.last_name_p || ', Apellido Materno: ' || usuario.last_name_m);
  END LOOP;
END;
--ejecucion 
EXEC usuarios_sin_deudas;



--2 SP:procedimiento almacenado que reciba como parÃ¡metro el titulo de un libro y despliegue las copias que estÃ¡n disponibles (no prestadas).
CREATE OR REPLACE PROCEDURE copias_disponibles(p_titulo IN VARCHAR2) AS
  v_libro_id NUMBER;
  v_disponibles NUMBER;
BEGIN
  -- Obtener el ID del libro basado en el tÃ­tulo proporcionado
  SELECT id INTO v_libro_id
  FROM books
  WHERE title = p_titulo;

  -- Verificar si el libro existe
  IF v_libro_id IS NOT NULL THEN
    -- Obtener la cantidad de copias disponibles
    SELECT available INTO v_disponibles
    FROM books
    WHERE id = v_libro_id;

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Libro: ' || p_titulo || ', Copias Disponibles: ' || v_disponibles);
  ELSE
    -- Si el libro no existe
    DBMS_OUTPUT.PUT_LINE('El libro con el tÃ­tulo ' || p_titulo || ' no existe.');
  END IF;
END;
--ejecucion
EXEC copias_disponibles('TÃ­tulo del Libro');-- aqui se pone el titulo que hay en la BD

--3 SP: Procedimiento Almacenado que ingrese como parametros el nombre y apellido de un usuario y despliegue los tÃ­tulos y copias que mantiene en prÃ©stamo

CREATE OR REPLACE PROCEDURE libros_en_prestamo(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2) AS
BEGIN
  FOR prestamo IN (SELECT b.title, lt.date_out
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE u.name = p_nombre AND u.last_name_p = p_apellido) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario: ' || p_nombre || ' ' || p_apellido || ', TÃ­tulo: ' || prestamo.title || ', Fecha de PrÃ©stamo: ' || prestamo.date_out);
  END LOOP;
END;

--Ejecucion 
EXEC libros_en_prestamo('NombreUsuario', 'ApellidoUsuario');--Aqui se coloca el nombre del usuario y apellidos ya registrada en la BD osea registrado previamente, con registros ya hechos

--4 SP:  procedimiento almacenado que despliegue el tÃ­tulo del libro mÃ¡s prestado.
CREATE OR REPLACE PROCEDURE libro_mas_prestado AS
  v_titulo VARCHAR2(255);
BEGIN
  -- Obtener el tÃ­tulo del libro mÃ¡s prestado
  SELECT b.title
  INTO v_titulo
  FROM books b
  JOIN lendings_table lt ON b.id = lt.book_id
  GROUP BY b.title
  ORDER BY COUNT(lt.id) DESC
  FETCH FIRST 1 ROW ONLY;

  -- Mostrar el resultado
  DBMS_OUTPUT.PUT_LINE('El libro mÃ¡s prestado es: ' || v_titulo);
END;
--ejecucion
EXEC libro_mas_prestado;

-- 5 SP: Procedimiento Almacenado que ingrese como parÃ¡metro el nombre de un autor y que devuelva como parÃ¡metro de salida el nÃºmero de libros que ha escrito
CREATE OR REPLACE PROCEDURE libros_por_autor(
  p_nombre_autor IN VARCHAR2,
  p_num_libros OUT NUMBER
) AS
BEGIN
  -- Obtener el n�mero de libros escritos por el autor
  SELECT COUNT(DISTINCT b.id)
  INTO p_num_libros
  FROM books b
  WHERE b.author = p_nombre_autor;

  -- Imprimir el resultado en el output del sistema
  DBMS_OUTPUT.PUT_LINE('El autor ' || p_nombre_autor || ' ha escrito ' || p_num_libros || ' libro(s).');
END;
/
-- Ejecuci�n del procedimiento almacenado
DECLARE
  v_num_libros NUMBER;
BEGIN
  libros_por_autor('NombreAutor', v_num_libros); -- Reemplaza 'NombreAutor' con el nombre real del autor en la base de datos
END;
/

--6 SP:  Procedimiento Almacenado que reciba el nombre de un gÃ©nero como parÃ¡metro y devuelva los tÃ­tulos de los libros pertenecientes a ese gÃ©nero.
CREATE OR REPLACE PROCEDURE libros_por_genero(p_nombre_genero IN VARCHAR2) AS
BEGIN
  FOR libro IN (SELECT b.title
                FROM books b
                JOIN libros_generos lg ON b.id = lg.id_libros
                JOIN generos g ON lg.id_genero = g.id_genero
                WHERE g.Nombre_Genero = p_nombre_genero)
  LOOP
    DBMS_OUTPUT.PUT_LINE('TÃ­tulo: ' || libro.title);
  END LOOP;
END;

--Ejecucion 
BEGIN
  libros_por_genero('NombreGenero');
END;


--7 SP: Procedimiento Almacenado que muestre los prÃ©stamos que estÃ¡n vencidos, incluyendo detalles sobre los usuarios y los libros involucrados

CREATE OR REPLACE PROCEDURE prestamos_vencidos AS
BEGIN
  FOR prestamo IN (SELECT lt.id, u.name || ' ' || u.last_name_p || ' ' || u.last_name_m AS nombre_usuario,
                          b.title AS titulo_libro, lt.date_out, lt.date_return
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE lt.date_return < SYSDATE)
  LOOP
    DBMS_OUTPUT.PUT_LINE('PrÃ©stamo ID: ' || prestamo.id ||
                         ', Usuario: ' || prestamo.nombre_usuario ||
                         ', Libro: ' || prestamo.titulo_libro ||
                         ', Fecha de PrÃ©stamo: ' || prestamo.date_out ||
                         ', Fecha de DevoluciÃ³n Vencida: ' || prestamo.date_return);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay prÃ©stamos vencidos.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion en un bloque anonimo
BEGIN
  prestamos_vencidos;
END;

--8 SP: Procedimiento Almacenado que muestre informaciÃ³n detallada sobre un libro especÃ­fico, incluyendo datos sobre autores, gÃ©neros y editorial

CREATE OR REPLACE PROCEDURE info_libro_detallada(p_id_libro IN NUMBER) AS
BEGIN
  FOR info_libro IN (SELECT b.title AS titulo_libro, b.publication_date, b.author, b.category, b."edit" AS editorial,
                                a.Nombre_Autor AS autor, g.Nombre_Genero AS genero, e.Nombre_editorial AS nombre_editorial
                     FROM books b
                     JOIN libros_autores la ON b.id = la.id_libros
                     JOIN autores a ON la.id_autor = a.ID_autor
                     JOIN libros_generos lg ON b.id = lg.id_libros
                     JOIN generos g ON lg.id_genero = g.ID_genero
                     JOIN editoriales_libros el ON b.id = el.ID_libro
                     JOIN editorial e ON el.ID_editorial = e.ID_editorial
                     WHERE b.id = p_id_libro)
  LOOP
    DBMS_OUTPUT.PUT_LINE('InformaciÃ³n detallada del libro:');
    DBMS_OUTPUT.PUT_LINE('TÃ­tulo: ' || info_libro.titulo_libro);
    DBMS_OUTPUT.PUT_LINE('Fecha de PublicaciÃ³n: ' || info_libro.publication_date);
    DBMS_OUTPUT.PUT_LINE('Autor: ' || info_libro.autor);
    DBMS_OUTPUT.PUT_LINE('GÃ©nero: ' || info_libro.genero);
    DBMS_OUTPUT.PUT_LINE('Editorial: ' || info_libro.nombre_editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontrÃ³ informaciÃ³n para el libro con ID ' || p_id_libro);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion

BEGIN
  info_libro_detallada(ID_DEL_LIBRO);-- Aqui se coloca e; ID del Libro que este registrado previamente en la BD
END;


--9. SP: Procedimiento Almacenado que muestre los usuarios con la mayor cantidad de multas acumuladas

CREATE OR REPLACE PROCEDURE usuarios_con_mas_multas AS
BEGIN
  FOR usuario_multa IN (
    SELECT u.id, u.name || ' ' || u.last_name_p || ' ' || u.last_name_m AS nombre_usuario,
           u.sanc_money AS total_multas
    FROM users u
    ORDER BY u.sanc_money DESC
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario ID: ' || usuario_multa.id ||
                         ', Nombre: ' || usuario_multa.nombre_usuario ||
                         ', Total de Multas: ' || usuario_multa.total_multas);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay informaciÃ³n disponible sobre usuarios con multas acumuladas.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--ejecucion
BEGIN
  usuarios_con_mas_multas;
END;

--10. SP: Procedimiento Almacenado que muestre los libros mÃ¡s recientemente aÃ±adidos a la biblioteca

CREATE OR REPLACE PROCEDURE libros_recientes AS
BEGIN
  FOR libro_reciente IN (
    SELECT id, title AS titulo_libro, publication_date, author, category, "edit" AS editorial, lang, pages, description, ejemplares, stock, available
    FROM books
    ORDER BY id DESC
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_reciente.id ||
                         ', TÃ­tulo: ' || libro_reciente.titulo_libro ||
                         ', Fecha de PublicaciÃ³n: ' || libro_reciente.publication_date ||
                         ', Autor: ' || libro_reciente.author ||
                         ', CategorÃ­a: ' || libro_reciente.category ||
                         ', Editorial: ' || libro_reciente.editorial ||
                         ', Idioma: ' || libro_reciente.lang ||
                         ', PÃ¡ginas: ' || libro_reciente.pages ||
                         ', DescripciÃ³n: ' || libro_reciente.description ||
                         ', Ejemplares: ' || libro_reciente.ejemplares ||
                         ', Stock: ' || libro_reciente.stock ||
                         ', Disponibles: ' || libro_reciente.available);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay informaciÃ³n disponible sobre libros recientes.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion
BEGIN
  libros_recientes;
END;

--11. SP: Procedimiento Almacenado que reciba el nombre de un gÃ©nero como parÃ¡metro y devuelva los tÃ­tulos de los libros pertenecientes a ese gÃ©nero

CREATE OR REPLACE PROCEDURE libros_por_genero(p_nombre_genero IN VARCHAR2) AS
BEGIN
  FOR libro_genero IN (
    SELECT b.title AS titulo_libro
    FROM books b
    JOIN libros_generos lg ON b.id = lg.id_libros
    JOIN generos g ON lg.id_genero = g.ID_genero
    WHERE g.Nombre_Genero = p_nombre_genero
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('TÃ­tulo del Libro: ' || libro_genero.titulo_libro);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay informaciÃ³n disponible para el gÃ©nero ' || p_nombre_genero);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--Ejecucion
BEGIN
  libros_por_genero('NOMBRE_DEL_GENERO');
END;

--12: SP: Procedimiento Almacenado que muestre los libros que actualmente no estÃ¡n disponibles para prÃ©stamo

CREATE OR REPLACE PROCEDURE libros_no_disponibles AS
BEGIN
  FOR libro_no_disponible IN (
    SELECT id, title AS titulo_libro, author, "edit" AS editorial
    FROM books
    WHERE available = 0
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_no_disponible.id ||
                         ', TÃ­tulo: ' || libro_no_disponible.titulo_libro ||
                         ', Autor: ' || libro_no_disponible.author ||
                         ', Editorial: ' || libro_no_disponible.editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Todos los libros estÃ¡n disponibles para prÃ©stamo.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
-- Ejecucion de SP
BEGIN
  libros_no_disponibles;
END;

--------------------------------------------------------------------------procedimientos almacenados Ale
--13
CREATE OR REPLACE PROCEDURE insert_book_and_multa (
  p_title VARCHAR2,
  p_publication_date VARCHAR2,
  p_author VARCHAR2,
  p_category VARCHAR2,
  p_edit VARCHAR2,
  p_lang VARCHAR2,
  p_pages VARCHAR2,
  p_description VARCHAR2,
  p_ejemplares VARCHAR2,
  p_stock NUMBER,
  p_available NUMBER,
  p_id_users NUMBER,
  p_monto DECIMAL,
  p_fecha_vencimiento DATE,
  p_estado_multa VARCHAR2
) AS
  v_book_id NUMBER;
  v_multa_id NUMBER;
BEGIN
  -- Insertar en la tabla books
  INSERT INTO books (
    title, publication_date, author, category, "edit", lang,
    pages, description, ejemplares, stock, available
  ) VALUES (
    p_title, p_publication_date, p_author, p_category, p_edit, p_lang,
    p_pages, p_description, p_ejemplares, p_stock, p_available
  ) RETURNING id INTO v_book_id;

  -- Insertar en la tabla multas
  INSERT INTO multas (id_users, monto, fecha_vencimiento, estado_multa)
  VALUES (p_id_users, p_monto, p_fecha_vencimiento, p_estado_multa)
  RETURNING id_multa INTO v_multa_id;

  -- Realizar otras operaciones o manipulaciones según sea necesario

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    -- Manejar errores según sea necesario
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insert_book_and_multa;
/
-------------------------------------------------------------------------------
--14
CREATE OR REPLACE PROCEDURE apply_multas_to_overdue_books AS
  v_book_id books.id%TYPE;
  v_user_id multas.id_users%TYPE;
  v_fecha_actual DATE := SYSDATE;

  CURSOR overdue_books_cur IS
    SELECT b.id, b.available, m.id_users, m.fecha_vencimiento
    FROM books b
    JOIN multas m ON b.id = m.id_users
    WHERE b.available > 0 AND m.fecha_vencimiento < v_fecha_actual;

BEGIN
  -- Recorrer los libros vencidos y aplicar multas
  FOR overdue_book_rec IN overdue_books_cur LOOP
    v_book_id := overdue_book_rec.id;
    v_user_id := overdue_book_rec.id_users;

    -- Reducir la disponibilidad del libro
    UPDATE books SET available = available - 1 WHERE id = v_book_id;

    -- Aplicar multa al usuario
    INSERT INTO multas (id_users, monto, fecha_vencimiento, estado_multa)
    VALUES (v_user_id, 10.00, v_fecha_actual, 'PENDIENTE');

    -- Realizar otras operaciones o manipulaciones según sea necesario
  END LOOP;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    -- Manejar errores según sea necesario
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END apply_multas_to_overdue_books;
/
-------------------------------------------------------------------------------
--15

-- Procedimiento para insertar un nuevo autor
CREATE OR REPLACE PROCEDURE insertar_autor(
    p_nombre_autor VARCHAR2,
    p_nacionalidad VARCHAR2,
    p_info_adicional CLOB
) AS
BEGIN
    INSERT INTO autores (Nombre_Autor, Nacionalidad, Informacion_Adicional)
    VALUES (p_nombre_autor, p_nacionalidad, p_info_adicional);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_autor;
/
--------------------------------------------------------------------------------
--16
CREATE OR REPLACE PROCEDURE insertar_libro(
    p_title VARCHAR2,
    p_publication_date VARCHAR2,
    p_author_id NUMBER,
    p_category VARCHAR2,
    p_edit VARCHAR2,
    p_lang VARCHAR2,
    p_pages VARCHAR2,
    p_description VARCHAR2,
    p_ejemplares VARCHAR2,
    p_stock NUMBER,
    p_available NUMBER
) AS
BEGIN
    INSERT INTO books (
        title, publication_date, author_id, category, "edit", lang,
        pages, description, ejemplares, stock, available
    ) VALUES (
        p_title, p_publication_date, p_author_id, p_category, p_edit, p_lang,
        p_pages, p_description, p_ejemplares, p_stock, p_available
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_libro;
/
-------------------------------------------------------------------------------------------
--17
-- Procedimiento para actualizar la información de un autor y el título de un libro
CREATE OR REPLACE PROCEDURE actualizar_autor_y_libro(
    p_id_autor NUMBER,
    p_nombre_autor VARCHAR2,
    p_nacionalidad VARCHAR2,
    p_info_adicional CLOB,
    p_id_libro NUMBER,
    p_nuevo_titulo VARCHAR2
) AS
BEGIN
    -- Actualizar información del autor
    UPDATE autores
    SET Nombre_Autor = p_nombre_autor,
        Nacionalidad = p_nacionalidad,
        Informacion_Adicional = p_info_adicional
    WHERE ID_autor = p_id_autor;

    -- Actualizar título del libro
    UPDATE books
    SET title = p_nuevo_titulo
    WHERE id = p_id_libro;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END actualizar_autor_y_libro;
/
----------------------------------------------------------------------------------
--18
-- Procedimiento para insertar un nuevo autor
CREATE OR REPLACE PROCEDURE insertar_autor(
    p_nombre_autor VARCHAR2,
    p_nacionalidad VARCHAR2,
    p_info_adicional CLOB
) AS
BEGIN
    INSERT INTO autores (Nombre_Autor, Nacionalidad, Informacion_Adicional)
    VALUES (p_nombre_autor, p_nacionalidad, p_info_adicional);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_autor;
/
------------------------------------------------------------------------------
--19
-- Procedimiento para insertar un nuevo género
CREATE OR REPLACE PROCEDURE insertar_genero(
    p_nombre_genero VARCHAR2,
    p_desc_genero VARCHAR2
) AS
BEGIN
    INSERT INTO Generos (Nombre_Genero, Descripcion_Genero)
    VALUES (p_nombre_genero, p_desc_genero);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_genero;
/
-----------------------------------------------------------------------------
--20
-- Procedimiento para asociar un libro con un autor
CREATE OR REPLACE PROCEDURE asociar_libro_autor(
    p_id_autor NUMBER,
    p_id_libro NUMBER
) AS
BEGIN
    INSERT INTO libros_autores (id_autor, id_libros)
    VALUES (p_id_autor, p_id_libro);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END asociar_libro_autor;
/
------------------------------------------------------------------------------
--21
-- Procedimiento para insertar una nueva multa
CREATE OR REPLACE PROCEDURE insertar_multa(
    p_id_usuario NUMBER,
    p_monto DECIMAL,
    p_fecha_vencimiento DATE,
    p_estado_multa VARCHAR2
) AS
BEGIN
    INSERT INTO multas (id_users, monto, fecha_vencimiento, estado_multa)
    VALUES (p_id_usuario, p_monto, p_fecha_vencimiento, p_estado_multa);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_multa;
/
------------------------------------------------------------------------------
--21
-- Procedimiento para actualizar una multa
CREATE OR REPLACE PROCEDURE actualizar_multa(
    p_id_multa NUMBER,
    p_monto DECIMAL,
    p_fecha_vencimiento DATE,
    p_estado_multa VARCHAR2
) AS
BEGIN
    UPDATE multas
    SET monto = p_monto,
        fecha_vencimiento = p_fecha_vencimiento,
        estado_multa = p_estado_multa
    WHERE id_multa = p_id_multa;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END actualizar_multa;
/
--------------------------------------------------------------------------
--22
-- Procedimiento para eliminar una multa
CREATE OR REPLACE PROCEDURE eliminar_multa(
    p_id_multa NUMBER
) AS
BEGIN
    DELETE FROM multas WHERE id_multa = p_id_multa;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END eliminar_multa;
/
-----------------------------------------------------------------------
--23
-- Procedimiento para insertar una nueva editorial
CREATE OR REPLACE PROCEDURE insertar_editorial(
    p_nombre_editorial VARCHAR2,
    p_direccion_editorial VARCHAR2,
    p_info_contacto_editorial VARCHAR2
) AS
BEGIN
    INSERT INTO editorial (Nombre_editorial, Direccion_editorial, Informacion_contacto_editorial)
    VALUES (p_nombre_editorial, p_direccion_editorial, p_info_contacto_editorial);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END insertar_editorial;
/
---------------------------------------------------------------------------
--24

CREATE OR REPLACE PROCEDURE actualizar_editorial(
    p_id_editorial NUMBER,
    p_nombre_editorial VARCHAR2,
    p_direccion_editorial VARCHAR2,
    p_info_contacto_editorial VARCHAR2
) AS
BEGIN
    UPDATE editorial
    SET Nombre_editorial = p_nombre_editorial,
        Direccion_editorial = p_direccion_editorial,
        Informacion_contacto_editorial = p_info_contacto_editorial
    WHERE ID_editorial = p_id_editorial;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END actualizar_editorial;
/
-----------------------------------------------------------------------------
--25
CREATE OR REPLACE PROCEDURE eliminar_editorial(
    p_id_editorial NUMBER
) AS
BEGIN
    DELETE FROM editorial WHERE ID_editorial = p_id_editorial;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores según sea necesario
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END eliminar_editorial;
/

--Cursores----------------------------------------------------------------------
--1--
DECLARE
    CURSOR c_books IS
        SELECT * FROM books;
BEGIN
    FOR book_rec IN c_books LOOP
        -- Lógica para cada registro de libro
        DBMS_OUTPUT.PUT_LINE('Book Title: ' || book_rec.title);
    END LOOP;
END;
--------------------------------------------------------------------------------
--2--
DECLARE
    v_author_name VARCHAR2(255) := 'NombreDelAutor';
    CURSOR c_books_by_author IS
        SELECT * FROM books WHERE author = v_author_name;
BEGIN
    FOR book_rec IN c_books_by_author LOOP
        -- Lógica para cada libro del autor específico
        DBMS_OUTPUT.PUT_LINE('Book Title: ' || book_rec.title);
    END LOOP;
END;
--------------------------------------------------------------------------------
--3--
DECLARE
    CURSOR c_lendings IS
        SELECT * FROM lendings_table;
BEGIN
    FOR lending_rec IN c_lendings LOOP
        -- Lógica para cada registro de préstamo
        DBMS_OUTPUT.PUT_LINE('Book ID: ' || lending_rec.book_id || ', User ID: ' || lending_rec.user_id);
    END LOOP;
END;
--------------------------------------------------------------------------------
--4--
DECLARE
    CURSOR c_users_with_penalties IS
        SELECT * FROM users WHERE sanctions > 0;
BEGIN
    FOR user_rec IN c_users_with_penalties LOOP
        -- Lógica para cada usuario con multa
        DBMS_OUTPUT.PUT_LINE('User ID: ' || user_rec.id || ', Name: ' || user_rec.name);
    END LOOP;
END;
--------------------------------------------------------------------------------
--5--
DECLARE
    v_book_id NUMBER := 1; -- ID del libro deseado
    v_available_books NUMBER;
    CURSOR c_available_books IS
        SELECT available FROM books WHERE id = v_book_id;
BEGIN
    OPEN c_available_books;
    FETCH c_available_books INTO v_available_books;
    CLOSE c_available_books;

    -- Lógica para utilizar v_available_books
    DBMS_OUTPUT.PUT_LINE('Available Books: ' || v_available_books);
END;
--------------------------------------------------------------------------------
--6--
DECLARE
    v_lending_id NUMBER := 1; -- ID del préstamo deseado
    CURSOR c_lending_details IS
        SELECT * FROM lendings_table WHERE id = v_lending_id;
BEGIN
    FOR lending_rec IN c_lending_details LOOP
        -- Lógica para cada detalle del préstamo
        DBMS_OUTPUT.PUT_LINE('Lending ID: ' || lending_rec.id || ', Book ID: ' || lending_rec.book_id || ', User ID: ' || lending_rec.user_id);
    END LOOP;
END;
--------------------------------------------------------------------------------
--7--
DECLARE
    CURSOR c_book_genres IS
        SELECT DISTINCT category FROM books;
BEGIN
    FOR genre_rec IN c_book_genres LOOP
        DBMS_OUTPUT.PUT_LINE('Book Genre: ' || genre_rec.category);
    END LOOP;
END;
--------------------------------------------------------------------------------
--8--
DECLARE
    CURSOR c_authors_with_info IS
        SELECT * FROM autores;
BEGIN
    FOR author_rec IN c_authors_with_info LOOP
        DBMS_OUTPUT.PUT_LINE('Author ID: ' || author_rec.ID_autor || ', Name: ' || author_rec.Nombre_Autor || ', Nationality: ' || author_rec.Nacionalidad);
    END LOOP;
END;
--------------------------------------------------------------------------------
--9--
DECLARE
    CURSOR libros_prestamo_cursor IS
        SELECT id, title, author
        FROM books
        WHERE id IN (SELECT book_id FROM lendings_table WHERE date_return IS NULL);
BEGIN
    
    FOR libro IN libros_prestamo_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Libro en préstamo: ' || libro.title || ', Autor: ' || libro.author);
    END LOOP;
END;
--------------------------------------------------------------------------------
--10--
DECLARE
    CURSOR usuarios_multas_cursor IS
        SELECT id, name, last_name_p, last_name_m
        FROM users
        WHERE id IN (SELECT DISTINCT id_users FROM multas WHERE estado_multa = 'Activa');
BEGIN
    FOR usuario IN usuarios_multas_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Usuario con multa activa: ' || usuario.name || ' ' || usuario.last_name_p);
    END LOOP;
END;
--------------------------------------------------------------------------------
--11--
DECLARE
    v_user_id NUMBER := 1; -- ID del usuario específico
    CURSOR prestamos_usuario_cursor IS
        SELECT lt.id, lt.date_out, lt.date_return, b.title
        FROM lendings_table lt
        INNER JOIN books b ON lt.book_id = b.id
        WHERE lt.user_id = v_user_id;
BEGIN
    FOR prestamo IN prestamos_usuario_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Préstamo ID: ' || prestamo.id || ', Libro: ' || prestamo.title ||
                             ', Fecha de préstamo: ' || prestamo.date_out);
    END LOOP;
END;
--------------------------------------------------------------------------------
--12--
DECLARE
    CURSOR autores_mas_cinco_libros_cursor IS
        SELECT a.ID_autor, a.Nombre_Autor, COUNT(la.id_libros) AS total_libros
        FROM autores a
        INNER JOIN libros_autores la ON a.ID_autor = la.id_autor
        GROUP BY a.ID_autor, a.Nombre_Autor
        HAVING COUNT(la.id_libros) > 5;
BEGIN
    FOR autor IN autores_mas_cinco_libros_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Autor con más de 5 libros: ' || autor.Nombre_Autor || ', Total de libros: ' || autor.total_libros);
    END LOOP;
END;
--------------------------------------------------------------------------------
--13--
DECLARE
    v_categoria VARCHAR2(50) := 'Novela'; -- Categoría específica
    CURSOR libros_categoria_cursor IS
        SELECT id, title, author
        FROM books
        WHERE category = v_categoria;
BEGIN
    FOR libro_categoria IN libros_categoria_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Libro en la categoría ' || v_categoria || ': ' || libro_categoria.title || ', Autor: ' || libro_categoria.author);
    END LOOP;
END;
--------------------------------------------------------------------------------
--14--
DECLARE
    CURSOR generos_libros_cursor IS
        SELECT DISTINCT lg.Nombre_Genero
        FROM libros_generos lg;
BEGIN
    FOR genero_libro IN generos_libros_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Género de libro disponible: ' || genero_libro.Nombre_Genero);
    END LOOP;
END;
--------------------------------------------------------------------------------
--15--
DECLARE
    CURSOR usuarios_con_sanciones_cursor IS
        SELECT id, name, last_name_p, last_name_m, sanc_money
        FROM users
        WHERE sanc_money > 0;
BEGIN
    FOR usuario_sancionado IN usuarios_con_sanciones_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Usuario con sanción monetaria: ' || usuario_sancionado.name ||
                             ' ' || usuario_sancionado.last_name_p || ', Monto: ' || usuario_sancionado.sanc_money);
    END LOOP;
END;

--Funciones---------------------------------------------------------------------
--1--
CREATE OR REPLACE FUNCTION obtener_libros_prestados_usuario(in_user_id NUMBER)
RETURN NUMBER
IS
    total_libros_prestados NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de libros prestados por un usuario
    SELECT COUNT(*)
    INTO total_libros_prestados
    FROM lendings_table
    WHERE user_id = in_user_id;
    
    RETURN total_libros_prestados;
END;
--------------------------------------------------------------------------------
--2--
CREATE OR REPLACE FUNCTION obtener_multas_usuario(in_user_id NUMBER)
RETURN NUMBER
IS
    total_multas NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de multas para un usuario
    SELECT COUNT(*)
    INTO total_multas
    FROM multas
    WHERE id_users = in_user_id;
    
    RETURN total_multas;
END;
--------------------------------------------------------------------------------
--3--
CREATE OR REPLACE FUNCTION obtener_nombre_completo_usuario(in_user_id NUMBER)
RETURN VARCHAR2
IS
    nombre_completo VARCHAR2(100);
BEGIN
    -- Obtener el nombre completo de un usuario
    SELECT name || ' ' || last_name_p || ' ' || last_name_m
    INTO nombre_completo
    FROM users
    WHERE id = in_user_id;
    
    RETURN nombre_completo;
END;
--------------------------------------------------------------------------------
--4--
CREATE OR REPLACE FUNCTION obtener_libros_por_genero(in_genre VARCHAR2)
RETURN NUMBER
IS
    total_libros NUMBER := 0;
BEGIN
    -- Obtener el número total de libros en un género específico
    SELECT COUNT(*)
    INTO total_libros
    FROM libros_generos lg
    INNER JOIN books b ON lg.id_libros = b.id
    WHERE lg.Nombre_Genero = in_genre;
    
    RETURN total_libros;
END;
--------------------------------------------------------------------------------
--5--
CREATE OR REPLACE FUNCTION obtener_nombre_autor_por_id(in_author_id NUMBER)
RETURN VARCHAR2
IS
    nombre_autor VARCHAR2(100);
BEGIN
    -- Obtener el nombre de un autor por su ID
    SELECT Nombre_Autor
    INTO nombre_autor
    FROM autores
    WHERE ID_autor = in_author_id;
    
    RETURN nombre_autor;
END;
--------------------------------------------------------------------------------
--6--
CREATE OR REPLACE FUNCTION obtener_nombre_editorial_por_id(in_editorial_id NUMBER)
RETURN VARCHAR2
IS
    nombre_editorial VARCHAR2(100);
BEGIN
    -- Obtener el nombre de una editorial por su ID
    SELECT Nombre_editorial
    INTO nombre_editorial
    FROM editorial
    WHERE ID_editorial = in_editorial_id;
    
    RETURN nombre_editorial;
END;
--------------------------------------------------------------------------------
--7--
CREATE OR REPLACE FUNCTION obtener_libros_por_idioma(in_idioma VARCHAR2)
RETURN NUMBER
IS
    total_libros_por_idioma NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de libros por idioma
    SELECT COUNT(*)
    INTO total_libros_por_idioma
    FROM books
    WHERE lang = in_idioma;
    
    RETURN total_libros_por_idioma;
END;
--------------------------------------------------------------------------------
--8--
CREATE OR REPLACE FUNCTION obtener_prestamos_por_categoria(in_category VARCHAR2)
RETURN NUMBER
IS
    total_prestamos_por_categoria NUMBER := 0;
BEGIN
    -- Obtener la cantidad de préstamos por categoría de libros
    SELECT COUNT(*)
    INTO total_prestamos_por_categoria
    FROM lendings_table lt
    INNER JOIN books b ON lt.book_id = b.id
    WHERE b.category = in_category;
    
    RETURN total_prestamos_por_categoria;
END;
--------------------------------------------------------------------------------
--9--
CREATE OR REPLACE FUNCTION obtener_libros_por_autor(in_author_id NUMBER)
RETURN NUMBER
IS
    total_libros_por_autor NUMBER := 0;
BEGIN
    -- Obtener la cantidad de libros escritos por un autor específico
    SELECT COUNT(*)
    INTO total_libros_por_autor
    FROM libros_autores la
    INNER JOIN books b ON la.id_libros = b.id
    WHERE la.id_autor = in_author_id;
    
    RETURN total_libros_por_autor;
END;
--------------------------------------------------------------------------------
--10--
CREATE OR REPLACE FUNCTION obtener_prestamos_activos_usuario(in_user_id NUMBER)
RETURN NUMBER
IS
    total_prestamos_activos NUMBER := 0;
BEGIN
    -- Obtener la cantidad de préstamos activos de un usuario
    SELECT COUNT(*)
    INTO total_prestamos_activos
    FROM lendings_table
    WHERE user_id = in_user_id AND date_return IS NULL;
    
    RETURN total_prestamos_activos;
END;
--------------------------------------------------------------------------------
--11--
CREATE OR REPLACE FUNCTION obtener_libros_por_genero_idioma(in_genre VARCHAR2, in_idioma VARCHAR2)
RETURN NUMBER
IS
    total_libros_por_genero_idioma NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de libros por género en un idioma específico
    SELECT COUNT(*)
    INTO total_libros_por_genero_idioma
    FROM libros_generos lg
    INNER JOIN books b ON lg.id_libros = b.id
    WHERE lg.Nombre_Genero = in_genre AND b.lang = in_idioma;
    
    RETURN total_libros_por_genero_idioma;
END;
--------------------------------------------------------------------------------
--12--
CREATE OR REPLACE FUNCTION obtener_monto_multas_usuario(in_user_id NUMBER)
RETURN DECIMAL
IS
    monto_total_multas DECIMAL(10, 2) := 0;
BEGIN
    -- Obtener el monto total de multas para un usuario
    SELECT SUM(monto)
    INTO monto_total_multas
    FROM multas
    WHERE id_users = in_user_id;
    
    RETURN monto_total_multas;
END;
--------------------------------------------------------------------------------
--13--
CREATE OR REPLACE FUNCTION obtener_libros_por_autor_idioma(in_author_id NUMBER, in_idioma VARCHAR2)
RETURN NUMBER
IS
    total_libros_por_autor_idioma NUMBER := 0;
BEGIN
    -- Obtener la cantidad de libros de un autor en un idioma específico
    SELECT COUNT(*)
    INTO total_libros_por_autor_idioma
    FROM libros_autores la
    INNER JOIN books b ON la.id_libros = b.id
    WHERE la.id_autor = in_author_id AND b.lang = in_idioma;
    
    RETURN total_libros_por_autor_idioma;
END;
--------------------------------------------------------------------------------
--14--
CREATE OR REPLACE FUNCTION obtener_libros_por_categoria(in_category VARCHAR2)
RETURN NUMBER
IS
    total_libros_por_categoria NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de libros en una categoría específica
    SELECT COUNT(*)
    INTO total_libros_por_categoria
    FROM books
    WHERE category = in_category;
    
    RETURN total_libros_por_categoria;
END;
--------------------------------------------------------------------------------
--15--
CREATE OR REPLACE FUNCTION obtener_libros_por_idioma_categoria(in_idioma VARCHAR2, in_categoria VARCHAR2)
RETURN NUMBER
IS
    total_libros_por_idioma_categoria NUMBER := 0;
BEGIN
    -- Obtener la cantidad total de libros por idioma y categoría
    SELECT COUNT(*)
    INTO total_libros_por_idioma_categoria
    FROM books
    WHERE lang = in_idioma AND category = in_categoria;
    
    RETURN total_libros_por_idioma_categoria;
END;

--Paquetes----------------------------------------------------------------------
--1--
CREATE OR REPLACE PACKAGE book_package AS
  PROCEDURE get_book_info(book_id IN NUMBER);
  PROCEDURE get_available_copies(book_title IN VARCHAR2);
END book_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY book_package AS
  PROCEDURE get_book_info(book_id IN NUMBER) IS
  BEGIN
    FOR book_rec IN (SELECT * FROM books WHERE id = book_id) LOOP
      DBMS_OUTPUT.PUT_LINE('Book ID: ' || book_rec.id || ', Title: ' || book_rec.title || ', Author: ' || book_rec.author);
    END LOOP;
  END get_book_info;

  PROCEDURE get_available_copies(book_title IN VARCHAR2) IS
    v_libro_id NUMBER;
    v_disponibles NUMBER;
  BEGIN
    SELECT id INTO v_libro_id FROM books WHERE title = book_title;

    IF v_libro_id IS NOT NULL THEN
      SELECT available INTO v_disponibles FROM books WHERE id = v_libro_id;
      DBMS_OUTPUT.PUT_LINE('Book: ' || book_title || ', Available Copies: ' || v_disponibles);
    ELSE
      DBMS_OUTPUT.PUT_LINE('The book with title ' || book_title || ' does not exist.');
    END IF;
  END get_available_copies;
END book_package;
--------------------------------------------------------------------------------
--2--
CREATE OR REPLACE PACKAGE stats_package AS
  PROCEDURE get_total_books;
  PROCEDURE get_total_users;
END stats_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY stats_package AS
  PROCEDURE get_total_books IS
    total_books NUMBER;
  BEGIN
    SELECT COUNT(*) INTO total_books FROM books;
    DBMS_OUTPUT.PUT_LINE('Total Books: ' || total_books);
  END get_total_books;

  PROCEDURE get_total_users IS
    total_users NUMBER;
  BEGIN
    SELECT COUNT(*) INTO total_users FROM users;
    DBMS_OUTPUT.PUT_LINE('Total Users: ' || total_users);
  END get_total_users;
END stats_package;
--------------------------------------------------------------------------------
--3--
CREATE OR REPLACE PACKAGE transaction_package AS
  PROCEDURE make_purchase(user_id IN NUMBER, book_id IN NUMBER);
  PROCEDURE return_book(user_id IN NUMBER, book_id IN NUMBER);
END transaction_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY transaction_package AS
  PROCEDURE make_purchase(user_id IN NUMBER, book_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Purchase made successfully.');
  END make_purchase;

  PROCEDURE return_book(user_id IN NUMBER, book_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Book returned successfully.');
  END return_book;
END transaction_package;
--------------------------------------------------------------------------------
--4--
CREATE OR REPLACE PACKAGE user_package AS
  PROCEDURE create_user(username IN VARCHAR2, email IN VARCHAR2, password IN VARCHAR2);
  FUNCTION authenticate_user(username IN VARCHAR2, password IN VARCHAR2) RETURN BOOLEAN;
  PROCEDURE update_user_profile(user_id IN NUMBER, new_username IN VARCHAR2, new_email IN VARCHAR2);
END user_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY user_package AS
  PROCEDURE create_user(username IN VARCHAR2, email IN VARCHAR2, password IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('User created successfully.');
  END create_user;

  FUNCTION authenticate_user(username IN VARCHAR2, password IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN TRUE; 
  END authenticate_user;

  PROCEDURE update_user_profile(user_id IN NUMBER, new_username IN VARCHAR2, new_email IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('User profile updated successfully.');
  END update_user_profile;
END user_package;
--------------------------------------------------------------------------------
--5--
CREATE OR REPLACE PACKAGE user_management_package AS
  PROCEDURE create_user(username IN VARCHAR2, password IN VARCHAR2, email IN VARCHAR2);
  PROCEDURE update_user_email(user_id IN NUMBER, new_email IN VARCHAR2);
  PROCEDURE delete_user(user_id IN NUMBER);
  FUNCTION get_user_info(user_id IN NUMBER) RETURN SYS_REFCURSOR;
END user_management_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY user_management_package AS
  PROCEDURE create_user(username IN VARCHAR2, password IN VARCHAR2, email IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('User created successfully.');
  END create_user;

  PROCEDURE update_user_email(user_id IN NUMBER, new_email IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('User email updated successfully.');
  END update_user_email;

  PROCEDURE delete_user(user_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('User deleted successfully.');
  END delete_user;

  FUNCTION get_user_info(user_id IN NUMBER) RETURN SYS_REFCURSOR IS
    user_info_cursor SYS_REFCURSOR;
  BEGIN
    OPEN user_info_cursor FOR
      SELECT * FROM users WHERE user_id = user_id;
    RETURN user_info_cursor;
  END get_user_info;
END user_management_package;
--------------------------------------------------------------------------------
--6--
CREATE OR REPLACE PACKAGE product_management_package AS
  PROCEDURE add_product(product_name IN VARCHAR2, price IN NUMBER, stock_quantity IN NUMBER);
  PROCEDURE update_product_price(product_id IN NUMBER, new_price IN NUMBER);
  PROCEDURE update_stock_quantity(product_id IN NUMBER, quantity_change IN NUMBER);
  PROCEDURE delete_product(product_id IN NUMBER);
  FUNCTION get_product_info(product_id IN NUMBER) RETURN SYS_REFCURSOR;
END product_management_package;
--Body--------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY product_management_package AS
  PROCEDURE add_product(product_name IN VARCHAR2, price IN NUMBER, stock_quantity IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Product added successfully.');
  END add_product;

  PROCEDURE update_product_price(product_id IN NUMBER, new_price IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Product price updated successfully.');
  END update_product_price;

  PROCEDURE update_stock_quantity(product_id IN NUMBER, quantity_change IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Stock quantity updated successfully.');
  END update_stock_quantity;

  PROCEDURE delete_product(product_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Product deleted successfully.');
  END delete_product;

  FUNCTION get_product_info(product_id IN NUMBER) RETURN SYS_REFCURSOR IS
    product_info_cursor SYS_REFCURSOR;
  BEGIN
    OPEN product_info_cursor FOR
      SELECT * FROM products WHERE product_id = product_id;
    RETURN product_info_cursor;
  END get_product_info;
END product_management_package;
--------------------------------------------------------------------------------
--7--
CREATE OR REPLACE PACKAGE security_package AS
  PROCEDURE grant_access(user_id IN NUMBER, resource_name IN VARCHAR2);
  PROCEDURE revoke_access(user_id IN NUMBER, resource_name IN VARCHAR2);
END security_package;

CREATE OR REPLACE PACKAGE BODY security_package AS
  PROCEDURE grant_access(user_id IN NUMBER, resource_name IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Access granted to ' || resource_name || ' for user ' || user_id);
  END grant_access;

  PROCEDURE revoke_access(user_id IN NUMBER, resource_name IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Access revoked from ' || resource_name || ' for user ' || user_id);
  END revoke_access;
END security_package;
--------------------------------------------------------------------------------
--8--
CREATE OR REPLACE PACKAGE message_management_package AS
  PROCEDURE send_email(recipient_email IN VARCHAR2, subject IN VARCHAR2, message_text IN VARCHAR2);
  PROCEDURE send_sms(phone_number IN VARCHAR2, message_text IN VARCHAR2);
END message_management_package;

CREATE OR REPLACE PACKAGE BODY message_management_package AS
  PROCEDURE send_email(recipient_email IN VARCHAR2, subject IN VARCHAR2, message_text IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Email sent to ' || recipient_email || ' with subject: ' || subject);
  END send_email;

  PROCEDURE send_sms(phone_number IN VARCHAR2, message_text IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('SMS sent to ' || phone_number);
  END send_sms;
END message_management_package;
--------------------------------------------------------------------------------
--9--
CREATE OR REPLACE PACKAGE lending_package AS
  PROCEDURE borrow_book(user_id IN NUMBER, book_id IN NUMBER);
  PROCEDURE return_book(lending_id IN NUMBER);
  FUNCTION get_user_lendings(user_id IN NUMBER) RETURN SYS_REFCURSOR;
END lending_package;

CREATE OR REPLACE PACKAGE BODY lending_package AS
  PROCEDURE borrow_book(user_id IN NUMBER, book_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Book borrowed successfully by User ID: ' || user_id);
  END borrow_book;

  PROCEDURE return_book(lending_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Book returned successfully for Lending ID: ' || lending_id);
  END return_book;

  FUNCTION get_user_lendings(user_id IN NUMBER) RETURN SYS_REFCURSOR IS
    lendings_cursor SYS_REFCURSOR;
  BEGIN
    OPEN lendings_cursor FOR
      SELECT lt.id, lt.date_out, lt.date_return, b.title
      FROM lendings_table lt
      INNER JOIN books b ON lt.book_id = b.id
      WHERE lt.user_id = user_id;
      
    RETURN lendings_cursor;
  END get_user_lendings;
END lending_package;
--------------------------------------------------------------------------------
--10--
CREATE OR REPLACE PACKAGE author_package AS
  PROCEDURE add_author(author_name IN VARCHAR2);
  PROCEDURE update_author(author_id IN NUMBER, new_name IN VARCHAR2);
  PROCEDURE delete_author(author_id IN NUMBER);
  FUNCTION get_books_by_author(author_id IN NUMBER) RETURN SYS_REFCURSOR;
END author_package;

CREATE OR REPLACE PACKAGE BODY author_package AS
  PROCEDURE add_author(author_name IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Author added successfully: ' || author_name);
  END add_author;

  PROCEDURE update_author(author_id IN NUMBER, new_name IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Author updated successfully. New name: ' || new_name);
  END update_author;

  PROCEDURE delete_author(author_id IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Author deleted successfully. Author ID: ' || author_id);
  END delete_author;

  FUNCTION get_books_by_author(author_id IN NUMBER) RETURN SYS_REFCURSOR IS
    books_cursor SYS_REFCURSOR;
  BEGIN
    OPEN books_cursor FOR
      SELECT b.id, b.title, b.category
      FROM libros_autores la
      INNER JOIN books b ON la.id_libros = b.id
      WHERE la.id_autor = author_id;
      
    RETURN books_cursor;
  END get_books_by_author;
END author_package;







