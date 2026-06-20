
-- Consultas 

-- SECCION 1: CONSULTAS BASICAS (SELECT, WHERE, ORDER BY)

-- 1.1 Listar todos los libros ordenados por titulo
SELECT ISBN, Titulo, Anio_Publicacion, Idioma
FROM Libro
ORDER BY Titulo ASC;

-- 1.2 Listar todos los socios activos
SELECT ID_Socio, Nombre_Socio, Apellido_Socio, Correo, Telefono
FROM Socio
WHERE Estado_Socio = 'Activo'
ORDER BY Apellido_Socio, Nombre_Socio;

-- 1.3 Listar ejemplares disponibles para prestamo
SELECT ID_Ejemplar, ISBN, Estado_Fisico, Disponibilidad
FROM Ejemplar
WHERE Disponibilidad = 'Disponible'
ORDER BY ISBN;

-- 1.4 Listar todos los prestamos realizados en el último mes
SELECT ID_Prestamo, Fecha_Prestamo, Fecha_Limite, ID_Socio, ID_Ejemplar
FROM Prestamo
WHERE Fecha_Prestamo >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY Fecha_Prestamo DESC;

-- 1.5 Listar multas pendientes de pago
SELECT ID_Multa, Monto_Calculado, Estado_Pago, ID_Devolucion
FROM Multa
WHERE Estado_Pago = 'Pendiente'
ORDER BY Monto_Calculado DESC;

-- 1.6 Listar reservas activas (Pendientes)
SELECT ID_Reserva, Fecha_Reserva, Estado_Reserva, ID_Ejemplar, ID_Socio
FROM Reserva
WHERE Estado_Reserva = 'Pendiente'
ORDER BY Fecha_Reserva ASC;

-- 1.7 Buscar libros publicados despues del año 2000
SELECT ISBN, Titulo, Anio_Publicacion, Idioma
FROM Libro
WHERE Anio_Publicacion > 2000
ORDER BY Anio_Publicacion DESC;

-- 1.8 Listar autores ordenados por apellido
SELECT ID_Autor, Nombre_Autor, Apellido_Autor, Nacionalidad
FROM Autor
ORDER BY Apellido_Autor, Nombre_Autor;

-- SECCIÓN 2: CONSULTAS CON JOINs ENTRE TABLAS

-- 2.1 Listar libros con su categoria y editorial
SELECT l.ISBN, l.Titulo, l.Anio_Publicacion, c.Nombre_Categoria, e.Nombre_Editorial, e.Pais
FROM Libro l
JOIN Categoria c ON l.ID_Categoria = c.ID_Categoria
JOIN Editorial e ON l.ID_Editorial = e.ID_Editorial
ORDER BY l.Titulo;

-- 2.2 Listar libros con sus autores
SELECT l.ISBN, l.Titulo, a.Nombre_Autor, a.Apellido_Autor, a.Nacionalidad
FROM Libro l
JOIN Libro_Autor la ON l.ISBN = la.ISBN
JOIN Autor a ON la.ID_Autor = a.ID_Autor
ORDER BY l.Titulo, a.Apellido_Autor;

-- 2.3 Listar prestamos con información del socio, ejemplar y empleado
SELECT p.ID_Prestamo, p.Fecha_Prestamo, p.Fecha_Limite,
       s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio,
       l.Titulo AS Libro,
       emp.Nombre_Empleado || ' ' || emp.Apellido_Empleado AS Empleado
FROM Prestamo p
JOIN Socio s ON p.ID_Socio = s.ID_Socio
JOIN Ejemplar ej ON p.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
JOIN Empleado emp ON p.ID_Empleado = emp.ID_Empleado
ORDER BY p.Fecha_Prestamo DESC;

-- 2.4 Listar devoluciones con su prestamo y socio correspondiente
SELECT d.ID_Devolucion, d.Fecha_Real_Devolucion, d.Condicion_Ejemplar_Recibido,
       p.Fecha_Prestamo, p.Fecha_Limite,
       s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio, l.Titulo AS Libro
