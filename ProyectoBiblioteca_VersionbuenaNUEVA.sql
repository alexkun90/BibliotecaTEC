-- Eliminamos las configuraciones espec?ficas de MySQL
-- SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
-- SET AUTOCOMMIT = 0;
-- START TRANSACTION;
-- SET time_zone = "+00:00";
-- /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
-- /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
-- /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
-- /*!40101 SET NAMES utf8mb4 */;

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


-- Crear las restricciones de clave for?nea
ALTER TABLE lendings_table ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE lendings_table ADD CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(id);

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
INSERT INTO users(name, last_name_p, last_name_m, domicilio, tel) VALUES('Adrian','Ortega','Salas','ejemplo','2222222');
INSERT INTO users(name, last_name_p, last_name_m, domicilio, tel) VALUES('Adrian','Ortega','Salas','ejemplo','2222222');

INSERT INTO books(title, publication_date, author, category, "edit", lang, pages, description, ejemplares, stock, available) VALUES('PRUEBA','14-11-23','ORTEGA','MIEDO','Roos','EN','123','PRUEBA','HOLA',100,99);

--CONSULTAS DE PRUEBA 
SELECT * FROM USERS;
SELECT * FROM Books;
SELECT * FROM lendings_table;







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

--FUNCIONES

CREATE OR REPLACE PROCEDURE SP_Agregar_Libro(
   p_Title VARCHAR2,
   p_Author VARCHAR2,
   p_ISBN VARCHAR2,
   p_PublicationYear VARCHAR2,
   p_Genre VARCHAR2,
   p_Description VARCHAR2,
   p_Availability NUMBER
)
AS
BEGIN
   INSERT INTO books (title, author, isbn, publication_year, genre, description, availability)
   VALUES (p_Title, p_Author, p_ISBN, p_PublicationYear, p_Genre, p_Description, p_Availability);
END SP_Agregar_Libro;


CREATE OR REPLACE PROCEDURE SP_Registrar_Préstamo(
   p_UserID NUMBER,
   p_BookID NUMBER,
   p_DateOut VARCHAR2,
   p_DateReturnExpected VARCHAR2
)
AS
BEGIN
   INSERT INTO lendings_table (user_id, book_id, date_out, date_return_expected)
   VALUES (p_UserID, p_BookID, p_DateOut, p_DateReturnExpected);
END SP_Registrar_Préstamo;


CREATE OR REPLACE PROCEDURE SP_Registrar_Devolución(
   p_LoanID NUMBER,
   p_DateReturn VARCHAR2
)
AS
BEGIN
   UPDATE lendings_table
   SET date_return = p_DateReturn
   WHERE id = p_LoanID;
END SP_Registrar_Devolución;


