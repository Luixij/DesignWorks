# Diseño de Base de Datos - DesignWorks

## 📊 Información General

- **Motor**: MariaDB 11
- **Charset**: utf8mb4
- **Collation**: utf8mb4_general_ci
- **Engine**: InnoDB
- **Base de Datos**: `design_works`

---

## 🗂️ Esquema Relacional

### Vista General

El sistema utiliza **6 tablas principales** para gestionar:
- Usuarios y autenticación
- Trabajos de diseño
- Participación en trabajos
- Comentarios y comunicación
- Requisitos del cliente
- Historial de cambios de estado (auditoría)

```
                    ┌─────────────┐
                    │  USUARIOS   │
                    └──────┬──────┘
                           │
                ┌──────────┴──────────┐
                │                     │
         creado_por_id           usuario_id
                │                     │
                ↓                     ↓
        ┌──────────────┐      ┌───────────────────┐
        │   TRABAJOS   │◄────┤TRABAJO_PARTICIPANTES│
        └──────┬───────┘      └───────────────────┘
               │
      ┌────────┼────────┬──────────────┐
      │        │        │              │
      ↓        ↓        ↓              ↓
┌───────────┐ ┌────────────┐ ┌──────────────┐
│COMENTARIOS│ │ REQUISITOS │ │HISTORIAL_    │
│           │ │            │ │  ESTADOS     │
└───────────┘ └────────────┘ └──────────────┘
```

---

## 📋 Definición de Tablas

### 1. USUARIOS

Almacena la información de todos los usuarios del sistema (administradores y diseñadores).

