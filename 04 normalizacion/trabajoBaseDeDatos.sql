-- crear base de datos 
CREATE DATABASE sistema_ventas;
-- usar base de datos
USE sistema_ventas;
-- Creamos la tabla tipo_usuario
CREATE TABLE tipo_usuarios (
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
-- Identificador único
nombre_tipo VARCHAR(50) NOT NULL,
-- Tipo de usuario (Admin, Cliente)
-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
-- Tabla para usuarios

CREATE TABLE usuarios (

id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Id único

nombre_tipo VARCHAR(100) NOT NULL, -- Nombre de usuario

correo VARCHAR(100) UNIQUE, -- Correo electrónico único

tipo_usuario_id INT, -- Relación a tipo_usuario

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT, -- Usuario que crea

updated_by INT, -- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
ALTER TABLE usuarios -- Modificar tabla
-- Agregar una restricción (FK)

ADD CONSTRAINT fk_usuario_tipo_usuario

-- Añade referencia(FK)

FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuario(id_tipo_usuario);

CREATE TABLE Tabla_productos (

id_producto INT AUTO_INCREMENT PRIMARY KEY, -- Id único

nombre_producto VARCHAR(100) NOT NULL, -- Nombre de producto

precio FLOAT NOT NULL, -- Precio del producto

stock INT DEFAULT 0 NOT NULL, -- stock de los productos

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT, -- Usuario que crea

updated_by INT, -- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);


CREATE TABLE Tabla_Ventas (

id_Tabla_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único

fecha  DATE NOT NULL, -- fecha de la venta

usuario_id INT, -- Relación al usuario

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT, -- Usuario que crea

updated_by INT, -- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
ALTER TABLE Tabla_Ventas -- Modificar tabla
-- Agregar una restricción (FK)

ADD CONSTRAINT fk_Tabla_ventas_usuarios

-- Añade referencia(FK)

FOREIGN KEY (usuario_id) REFERENCES
usuarios(id_usuario);

CREATE TABLE detalle_ventas (

id_Detalle_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único

Tabla_ventas_id  INT, -- Relacion al id de la tabla ventas

Tabla_productos_id  INT, -- Relacion al id de la tabla productos

fecha DATE, -- fecha del detalle de la venta

cantidad INT, -- cantidad de detalles de las ventas

precio_unitario FLOAT, -- precio unitario 

-- Campos de auditoría

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación

created_by INT, -- Usuario que crea

updated_by INT, -- Usuario que modifica

deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);