CREATE OR REPLACE PROCEDURE SP_Agregar_Usuario(
   p_Name VARCHAR2,
   p_LastNameP VARCHAR2,
   p_LastNameM VARCHAR2,
   p_Email VARCHAR2,
   p_Phone VARCHAR2,
   p_Address VARCHAR2
)
AS
BEGIN
   INSERT INTO usuarios(name, last_name_p, last_name_m, correo_electronico, telefono, direccion)
   VALUES(p_Name, p_LastNameP, p_LastNameM, p_Email, p_Phone, p_Address);
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('Usuario agregado exitosamente.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_Agregar_Usuario;


CREATE OR REPLACE PROCEDURE SP_Registrar_Libro(
   p_Title VARCHAR2,
   p_PublicationDate VARCHAR2,
   p_Author VARCHAR2,
   p_Category VARCHAR2,
   p_Editor VARCHAR2,
   p_Language VARCHAR2,
   p_Pages VARCHAR2,
   p_Description VARCHAR2,
   p_Copies VARCHAR2,
   p_Stock NUMBER,
   p_Available NUMBER
)
AS
BEGIN
   INSERT INTO libros(title, publication_date, author, category, "edit", lang, pages, description, ejemplares, stock, available)
   VALUES(p_Title, p_PublicationDate, p_Author, p_Category, p_Editor, p_Language, p_Pages, p_Description, p_Copies, p_Stock, p_Available);
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('Libro registrado exitosamente.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_Registrar_Libro;


CREATE OR REPLACE PROCEDURE SP_Solicitar_Prestamo(
   p_UserID NUMBER,
   p_BookID NUMBER,
   p_StartDate VARCHAR2,
   p_DueDate VARCHAR2
)
AS
BEGIN
   INSERT INTO prestamos(id_usuario, id_libro, fecha_prestamo, fecha_devolucion_prevista, estado_prestamo)
   VALUES(p_UserID, p_BookID, TO_DATE(p_StartDate, 'DD-MM-RR'), TO_DATE(p_DueDate, 'DD-MM-RR'), 'pendiente');
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('Solicitud de préstamo registrada exitosamente.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_Solicitar_Prestamo;


CREATE OR REPLACE PROCEDURE SP_Registrar_Devolucion(
   p_LoanID NUMBER,
   p_ReturnDate VARCHAR2
)
AS
BEGIN
   UPDATE prestamos
   SET fecha_devolucion_real = TO_DATE(p_ReturnDate, 'DD-MM-RR'),
       estado_prestamo = 'devuelto'
   WHERE id_prestamo = p_LoanID;
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('Devolución registrada exitosamente.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_Registrar_Devolucion;


CREATE OR REPLACE PROCEDURE SP_Agregar_Autor(
   p_AuthorName VARCHAR2,
   p_Nationality VARCHAR2,
   p_AdditionalInfo VARCHAR2
)
AS
BEGIN
   INSERT INTO autores(nombre_autor, nacionalidad, informacion_adicional)
   VALUES(p_AuthorName, p_Nationality, p_AdditionalInfo);
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('Autor agregado exitosamente.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_Agregar_Autor;


--CURSORES
DECLARE
   CURSOR available_books IS
      SELECT id_libro, titulo, autor
      FROM libros
      WHERE disponible = 1;
   
   v_book_id libros.id_libro%TYPE;
   v_title libros.titulo%TYPE;
   v_author libros.autor%TYPE;
BEGIN
   OPEN available_books;
   LOOP
      FETCH available_books INTO v_book_id, v_title, v_author;
      EXIT WHEN available_books%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID: ' || v_book_id || ', Título: ' || v_title || ', Autor: ' || v_author);
   END LOOP;
   CLOSE available_books;
END;


DECLARE
   CURSOR users_with_fines IS
      SELECT u.id_usuario, u.nombre, u.apellido, m.monto
      FROM usuarios u
      JOIN multas m ON u.id_usuario = m.id_usuario
      WHERE m.estado_multa = 'pendiente';
   
   v_user_id usuarios.id_usuario%TYPE;
   v_name usuarios.nombre%TYPE;
   v_lastname usuarios.apellido%TYPE;
   v_fine_amount multas.monto%TYPE;
BEGIN
   OPEN users_with_fines;
   LOOP
      FETCH users_with_fines INTO v_user_id, v_name, v_lastname, v_fine_amount;
      EXIT WHEN users_with_fines%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID: ' || v_user_id || ', Nombre: ' || v_name || ' ' || v_lastname || ', Multa: ' || v_fine_amount);
   END LOOP;
   CLOSE users_with_fines;
END;


DECLARE
   CURSOR pending_loans IS
      SELECT p.id_prestamo, u.nombre, u.apellido, b.titulo, p.fecha_prestamo
      FROM prestamos p
      JOIN usuarios u ON p.id_usuario = u.id_usuario
      JOIN libros b ON p.id_libro = b.id_libro
      WHERE p.estado_prestamo = 'pendiente';
   
   v_loan_id prestamos.id_prestamo%TYPE;
   v_user_name usuarios.nombre%TYPE;
   v_user_lastname usuarios.apellido%TYPE;
   v_book_title libros.titulo%TYPE;
   v_loan_date prestamos.fecha_prestamo%TYPE;
BEGIN
   OPEN pending_loans;
   LOOP
      FETCH pending_loans INTO v_loan_id, v_user_name, v_user_lastname, v_book_title, v_loan_date;
      EXIT WHEN pending_loans%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Préstamo: ' || v_loan_id || ', Usuario: ' || v_user_name || ' ' || v_user_lastname || ', Libro: ' || v_book_title || ', Fecha de Préstamo: ' || v_loan_date);
   END LOOP;
   CLOSE pending_loans;
END;


DECLARE
   CURSOR book_authors_and_genres IS
      SELECT l.id_libro, a.nombre_autor, g.nombre_genero
      FROM libros_autores l
      JOIN autores a ON l.id_autor = a.id_autor
      JOIN libros_generos g ON l.id_libro = g.id_libro;
   
   v_book_id libros_autores.id_libro%TYPE;
   v_author_name autores.nombre_autor%TYPE;
   v_genre_name generos.nombre_genero%TYPE;
BEGIN
   OPEN book_authors_and_genres;
   LOOP
      FETCH book_authors_and_genres INTO v_book_id, v_author_name, v_genre_name;
      EXIT WHEN book_authors_and_genres%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Libro: ' || v_book_id || ', Autor: ' || v_author_name || ', Género: ' || v_genre_name);
   END LOOP;
   CLOSE book_authors_and_genres;
END;


DECLARE
   CURSOR users_with_pending_fines IS
      SELECT u.id_usuario, u.nombre, u.apellido, m.monto
      FROM usuarios u
      JOIN multas m ON u.id_usuario = m.id_usuario
      WHERE m.estado_multa = 'pendiente';
   
   v_user_id usuarios.id_usuario%TYPE;
   v_user_name usuarios.nombre%TYPE;
   v_user_lastname usuarios.apellido%TYPE;
   v_fine_amount multas.monto%TYPE;
BEGIN
   OPEN users_with_pending_fines;
   LOOP
      FETCH users_with_pending_fines INTO v_user_id, v_user_name, v_user_lastname, v_fine_amount;
      EXIT WHEN users_with_pending_fines%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Usuario: ' || v_user_id || ', Nombre: ' || v_user_name || ' ' || v_user_lastname || ', Multa Pendiente: ' || v_fine_amount);
   END LOOP;
   CLOSE users_with_pending_fines;
END;


DECLARE
   CURSOR books_by_genre IS
      SELECT l.id_libro, l.titulo, g.nombre_genero
      FROM libros l
      JOIN libros_generos g ON l.id_libro = g.id_libro;
   
   v_book_id libros.id_libro%TYPE;
   v_book_title libros.titulo%TYPE;
   v_genre_name generos.nombre_genero%TYPE;
BEGIN
   OPEN books_by_genre;
   LOOP
      FETCH books_by_genre INTO v_book_id, v_book_title, v_genre_name;
      EXIT WHEN books_by_genre%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Libro: ' || v_book_id || ', Título: ' || v_book_title || ', Género: ' || v_genre_name);
   END LOOP;
   CLOSE books_by_genre;
END;


DECLARE
   CURSOR overdue_fines IS
      SELECT m.id_multa, u.nombre, u.apellido, m.monto, m.fecha_vencimiento
      FROM multas m
      JOIN usuarios u ON m.id_usuario = u.id_usuario
      WHERE m.estado_multa = 'pendiente' AND m.fecha_vencimiento < SYSDATE;
   
   v_fine_id multas.id_multa%TYPE;
   v_user_name usuarios.nombre%TYPE;
   v_user_lastname usuarios.apellido%TYPE;
   v_fine_amount multas.monto%TYPE;
   v_due_date multas.fecha_vencimiento%TYPE;
BEGIN
   OPEN overdue_fines;
   LOOP
      FETCH overdue_fines INTO v_fine_id, v_user_name, v_user_lastname, v_fine_amount, v_due_date;
      EXIT WHEN overdue_fines%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Multa: ' || v_fine_id || ', Usuario: ' || v_user_name || ' ' || v_user_lastname || ', Monto: ' || v_fine_amount || ', Fecha de Vencimiento: ' || v_due_date);
   END LOOP;
   CLOSE overdue_fines;
END;


DECLARE
   CURSOR borrowed_books IS
      SELECT l.id_libro, u.nombre, u.apellido, l.fecha_prestamo, l.fecha_devolucion
      FROM prestamos l
      JOIN usuarios u ON l.id_usuario = u.id_usuario
      WHERE l.estado_prestamo = 'activo';
   
   v_book_id prestamos.id_libro%TYPE;
   v_user_name usuarios.nombre%TYPE;
   v_user_lastname usuarios.apellido%TYPE;
   v_loan_date prestamos.fecha_prestamo%TYPE;
   v_return_date prestamos.fecha_devolucion%TYPE;
BEGIN
   OPEN borrowed_books;
   LOOP
      FETCH borrowed_books INTO v_book_id, v_user_name, v_user_lastname, v_loan_date, v_return_date;
      EXIT WHEN borrowed_books%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('ID Libro: ' || v_book_id || ', Usuario: ' || v_user_name || ' ' || v_user_lastname || ', Fecha de Préstamo: ' || v_loan_date || ', Fecha de Devolución: ' || v_return_date);
   END LOOP;
   CLOSE borrowed_books;
END;