```sql
CREATE TABLE usuarios (
  id                BIGINT AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(100) NOT NULL,
  email             VARCHAR(150) NOT NULL UNIQUE,
  rol               VARCHAR(20)  NOT NULL,
  contrasena_hash   VARCHAR(255) NOT NULL,
  activo            TINYINT(1)   NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `nombre` | VARCHAR(100) | NOT NULL | Nombre completo del usuario |
| `email` | VARCHAR(150) | NOT NULL, UNIQUE | Email único para login |
| `rol` | VARCHAR(20) | NOT NULL | `ADMIN` o `DISENADOR` |
| `contrasena_hash` | VARCHAR(255) | NOT NULL | Hash BCrypt de la contraseña |
| `activo` | TINYINT(1) | NOT NULL, DEFAULT 1 | 1 = activo, 0 = inactivo |

**Índices:**
- PRIMARY KEY en `id`
- UNIQUE en `email`

**Valores de `rol`:**
- `ADMIN`: Administrador del sistema
- `DISENADOR`: Diseñador que ejecuta trabajos

**Usuarios Seed:**
```sql
INSERT INTO usuarios (nombre, email, rol, contrasena_hash, activo) VALUES
('Luis Admin',        'admin@designworks.com',     'ADMIN',     '$2a$12$...', 1),
('Marta Diseño',      'marta@designworks.com',     'DISENADOR', '$2a$12$...', 1),
('Carlos Ilustración','carlos@designworks.com',    'DISENADOR', '$2a$12$...', 1),
('Ana Maquetación',   'ana@designworks.com',       'DISENADOR', '$2a$12$...', 1),
('Javi Apoyo',        'javi@designworks.com',      'DISENADOR', '$2a$12$...', 1);
```

**Contraseñas (desarrollo):**
- Admin: `Admin1234!`
- Diseñadores: `Design1234!`

---

### 2. TRABAJOS

Tabla central del sistema. Registra cada encargo de diseño con su información principal.

```sql
CREATE TABLE trabajos (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  titulo        VARCHAR(150) NOT NULL,
  cliente       VARCHAR(150) NOT NULL,
  prioridad     VARCHAR(20) NOT NULL,
  fecha_inicio  DATE NULL,
  fecha_fin     DATE NULL,
  estado_actual VARCHAR(20) NOT NULL,
  descripcion   TEXT,
  creado_por_id BIGINT NOT NULL,

  CONSTRAINT fk_trabajos_creado_por
    FOREIGN KEY (creado_por_id) REFERENCES usuarios(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices
CREATE INDEX idx_trabajos_estado     ON trabajos(estado_actual);
CREATE INDEX idx_trabajos_prioridad  ON trabajos(prioridad);
CREATE INDEX idx_trabajos_cliente    ON trabajos(cliente);
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `titulo` | VARCHAR(150) | NOT NULL | Título descriptivo del trabajo |
| `cliente` | VARCHAR(150) | NOT NULL | Nombre del cliente |
| `prioridad` | VARCHAR(20) | NOT NULL | Ver valores permitidos abajo |
| `fecha_inicio` | DATE | NULL | Fecha de inicio (puede ser null) |
| `fecha_fin` | DATE | NULL | Fecha límite de entrega |
| `estado_actual` | VARCHAR(20) | NOT NULL | Ver estados permitidos abajo |
| `descripcion` | TEXT | NULL | Brief o descripción del trabajo |
| `creado_por_id` | BIGINT | FK → usuarios(id) | Usuario que creó el trabajo |

**Valores de `prioridad`:**
- `BAJA`: Trabajo de baja prioridad
- `MEDIA`: Prioridad normal
- `ALTA`: Alta prioridad
- `URGENTE`: Requiere atención inmediata

**Valores de `estado_actual`:**
- `CREADO`: Trabajo creado, pendiente de asignación
- `EN_PROGRESO`: En desarrollo activo
- `EN_REVISION`: Pendiente de revisión del cliente/admin
- `ENTREGADO`: Finalizado y entregado (estado final)
- `CANCELADO`: Trabajo cancelado (estado final)

**Índices:**
- `idx_trabajos_estado`: Optimiza filtrado por estado
- `idx_trabajos_prioridad`: Optimiza ordenamiento por prioridad
- `idx_trabajos_cliente`: Optimiza búsqueda por cliente

**Ejemplo de Datos:**
```sql
INSERT INTO trabajos (titulo, cliente, prioridad, fecha_inicio, fecha_fin, 
                      estado_actual, descripcion, creado_por_id) VALUES
('Identidad corporativa - Cafetería Nómada', 'Cafetería Nómada', 'URGENTE', 
 '2026-01-07', '2026-01-22', 'EN_PROGRESO',
 'Diseño de logotipo, paleta y aplicaciones básicas para cafetería.', 1);
```

---

### 3. TRABAJO_PARTICIPANTES

Tabla de relación N:M entre usuarios y trabajos. Define qué diseñadores participan en cada trabajo.

```sql
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
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `trabajo_id` | BIGINT | PK, FK → trabajos(id) | ID del trabajo |
| `usuario_id` | BIGINT | PK, FK → usuarios(id) | ID del usuario participante |
| `rol_en_trabajo` | VARCHAR(80) | NOT NULL | Rol del usuario en este trabajo específico |

**Clave Primaria Compuesta:** `(trabajo_id, usuario_id)`
- Evita duplicados: un usuario no puede participar dos veces en el mismo trabajo

**Valores de `rol_en_trabajo`:**
- `ADMIN`: Administrador del trabajo
- `DISENADOR`: Diseñador principal
- `APOYO`: Diseñador de apoyo
- `ILUSTRADOR`: Especialista en ilustración
- `MAQUETADOR`: Especialista en maquetación

**Cascadas:**
- Si se elimina un trabajo → se eliminan sus participantes
- Si se elimina un usuario → se eliminan sus participaciones

**Ejemplo de Datos:**
```sql
INSERT INTO trabajo_participantes (trabajo_id, usuario_id, rol_en_trabajo) VALUES
(1, 1, 'ADMIN'),       -- Luis es admin del trabajo 1
(1, 2, 'DISENADOR'),   -- Marta participa como diseñadora
(1, 3, 'DISENADOR');   -- Carlos participa como diseñador
```

---

### 4. COMENTARIOS

Permite la comunicación entre participantes sobre un trabajo.

```sql
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
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `trabajo_id` | BIGINT | FK → trabajos(id) | Trabajo al que pertenece |
| `usuario_id` | BIGINT | FK → usuarios(id) | Autor del comentario |
| `fecha` | DATETIME | NOT NULL | Fecha y hora del comentario |
| `texto` | TEXT | NOT NULL | Contenido del comentario |

**Índice Compuesto:**
- `idx_coment_trabajo_fecha`: Optimiza consultas de comentarios de un trabajo ordenados por fecha

**Cascadas:**
- Si se elimina un trabajo → se eliminan sus comentarios
- Si se elimina un usuario → se eliminan sus comentarios

**Ejemplo de Datos:**
```sql
INSERT INTO comentarios (trabajo_id, usuario_id, fecha, texto) VALUES
(1, 2, '2026-01-09 11:00:00', 
 'He preparado 3 rutas: tipográfica, isotipo y combo. Subo bocetos en breve.');
```

---

### 5. REQUISITOS

Almacena los requisitos específicos o briefs de cada trabajo.

```sql
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
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `trabajo_id` | BIGINT | FK → trabajos(id) | Trabajo al que pertenece |
| `descripcion` | TEXT | NOT NULL | Descripción del requisito |
| `adjunto_url` | VARCHAR(500) | NULL | URL a archivo de referencia (opcional) |

**Cascadas:**
- Si se elimina un trabajo → se eliminan sus requisitos

**Ejemplo de Datos:**
```sql
INSERT INTO requisitos (trabajo_id, descripcion, adjunto_url) VALUES
(1, 'Logotipo principal + versión monocroma + favicon.', NULL),
(1, 'Aplicación en vaso, bolsa y tarjeta.', NULL),
(2, 'Cartel A2 y A3 + versión redes (1080x1350).', 
    'https://example.com/referencias/festival-estella.zip');
```

---

### 6. HISTORIAL_ESTADOS

Tabla de auditoría que registra todos los cambios de estado de un trabajo.

```sql
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
```

**Campos:**

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `trabajo_id` | BIGINT | FK → trabajos(id) | Trabajo afectado |
| `estado` | VARCHAR(20) | NOT NULL | Nuevo estado aplicado |
| `fecha` | DATETIME | NOT NULL | Fecha y hora del cambio |
| `usuario_id` | BIGINT | FK → usuarios(id) | Usuario que realizó el cambio |
| `motivo` | TEXT | NULL | Justificación del cambio (opcional) |

**Valores de `estado`:** (mismos que `trabajos.estado_actual`)
- `CREADO`, `EN_PROGRESO`, `EN_REVISION`, `ENTREGADO`, `CANCELADO`

**Índices:**
- `idx_hist_trabajo_fecha`: Optimiza consultas de historial por trabajo
- `idx_hist_estado`: Optimiza filtrado por tipo de estado

**Cascadas:**
- Si se elimina un trabajo → se elimina su historial
- Si se elimina un usuario → NO se puede (RESTRICT), para mantener auditoría

**Ejemplo de Datos:**
```sql
INSERT INTO historial_estados (trabajo_id, estado, fecha, usuario_id, motivo) VALUES
(1, 'CREADO',       '2026-01-07 09:00:00', 1, 'Trabajo creado y listo para asignación.'),
(1, 'EN_PROGRESO',  '2026-01-08 10:30:00', 2, 'Comenzamos bocetos y exploración de logo.');
```

---

## 🔗 Relaciones entre Tablas

### Diagrama Entidad-Relación Detallado

```
┌──────────────────┐
│    USUARIOS      │
│ ================ │
│ id (PK)          │◄────────┐
│ nombre           │         │
│ email (UK)       │         │
│ rol              │         │
│ contrasena_hash  │         │
│ activo           │         │
└────────┬─────────┘         │
         │                   │
         │ 1:N               │ N:1
         │ creado_por        │ usuario
         │                   │
         ↓                   │
┌────────────────────────┐  │
│      TRABAJOS          │  │
│ ====================== │  │
│ id (PK)                │  │
│ titulo                 │  │
│ cliente                │  │
│ prioridad              │  │
│ fecha_inicio           │  │
│ fecha_fin              │  │
│ estado_actual          │  │
│ descripcion            │  │
│ creado_por_id (FK) ────┘  │
└────┬───────────────────┘  │
     │                      │
     │ 1:N                  │
     ├──────────────────────┼───────────────┐
     │                      │               │
     ↓                      │               ↓
┌─────────────┐             │         ┌──────────────────┐
│ COMENTARIOS │             │         │    REQUISITOS    │
│ =========== │             │         │ ================ │
│ id (PK)     │             │         │ id (PK)          │
│ trabajo_id  │◄────────────┘         │ trabajo_id (FK)  │
│ usuario_id  │◄──────────────────────┤ descripcion      │
│ fecha       │                       │ adjunto_url      │
│ texto       │                       └──────────────────┘
└─────────────┘
     │
     │
     ↓
┌───────────────────────┐
│ HISTORIAL_ESTADOS     │
│ ===================== │
│ id (PK)               │
│ trabajo_id (FK) ──────┤
│ estado                │
│ fecha                 │
│ usuario_id (FK) ──────┤
│ motivo                │
└───────────────────────┘
     │
     │ N:M (resuelta)
     ↓
┌──────────────────────────┐
│ TRABAJO_PARTICIPANTES    │
│ ======================== │
│ trabajo_id (PK, FK)      │
│ usuario_id (PK, FK)      │
│ rol_en_trabajo           │
└──────────────────────────┘
```

### Cardinalidades

| Relación | Tipo | Descripción |
|----------|------|-------------|
| Usuario → Trabajo (creado_por) | 1:N | Un usuario puede crear muchos trabajos |
| Trabajo → Comentario | 1:N | Un trabajo puede tener muchos comentarios |
| Usuario → Comentario | 1:N | Un usuario puede escribir muchos comentarios |
| Trabajo → Requisito | 1:N | Un trabajo puede tener muchos requisitos |
| Trabajo → HistorialEstado | 1:N | Un trabajo tiene muchos registros de historial |
| Usuario → HistorialEstado | 1:N | Un usuario genera muchos cambios de estado |
| Trabajo ↔ Usuario | N:M | Resuelta mediante `trabajo_participantes` |

---

## 🗃️ Scripts SQL

### Inicialización Completa

**Ubicación:** `infra/sql/init.sql`

El script de inicialización realiza:
1. Configuración de charset (utf8mb4)
2. Drop de tablas existentes (solo en DEV)
3. Creación de tablas con constraints
4. Creación de índices
5. Inserción de datos de ejemplo (seed)

**Ejecución Automática:**
- Al levantar Docker Compose, el script se ejecuta automáticamente
- Ubicación en Docker: `/docker-entrypoint-initdb.d/init.sql`

### Consultas Útiles

**Ver todas las tablas:**
```sql
SHOW TABLES;
```

**Contar registros:**
```sql
SELECT COUNT(*) FROM usuarios;
SELECT COUNT(*) FROM trabajos;
SELECT COUNT(*) FROM comentarios;
```

**Ver trabajos con su creador:**
```sql
SELECT t.id, t.titulo, t.estado_actual, u.nombre AS creado_por
FROM trabajos t
JOIN usuarios u ON t.creado_por_id = u.id
ORDER BY t.id;
```

**Ver participantes de un trabajo:**
```sql
SELECT t.titulo, u.nombre, tp.rol_en_trabajo
FROM trabajo_participantes tp
JOIN trabajos t ON tp.trabajo_id = t.id
JOIN usuarios u ON tp.usuario_id = u.id
WHERE t.id = 1;
```

**Historial completo de un trabajo:**
```sql
SELECT h.estado, h.fecha, u.nombre AS usuario, h.motivo
FROM historial_estados h
JOIN usuarios u ON h.usuario_id = u.id
WHERE h.trabajo_id = 1
ORDER BY h.fecha;
```

**Trabajos por estado:**
```sql
SELECT estado_actual, COUNT(*) AS cantidad
FROM trabajos
GROUP BY estado_actual;
```

---

## 🔒 Constraints y Validaciones

### Foreign Keys

Todas las FKs implementan:
- **ON DELETE CASCADE**: Eliminación en cascada para dependientes (comentarios, requisitos, etc.)
- **ON DELETE RESTRICT**: Restricción para preservar auditoría (historial → usuario)
- **ON UPDATE CASCADE**: Actualización en cascada de IDs

### Unique Constraints

- `usuarios.email`: Evita emails duplicados

### Check Constraints (Implementación futura)

Aunque MariaDB soporta CHECK, se validarán en la capa de aplicación:
```sql
-- Futuro: validación de estados
ALTER TABLE trabajos ADD CONSTRAINT chk_estado
  CHECK (estado_actual IN ('CREADO', 'EN_PROGRESO', 'EN_REVISION', 'ENTREGADO', 'CANCELADO'));

-- Futuro: validación de prioridades
ALTER TABLE trabajos ADD CONSTRAINT chk_prioridad
  CHECK (prioridad IN ('BAJA', 'MEDIA', 'ALTA', 'URGENTE'));
```

---

## 📊 Datos de Ejemplo (Seed)

### Usuarios (5)
- 1 Administrador
- 4 Diseñadores

### Trabajos (6)
- 1 URGENTE en progreso
- 2 ALTA (uno en revisión, otro entregado)
- 2 MEDIA (uno creado, otro cancelado)
- 1 BAJA creado

### Participantes (14 asignaciones)
- Cada trabajo tiene 2-3 participantes

### Comentarios (6)
- Distribuidos en 3 trabajos activos

### Requisitos (8)
- 2-3 requisitos por trabajo

### Historial (13 registros)
- Trazabilidad completa de cambios de estado

---

## 🛠️ Mantenimiento

### Backup

**Manual:**
```bash
docker exec designWorks_mariadb mariadb-dump -u dsing_user -pFcfR_El21 design_works > backup_$(date +%Y%m%d).sql
```

**Restore:**
```bash
docker exec -i designWorks_mariadb mariadb -u dsing_user -pFcfR_El21 design_works < backup_20260209.sql
```

### Optimización

**Analizar índices:**
```sql
SHOW INDEX FROM trabajos;
ANALYZE TABLE trabajos;
```

**Estadísticas de tablas:**
```sql
SELECT 
  table_name,
  table_rows,
  data_length,
  index_length
FROM information_schema.TABLES
WHERE table_schema = 'design_works';
```

---

## 🔮 Mejoras Futuras

### Tablas Adicionales
- **notificaciones**: Alertas para usuarios
- **archivos**: Gestión de adjuntos
- **plantillas_trabajo**: Templates reutilizables

### Optimizaciones
- Particionamiento de `historial_estados` por fecha
- Vistas materializadas para reportes
- Full-text search en comentarios

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM