/* =========================================================
   DesignWorks - Init DB (MariaDB)
   - Tablas + claves + índices + datos de ejemplo
   - Alineado con: usuarios, trabajos, participantes, comentarios,
     requisitos e historial de estados.
   ========================================================= */

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- Para reinicios limpios en entorno DEV
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS historial_estados;
DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS requisitos;
DROP TABLE IF EXISTS trabajo_participantes;
DROP TABLE IF EXISTS trabajos;
DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS = 1;

/* =========================
   TABLA: USUARIOS
   ========================= */
CREATE TABLE usuarios (
  id                BIGINT AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(100) NOT NULL,
  email             VARCHAR(150) NOT NULL UNIQUE,
  rol               VARCHAR(20)  NOT NULL,      
  contrasena_hash   VARCHAR(255) NOT NULL,     
  activo            TINYINT(1)   NOT NULL DEFAULT 1,
  created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================
   TABLA: TRABAJOS
   ========================= */
CREATE TABLE trabajos (
  id            BIGINT  AUTO_INCREMENT PRIMARY KEY,
  titulo        VARCHAR(100) NOT NULL,
  cliente       VARCHAR(150) NOT NULL,
  prioridad     ENUM('baja','media','alta','urgente') NOT NULL DEFAULT 'media',
  fecha_inicio  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
  fecha_fin     DATETIME NULL,                                
  estado_actual ENUM('CREADO','EN_PROGRESO','EN_REVISION','ENTREGADO','CANCELADO')
               NOT NULL DEFAULT 'CREADO',
  descripcion   TEXT NOT NULL,
  creado_por_id BIGINT NOT NULL,

  CONSTRAINT fk_trabajos_creado_por
    FOREIGN KEY (creado_por_id) REFERENCES usuarios(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices para filtros frecuentes (estado, prioridad, cliente, fechas)
CREATE INDEX idx_trabajos_estado     ON trabajos(estado_actual);
CREATE INDEX idx_trabajos_prioridad  ON trabajos(prioridad);
CREATE INDEX idx_trabajos_cliente    ON trabajos(cliente);
CREATE INDEX idx_trabajos_fechafin   ON trabajos(fecha_fin);
CREATE INDEX idx_trabajos_fechainicio ON trabajos(fecha_inicio);

/* =========================
   TABLA: TRABAJO_PARTICIPANTES
   Relación N:M (PK compuesta)
   ========================= */
CREATE TABLE trabajo_participantes (
  trabajo_id      BIGINT NOT NULL,
  usuario_id      BIGINT NOT NULL,
  rol_en_trabajo ENUM('ADMIN','DISENADOR') NOT NULL DEFAULT 'DISENADOR', 

  PRIMARY KEY (trabajo_id, usuario_id),

  CONSTRAINT fk_tp_trabajo
    FOREIGN KEY (trabajo_id) REFERENCES trabajos(id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT fk_tp_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_tp_usuario ON trabajo_participantes(usuario_id);

/* =========================
   TABLA: COMENTARIOS
   ========================= */
CREATE TABLE comentarios (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trabajo_id  BIGINT NOT NULL,
  usuario_id  BIGINT NOT NULL,
  fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  texto       TEXT NOT NULL,

  CONSTRAINT fk_coment_trabajo
    FOREIGN KEY (trabajo_id) REFERENCES trabajos(id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT fk_coment_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_coment_trabajo_fecha ON comentarios(trabajo_id, fecha);

/* =========================
   TABLA: REQUISITOS
   (descripcion, adjunto_url, trabajo_id)
   ========================= */
CREATE TABLE requisitos (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trabajo_id  BIGINT NOT NULL,
  descripcion TEXT NOT NULL,
  adjunto_url VARCHAR(255) NULL,

  CONSTRAINT fk_req_trabajo
    FOREIGN KEY (trabajo_id) REFERENCES trabajos(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_req_trabajo ON requisitos(trabajo_id);

/* =========================
   TABLA: HISTORIAL_ESTADOS
   Registra trazabilidad de cambios de estado
   ========================= */
CREATE TABLE historial_estados (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trabajo_id  BIGINT NOT NULL,
  estado      ENUM('CREADO','EN_PROGRESO','EN_REVISION','ENTREGADO','CANCELADO') NOT NULL,
  fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  usuario_id  BIGINT NOT NULL,
  motivo      TEXT NULL,

  CONSTRAINT fk_hist_trabajo
    FOREIGN KEY (trabajo_id) REFERENCES trabajos(id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT fk_hist_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_hist_trabajo_fecha ON historial_estados(trabajo_id, fecha);
CREATE INDEX idx_hist_estado ON historial_estados(estado);

-- TRIGGER PARA CONVERTIR ROLES EN ADMIN O DISEÑADORES
DELIMITER //

CREATE TRIGGER bi_trabajo_participantes_rol
BEFORE INSERT ON trabajo_participantes
FOR EACH ROW
BEGIN
  IF NEW.rol_en_trabajo IS NULL OR UPPER(TRIM(NEW.rol_en_trabajo)) <> 'ADMIN' THEN
    SET NEW.rol_en_trabajo = 'DISENADOR';
  ELSE
    SET NEW.rol_en_trabajo = 'ADMIN';
  END IF;
END//

CREATE TRIGGER bu_trabajo_participantes_rol
BEFORE UPDATE ON trabajo_participantes
FOR EACH ROW
BEGIN
  IF NEW.rol_en_trabajo IS NULL OR UPPER(TRIM(NEW.rol_en_trabajo)) <> 'ADMIN' THEN
    SET NEW.rol_en_trabajo = 'DISENADOR';
  ELSE
    SET NEW.rol_en_trabajo = 'ADMIN';
  END IF;
END//

DELIMITER ;


/* =========================================================
   DATOS DE EJEMPLO (SEED)
   - 1 admin + 4 diseñadores
   - 6 trabajos variados (estados/prioridades)
   - participantes por trabajo
   - requisitos, comentarios e historial
   ========================================================= */

-- Contraseña usadas "Admin1234!" / "Design1234!")
INSERT INTO usuarios (nombre, email, rol, contrasena_hash, activo) VALUES
('Luis Admin',        'admin@designworks.com',     'ADMIN',     '$2a$12$o07P2F39IagpryykAqMUAuN4v2PVZns8rFY3WMFQU4mWS6glqvZUa', 1),
('Marta Diseño',      'marta@designworks.com',     'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Carlos Ilustración','carlos@designworks.com',    'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Ana Maquetación',   'ana@designworks.com',       'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Javi Apoyo',        'javi@designworks.com',      'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1);

/* Insertamos trabajos */

INSERT INTO trabajos (titulo, cliente, prioridad, fecha_inicio, fecha_fin, estado_actual, descripcion, creado_por_id) VALUES
('Identidad corporativa - Cafetería Nómada', 'Cafetería Nómada', 'urgente', NOW() - INTERVAL 10 DAY, NOW() + INTERVAL 5 DAY, 'EN_PROGRESO',
 'Diseño de logotipo, paleta y aplicaciones básicas para cafetería.', 1),
('Cartelería evento - Festival Estella', 'Ayto. Estella', 'alta', NOW() - INTERVAL 20 DAY, NOW() + INTERVAL 2 DAY, 'EN_REVISION',
 'Carteles y piezas para redes. Variantes en A3/A2 y formatos story.', 1),
('Maquetación catálogo - Tienda Verde', 'Tienda Verde', 'media', NOW() - INTERVAL 5 DAY, NOW() + INTERVAL 15 DAY, 'CREADO',
 'Catálogo de productos 24 páginas. Estilo limpio y moderno.', 1),
('Ilustraciones packaging - Miel del Valle', 'Miel del Valle', 'alta', NOW() - INTERVAL 30 DAY, NOW() - INTERVAL 2 DAY, 'ENTREGADO',
 'Serie de ilustraciones para etiquetas y caja exterior.', 1),
('Rediseño web landing - Studio Fit', 'Studio Fit', 'media', NOW() - INTERVAL 12 DAY, NULL, 'CANCELADO',
 'Landing promocional. Se cancela por cambio de proveedor.', 1),
('Plantillas RRSS - Clínica Sonríe', 'Clínica Sonríe', 'baja', NOW() - INTERVAL 2 DAY, NOW() + INTERVAL 25 DAY, 'CREADO',
 'Pack de 12 plantillas editables con guía de uso.', 1);

-- Participantes
INSERT INTO trabajo_participantes (trabajo_id, usuario_id, rol_en_trabajo) VALUES
(1, 2, 'DISENADOR'),
(1, 3, 'DISENADOR'),
(1, 5, 'DISENADOR'),
(2, 2, 'DISENADOR'),
(2, 4, 'DISENADOR'),
(3, 4, 'DISENADOR'),
(3, 5, 'DISENADOR'),
(4, 3, 'DISENADOR'),
(4, 2, 'DISENADOR'),
(5, 2, 'DISENADOR'),
(6, 5, 'DISENADOR');

-- Requisitos (briefs)
INSERT INTO requisitos (trabajo_id, descripcion, adjunto_url) VALUES
(1, 'Logotipo principal + versión monocroma + favicon.', NULL),
(1, 'Aplicación en vaso, bolsa y tarjeta.', NULL),
(2, 'Cartel A2 y A3 + versión redes (1080x1350).', 'https://example.com/referencias/festival-estella.zip'),
(2, 'Mantener tipografía corporativa del ayuntamiento.', NULL),
(3, 'Maquetación 24 páginas con retícula 12 columnas.', NULL),
(4, 'Estilo ilustración: orgánico, colores tierra.', 'https://example.com/referencias/miel-paleta.png'),
(6, '12 plantillas: 6 posts + 6 stories + guía rápida.', NULL);

-- Historial de estados (trazabilidad)
INSERT INTO historial_estados (trabajo_id, estado, fecha, usuario_id, motivo) VALUES
(1, 'CREADO',       NOW() - INTERVAL 10 DAY, 1, 'Trabajo creado y listo para asignación.'),
(1, 'EN_PROGRESO',  NOW() - INTERVAL 9 DAY,  2, 'Comenzamos bocetos y exploración de logo.'),
(2, 'CREADO',       NOW() - INTERVAL 20 DAY, 1, 'Trabajo creado.'),
(2, 'EN_PROGRESO',  NOW() - INTERVAL 19 DAY, 2, 'Primera propuesta de cartelería.'),
(2, 'EN_REVISION',  NOW() - INTERVAL 2 DAY,  1, 'Enviado al cliente para revisión final.'),
(3, 'CREADO',       NOW() - INTERVAL 5 DAY,  1, 'Pendiente de confirmación de contenidos.'),
(4, 'CREADO',       NOW() - INTERVAL 30 DAY, 1, 'Creado.'),
(4, 'EN_PROGRESO',  NOW() - INTERVAL 28 DAY, 3, 'Ilustraciones en desarrollo.'),
(4, 'EN_REVISION',  NOW() - INTERVAL 10 DAY, 1, 'Revisión interna antes de entrega.'),
(4, 'ENTREGADO',    NOW() - INTERVAL 2 DAY,  1, 'Entregado y aprobado por el cliente.'),
(5, 'CREADO',       NOW() - INTERVAL 12 DAY, 1, 'Creado.'),
(5, 'CANCELADO',    NOW() - INTERVAL 10 DAY, 1, 'Cancelado por cambio de proveedor.'),
(6, 'CREADO',       NOW() - INTERVAL 2 DAY,  1, 'Creado. Pendiente de primera propuesta.');

-- Comentarios (timeline)
INSERT INTO comentarios (trabajo_id, usuario_id, fecha, texto) VALUES
(1, 2, NOW() - INTERVAL 8 DAY, 'He preparado 3 rutas: tipográfica, isotipo y combo. Subo bocetos en breve.'),
(1, 3, NOW() - INTERVAL 7 DAY, 'Propongo ilustración minimal para el isotipo; encaja con el naming.'),
(2, 4, NOW() - INTERVAL 3 DAY, 'Ajusté jerarquía en cartel A2, revisa el bloque de patrocinadores.'),
(2, 2, NOW() - INTERVAL 2 DAY, 'Listo para enviar. He incluido versión con más contraste para impresión.'),
(4, 3, NOW() - INTERVAL 9 DAY, 'Ilustración final lista, falta adaptar a los troqueles del packaging.'),
(6, 5, NOW() - INTERVAL 1 DAY, 'Arranco con 2 estilos: clínico limpio y otro más cercano. ¿Preferencia?');
