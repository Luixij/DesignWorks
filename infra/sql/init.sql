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
  activo            TINYINT(1)   NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================
   TABLA: TRABAJOS
   ========================= */
CREATE TABLE trabajos (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  titulo        VARCHAR(150) NOT NULL,
  cliente       VARCHAR(150) NOT NULL,
  prioridad     VARCHAR(20) NOT NULL,
  fecha_inicio  DATE NULL,  -- ← CAMBIADO A DATE (era DATETIME)
  fecha_fin     DATE NULL,  -- ← CAMBIADO A DATE (era DATETIME)
  estado_actual VARCHAR(20) NOT NULL,
  descripcion   TEXT,
  creado_por_id BIGINT NOT NULL,

  CONSTRAINT fk_trabajos_creado_por
    FOREIGN KEY (creado_por_id) REFERENCES usuarios(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_trabajos_estado     ON trabajos(estado_actual);
CREATE INDEX idx_trabajos_prioridad  ON trabajos(prioridad);
CREATE INDEX idx_trabajos_cliente    ON trabajos(cliente);

/* =========================
   TABLA: TRABAJO_PARTICIPANTES
   ========================= */
CREATE TABLE trabajo_participantes (
  trabajo_id     BIGINT NOT NULL,
  usuario_id     BIGINT NOT NULL,
  rol_en_trabajo VARCHAR(80) NOT NULL,

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
  fecha       DATETIME NOT NULL,
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
   ========================= */
CREATE TABLE requisitos (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trabajo_id  BIGINT NOT NULL,
  descripcion TEXT NOT NULL,
  adjunto_url VARCHAR(500) NULL,

  CONSTRAINT fk_req_trabajo
    FOREIGN KEY (trabajo_id) REFERENCES trabajos(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_req_trabajo ON requisitos(trabajo_id);

/* =========================
   TABLA: HISTORIAL_ESTADOS
   ========================= */
CREATE TABLE historial_estados (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  trabajo_id  BIGINT NOT NULL,
  estado      VARCHAR(20) NOT NULL,
  fecha       DATETIME NOT NULL,
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

/* =========================================================
   DATOS DE EJEMPLO (SEED)
   Contraseñas: Admin1234! / Design1234!
   ========================================================= */

INSERT INTO usuarios (nombre, email, rol, contrasena_hash, activo) VALUES
('Luis Admin',        'admin@designworks.com',     'ADMIN',     '$2a$12$o07P2F39IagpryykAqMUAuN4v2PVZns8rFY3WMFQU4mWS6glqvZUa', 1),
('Marta Diseño',      'marta@designworks.com',     'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Carlos Ilustración','carlos@designworks.com',    'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Ana Maquetación',   'ana@designworks.com',       'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1),
('Javi Apoyo',        'javi@designworks.com',      'DISENADOR', '$2a$12$1VbU5I4r.RzBJOEa25NpP.UxvB9ffLz4BpnSBsjqjpKCHhJtaKbrK', 1);

-- Trabajos (usando VARCHAR para ENUM y DATE para fechas)
INSERT INTO trabajos (titulo, cliente, prioridad, fecha_inicio, fecha_fin, estado_actual, descripcion, creado_por_id) VALUES
('Identidad corporativa - Cafetería Nómada', 'Cafetería Nómada', 'URGENTE', '2026-01-07', '2026-01-22', 'EN_PROGRESO',
 'Diseño de logotipo, paleta y aplicaciones básicas para cafetería.', 1),
('Cartelería evento - Festival Estella', 'Ayto. Estella', 'ALTA', '2025-12-28', '2026-01-19', 'EN_REVISION',
 'Carteles y piezas para redes. Variantes en A3/A2 y formatos story.', 1),
('Maquetación catálogo - Tienda Verde', 'Tienda Verde', 'MEDIA', '2026-01-12', '2026-02-01', 'CREADO',
 'Catálogo de productos 24 páginas. Estilo limpio y moderno.', 1),
('Ilustraciones packaging - Miel del Valle', 'Miel del Valle', 'ALTA', '2025-12-18', '2026-01-15', 'ENTREGADO',
 'Serie de ilustraciones para etiquetas y caja exterior.', 1),
('Rediseño web landing - Studio Fit', 'Studio Fit', 'MEDIA', '2026-01-05', NULL, 'CANCELADO',
 'Landing promocional. Se cancela por cambio de proveedor.', 1),
('Plantillas RRSS - Clínica Sonríe', 'Clínica Sonríe', 'BAJA', '2026-01-15', '2026-02-11', 'CREADO',
 'Pack de 12 plantillas editables con guía de uso.', 1);

-- Participantes
INSERT INTO trabajo_participantes (trabajo_id, usuario_id, rol_en_trabajo) VALUES
(1, 1, 'ADMIN'),
(1, 2, 'DISENADOR'),
(1, 3, 'DISENADOR'),
(2, 1, 'ADMIN'),
(2, 2, 'DISENADOR'),
(2, 4, 'DISENADOR'),
(3, 1, 'ADMIN'),
(3, 4, 'DISENADOR'),
(4, 1, 'ADMIN'),
(4, 3, 'DISENADOR'),
(5, 1, 'ADMIN'),
(5, 2, 'DISENADOR'),
(6, 1, 'ADMIN'),
(6, 5, 'DISENADOR');

-- Requisitos
INSERT INTO requisitos (trabajo_id, descripcion, adjunto_url) VALUES
(1, 'Logotipo principal + versión monocroma + favicon.', 'https://www.luisimaicela.com/designworks/1.cafeteria_nomada.jpg'),
(1, 'Aplicación en vaso, bolsa y tarjeta.', 'https://www.luisimaicela.com/designworks/2.ayto_estella_festival_carteleria.jpg'),
(2, 'Cartel A2 y A3 + versión redes (1080x1350).', 'https://www.luisimaicela.com/designworks/2.ayto_estella_festival_carteleria.jpg'),
(3, 'Maquetación 24 páginas con retícula 12 columnas.', 'https://www.luisimaicela.com/designworks/3.tienda_verde_catalogo.jpg'),
(4, 'Estilo ilustración: orgánico, colores tierra.', 'https://www.luisimaicela.com/designworks/4.miel_valle_packaging.jpg'),
(6, '12 plantillas: 6 posts + 6 stories + guía rápida.', 'https://www.luisimaicela.com/designworks/6.clinica_sonrie_rrss.jpg');

-- Historial de estados
INSERT INTO historial_estados (trabajo_id, estado, fecha, usuario_id, motivo) VALUES
(1, 'CREADO',       '2026-01-07 09:00:00', 1, 'Trabajo creado y listo para asignación.'),
(1, 'EN_PROGRESO',  '2026-01-08 10:30:00', 2, 'Comenzamos bocetos y exploración de logo.'),
(2, 'CREADO',       '2025-12-28 09:00:00', 1, 'Trabajo creado.'),
(2, 'EN_PROGRESO',  '2025-12-29 11:00:00', 2, 'Primera propuesta de cartelería.'),
(2, 'EN_REVISION',  '2026-01-15 14:00:00', 1, 'Enviado al cliente para revisión final.'),
(3, 'CREADO',       '2026-01-12 09:00:00', 1, 'Pendiente de confirmación de contenidos.'),
(4, 'CREADO',       '2025-12-18 09:00:00', 1, 'Creado.'),
(4, 'EN_PROGRESO',  '2025-12-20 10:00:00', 3, 'Ilustraciones en desarrollo.'),
(4, 'EN_REVISION',  '2026-01-07 15:00:00', 1, 'Revisión interna antes de entrega.'),
(4, 'ENTREGADO',    '2026-01-15 16:00:00', 1, 'Entregado y aprobado por el cliente.'),
(5, 'CREADO',       '2026-01-05 09:00:00', 1, 'Creado.'),
(5, 'CANCELADO',    '2026-01-07 12:00:00', 1, 'Cancelado por cambio de proveedor.'),
(6, 'CREADO',       '2026-01-15 09:00:00', 1, 'Creado. Pendiente de primera propuesta.');

-- Comentarios
INSERT INTO comentarios (trabajo_id, usuario_id, fecha, texto) VALUES
(1, 2, '2026-01-09 11:00:00', 'He preparado 3 rutas: tipográfica, isotipo y combo. Subo bocetos en breve.'),
(1, 3, '2026-01-10 14:00:00', 'Propongo ilustración minimal para el isotipo; encaja con el naming.'),
(2, 4, '2026-01-14 10:00:00', 'Ajusté jerarquía en cartel A2, revisa el bloque de patrocinadores.'),
(2, 2, '2026-01-15 13:00:00', 'Listo para enviar. He incluido versión con más contraste para impresión.'),
(4, 3, '2026-01-08 16:00:00', 'Ilustración final lista, falta adaptar a los troqueles del packaging.'),
(6, 5, '2026-01-16 10:00:00', 'Arranco con 2 estilos: clínico limpio y otro más cercano. ¿Preferencia?');

