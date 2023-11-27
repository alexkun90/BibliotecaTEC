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

-- Crear las restricciones de clave for√Ø¬ø¬Ωnea
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

--Creacion del usuario C##admin contrase√±a: 123
  
/*
    sqlplus /nolog
    conn system/su_contrase√±a
    
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
        -- Incrementar el n√∫mero de sanciones y el monto total de sanciones al insertar una multa
        UPDATE users
        SET sanctions = sanctions + 1,
            sanc_money = sanc_money + :new.monto
        WHERE id = :new.id_users;
    ELSIF DELETING THEN
        -- Decrementar el n√∫mero de sanciones y el monto total de sanciones al eliminar una multa
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



--2 SP:procedimiento almacenado que reciba como par√°metro el titulo de un libro y despliegue las copias que est√°n disponibles (no prestadas).
CREATE OR REPLACE PROCEDURE copias_disponibles(p_titulo IN VARCHAR2) AS
  v_libro_id NUMBER;
  v_disponibles NUMBER;
BEGIN
  -- Obtener el ID del libro basado en el t√≠tulo proporcionado
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
    DBMS_OUTPUT.PUT_LINE('El libro con el t√≠tulo ' || p_titulo || ' no existe.');
  END IF;
END;
--ejecucion
EXEC copias_disponibles('T√≠tulo del Libro');-- aqui se pone el titulo que hay en la BD

--3 SP: Procedimiento Almacenado que ingrese como parametros el nombre y apellido de un usuario y despliegue los t√≠tulos y copias que mantiene en pr√©stamo

CREATE OR REPLACE PROCEDURE libros_en_prestamo(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2) AS
BEGIN
  FOR prestamo IN (SELECT b.title, lt.date_out
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE u.name = p_nombre AND u.last_name_p = p_apellido) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario: ' || p_nombre || ' ' || p_apellido || ', T√≠tulo: ' || prestamo.title || ', Fecha de Pr√©stamo: ' || prestamo.date_out);
  END LOOP;
END;

--Ejecucion 
EXEC libros_en_prestamo('NombreUsuario', 'ApellidoUsuario');--Aqui se coloca el nombre del usuario y apellidos ya registrada en la BD osea registrado previamente, con registros ya hechos

--4 SP:  procedimiento almacenado que despliegue el t√≠tulo del libro m√°s prestado.
CREATE OR REPLACE PROCEDURE libro_mas_prestado AS
  v_titulo VARCHAR2(255);
BEGIN
  -- Obtener el t√≠tulo del libro m√°s prestado
  SELECT b.title
  INTO v_titulo
  FROM books b
  JOIN lendings_table lt ON b.id = lt.book_id
  GROUP BY b.title
  ORDER BY COUNT(lt.id) DESC
  FETCH FIRST 1 ROW ONLY;

  -- Mostrar el resultado
  DBMS_OUTPUT.PUT_LINE('El libro m√°s prestado es: ' || v_titulo);
END;
--ejecucion
EXEC libro_mas_prestado;

-- 5 SP: Procedimiento Almacenado que ingrese como par√°metro el nombre de un autor y que devuelva como par√°metro de salida el n√∫mero de libros que ha escrito
CREATE OR REPLACE PROCEDURE libros_por_autor(
  p_nombre_autor IN VARCHAR2,
  p_num_libros OUT NUMBER
) AS
BEGIN
  -- Obtener el n√∫mero de libros escritos por el autor
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

--6 SP:  Procedimiento Almacenado que reciba el nombre de un g√©nero como par√°metro y devuelva los t√≠tulos de los libros pertenecientes a ese g√©nero.
CREATE OR REPLACE PROCEDURE libros_por_genero(p_nombre_genero IN VARCHAR2) AS
BEGIN
  FOR libro IN (SELECT b.title
                FROM books b
                JOIN libros_generos lg ON b.id = lg.id_libros
                JOIN generos g ON lg.id_genero = g.id_genero
                WHERE g.Nombre_Genero = p_nombre_genero)
  LOOP
    DBMS_OUTPUT.PUT_LINE('T√≠tulo: ' || libro.title);
  END LOOP;
END;

--Ejecucion 
BEGIN
  libros_por_genero('NombreGenero');
END;


--7 SP: Procedimiento Almacenado que muestre los pr√©stamos que est√°n vencidos, incluyendo detalles sobre los usuarios y los libros involucrados

CREATE OR REPLACE PROCEDURE prestamos_vencidos AS
BEGIN
  FOR prestamo IN (SELECT lt.id, u.name || ' ' || u.last_name_p || ' ' || u.last_name_m AS nombre_usuario,
                          b.title AS titulo_libro, lt.date_out, lt.date_return
                   FROM lendings_table lt
                   JOIN users u ON lt.user_id = u.id
                   JOIN books b ON lt.book_id = b.id
                   WHERE lt.date_return < SYSDATE)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Pr√©stamo ID: ' || prestamo.id ||
                         ', Usuario: ' || prestamo.nombre_usuario ||
                         ', Libro: ' || prestamo.titulo_libro ||
                         ', Fecha de Pr√©stamo: ' || prestamo.date_out ||
                         ', Fecha de Devoluci√≥n Vencida: ' || prestamo.date_return);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay pr√©stamos vencidos.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion en un bloque anonimo
BEGIN
  prestamos_vencidos;
END;

--8 SP: Procedimiento Almacenado que muestre informaci√≥n detallada sobre un libro espec√≠fico, incluyendo datos sobre autores, g√©neros y editorial

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
    DBMS_OUTPUT.PUT_LINE('Informaci√≥n detallada del libro:');
    DBMS_OUTPUT.PUT_LINE('T√≠tulo: ' || info_libro.titulo_libro);
    DBMS_OUTPUT.PUT_LINE('Fecha de Publicaci√≥n: ' || info_libro.publication_date);
    DBMS_OUTPUT.PUT_LINE('Autor: ' || info_libro.autor);
    DBMS_OUTPUT.PUT_LINE('G√©nero: ' || info_libro.genero);
    DBMS_OUTPUT.PUT_LINE('Editorial: ' || info_libro.nombre_editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontr√≥ informaci√≥n para el libro con ID ' || p_id_libro);
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
    DBMS_OUTPUT.PUT_LINE('No hay informaci√≥n disponible sobre usuarios con multas acumuladas.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--ejecucion
BEGIN
  usuarios_con_mas_multas;
END;

--10. SP: Procedimiento Almacenado que muestre los libros m√°s recientemente a√±adidos a la biblioteca

CREATE OR REPLACE PROCEDURE libros_recientes AS
BEGIN
  FOR libro_reciente IN (
    SELECT id, title AS titulo_libro, publication_date, author, category, "edit" AS editorial, lang, pages, description, ejemplares, stock, available
    FROM books
    ORDER BY id DESC
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_reciente.id ||
                         ', T√≠tulo: ' || libro_reciente.titulo_libro ||
                         ', Fecha de Publicaci√≥n: ' || libro_reciente.publication_date ||
                         ', Autor: ' || libro_reciente.author ||
                         ', Categor√≠a: ' || libro_reciente.category ||
                         ', Editorial: ' || libro_reciente.editorial ||
                         ', Idioma: ' || libro_reciente.lang ||
                         ', P√°ginas: ' || libro_reciente.pages ||
                         ', Descripci√≥n: ' || libro_reciente.description ||
                         ', Ejemplares: ' || libro_reciente.ejemplares ||
                         ', Stock: ' || libro_reciente.stock ||
                         ', Disponibles: ' || libro_reciente.available);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay informaci√≥n disponible sobre libros recientes.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;

--Ejecucion
BEGIN
  libros_recientes;
END;

--11. SP: Procedimiento Almacenado que reciba el nombre de un g√©nero como par√°metro y devuelva los t√≠tulos de los libros pertenecientes a ese g√©nero

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
    DBMS_OUTPUT.PUT_LINE('T√≠tulo del Libro: ' || libro_genero.titulo_libro);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay informaci√≥n disponible para el g√©nero ' || p_nombre_genero);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
--Ejecucion
BEGIN
  libros_por_genero('NOMBRE_DEL_GENERO');
END;

--12: SP: Procedimiento Almacenado que muestre los libros que actualmente no est√°n disponibles para pr√©stamo

CREATE OR REPLACE PROCEDURE libros_no_disponibles AS
BEGIN
  FOR libro_no_disponible IN (
    SELECT id, title AS titulo_libro, author, "edit" AS editorial
    FROM books
    WHERE available = 0
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID del Libro: ' || libro_no_disponible.id ||
                         ', T√≠tulo: ' || libro_no_disponible.titulo_libro ||
                         ', Autor: ' || libro_no_disponible.author ||
                         ', Editorial: ' || libro_no_disponible.editorial);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Todos los libros est√°n disponibles para pr√©stamo.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el procedimiento: ' || SQLERRM);
END;
-- Ejecucion de SP
BEGIN
  libros_no_disponibles;
END;

--Cursores----------------------------------------------------------------------
--1--
DECLARE
    CURSOR c_books IS
        SELECT * FROM books;
BEGIN
    FOR book_rec IN c_books LOOP
        -- LÛgica para cada registro de libro
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
        -- LÛgica para cada libro del autor especÌfico
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
        -- LÛgica para cada registro de prÈstamo
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
        -- LÛgica para cada usuario con multa
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

    -- LÛgica para utilizar v_available_books
    DBMS_OUTPUT.PUT_LINE('Available Books: ' || v_available_books);
END;
--------------------------------------------------------------------------------
--6--
DECLARE
    v_lending_id NUMBER := 1; -- ID del prÈstamo deseado
    CURSOR c_lending_details IS
        SELECT * FROM lendings_table WHERE id = v_lending_id;
BEGIN
    FOR lending_rec IN c_lending_details LOOP
        -- LÛgica para cada detalle del prÈstamo
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
        -- LÛgica para cada gÈnero
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
        -- LÛgica para cada autor con informaciÛn adicional
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
    -- LÛgica de uso del cursor (puede ser un bucle FOR, etc.)
    FOR libro IN libros_prestamo_cursor LOOP
        -- Acciones a realizar con cada fila del cursor
        DBMS_OUTPUT.PUT_LINE('Libro en prÈstamo: ' || libro.title || ', Autor: ' || libro.author);
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
    v_user_id NUMBER := 1; -- ID del usuario especÌfico
    CURSOR prestamos_usuario_cursor IS
        SELECT lt.id, lt.date_out, lt.date_return, b.title
        FROM lendings_table lt
        INNER JOIN books b ON lt.book_id = b.id
        WHERE lt.user_id = v_user_id;
BEGIN
    FOR prestamo IN prestamos_usuario_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('PrÈstamo ID: ' || prestamo.id || ', Libro: ' || prestamo.title ||
                             ', Fecha de prÈstamo: ' || prestamo.date_out);
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
        DBMS_OUTPUT.PUT_LINE('Autor con m·s de 5 libros: ' || autor.Nombre_Autor || ', Total de libros: ' || autor.total_libros);
    END LOOP;
END;
--------------------------------------------------------------------------------
--13--
DECLARE
    v_categoria VARCHAR2(50) := 'Novela'; -- CategorÌa especÌfica
    CURSOR libros_categoria_cursor IS
        SELECT id, title, author
        FROM books
        WHERE category = v_categoria;
BEGIN
    FOR libro_categoria IN libros_categoria_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Libro en la categorÌa ' || v_categoria || ': ' || libro_categoria.title || ', Autor: ' || libro_categoria.author);
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
        DBMS_OUTPUT.PUT_LINE('GÈnero de libro disponible: ' || genero_libro.Nombre_Genero);
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
        DBMS_OUTPUT.PUT_LINE('Usuario con sanciÛn monetaria: ' || usuario_sancionado.name ||
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
    -- Obtener el n˙mero total de libros en un gÈnero especÌfico
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
    -- Obtener la cantidad de prÈstamos por categorÌa de libros
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
    -- Obtener la cantidad de libros escritos por un autor especÌfico
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
    -- Obtener la cantidad de prÈstamos activos de un usuario
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
    -- Obtener la cantidad total de libros por gÈnero en un idioma especÌfico
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
    -- Obtener la cantidad de libros de un autor en un idioma especÌfico
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
    -- Obtener la cantidad total de libros en una categorÌa especÌfica
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
    -- Obtener la cantidad total de libros por idioma y categorÌa
    SELECT COUNT(*)
    INTO total_libros_por_idioma_categoria
    FROM books
    WHERE lang = in_idioma AND category = in_categoria;
    
    RETURN total_libros_por_idioma_categoria;
END;
--Paquetes----------------------------------------------------------------------
--1--
CREATE OR REPLACE PACKAGE library_mgmt AS
    -- Estados de un prÈstamo
    estado_prestado CONSTANT VARCHAR2(10) := 'Prestado';
    estado_devuelto CONSTANT VARCHAR2(10) := 'Devuelto';
    estado_vencido CONSTANT VARCHAR2(10) := 'Vencido';
    
    -- Cursor para obtener detalles de un prÈstamo
    TYPE LendingDetailCursor IS REF CURSOR;
    
    FUNCTION get_lending_detail(p_lending_id NUMBER) RETURN LendingDetailCursor;
    
    -- Obtener la multa total asociada a un prÈstamo
    FUNCTION obtener_multa_total(p_lending_id NUMBER) RETURN NUMBER;
END library_mgmt;
drop package library_mgmt;
--Body--
CREATE OR REPLACE PACKAGE BODY library_mgmt AS
    -- Cursor para obtener detalles de un prÈstamo
    FUNCTION get_lending_detail(p_lending_id NUMBER) RETURN LendingDetailCursor IS
        cur LendingDetailCursor;
    BEGIN
        OPEN cur FOR
            SELECT lt.id, lt.user_id, lt.book_id, lt.date_out, lt.date_return,
                b.title, u.name || ' ' || u.last_name_p AS user_name
            FROM lendings_table lt
            INNER JOIN books b ON lt.book_id = b.id
            INNER JOIN users u ON lt.user_id = u.id
            WHERE lt.id = p_lending_id;

        RETURN cur;
    END get_lending_detail;

    -- Obtener la multa total asociada a un prÈstamo
    FUNCTION obtener_multa_total(p_lending_id NUMBER) RETURN NUMBER IS
        v_multa_total NUMBER := 0;
    BEGIN
        -- LÛgica para calcular la multa total asociada a un prÈstamo
        FOR lending_rec IN (SELECT * FROM TABLE(get_lending_detail(p_lending_id))) LOOP
            -- LÛgica para calcular la multa
            IF lending_rec.date_return IS NULL OR lending_rec.date_return > SYSDATE THEN
                -- No hay multa si el libro no se ha devuelto o si la devoluciÛn est· dentro del plazo
                v_multa_total := 0;
            ELSE
                -- Ejemplo: $1 por dÌa de retraso
                v_multa_total := (lending_rec.date_return - lending_rec.date_out) * 1;
            END IF;
        END LOOP;
        
        RETURN v_multa_total;
    END obtener_multa_total;
END library_mgmt;
--------------------------------------------------------------------------------
--2--

--------------------------------------------------------------------------------
--3--

--------------------------------------------------------------------------------
--4--

--------------------------------------------------------------------------------
--5--

--------------------------------------------------------------------------------
--6--

--------------------------------------------------------------------------------
--7--

--------------------------------------------------------------------------------
--8--

--------------------------------------------------------------------------------
--9--

--------------------------------------------------------------------------------
--10--