FROM Devolucion d
JOIN Prestamo p ON d.ID_Prestamo = p.ID_Prestamo
JOIN Socio s ON p.ID_Socio = s.ID_Socio
JOIN Ejemplar ej ON p.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
ORDER BY d.Fecha_Real_Devolucion DESC;

-- 2.5 Listar multas con el detalle del socio y el libro
SELECT m.ID_Multa, m.Monto_Calculado, m.Estado_Pago,
       s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio, s.Correo,
       l.Titulo AS Libro, d.Fecha_Real_Devolucion, p.Fecha_Limite
FROM Multa m
JOIN Devolucion d ON m.ID_Devolucion = d.ID_Devolucion
JOIN Prestamo p ON d.ID_Prestamo = p.ID_Prestamo
JOIN Socio s ON p.ID_Socio = s.ID_Socio
JOIN Ejemplar ej ON p.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
ORDER BY m.Monto_Calculado DESC;

-- 2.6 Listar reservas pendientes con datos del socio y del libro reservado
SELECT r.ID_Reserva, r.Fecha_Reserva, r.Estado_Reserva,
       s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio,
       l.Titulo AS Libro, ej.Estado_Fisico
FROM Reserva r
JOIN Socio s ON r.ID_Socio = s.ID_Socio
JOIN Ejemplar ej ON r.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
WHERE r.Estado_Reserva = 'Pendiente'
ORDER BY r.Fecha_Reserva;

-- 2.7 Listar empleados con su supervisor (auto-join)
SELECT e.ID_Empleado, e.Nombre_Empleado || ' ' || e.Apellido_Empleado AS Empleado, e.Cargo,
       sup.Nombre_Empleado || ' ' || sup.Apellido_Empleado AS Supervisor
FROM Empleado e
LEFT JOIN Empleado sup ON e.ID_Supervisor = sup.ID_Empleado
ORDER BY e.Cargo, e.Apellido_Empleado;

-- SECCIÓN 3: FUNCIONES DE AGREGACIÓN

-- 3.1 Total de prestamos por socio
SELECT s.ID_Socio, s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio,
       COUNT(p.ID_Prestamo) AS Total_Prestamos
FROM Socio s
LEFT JOIN Prestamo p ON s.ID_Socio = p.ID_Socio
GROUP BY s.ID_Socio, s.Nombre_Socio, s.Apellido_Socio
ORDER BY Total_Prestamos DESC;

-- 3.2 Total de libros por categoría
SELECT c.Nombre_Categoria, COUNT(l.ISBN) AS Total_Libros
FROM Categoria c
LEFT JOIN Libro l ON c.ID_Categoria = l.ID_Categoria
GROUP BY c.Nombre_Categoria
ORDER BY Total_Libros DESC;

-- 3.3 Monto total de multas por socio
SELECT s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio,
       SUM(m.Monto_Calculado) AS Total_Multas, COUNT(m.ID_Multa) AS Cantidad_Multas
FROM Socio s
JOIN Prestamo p ON s.ID_Socio = p.ID_Socio
JOIN Devolucion d ON p.ID_Prestamo = d.ID_Prestamo
JOIN Multa m ON d.ID_Devolucion = m.ID_Devolucion
GROUP BY s.ID_Socio, s.Nombre_Socio, s.Apellido_Socio
ORDER BY Total_Multas DESC;

-- 3.4 Promedio, minimo y maximo de multas registradas
SELECT AVG(Monto_Calculado) AS Promedio_Multa, MIN(Monto_Calculado) AS Multa_Minima,
       MAX(Monto_Calculado) AS Multa_Maxima, SUM(Monto_Calculado) AS Total_General
FROM Multa;

-- 3.5 Cantidad de ejemplares por libro
SELECT l.Titulo, COUNT(ej.ID_Ejemplar) AS Total_Ejemplares,
       SUM(CASE WHEN ej.Disponibilidad = 'Disponible' THEN 1 ELSE 0 END) AS Disponibles,
       SUM(CASE WHEN ej.Disponibilidad <> 'Disponible' THEN 1 ELSE 0 END) AS No_Disponibles
