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

ALTER TABLE productos
ADD descripcion_producto VARCHAR(100) AFTER id_producto;

ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_detalle_ventas_productos
-- Añade referencia(FK)
FOREIGN KEY (producto_id) REFERENCES
productos(id_producto);


INSERT INTO usuarios (
    nombre_usuario, Password, correo, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'sistema',
    '$2y$10$2pE', -- Contraseña encriptada (ejemplo realista con bcrypt)
    'sistema@plataforma.cl',
    NULL,
    NULL,
    NULL
);

INSERT INTO tipo_usuarios (
    nombre_tipo,
    descripcion_tipo,
    created_by,
    updated_by
)
VALUES (
    'administrador',
    'Accede a todas las funciones del sistema, incluida la administración de usuarios.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'vendedor',
    'Gestiona las ventas y la atención al cliente, con acceso limitado a funciones administrativas.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'gerente',
    'Supervisa la operación del sistema de ventas y analiza el rendimiento del equipo.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'cliente',
    'Accede a su perfil personal, historial de compras y estado de sus pedidos.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
);

INSERT INTO usuarios (
    nombre_usuario, Password, correo, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'abigail.caniucura',
    'lalala1234', -- bcrypt hasheado
    'abigailcaniucura@gmail.com',
    1,  -- tipo: Administrador
    1,   1  -- creado por el usuario "sistema"

),
(
    'yetzibel.gonzales',
    'lalu4321', -- bcrypt hasheado
    'yetzibelgonzales@gmail.com',
    2,  -- tipo: Administrador
    1,   1  -- creado por el usuario "sistema"

),
(
    'mariangel.pirona',
    'jijijaja654', -- bcrypt hasheado
    'mariangelpirona@gmail.com',
    4,  -- tipo: Administrador
    1,   1  -- creado por el usuario "sistema"

),
(
    'ignacio.garrido',
    'tukituki', -- bcrypt hasheado
    'ignaciogarrido@gmail.com',
    3,  -- tipo: Administrador
    1,   1  -- creado por el usuario "sistema"

),
(
    'benjaminrios',
    'weko', -- bcrypt hasheado
    'benjaminrios@gmail.com',
    4,  -- tipo: Administrador
    1,   1  -- creado por el usuario "sistema"

);


INSERT INTO productos (
    nombre_producto, descripcion_producto, precio, stock, created_by, updated_by
)
VALUES (
	'Utek Fuente de poder micro atx 500w', -- nombre del producto
    'Fuente de poder de 500W para gabinetes micro ATX, ideal para equipos de bajo consumo.',
    21.990, -- precio
    100, -- stock
    3,  
    3

),
(
    'Unidad De Reparación De Computadora Portátil Intel Core 4 I7 3630qm', -- nombre del producto
    'Servicio de reparación con procesador Intel Core i7 de tercera generación para notebooks.',
    72.632, -- precio
    90, -- stock
    3,  
    3

),
(
    'Placa Madre Original Dell Inspiron 3542 3552 Fabricante De Equipos',
    'Placa base OEM compatible con laptops Dell Inspiron, ideal para reemplazos originales.',
    28.187, -- precio
    200, -- stock
    3,  
    3

),
(
    'Monitor Gamer 23.8'' 24F1P FHD 1K 180HZ 1MS FreeSync HDMI',
    'Monitor de alto rendimiento para gaming con 180Hz de refresco y 1ms de respuesta.',
    99.990, -- precio
    250, -- stock
    3,  
    3

),
(
    'Memoria RAM DDR4 3200MT/s Crucial PRO CP2K16G4DFRA32A',
    'Kit de RAM DDR4 Crucial PRO 3200MT/s, ideal para alto rendimiento en multitarea y juegos.',
    64.660, -- precio
    900, -- stock
    3,  
    3

);
ALTER TABLE ventas
CHANGE COLUMN Fecha fecha DATETIME;


INSERT INTO ventas (
    usuario_id, fecha, created_by, updated_by        
)
VALUES
(
    2,                -- Usuario que hizo la venta
    NOW(),            -- Fecha y hora actual del sistema
    3,                -- Usuario que creó el registro
    2                 -- Usuario que lo actualizó por última vez
),
(
    2,
    NOW(),
    3,
    3
),
(
    2,
    NOW(),
    3,
    3
),
(
    2,
    NOW(),
    3,
    2
),
(
    2,
    NOW(),
    3,
    2
);


INSERT INTO detalle_ventas (
    venta_id, producto_id, cantidad, precio_unitario, created_by, updated_by          
)
VALUES
(
    1,      -- Esta línea corresponde a la venta con ID 1
    1,      -- Producto con ID 1
    15,      -- Se vendieron 2 unidades
    21.990, -- Precio unitario del producto: 21.990
    2,      -- Creado por el usuario con ID 3
    2       -- Última actualización por el usuario con ID 3
),
(
    2,
    2,
    72,
    72.632,
    2,
    3
),
(
    3,
    3,
    90,
    28.187,
    2,
    2
),
(
    4,
    4,
    35,
    99.990,
    2,
    3
),
(
    5,
    5,
    40,
    64.660,
    2,
    4
);


select*from ventas;
select*from detalle_ventas;
select*from productos;
select*from tipo_usuarios;
select*from usuarios;






























