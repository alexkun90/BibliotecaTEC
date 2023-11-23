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

-- Crear las restricciones de clave forï¿½nea
ALTER TABLE lendings_table ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE lendings_table ADD CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(id);

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

--Creacion del usuario C##admin contraseña: 123
  
/*
    sqlplus /nolog
    conn system/su_contraseña
    
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


CREATE SEQUENCE autores_seq;

CREATE TABLE autores (
    ID_autor NUMBER DEFAULT multas_seq.NextVal PRIMARY Key,
    Nombre_Autor VARCHAR(45),
    Nacionalidad VARCHAR(25),
    Informacion_Adicional TEXT
);

CREATE SEQUENCE generos_seq;

CREATE TABLE Generos (
    ID_genero NUMBER DEFAULT generos_seq.NextVal PRIMARY KEY,
    Nombre_Genero VARCHAR(50),
    Descripcion_Genero VARCHAR(50)
);

CREATE SEQUENCE libros_autores_seq;

CREATE TABLE libros_autores (
    id_libros NUMBER DEFAULT libros_autores_seq.NextVal PRIMARY KEY,
    id_autor NUMBER
);

CREATE SEQUENCE libros_generos_seq;

CREATE TABLE libros_generos (
    id_libros NUMBER DEFAULT libros_generos_seq.NextVal PRIMARY KEY,
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
    ID_libro NUMBER
);

CREATE SEQUENCE idiomas_seq;

CREATE TABLE idiomas (
    ID_idioma NUMBER DEFAULT idiomas_seq.NextVal PRIMARY KEY,
    Nombre_idioma VARCHAR(50),
    Descripcion_idioma VARCHAR(255)
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

CREATE OR REPLACE TRIGGER update_user_sanctions
AFTER INSERT OR DELETE ON multas
FOR EACH ROW
DECLARE
    v_sanc_count NUMBER;
    v_total_sanc_money NUMBER;
BEGIN
    IF INSERTING THEN
        -- Incrementar el número de sanciones y el monto total de sanciones al insertar una multa
        UPDATE users
        SET sanctions = sanctions + 1,
            sanc_money = sanc_money + :new.monto
        WHERE id = :new.id_users;
    ELSIF DELETING THEN
        -- Decrementar el número de sanciones y el monto total de sanciones al eliminar una multa
        SELECT sanctions, sanc_money
        INTO v_sanc_count, v_total_sanc_money
        FROM users
        WHERE id = :old.id_users;

        IF v_sanc_count > 0 THEN
            UPDATE users
            SET sanctions = v_sanc_count - 1,
                sanc_money = v_total_sanc_money - :old.monto
            WHERE id = :old.id_users;
        END IF;
    END IF;
END;
/

-------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_book_available
AFTER INSERT OR DELETE ON multas
FOR EACH ROW
DECLARE
    v_available NUMBER;
BEGIN
    IF INSERTING THEN
        -- Actualizar disponible al insertar una multa
        SELECT available
        INTO v_available
        FROM books
        WHERE id = (SELECT book_id FROM lendings_table WHERE id = :new.id_multa);

        IF v_available > 0 THEN
            UPDATE books
            SET available = available - 1
            WHERE id = (SELECT book_id FROM lendings_table WHERE id = :new.id_multa);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No hay ejemplares disponibles para prestar.');
        END IF;

    ELSIF DELETING THEN
        -- Actualizar disponible al eliminar una multa
        UPDATE books
        SET available = available + 1
        WHERE id = (SELECT book_id FROM lendings_table WHERE id = :old.id_multa);
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
SELECT ID_usuario, ID_multa
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



--2 SP:procedimiento almacenado que reciba como parámetro el titulo de un libro y despliegue las copias que están disponibles (no prestadas).
CREATE OR REPLACE PROCEDURE copias_disponibles(p_titulo IN VARCHAR2) AS
  v_libro_id NUMBER;
  v_disponibles NUMBER;
BEGIN
  -- Obtener el ID del libro basado en el título proporcionado
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
    DBMS_OUTPUT.PUT_LINE('El libro con el título ' || p_titulo || ' no existe.');
  END IF;
END;
--ejecucion
EXEC copias_disponibles('Título del Libro');-- aqui se pone el titulo que hay en la BD

--3 SP: Procedimiento Almacenado que ingrese como parametros el nombre y apellido de un usuario y despliegue los títulos y copias que mantiene en préstamo

CREATE OR REPLACE PROCEDURE libros_en_prestamo(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2) AS
BEGIN
  FOR prestamo IN (SELECT b.title, lt.date_out
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE u.name = p_nombre AND u.last_name_p = p_apellido) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario: ' || p_nombre || ' ' || p_apellido || ', Título: ' || prestamo.title || ', Fecha de Préstamo: ' || prestamo.date_out);
  END LOOP;
END;

--Ejecucion 
EXEC libros_en_prestamo('NombreUsuario', 'ApellidoUsuario');--Aqui se coloca el nombre del usuario y apellidos ya registrada en la BD osea registrado previamente, con registros ya hechos

--4 SP:  procedimiento almacenado que despliegue el título del libro más prestado.
CREATE OR REPLACE PROCEDURE libro_mas_prestado AS
  v_titulo VARCHAR2(255);
BEGIN
  -- Obtener el título del libro más prestado
  SELECT b.title
  INTO v_titulo
  FROM books b
  JOIN lendings_table lt ON b.id = lt.book_id
  GROUP BY b.title
  ORDER BY COUNT(lt.id) DESC
  FETCH FIRST 1 ROW ONLY;

  -- Mostrar el resultado
  DBMS_OUTPUT.PUT_LINE('El libro más prestado es: ' || v_titulo);
END;
--ejecucion
EXEC libro_mas_prestado;

-- 5 SP: Procedimiento Almacenado que ingrese como parámetro el nombre de un autor y que devuelva como parámetro de salida el número de libros que ha escrito
CREATE OR REPLACE PROCEDURE libros_por_autor(
  p_nombre_autor IN VARCHAR2,
  p_num_libros OUT NUMBER
) AS
BEGIN
  -- Obtener el número de libros escritos por el autor
  SELECT COUNT(distinct la.ID_libro)
  INTO p_num_libros
  FROM autores_libros la
  JOIN autores a ON la.ID_autor = a.ID_autor
  WHERE a.Nombre_Autor = p_nombre_autor;
END;
--Ejcucion
DECLARE
  v_num_libros NUMBER;
BEGIN
  libros_por_autor('NombreAutor', v_num_libros);--Aqui se pone el nombre del autor que ya estarian en la base de datos registrados
  DBMS_OUTPUT.PUT_LINE('El autor ha escrito ' || v_num_libros || ' libros.');
END;

--6 SP:  Procedimiento Almacenado que reciba el nombre de un género como parámetro y devuelva los títulos de los libros pertenecientes a ese género.
CREATE OR REPLACE PROCEDURE libros_por_genero(p_nombre_genero IN VARCHAR2) AS
BEGIN
  FOR libro IN (SELECT b.title
                FROM books b
                JOIN libros_generos lg ON b.id = lg.id_libros
                JOIN generos g ON lg.id_genero = g.id_genero
                WHERE g.Nombre_Genero = p_nombre_genero)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Título: ' || libro.title);
  END LOOP;
END;

--Ejecucion 
BEGIN
  libros_por_genero('NombreGenero');
END;


--7 SP: Procedimiento Almacenado que muestre los préstamos que están vencidos, incluyendo detalles sobre los usuarios y los libros involucrados

CREATE OR REPLACE PROCEDURE prestamos_vencidos AS
BEGIN
  FOR prestamo IN (SELECT lt.id, u.name || ' ' || u.last_name_p || ' ' || u.last_name_m AS nombre_usuario,
                          b.title AS titulo_libro, lt.date_out, lt.date_return
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE lt.date_return < SYSDATE)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Préstamo ID: ' || prestamo.id ||
                         ', Usuario: ' || prestamo.nombre_usuario ||
                         ', Libro: ' || prestamo.titulo_libro ||
                         ', Fecha de Préstamo: ' || prestamo.date_out ||
                         ', Fecha de Devolución Vencida: ' || prestamo.date_return);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay préstamos vencidos.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion en un bloque anonimo
BEGIN
  prestamos_vencidos;
END;

--8 SP: Procedimiento Almacenado que muestre información detallada sobre un libro específico, incluyendo datos sobre autores, géneros y editorial

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
    DBMS_OUTPUT.PUT_LINE('Información detallada del libro:');
    DBMS_OUTPUT.PUT_LINE('Título: ' || info_libro.titulo_libro);
    DBMS_OUTPUT.PUT_LINE('Fecha de Publicación: ' || info_libro.publication_date);
    DBMS_OUTPUT.PUT_LINE('Autor: ' || info_libro.autor);
    DBMS_OUTPUT.PUT_LINE('Género: ' || info_libro.genero);
    DBMS_OUTPUT.PUT_LINE('Editorial: ' || info_libro.nombre_editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró información para el libro con ID ' || p_id_libro);
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
    DBMS_OUTPUT.PUT_LINE('No hay información disponible sobre usuarios con multas acumuladas.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--ejecucion
BEGIN
  usuarios_con_mas_multas;
END;

--10. SP: Procedimiento Almacenado que muestre los libros más recientemente añadidos a la biblioteca

CREATE OR REPLACE PROCEDURE libros_recientes AS
BEGIN
  FOR libro_reciente IN (
    SELECT id, title AS titulo_libro, publication_date, author, category, "edit" AS editorial, lang, pages, description, ejemplares, stock, available
    FROM books
    ORDER BY id DESC
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_reciente.id ||
                         ', Título: ' || libro_reciente.titulo_libro ||
                         ', Fecha de Publicación: ' || libro_reciente.publication_date ||
                         ', Autor: ' || libro_reciente.author ||
                         ', Categoría: ' || libro_reciente.category ||
                         ', Editorial: ' || libro_reciente.editorial ||
                         ', Idioma: ' || libro_reciente.lang ||
                         ', Páginas: ' || libro_reciente.pages ||
                         ', Descripción: ' || libro_reciente.description ||
                         ', Ejemplares: ' || libro_reciente.ejemplares ||
                         ', Stock: ' || libro_reciente.stock ||
                         ', Disponibles: ' || libro_reciente.available);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay información disponible sobre libros recientes.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion
BEGIN
  libros_recientes;
END;

--11. SP: Procedimiento Almacenado que reciba el nombre de un género como parámetro y devuelva los títulos de los libros pertenecientes a ese género

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
    DBMS_OUTPUT.PUT_LINE('Título del Libro: ' || libro_genero.titulo_libro);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay información disponible para el género ' || p_nombre_genero);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--Ejecucion
BEGIN
  libros_por_genero('NOMBRE_DEL_GENERO');
END;

--12: SP: Procedimiento Almacenado que muestre los libros que actualmente no están disponibles para préstamo

CREATE OR REPLACE PROCEDURE libros_no_disponibles AS
BEGIN
  FOR libro_no_disponible IN (
    SELECT id, title AS titulo_libro, author, "edit" AS editorial
    FROM books
    WHERE available = 0
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_no_disponible.id ||
                         ', Título: ' || libro_no_disponible.titulo_libro ||
                         ', Autor: ' || libro_no_disponible.author ||
                         ', Editorial: ' || libro_no_disponible.editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Todos los libros están disponibles para préstamo.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
-- Ejecucion de SP
BEGIN
  libros_no_disponibles;
END;





