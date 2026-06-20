-- 1. TRIGGER: Cálculo automático de multas al registrar una devolución tardía

CREATE OR REPLACE FUNCTION fn_calcular_multa()
RETURNS TRIGGER AS $$
DECLARE
    v_fecha_limite DATE;
    v_dias_retraso INT;
    v_monto_multa NUMERIC(10,2);
    v_id_multa INT;
BEGIN
    -- Obtener la fecha límite establecida originalmente para el préstamo
    SELECT Fecha_Limite INTO v_fecha_limite
    FROM Prestamo
    WHERE ID_Prestamo = NEW.ID_Prestamo;

    -- Calcular la diferencia en días entre la devolución real y la fecha límite
    v_dias_retraso := NEW.Fecha_Real_Devolucion - v_fecha_limite;

    -- Si existen días de retraso (mora), se procede a generar la multa
    IF v_dias_retraso > 0 THEN
        -- Tarifa estipulada por el negocio: $0.50 por día de retraso
        v_monto_multa := v_dias_retraso * 0.50;

        -- Obtener el identificador consecutivo automático para la nueva multa
        SELECT COALESCE(MAX(ID_Multa), 0) + 1 INTO v_id_multa FROM Multa;

        -- Insertar el registro de la multa con estado inicial 'Pendiente'
        INSERT INTO Multa (ID_Multa, Monto_Calculado, Estado_Pago, ID_Devolucion)
        VALUES (v_id_multa, v_monto_multa, 'Pendiente', NEW.ID_Devolucion);
        
        RAISE NOTICE 'ALERTA: Se ha generado automáticamente la multa ID % por % días de retraso. Monto: $% ', 
                     v_id_multa, v_dias_retraso, v_monto_multa;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creación del disparador asociado a la tabla Devolucion

CREATE OR REPLACE TRIGGER trg_verificar_multa
AFTER INSERT ON Devolucion
FOR EACH ROW
EXECUTE FUNCTION fn_calcular_multa();

-- 2. PROCEDIMIENTO ALMACENADO: Procesar y Validar un Préstamo de Ejemplar