FROM Libro l
LEFT JOIN Ejemplar ej ON l.ISBN = ej.ISBN
GROUP BY l.ISBN, l.Titulo
ORDER BY Total_Ejemplares DESC;

-- 3.6 Pretamos registrados por empleado
SELECT emp.Nombre_Empleado || ' ' || emp.Apellido_Empleado AS Empleado, emp.Cargo,
       COUNT(p.ID_Prestamo) AS Total_Prestamos
FROM Empleado emp
LEFT JOIN Prestamo p ON emp.ID_Empleado = p.ID_Empleado
GROUP BY emp.ID_Empleado, emp.Nombre_Empleado, emp.Apellido_Empleado, emp.Cargo
ORDER BY Total_Prestamos DESC;

-- SECCIÓN 4: CONSULTAS AVANZADAS (SUBCONSULTAS, GROUP BY, HAVING)

-- 4.1 Libros mas prestados en los ultimos 3 meses
SELECT l.ISBN, l.Titulo, COUNT(p.ID_Prestamo) AS Veces_Prestado
FROM Libro l
JOIN Ejemplar ej ON l.ISBN = ej.ISBN
JOIN Prestamo p ON ej.ID_Ejemplar = p.ID_Ejemplar
WHERE p.Fecha_Prestamo >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY l.ISBN, l.Titulo
ORDER BY Veces_Prestado DESC;

-- 4.2 Socios con multas pendientes
SELECT s.ID_Socio, s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio, s.Correo, s.Telefono,
       COUNT(m.ID_Multa) AS Cantidad_Multas, SUM(m.Monto_Calculado) AS Total_Deuda
FROM Socio s
JOIN Prestamo p ON s.ID_Socio = p.ID_Socio
JOIN Devolucion d ON p.ID_Prestamo = d.ID_Prestamo
JOIN Multa m ON d.ID_Devolucion = m.ID_Devolucion
WHERE m.Estado_Pago = 'Pendiente'
GROUP BY s.ID_Socio, s.Nombre_Socio, s.Apellido_Socio, s.Correo, s.Telefono
ORDER BY Total_Deuda DESC;

-- 4.3 Autores con mayor número de títulos en catalogo
SELECT a.ID_Autor, a.Nombre_Autor || ' ' || a.Apellido_Autor AS Autor, a.Nacionalidad,
       COUNT(la.ISBN) AS Total_Titulos
FROM Autor a
JOIN Libro_Autor la ON a.ID_Autor = la.ID_Autor
GROUP BY a.ID_Autor, a.Nombre_Autor, a.Apellido_Autor, a.Nacionalidad
ORDER BY Total_Titulos DESC;

-- 4.4 Ejemplares que nunca han sido prestados
SELECT ej.ID_Ejemplar, ej.Estado_Fisico, ej.Disponibilidad, l.Titulo AS Libro
FROM Ejemplar ej
JOIN Libro l ON ej.ISBN = l.ISBN
WHERE ej.ID_Ejemplar NOT IN (SELECT ID_Ejemplar FROM Prestamo)
ORDER BY l.Titulo;

-- 4.5 Empleado que ha procesado mas prestamos en el mes actual
SELECT emp.ID_Empleado, emp.Nombre_Empleado || ' ' || emp.Apellido_Empleado AS Empleado, emp.Cargo,
       COUNT(p.ID_Prestamo) AS Prestamos_Este_Mes
FROM Empleado emp
JOIN Prestamo p ON emp.ID_Empleado = p.ID_Empleado
WHERE EXTRACT(MONTH FROM p.Fecha_Prestamo) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM p.Fecha_Prestamo) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY emp.ID_Empleado, emp.Nombre_Empleado, emp.Apellido_Empleado, emp.Cargo
ORDER BY Prestamos_Este_Mes DESC
LIMIT 1;

-- 4.6 Socios que tienen exactamente 3 prestamos activos (sin devolución)
SELECT s.ID_Socio, s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio,
       COUNT(p.ID_Prestamo) AS Prestamos_Activos
FROM Socio s
JOIN Prestamo p ON s.ID_Socio = p.ID_Socio
WHERE p.ID_Prestamo NOT IN (SELECT ID_Prestamo FROM Devolucion)
GROUP BY s.ID_Socio, s.Nombre_Socio, s.Apellido_Socio
HAVING COUNT(p.ID_Prestamo) = 3
ORDER BY s.Apellido_Socio;

-- 4.7 Libros con mas de un autor registrado
SELECT l.ISBN, l.Titulo, COUNT(la.ID_Autor) AS Cantidad_Autores
FROM Libro l
JOIN Libro_Autor la ON l.ISBN = la.ISBN
GROUP BY l.ISBN, l.Titulo
HAVING COUNT(la.ID_Autor) > 1
ORDER BY Cantidad_Autores DESC;

-- 4.8 Socios que nunca han tenido una multa
SELECT s.ID_Socio, s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio, s.Estado_Socio
FROM Socio s
WHERE s.ID_Socio NOT IN (
    SELECT p.ID_Socio
    FROM Prestamo p
    JOIN Devolucion d ON p.ID_Prestamo = d.ID_Prestamo
    JOIN Multa m ON d.ID_Devolucion = m.ID_Devolucion
)
ORDER BY s.Apellido_Socio;

-- 4.9 Prestamos vencidos sin devolucion registrada
SELECT p.ID_Prestamo, p.Fecha_Prestamo, p.Fecha_Limite,
       CURRENT_DATE - p.Fecha_Limite AS Dias_Vencido,
       s.Nombre_Socio || ' ' || s.Apellido_Socio AS Socio, s.Correo, l.Titulo AS Libro
FROM Prestamo p
JOIN Socio s ON p.ID_Socio = s.ID_Socio
JOIN Ejemplar ej ON p.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
WHERE p.Fecha_Limite < CURRENT_DATE
  AND p.ID_Prestamo NOT IN (SELECT ID_Prestamo FROM Devolucion)
ORDER BY Dias_Vencido DESC;

-- 4.10 Categorias sin ningun libro registrado
SELECT c.ID_Categoria, c.Nombre_Categoria, c.Descripcion
FROM Categoria c
WHERE c.ID_Categoria NOT IN (SELECT DISTINCT ID_Categoria FROM Libro)
ORDER BY c.Nombre_Categoria;

-- 4.11 Ranking de editoriales por cantidad de libros en catalogo
SELECT e.Nombre_Editorial, e.Pais, COUNT(l.ISBN) AS Total_Libros,
       RANK() OVER (ORDER BY COUNT(l.ISBN) DESC) AS Ranking
FROM Editorial e
LEFT JOIN Libro l ON e.ID_Editorial = l.ID_Editorial
GROUP BY e.ID_Editorial, e.Nombre_Editorial, e.Pais
ORDER BY Ranking;

-- 4.12 Historial completo de un socio: prestamos, devoluciones y multas
--       (Reemplazar el valor 1 con el ID del socio que se desea consultar)
SELECT p.ID_Prestamo, p.Fecha_Prestamo, p.Fecha_Limite, l.Titulo AS Libro,
       d.Fecha_Real_Devolucion,
       CASE WHEN d.ID_Devolucion IS NULL THEN 'Sin devolver' ELSE 'Devuelto' END AS Estado_Devolucion,
       m.Monto_Calculado, m.Estado_Pago
FROM Prestamo p
JOIN Ejemplar ej ON p.ID_Ejemplar = ej.ID_Ejemplar
JOIN Libro l ON ej.ISBN = l.ISBN
LEFT JOIN Devolucion d ON p.ID_Prestamo = d.ID_Prestamo
LEFT JOIN Multa m ON d.ID_Devolucion = m.ID_Devolucion
WHERE p.ID_Socio = 1   
ORDER BY p.Fecha_Prestamo DESC;