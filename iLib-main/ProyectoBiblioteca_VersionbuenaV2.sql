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
