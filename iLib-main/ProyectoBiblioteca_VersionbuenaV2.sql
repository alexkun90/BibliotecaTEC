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
