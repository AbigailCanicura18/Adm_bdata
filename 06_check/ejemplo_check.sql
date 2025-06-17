CREATE DATABASE EJEMPLO_CHECK;
USE EJEMPLO_CHECK;

CREATE TABLE tipo_usuarios (
    id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo VARCHAR(50) NOT NULL
    CHECK (nombre_tipo IN ('Estudiante', 'Profesor', 'Administrador')),
    descripcion_tipo VARCHAR(300) NOT NULL ,
    nivel_acceso TINYINT CHECK (nivel_acceso BETWEEN 1 AND 3),
    -- Campos de auditoría
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	-- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico

);



CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_usuario) >= 3 AND nombre_usuario REGEXP '^[A-Za-z ]+$'),
    password VARCHAR(13) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    activo BOOLEAN DEFAULT TRUE,
    edad TINYINT CHECK (edad BETWEEN 13 AND 100),
    id_tipo INT,
    FOREIGN KEY (id_tipo) REFERENCES tipo_usuarios(id_tipo),
    
    -- Campos de auditoría
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	-- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);


CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(200) NOT NULL CHECK (CHAR_LENGTH(nombre_curso) BETWEEN 5 AND 200),
    duracion_horas DECIMAL(4,2) CHECK (duracion_horas > 0 AND duracion_horas <= 100),
    nivel VARCHAR(20) CHECK (nivel IN ('Principiante', 'Intermedio', 'Avanzado')),
    precio DECIMAL(10,2) CHECK (precio >= 0),
    fecha_publicacion DATE CHECK (fecha_publicacion >= '2020-01-01'),
    CHECK (
        (nivel = 'Principiante' AND precio <= 50) OR
        (nivel IN ('Intermedio', 'Avanzado') AND precio <= 200)
    ),
    -- Campos de auditoría
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	-- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
    
);




CREATE TABLE inscripciones(
	id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
	id_usuario INT NOT NULL,
    id_curso INT NOT NULL,
	fecha_inscripcion DATETIME DEFAULT current_timestamp,
    -- Campos de auditoría
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	-- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
	ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
    
);

ALTER TABLE inscripciones  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_cursos_inscripciones
-- Añade referencia(FK)
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso);

ALTER TABLE inscripciones  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_inscripciones
-- Añade referencia(FK)
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

