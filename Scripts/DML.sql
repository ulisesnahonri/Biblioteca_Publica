-- ============================================================
--  DML - Población de Base de Datos y Manipulación
-- ============================================================

INSERT INTO Categoria (ID_Categoria, Nombre_Categoria, Descripcion) VALUES
(1, 'Narrativa', 'Obras de ficción que incluyen novelas y cuentos'),
(2, 'Ciencia Ficción', 'Género literario basado en avances científicos o tecnológicos futuristas'),
(3, 'Historia', 'Obras que documentan o analizan eventos históricos'),
(4, 'Ciencias Exactas', 'Libros de matemáticas, física, química y disciplinas afines'),
(5, 'Filosofía', 'Reflexiones sobre el ser, el conocimiento y la ética'),
(6, 'Tecnología', 'Libros sobre informática, programación y sistemas'),
(7, 'Literatura Infantil', 'Obras dirigidas al público infantil y juvenil'),
(8, 'Poesía', 'Colecciones de poemas y obras líricas'),
(9, 'Enciclopedias', 'Obras de consulta exhaustiva de múltiples temas y conocimientos');

INSERT INTO Editorial (ID_Editorial, Nombre_Editorial, Pais, Sitio_Web) VALUES
(1, 'Alfaguara', 'España', 'https://www.alfaguara.com'),
(2, 'Planeta', 'España', 'https://www.editorial.planeta.es'),
(3, 'Anagrama', 'España', 'https://www.anagrama-ed.es'),
(4, 'Fondo de Cultura Económica', 'México', 'https://www.fondodeculturaeconomica.com'),
(5, 'Siglo XXI', 'México', 'https://www.sigloxxieditores.com.mx'),
(6, 'Penguin Books', 'Reino Unido', 'https://www.penguin.co.uk'),
(7, 'McGraw-Hill', 'Estados Unidos', 'https://www.mheducation.com'),
(8, 'Losada', 'Argentina', 'https://www.editoriallosada.com');

INSERT INTO Libro (ISBN, Titulo, Anio_Publicacion, Idioma, ID_Categoria, ID_Editorial) VALUES
('978-84-204-1385-0', 'Cien años de soledad', 1967, 'Español', 1, 1),
('978-84-339-7574-6', 'El amor en los tiempos del cólera', 1985, 'Español', 1, 3),
('978-84-08-04668-3', 'El nombre de la rosa', 1980, 'Español', 1, 2),
('978-84-204-8373-9', '1984', 1949, 'Español', 2, 1),
('978-84-450-7461-9', 'Brave New World', 1932, 'Inglés', 2, 6),
('978-84-375-0473-2', 'Sapiens: De animales a dioses', 2011, 'Español', 3, 2),
('978-84-663-4778-0', 'Breve historia del tiempo', 1988, 'Español', 4, 2),
('978-84-206-5433-8', 'El mundo de Sofía', 1991, 'Español', 5, 1),
('978-84-415-3336-7', 'El programador pragmático', 1999, 'Español', 6, 7),
('978-84-204-1012-5', 'El principito', 1943, 'Español', 7, 1),
('978-84-030-0276-8', 'Veinte poemas de amor', 1924, 'Español', 8, 8),
('978-84-339-6794-9', 'Pedro Páramo', 1955, 'Español', 1, 4);

INSERT INTO Autor (ID_Autor, Nombre_Autor, Apellido_Autor, Nacionalidad) VALUES
(1, 'Gabriel', 'García Márquez', 'Colombiana'),
(2, 'Umberto', 'Eco', 'Italiana'),
(3, 'George', 'Orwell', 'Británica'),
(4, 'Aldous', 'Huxley', 'Británica'),
(5, 'Yuval Noah', 'Harari', 'Israelí'),
(6, 'Stephen', 'Hawking', 'Británica'),
(7, 'Jostein', 'Gaarder', 'Noruega'),
(8, 'Andrew', 'Hunt', 'Estadounidense'),
(9, 'David', 'Thomas', 'Estadounidense'),
(10, 'Antoine de', 'Saint-Exupéry', 'Francesa'),
(11, 'Pablo', 'Neruda', 'Chilena'),
(12, 'Juan', 'Rulfo', 'Mexicana');

INSERT INTO Libro_Autor (ISBN, ID_Autor) VALUES
('978-84-204-1385-0', 1),
('978-84-339-7574-6', 1),
('978-84-08-04668-3', 2),
('978-84-204-8373-9', 3),
('978-84-450-7461-9', 4),
('978-84-375-0473-2', 5),
('978-84-663-4778-0', 6),
('978-84-206-5433-8', 7),
('978-84-415-3336-7', 8),
('978-84-415-3336-7', 9),
('978-84-204-1012-5', 10),
('978-84-030-0276-8', 11),
('978-84-339-6794-9', 12);

INSERT INTO Ejemplar (ID_Ejemplar, Estado_Fisico, Disponibilidad, ISBN) VALUES
(1, 'Bueno', 'Disponible', '978-84-204-1385-0'),
(2, 'Regular', 'Prestado', '978-84-204-1385-0'),
(3, 'Nuevo', 'Disponible', '978-84-204-1385-0'),
(4, 'Bueno', 'Disponible', '978-84-339-7574-6'),
(5, 'Bueno', 'Baja', '978-84-339-7574-6'),
(6, 'Bueno', 'Prestado', '978-84-08-04668-3'),
(7, 'Nuevo', 'Disponible', '978-84-08-04668-3'),
(8, 'Bueno', 'Disponible', '978-84-204-8373-9'),
(9, 'Regular', 'Prestado', '978-84-204-8373-9'),
(10, 'Nuevo', 'Disponible', '978-84-450-7461-9'),
(11, 'Bueno', 'Disponible', '978-84-375-0473-2'),
(12, 'Bueno', 'Prestado', '978-84-375-0473-2'),
(13, 'Regular', 'Disponible', '978-84-663-4778-0'),
(14, 'Nuevo', 'Disponible', '978-84-206-5433-8'),
(15, 'Bueno', 'Disponible', '978-84-206-5433-8'),
(16, 'Bueno', 'Prestado', '978-84-415-3336-7'),
(17, 'Nuevo', 'Prestado', '978-84-204-1012-5'),
(18, 'Bueno', 'Prestado', '978-84-204-1012-5'),
(19, 'Regular', 'Disponible', '978-84-204-1012-5'),
(20, 'Regular', 'Disponible', '978-84-030-0276-8'),
(21, 'Bueno', 'Disponible', '978-84-339-6794-9'),
(22, 'Nuevo', 'Prestado', '978-84-339-6794-9');

INSERT INTO Empleado (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Cargo, ID_Supervisor) VALUES
(1, 'María', 'González López', 'Directora', NULL),
(2, 'Carlos', 'Martínez Pérez', 'Jefe de Circulación', 1),
(3, 'Ana', 'Rodríguez Silva', 'Bibliotecaria', 2),
(4, 'Luis', 'Hernández Cruz', 'Bibliotecario', 2),
(5, 'Sofía', 'López Mendoza', 'Asistente', 3),
(6, 'Diego', 'Ramírez Torres', 'Asistente', 4);

INSERT INTO Socio (ID_Socio, DUI, Nombre_Socio, Apellido_Socio, Correo, Telefono, Estado_Socio) VALUES
(1, '01234567-8', 'Juan', 'Pérez García', 'juan.perez@email.com', '7111-2222', 'Activo'),
(2, '09876543-2', 'María', 'López Torres', 'maria.lopez@email.com', '7333-4444', 'Activo'),
(3, '05678901-3', 'Carlos', 'Morales Vega', 'carlos.morales@email.com', '7555-6666', 'Activo'),
(4, '02345678-9', 'Laura', 'Sánchez Ruiz', 'laura.sanchez@email.com', '7777-8888', 'Activo'),
(5, '06789012-4', 'Roberto', 'Díaz Flores', NULL, '7999-0000', 'Activo'),
(6, '03456789-0', 'Ana', 'Martínez Cruz', 'ana.martinez@email.com', '7112-2233', 'Suspendido'),
(7, '07890123-5', 'Pedro', 'Hernández Lima', 'pedro.h@email.com', '7334-4455', 'Activo'),
(8, '04567890-1', 'Lucía', 'Ramírez Medina', 'lucia.r@email.com', '7556-6677', 'Inactivo'),
(9, '08901234-6', 'Miguel', 'Vásquez Orellana', 'miguel.v@email.com', '7778-8899', 'Activo'),
(10, '00123456-7', 'Valentina', 'Castro Pineda', 'vale.castro@email.com', '7990-0011', 'Activo');

INSERT INTO Prestamo (ID_Prestamo, Fecha_Prestamo, Fecha_Limite, ID_Socio, ID_Ejemplar, ID_Empleado) VALUES
(1, '2026-06-01', '2026-06-15', 1, 2, 3),
(2, '2026-06-03', '2026-06-17', 2, 6, 4),
(3, '2026-06-05', '2026-06-19', 3, 9, 3),
(4, '2026-06-10', '2026-06-24', 4, 16, 5),
(5, '2026-05-10', '2026-05-24', 7, 22, 6),
(6, '2026-05-01', '2026-05-15', 5, 2, 3),
(7, '2026-04-10', '2026-04-24', 9, 6, 4),
(8, '2026-05-20', '2026-06-03', 1, 13, 3),
(9, '2026-03-15', '2026-03-29', 2, 20, 5),
(10, '2026-06-08', '2026-06-22', 10, 12, 6),
(11, '2026-06-12', '2026-06-26', 3, 17, 4),
(12, '2026-06-14', '2026-06-28', 3, 18, 5);

INSERT INTO Devolucion (ID_Devolucion, Fecha_Real_Devolucion, Condicion_Ejemplar_Recibido, ID_Prestamo) VALUES
(1, '2026-05-22', 'Bueno', 6),
(2, '2026-05-05', 'Regular', 7),
(3, '2026-06-03', 'Bueno', 8),
(4, '2026-04-08', 'Deteriorado', 9);

INSERT INTO Multa (ID_Multa, Monto_Calculado, Estado_Pago, ID_Devolucion) VALUES
(1, 1.75, 'Pagada', 1),
(2, 2.75, 'Pendiente', 2),
(3, 2.50, 'Pagada', 4);

INSERT INTO Reserva (ID_Reserva, Fecha_Reserva, Estado_Reserva, ID_Ejemplar, ID_Socio) VALUES
(1, '2026-06-10', 'Pendiente', 12, 3),
(2, '2026-06-11', 'Pendiente', 9, 4),
(3, '2026-05-28', 'Cancelada', 6, 5),
(4, '2026-06-14', 'Pendiente', 2, 7),
(5, '2026-06-15', 'Cancelada', 16, 8);


-- ============================================================
-- EJEMPLOS DE MANIPULACIÓN DE DATOS (UPDATE Y DELETE)
-- Requisito de la rúbrica para sentencias DML
-- ============================================================

-- 1. UPDATE: Actualizar el teléfono y correo de un socio
UPDATE Socio
SET Telefono = '7000-9999', Correo = 'juan.perez.nuevo@email.com'
WHERE ID_Socio = 1;

-- 2. UPDATE: Cambiar el estado de un ejemplar por desgaste natural
UPDATE Ejemplar
SET Estado_Fisico = 'Deteriorado'
WHERE ID_Ejemplar = 5;

-- 3. DELETE: Eliminar una reserva que fue cancelada por el usuario
DELETE FROM Reserva
WHERE ID_Reserva = 3;

-- 4. DELETE: Eliminar un autor que se ingresó por error y no tiene libros
-- (Primero insertamos uno de prueba y luego lo borramos)
INSERT INTO Autor (ID_Autor, Nombre_Autor, Apellido_Autor, Nacionalidad) 
VALUES (99, 'Autor', 'Equivocado', 'Desconocida');

DELETE FROM Autor
WHERE ID_Autor = 99;