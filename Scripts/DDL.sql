--  DDL - Creación de Tablas y Restricciones

CREATE TABLE Categoria
(
  ID_Categoria     INT          NOT NULL,
  Nombre_Categoria VARCHAR(300) NOT NULL,
  Descripcion      VARCHAR(1000),
  CONSTRAINT PK_Categoria PRIMARY KEY (ID_Categoria),
  CONSTRAINT UQ_Categoria_Nombre UNIQUE (Nombre_Categoria)
);

CREATE TABLE Editorial
(
  ID_Editorial     INT           NOT NULL,
  Nombre_Editorial VARCHAR(300)  NOT NULL,
  Pais             VARCHAR(300)  NOT NULL,
  Sitio_Web        VARCHAR(1000),
  CONSTRAINT PK_Editorial PRIMARY KEY (ID_Editorial),
  CONSTRAINT UQ_Editorial_Nombre UNIQUE (Nombre_Editorial),
  CONSTRAINT UQ_Editorial_Web UNIQUE (Sitio_Web)
);

CREATE TABLE Libro
(
  ISBN             VARCHAR(20)  NOT NULL,
  Titulo           VARCHAR(500) NOT NULL,
  Anio_Publicacion INT          NOT NULL,
  Idioma           VARCHAR(100),
  ID_Categoria     INT          NOT NULL,
  ID_Editorial     INT          NOT NULL,
  CONSTRAINT PK_Libro PRIMARY KEY (ISBN),
  CONSTRAINT FK_Libro_Categoria FOREIGN KEY (ID_Categoria)
    REFERENCES Categoria(ID_Categoria)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_Libro_Editorial FOREIGN KEY (ID_Editorial)
    REFERENCES Editorial(ID_Editorial)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE Autor
(
  ID_Autor       INT          NOT NULL,
  Nombre_Autor   VARCHAR(200) NOT NULL,
  Apellido_Autor VARCHAR(200) NOT NULL,
  Nacionalidad   VARCHAR(200),
  CONSTRAINT PK_Autor PRIMARY KEY (ID_Autor)
);

CREATE TABLE Libro_Autor
(
  ISBN     VARCHAR(20) NOT NULL,
  ID_Autor INT         NOT NULL,
  CONSTRAINT PK_Libro_Autor PRIMARY KEY (ISBN, ID_Autor),
  CONSTRAINT FK_LibroAutor_Libro FOREIGN KEY (ISBN)
    REFERENCES Libro(ISBN)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_LibroAutor_Autor FOREIGN KEY (ID_Autor)
    REFERENCES Autor(ID_Autor)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Ejemplar
(
  ID_Ejemplar    INT          NOT NULL,
  Estado_Fisico  VARCHAR(150) NOT NULL,
  Disponibilidad VARCHAR(50)  NOT NULL,
  ISBN           VARCHAR(20)  NOT NULL,
  CONSTRAINT PK_Ejemplar PRIMARY KEY (ID_Ejemplar),
  CONSTRAINT FK_Ejemplar_Libro FOREIGN KEY (ISBN)
    REFERENCES Libro(ISBN)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT CK_Ejemplar_Estado_Fisico CHECK (Estado_Fisico IN ('Nuevo', 'Bueno', 'Regular', 'Deteriorado')),
  CONSTRAINT CK_Ejemplar_Disponibilidad CHECK (Disponibilidad IN ('Disponible', 'Prestado', 'Baja'))
);

CREATE TABLE Socio
(
  ID_Socio       INT          NOT NULL,
  DUI            VARCHAR(10)  NOT NULL,
  Nombre_Socio   VARCHAR(200) NOT NULL,
  Apellido_Socio VARCHAR(200) NOT NULL,
  Correo         VARCHAR(250),
  Telefono       VARCHAR(200),
  Estado_Socio   VARCHAR(50)  DEFAULT 'Activo' NOT NULL,
  CONSTRAINT PK_Socio PRIMARY KEY (ID_Socio),
  CONSTRAINT UQ_Socio_DUI UNIQUE (DUI),
  CONSTRAINT UQ_Socio_Correo UNIQUE (Correo),
  CONSTRAINT CK_Socio_Estado_Socio CHECK (Estado_Socio IN ('Activo', 'Inactivo', 'Suspendido'))
);

CREATE TABLE Empleado
(
  ID_Empleado       INT          NOT NULL,
  Nombre_Empleado   VARCHAR(200) NOT NULL,
  Apellido_Empleado VARCHAR(200) NOT NULL,
  Cargo             VARCHAR(150) NOT NULL,
  ID_Supervisor     INT,
  CONSTRAINT PK_Empleado PRIMARY KEY (ID_Empleado),
  CONSTRAINT FK_Empleado_Supervisor FOREIGN KEY (ID_Supervisor)
    REFERENCES Empleado(ID_Empleado)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE Prestamo
(
  ID_Prestamo    INT  NOT NULL,
  Fecha_Prestamo DATE NOT NULL,
  Fecha_Limite   DATE NOT NULL,
  ID_Socio       INT  NOT NULL,
  ID_Ejemplar    INT  NOT NULL,
  ID_Empleado    INT  NOT NULL,
  CONSTRAINT PK_Prestamo PRIMARY KEY (ID_Prestamo),
  CONSTRAINT FK_Prestamo_Socio FOREIGN KEY (ID_Socio)
    REFERENCES Socio(ID_Socio)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_Prestamo_Ejemplar FOREIGN KEY (ID_Ejemplar)
    REFERENCES Ejemplar(ID_Ejemplar)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_Prestamo_Empleado FOREIGN KEY (ID_Empleado)
    REFERENCES Empleado(ID_Empleado)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE Devolucion
(
  ID_Devolucion               INT          NOT NULL,
  Fecha_Real_Devolucion       DATE         NOT NULL,
  Condicion_Ejemplar_Recibido VARCHAR(200),
  ID_Prestamo                 INT          NOT NULL,
  CONSTRAINT PK_Devolucion PRIMARY KEY (ID_Devolucion),
  CONSTRAINT FK_Devolucion_Prestamo FOREIGN KEY (ID_Prestamo)
    REFERENCES Prestamo(ID_Prestamo)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT UQ_Devolucion_Prestamo UNIQUE (ID_Prestamo),
  CONSTRAINT CK_Devolucion_Condicion CHECK (Condicion_Ejemplar_Recibido IN ('Nuevo', 'Bueno', 'Regular', 'Deteriorado'))
);

CREATE TABLE Multa
(
  ID_Multa        INT           NOT NULL,
  Monto_Calculado NUMERIC(10,2) NOT NULL,
  Estado_Pago     VARCHAR(50)   NOT NULL,
  ID_Devolucion   INT           NOT NULL,
  CONSTRAINT PK_Multa PRIMARY KEY (ID_Multa),
  CONSTRAINT FK_Multa_Devolucion FOREIGN KEY (ID_Devolucion)
    REFERENCES Devolucion(ID_Devolucion)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT UQ_Multa_Devolucion UNIQUE (ID_Devolucion),
  CONSTRAINT CK_Multa_Estado_Pago CHECK (Estado_Pago IN ('Pendiente', 'Pagada'))
);

CREATE TABLE Reserva
(
  ID_Reserva     INT  NOT NULL,
  Fecha_Reserva  DATE DEFAULT CURRENT_DATE NOT NULL,
  Estado_Reserva VARCHAR(50) DEFAULT 'Pendiente' NOT NULL,
  ID_Ejemplar    INT  NOT NULL,
  ID_Socio       INT  NOT NULL,
  CONSTRAINT PK_Reserva PRIMARY KEY (ID_Reserva),
  CONSTRAINT FK_Reserva_Ejemplar FOREIGN KEY (ID_Ejemplar)
    REFERENCES Ejemplar(ID_Ejemplar)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_Reserva_Socio FOREIGN KEY (ID_Socio)
    REFERENCES Socio(ID_Socio)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT CK_Reserva_Estado CHECK (Estado_Reserva IN ('Pendiente', 'Cancelada', 'Completada'))
);