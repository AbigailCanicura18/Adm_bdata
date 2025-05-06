CREATE DATABASE sistema_ventas_4E;
USE sistema_ventas_4E;

-- Creamos la tabla tipo_usuario
CREATE TABLE tipo_usuarios (
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único
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
id_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Id único
nombre_usuario VARCHAR(100) NOT NULL, -- Nombre de usuario
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

ALTER TABLE usuarios  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_tipo_usuario
-- Añade referencia(FK)
FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuarios(id_tipo_usuario);

CREATE TABLE productos (
id_producto INT AUTO_INCREMENT PRIMARY KEY, -- Id único
nombre_producto VARCHAR(100) NOT NULL, -- Nombre del producto
precio FLOAT NOT NULL, -- precio de los productos
stock INT, -- stock de cuantos productos hay
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE ventas (
id_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
usuario_id INT, -- Usuario que realizó la venta
Fecha DATE NOT NULL, -- Fecha automática de venta
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

ALTER TABLE ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_ventas_usuarios
-- Añade referencia(FK)
FOREIGN KEY (usuario_id) REFERENCES
usuarios(id_usuario);

CREATE TABLE detalle_ventas (
id_detalle_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
venta_id INT NOT NULL, -- Relación a la venta
producto_id INT NOT NULL, -- Relación al producto
cantidad INT NOT NULL, -- Cantidad vendida
precio_unitario FLOAT NOT NULL,
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
-- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_detalle_ventas_ventas
-- Añade referencia(FK)
FOREIGN KEY (venta_id) REFERENCES
ventas(id_venta);

ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_detalle_ventas_productos
-- Añade referencia(FK)
FOREIGN KEY (producto_id) REFERENCES
productos(id_producto);

-- 1. Eliminar la FK en detalle ventas
ALTER TABLE detalle_ventas
DROP FOREIGN KEY fk_detalle_ventas_ventas;

-- 1. Eliminar la FK en ventas
ALTER TABLE ventas
DROP FOREIGN KEY fk_ventas_usuarios;

-- Paso 1: Cambiar la columna auto_increment para que ya no lo sea
ALTER TABLE ventas MODIFY id_ventas INT;

-- Paso 2: Ahora sí puedes eliminar la clave primaria
ALTER TABLE ventas DROP PRIMARY KEY;

ALTER TABLE ventas
CHANGE COLUMN id_ventas id_venta INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE usuarios ADD Password VARCHAR(15) AFTER correo;

ALTER TABLE tipo_usuarios ADD descripcion_tipo VARCHAR(200) AFTER nombre_tipo;













