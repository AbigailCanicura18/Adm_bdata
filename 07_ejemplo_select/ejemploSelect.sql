-- 📌 Crear la base de datos y seleccionarla
CREATE DATABASE ejemploSelect;
USE ejemploSelect;



-- ====================================
-- 🧾 Tabla: tipo_usuarios
-- ====================================
CREATE TABLE tipo_usuarios (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY, -- ID único para cada tipo de usuario
    nombre_tipo VARCHAR(50) NOT NULL,       -- Nombre del tipo (Ej: Administrador)
    descripcion_tipo VARCHAR(200) NOT NULL, -- Descripción del tipo
    -- Validación mínima de longitud (se evita REGEXP para compatibilidad)
    CHECK (CHAR_LENGTH(descripcion_tipo) >= 10),
    
    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- ====================================
-- 👤 Tabla: usuarios
-- ====================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY, -- ID único por usuario
    username VARCHAR(50) NOT NULL UNIQUE,      -- Nombre de usuario (único)
    password VARCHAR(200) NOT NULL,            -- Contraseña
    email VARCHAR(100) NOT NULL UNIQUE,        -- Email único
    id_tipo_usuario INT,                       -- FK al tipo de usuario

    -- Relación con tipo_usuarios
    CONSTRAINT fk_usuarios_tipo_usuarios FOREIGN KEY (id_tipo_usuario)
        REFERENCES tipo_usuarios(id_tipo),

    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- ====================================
-- 🌆 Tabla: ciudad
-- ====================================
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY, -- ID único
    nombre_ciudad VARCHAR(100) NOT NULL,      -- Nombre de la ciudad
    -- Validación para restringir a ciertas ciudades
    CHECK (nombre_ciudad IN ('Santiago','Valparaíso','Concepción','La Serena','Puerto Montt')),
    region VARCHAR(100),                      -- Región a la que pertenece

    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- ====================================
-- 👥 Tabla: personas
-- ====================================
CREATE TABLE personas (
    id_persona INT AUTO_INCREMENT PRIMARY KEY, -- ID único
    rut VARCHAR(25) NOT NULL UNIQUE,           -- RUT chileno (único)
    nombre_completo VARCHAR(100) NOT NULL,     -- Nombre de la persona
    -- Validación mínima de longitud (sin REGEXP para compatibilidad)
    CHECK (CHAR_LENGTH(nombre_completo) >= 10),
    fecha_nac DATE,                            -- Fecha de nacimiento
    id_usuario INT,                            -- FK al usuario
    id_ciudad INT,                             -- FK a la ciudad

    -- Relaciones
    CONSTRAINT fk_personas_usuarios FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_personas_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad(id_ciudad),

    -- Campos de auditoría
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- ====================================
-- 🧪 Poblar las tablas
-- ====================================

-- Tabla tipo_usuarios
INSERT INTO tipo_usuarios (nombre_tipo, descripcion_tipo) VALUES
('Administrador', 'Acceso completo al sistema'),
('Cliente', 'Usuario con acceso restringido'),
('Moderador', 'Puede revisar y aprobar contenido');

-- Tabla usuarios
INSERT INTO usuarios (username, password, email, id_tipo_usuario) VALUES
('admin', 'pass1234', 'admin01@mail.com', 1),
('jvaldes', 'abc123', 'jvaldes@mail.com', 2),
('cmorales', '123456', 'cmorales@mail.com', 3),
('anavarro', 'pass4321', 'anavarro@mail.com', 2),
('rquezada', 'clave2023', 'rquezada@mail.com', 1),
('pgodoy', 'segura123', 'pgodoy@mail.com', 2),
('mdiaz', 'token456', 'mdiaz@mail.com', 3),
('scarvajal', 'azul789', 'scarvajal@mail.com', 2),
('ltapia', 'lt123', 'ltapia@mail.com', 3),
('afarias', 'afpass', 'afarias@mail.com', 2);

-- Tabla ciudad
INSERT INTO ciudad (nombre_ciudad, region) VALUES
('Santiago', 'Región Metropolitana'),
('Valparaíso', 'Región de Valparaíso'),
('Concepción', 'Región del Biobío'),
('La Serena', 'Región de Coquimbo'),
('Puerto Montt', 'Región de Los Lagos');

-- Tabla personas
INSERT INTO personas (rut, nombre_completo, fecha_nac, id_usuario, id_ciudad) VALUES
('11.111.111-1', 'Juan Valdés', '1990-04-12', 2, 1),
('22.222.222-2', 'Camila Morales', '1985-09-25', 3, 2),
('33.333.333-3', 'Andrea Navarro', '1992-11-03', 4, 3),
('44.444.444-4', 'Rodrigo Quezada', '1980-06-17', 5, 1),
('55.555.555-5', 'Patricio Godoy', '1998-12-01', 6, 4),
('66.666.666-6', 'María Díaz', '1987-07-14', 7, 5),
('77.777.777-7', 'Sebastián Carvajal', '1993-03-22', 8, 2),
('88.888.888-8', 'Lorena Tapia', '2000-10-10', 9, 3),
('99.999.999-9', 'Ana Farías', '1995-01-28', 10, 4),
('10.101.010-0', 'Carlos Soto', '1991-08-08', 1, 1); -- admin

-- ====================================
-- 🔍 Consultas útiles
-- ====================================

-- 1. Usuarios de tipo Cliente
SELECT username, email
FROM usuarios
WHERE id_tipo_usuario = 2;

-- 2. Personas nacidas después del año 1990
SELECT personas.nombre_completo, personas.fecha_nac, usuarios.username
FROM personas
JOIN usuarios ON personas.id_usuario = usuarios.id_usuario
WHERE personas.fecha_nac > '1990-01-01';

-- 3. Personas cuyo nombre comienza con 'A'
SELECT personas.nombre_completo, usuarios.email
FROM personas
JOIN usuarios ON personas.id_usuario = usuarios.id_usuario
WHERE personas.nombre_completo LIKE 'A%';

-- 4. Usuarios con correo '@mail.com'
SELECT username, email
FROM usuarios
WHERE email LIKE '%@mail.com%';

-- 5. Personas que NO viven en Valparaíso
SELECT personas.nombre_completo, ciudad.nombre_ciudad, usuarios.username
FROM personas
JOIN ciudad ON personas.id_ciudad = ciudad.id_ciudad
JOIN usuarios ON personas.id_usuario = usuarios.id_usuario
WHERE ciudad.nombre_ciudad <> 'Valparaíso';

-- 6. Usuarios con nombre de más de 7 caracteres
SELECT username
FROM usuarios
WHERE CHAR_LENGTH(username) > 7;

-- 7. Usuarios nacidos entre 1990 y 1995
SELECT usuarios.username
FROM personas
JOIN usuarios ON personas.id_usuario = usuarios.id_usuario
WHERE YEAR(personas.fecha_nac) BETWEEN 1990 AND 1995;