-- Inserción de datos iniciales

INSERT INTO tipo_usuarios (nombre_tipo_usuario, descripcion_tipo, created_by) VALUES
('Administrador', 'Acceso total al sistema', 1),
('Usuario', 'Usuario estándar que puede realizar simulaciones', 1);

INSERT INTO estados (nombre_estado, descripcion_estado, created_by) VALUES
('En Progreso', 'La simulación ha sido iniciada pero no completada', 1),
('Completada',  'La simulación ha sido finalizada por el usuario', 1),
('Abandonada',  'El usuario no completó la simulación', 1);

INSERT INTO tipo_opiniones (nombre_tipo_opinion, descripcion_tipo, created_by) VALUES
('Simulacion',      'Opinión específica sobre una simulación realizada', 1),
('Sistema General', 'Opinión general sobre la plataforma o sistema', 1),
('Sugerencia',      'Sugerencia para una nueva funcionalidad o mejora', 1),
('Problema',        'Reporte de un error técnico o bug', 1);

-- Creación del primer usuario administrador
INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id, created_by) VALUES
('Admin', 'admin@ciberseguridad.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1);