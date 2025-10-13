create database ciberseguridad_simulacion;
use ciberseguridad_simulacion;


CREATE TABLE tipo_usuarios(
    id_tipo_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_usuario  VARCHAR(50) NOT NULL CHECK (nombre_tipo_usuario IN ('Administrador','Usuario')),
    descripcion_tipo     VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_tipo) >= 3),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);

CREATE TABLE estados(
    id_estado          INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado      VARCHAR(20) NOT NULL UNIQUE,
    descripcion_estado VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_estado) >= 5),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);

CREATE TABLE tipo_opiniones(
    id_tipo_opinion      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_opinion  VARCHAR(50) NOT NULL CHECK (nombre_tipo_opinion IN ('Simulacion','Sistema General','Sugerencia','Problema')),
    descripcion_tipo     VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_tipo) >= 3),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);


CREATE TABLE usuarios(
    id_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario  VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_usuario) >= 3 AND nombre_usuario REGEXP '^[A-Za-zÀ-ÿ ]+$'),
    correo          VARCHAR(100) NOT NULL UNIQUE CHECK (correo LIKE '%@%.%'),
    contrasena      VARCHAR(255) NOT NULL,
    tipo_usuario_id INT NOT NULL,
    activo          BOOLEAN DEFAULT TRUE,
    ultimo_ingreso  DATETIME NULL,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_usuario_tipo FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuarios(id_tipo_usuario)
);


CREATE TABLE simulaciones(
    id_simulacion     INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id        INT NOT NULL,
    estado_id         INT NOT NULL DEFAULT 1,
    fecha_inicio      DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin         DATETIME NULL,
    duracion_segundos INT NULL,
    puntaje           DECIMAL(5,2) NULL CHECK (puntaje BETWEEN 0 AND 100),
    fue_enganado      BOOLEAN NULL,
    ip_usuario        VARCHAR(45),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_sim_usuario  FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_sim_estado   FOREIGN KEY (estado_id)  REFERENCES estados(id_estado)
);


CREATE TABLE datos_simulacion(
    id_datos          INT AUTO_INCREMENT PRIMARY KEY,
    simulacion_id     INT NOT NULL,
    telefono_falso    VARCHAR(20),
    correo_falso      VARCHAR(150) CHECK (correo_falso LIKE '%@%.%'),
    usuario_falso     VARCHAR(50),
    contrasena_falsa  VARCHAR(255),
    tipo_dato         VARCHAR(30) DEFAULT 'Login' CHECK (tipo_dato IN ('Login','Personal','Financiero','Otro')),
    datos_adicionales TEXT,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_datos_sim FOREIGN KEY (simulacion_id) REFERENCES simulaciones(id_simulacion)
);


CREATE TABLE opiniones_usuarios(
    id_opinion      INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id      INT NOT NULL,
    simulacion_id   INT NULL,
    tipo_opinion_id INT NOT NULL,
    calificacion    INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario      TEXT CHECK (CHAR_LENGTH(comentario) >= 5),
    es_anonima      BOOLEAN DEFAULT FALSE,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_op_usuario  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_op_tipo     FOREIGN KEY (tipo_opinion_id) REFERENCES tipo_opiniones(id_tipo_opinion),
    CONSTRAINT fk_op_sim      FOREIGN KEY (simulacion_id)   REFERENCES simulaciones(id_simulacion)
);


CREATE TABLE estadisticas_usuario(
    id_estadistica           INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id               INT NOT NULL UNIQUE,
    total_simulaciones       INT DEFAULT 0 CHECK (total_simulaciones >= 0),
    simulaciones_completadas INT DEFAULT 0 CHECK (simulaciones_completadas >= 0),
    duracion_promedio        DECIMAL(8,2) DEFAULT 0 CHECK (duracion_promedio >= 0),
    puntaje_promedio         DECIMAL(5,2) DEFAULT 0 CHECK (puntaje_promedio BETWEEN 0 AND 100),
    veces_enganado           INT DEFAULT 0 CHECK (veces_enganado >= 0),
    veces_detectado          INT DEFAULT 0 CHECK (veces_detectado >= 0),
    primera_simulacion       DATETIME NULL,
    ultima_simulacion        DATETIME NULL,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_est_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