CREATE OR REPLACE PROCEDURE sp_procesar_prestamo(
    p_id_prestamo INT,
    p_id_socio INT,
    p_id_ejemplar INT,
    p_id_empleado INT,
    p_fecha_prestamo DATE,
    p_dias_prestamo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado_ejemplar VARCHAR(50);
    v_estado_socio VARCHAR(50);
    v_multas_pendientes INT;
    v_prestamos_activos INT;
BEGIN
    -- VALIDACION 1: Verificar existencia y estado administrativo del socio
    SELECT Estado_Socio INTO v_estado_socio FROM Socio WHERE ID_Socio = p_id_socio;
    IF v_estado_socio IS NULL THEN
        RAISE EXCEPTION 'Préstamo denegado: El socio con ID % no existe.', p_id_socio;
    ELSIF v_estado_socio != 'Activo' THEN
        RAISE EXCEPTION 'Préstamo denegado: El socio no se encuentra activo (Estado actual: %).', v_estado_socio;
    END IF;

    -- VALIDACION 2: Verificar disponibilidad fisica real del ejemplar solicitado
    SELECT Disponibilidad INTO v_estado_ejemplar FROM Ejemplar WHERE ID_Ejemplar = p_id_ejemplar;
    IF v_estado_ejemplar IS NULL THEN
        RAISE EXCEPTION 'Préstamo denegado: El ejemplar con ID % no existe en el inventario.', p_id_ejemplar;
    ELSIF v_estado_ejemplar != 'Disponible' THEN
        RAISE EXCEPTION 'Préstamo denegado: El ejemplar % no está disponible (Estado actual: %).', p_id_ejemplar, v_estado_ejemplar;
    END IF;

    -- VALIDACION 3: Verificar que el socio no posea multas pendientes de pago
    SELECT COUNT(*) INTO v_multas_pendientes
    FROM Multa m
    JOIN Devolucion d ON m.ID_Devolucion = d.ID_Devolucion
    JOIN Prestamo p ON d.ID_Prestamo = p.ID_Prestamo
    WHERE p.ID_Socio = p_id_socio AND m.Estado_Pago = 'Pendiente';
    
    IF v_multas_pendientes > 0 THEN
        RAISE EXCEPTION 'Préstamo denegado: El socio % tiene % multa(s) pendiente(s) de pago.', p_id_socio, v_multas_pendientes;
    END IF;

    -- VALIDACION 4: Verificar limite institucional de prestamos activos (maximo 3 concurrentes)
    SELECT COUNT(*) INTO v_prestamos_activos
    FROM Prestamo p
    LEFT JOIN Devolucion d ON p.ID_Prestamo = d.ID_Prestamo
    WHERE p.ID_Socio = p_id_socio AND d.ID_Devolucion IS NULL;
    
    IF v_prestamos_activos >= 3 THEN
        RAISE EXCEPTION 'Préstamo denegado: El socio % ya alcanzó el límite estricto de 3 préstamos activos simultáneos.', p_id_socio;
    END IF;

    -- OPERACION TRANSACCIONAL: Si todas las reglas de negocio se cumplen con exito
    -- 1. Insertar el nuevo registro en la tabla Prestamo
    INSERT INTO Prestamo (ID_Prestamo, Fecha_Prestamo, Fecha_Limite, ID_Socio, ID_Ejemplar, ID_Empleado)
    VALUES (p_id_prestamo, p_fecha_prestamo, p_fecha_prestamo + p_dias_prestamo, p_id_socio, p_id_ejemplar, p_id_empleado);

    -- 2. Actualizar automáticamente la disponibilidad del ejemplar a 'Prestado'
    UPDATE Ejemplar
    SET Disponibilidad = 'Prestado'
    WHERE ID_Ejemplar = p_id_ejemplar;

    RAISE NOTICE 'ÉXITO: El préstamo ID % ha sido registrado correctamente y el ejemplar % pasó a estado Prestado.', 
                 p_id_prestamo, p_id_ejemplar;
END;
$$;



-- 3. DEMOSTRACIÓN DE FUNCIONAMIENTO (PRUEBAS DE VALIDACIÓN)

-- Prueba A: Intento de préstamo a socio con multas pendientes (DEBE FALLAR)
-- Explicación: El Socio 9 (Miguel Vásquez) tiene una multa de $2.75 marcada como 'Pendiente'.
--              Al intentar solicitar el Ejemplar 1 (que está disponible), el SP frena la transacción.
CALL sp_procesar_prestamo(11, 9, 1, 1, CURRENT_DATE, 14); 


-- Prueba B: Registro de un Préstamo Exitoso (DEBE PASAR)
-- Explicación: El Socio 4 (Laura Sánchez) está activa, libre de multas y con cupo disponible.
--              Se solicita el Ejemplar 10, registrando con éxito la operación en el sistema.
 CALL sp_procesar_prestamo(13, 4, 10, 2, CURRENT_DATE, 14);


-- Prueba C: Ejecución del Trigger mediante Devolución Tardía (COMPROBACIÓN AUTOMÁTICA)
-- Explicación: Insertamos la devolución para el préstamo ID 1 (cuya fecha límite era 2026-06-15).
--              Indicamos que se entrega el 2026-06-20 (5 días de retraso).
--              El disparador insertará automáticamente la multa ID 4 con un monto de $2.50.
INSERT INTO Devolucion (ID_Devolucion, Fecha_Real_Devolucion, Condicion_Ejemplar_Recibido, ID_Prestamo)
VALUES (5, '2026-06-20', 'Bueno', 1);

-- Verificar la creación automática de la multa generada por el Trigger:
 SELECT * FROM Multa WHERE ID_Devolucion = 5;