# API REST - DesignWorks

## 📡 Información General

- **Base URL (macOS)**: `http://localhost:8080/api`
- **Base URL (Windows)**: `http://localhost:8082/api`
- **Formato**: JSON
- **Autenticación**: JWT (Bearer Token)
- **Versión**: v1.0

---

## 🔐 Autenticación

Todos los endpoints (excepto `/auth/login`) requieren un token JWT válido en el header:

```http
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBkZXNpZ253...
```

### Flujo de Autenticación

```
1. Cliente → POST /auth/login (email + password)
2. Servidor → Valida credenciales
3. Servidor → Genera JWT
4. Servidor → Responde { token, rol, nombre }
5. Cliente → Almacena token de forma segura
6. Cliente → Envía token en cada petición subsiguiente
```

---

## 📋 Endpoints

### 🔑 Autenticación

#### POST /auth/login

Autentica un usuario y devuelve un token JWT.

**Request:**
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@designworks.com",
  "password": "Admin1234!"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBkZXNpZ253b3Jrcy5jb20iLCJ1c2VySWQiOjEsInJvbCI6IkFETUlOIiwibm9tYnJlIjoiTHVpcyBBZG1pbiIsImlhdCI6MTcwNzQ5NDQwMCwiZXhwIjoxNzA3NTgwODAwfQ.signature",
  "tipo": "Bearer",
  "rol": "ADMIN",
  "nombre": "Luis Admin",
  "email": "admin@designworks.com"
}
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Email o contraseña faltante |
| 401 | Credenciales inválidas |
| 403 | Usuario inactivo |

**Ejemplo de uso:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@designworks.com",
    "password": "Admin1234!"
  }'
```

---

### 📊 Trabajos

#### GET /trabajos

Lista todos los trabajos del sistema (solo ADMIN).

**Autorización:** ADMIN

**Request:**
```http
GET /api/trabajos?estado=EN_PROGRESO&prioridad=ALTA
Authorization: Bearer {token}
```

**Query Parameters:**

| Parámetro | Tipo | Descripción | Ejemplo |
|-----------|------|-------------|---------|
| `estado` | String | Filtrar por estado | `EN_PROGRESO` |
| `prioridad` | String | Filtrar por prioridad | `ALTA` |
| `cliente` | String | Filtrar por nombre de cliente | `Cafetería` |
| `fechaDesde` | Date | Filtrar desde fecha | `2026-01-01` |
| `fechaHasta` | Date | Filtrar hasta fecha | `2026-01-31` |

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada",
    "cliente": "Cafetería Nómada",
    "prioridad": "URGENTE",
    "fechaInicio": "2026-01-07",
    "fechaFin": "2026-01-22",
    "estadoActual": "EN_PROGRESO",
    "descripcion": "Diseño de logotipo, paleta y aplicaciones básicas para cafetería.",
    "creadoPor": {
      "id": 1,
      "nombre": "Luis Admin",
      "email": "admin@designworks.com"
    },
    "participantes": [
      {
        "id": 2,
        "nombre": "Marta Diseño",
        "rolEnTrabajo": "DISENADOR"
      },
      {
        "id": 3,
        "nombre": "Carlos Ilustración",
        "rolEnTrabajo": "DISENADOR"
      }
    ]
  }
]
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 401 | Token inválido o expirado |
| 403 | Acceso denegado (no es ADMIN) |

---

#### GET /trabajos/mis

Lista los trabajos asignados al usuario autenticado.

**Autorización:** ADMIN, DISEÑADOR

**Request:**
```http
GET /api/trabajos/mis?estado=EN_PROGRESO
Authorization: Bearer {token}
```

**Query Parameters:** (mismos que GET /trabajos)

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada",
    "cliente": "Cafetería Nómada",
    "prioridad": "URGENTE",
    "fechaInicio": "2026-01-07",
    "fechaFin": "2026-01-22",
    "estadoActual": "EN_PROGRESO",
    "miRol": "DISENADOR"
  }
]
```

---

#### GET /trabajos/{id}

Obtiene el detalle completo de un trabajo específico.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "titulo": "Identidad corporativa - Cafetería Nómada",
  "cliente": "Cafetería Nómada",
  "prioridad": "URGENTE",
  "fechaInicio": "2026-01-07",
  "fechaFin": "2026-01-22",
  "estadoActual": "EN_PROGRESO",
  "descripcion": "Diseño de logotipo, paleta y aplicaciones básicas para cafetería.",
  "creadoPor": {
    "id": 1,
    "nombre": "Luis Admin",
    "email": "admin@designworks.com"
  },
  "participantes": [
    {
      "id": 1,
      "nombre": "Luis Admin",
      "rolEnTrabajo": "ADMIN"
    },
    {
      "id": 2,
      "nombre": "Marta Diseño",
      "rolEnTrabajo": "DISENADOR"
    }
  ],
  "requisitos": [
    {
      "id": 1,
      "descripcion": "Logotipo principal + versión monocroma + favicon.",
      "adjuntoUrl": null
    },
    {
      "id": 2,
      "descripcion": "Aplicación en vaso, bolsa y tarjeta.",
      "adjuntoUrl": null
    }
  ],
  "comentarios": [
    {
      "id": 1,
      "usuario": {
        "id": 2,
        "nombre": "Marta Diseño"
      },
      "fecha": "2026-01-09T11:00:00",
      "texto": "He preparado 3 rutas: tipográfica, isotipo y combo. Subo bocetos en breve."
    }
  ]
}
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 404 | Trabajo no encontrado |
| 403 | No tiene permiso para ver este trabajo |

---

#### POST /trabajos

Crea un nuevo trabajo.

**Autorización:** ADMIN

**Request:**
```http
POST /api/trabajos
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Diseño packaging - Miel Artesanal",
  "cliente": "Miel del Valle",
  "prioridad": "MEDIA",
  "fechaInicio": "2026-02-10",
  "fechaFin": "2026-03-01",
  "descripcion": "Diseño de etiqueta y caja para producto artesanal",
  "participantesIds": [2, 3]
}
```

**Response (201 Created):**
```json
{
  "id": 7,
  "titulo": "Diseño packaging - Miel Artesanal",
  "cliente": "Miel del Valle",
  "prioridad": "MEDIA",
  "fechaInicio": "2026-02-10",
  "fechaFin": "2026-03-01",
  "estadoActual": "CREADO",
  "descripcion": "Diseño de etiqueta y caja para producto artesanal",
  "creadoPor": {
    "id": 1,
    "nombre": "Luis Admin"
  }
}
```

**Validaciones:**

| Campo | Regla |
|-------|-------|
| `titulo` | Obligatorio, máx 150 caracteres |
| `cliente` | Obligatorio, máx 150 caracteres |
| `prioridad` | Obligatorio, valores: BAJA, MEDIA, ALTA, URGENTE |
| `fechaInicio` | Opcional, formato: YYYY-MM-DD |
| `fechaFin` | Opcional, debe ser posterior a fechaInicio |
| `descripcion` | Opcional |
| `participantesIds` | Opcional, array de IDs de usuarios existentes |

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Datos de validación inválidos |
| 403 | Acceso denegado (no es ADMIN) |

---

#### PUT /trabajos/{id}

Actualiza un trabajo existente.

**Autorización:** ADMIN

**Request:**
```http
PUT /api/trabajos/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Identidad corporativa - Cafetería Nómada [ACTUALIZADO]",
  "fechaFin": "2026-01-25",
  "prioridad": "ALTA"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "titulo": "Identidad corporativa - Cafetería Nómada [ACTUALIZADO]",
  "prioridad": "ALTA",
  "fechaFin": "2026-01-25"
}
```

**Restricciones:**
- No se puede editar un trabajo en estado `ENTREGADO` o `CANCELADO`

**Errores:**

| Código | Descripción |
|--------|-------------|
| 404 | Trabajo no encontrado |
| 403 | Acceso denegado |
| 400 | No se puede editar trabajo finalizado |

---

#### PUT /trabajos/{id}/estado

Cambia el estado de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
PUT /api/trabajos/1/estado
Authorization: Bearer {token}
Content-Type: application/json

{
  "nuevoEstado": "EN_REVISION",
  "motivo": "Diseño terminado, pendiente de aprobación del cliente"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "estadoActual": "EN_REVISION",
  "historial": {
    "id": 14,
    "estadoAnterior": "EN_PROGRESO",
    "estadoNuevo": "EN_REVISION",
    "fecha": "2026-02-09T15:30:00",
    "usuario": "Marta Diseño",
    "motivo": "Diseño terminado, pendiente de aprobación del cliente"
  }
}
```

**Transiciones Permitidas:**

| Desde | Hacia |
|-------|-------|
| CREADO | EN_PROGRESO, CANCELADO |
| EN_PROGRESO | EN_REVISION, CANCELADO |
| EN_REVISION | EN_PROGRESO, ENTREGADO |
| ENTREGADO | (ninguno - estado final) |
| CANCELADO | (ninguno - estado final) |

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Transición de estado no permitida |
| 403 | No tiene permiso para cambiar el estado |
| 404 | Trabajo no encontrado |

---

### 📝 Comentarios

#### POST /trabajos/{id}/comentarios

Añade un comentario a un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
POST /api/trabajos/1/comentarios
Authorization: Bearer {token}
Content-Type: application/json

{
  "texto": "He actualizado el isotipo con los colores aprobados por el cliente."
}
```

**Response (201 Created):**
```json
{
  "id": 7,
  "trabajo": {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada"
  },
  "usuario": {
    "id": 2,
    "nombre": "Marta Diseño"
  },
  "fecha": "2026-02-09T16:45:00",
  "texto": "He actualizado el isotipo con los colores aprobados por el cliente."
}
```

**Validaciones:**

| Campo | Regla |
|-------|-------|
| `texto` | Obligatorio, mínimo 1 carácter |

---

#### GET /trabajos/{id}/comentarios

Obtiene todos los comentarios de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1/comentarios
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "usuario": {
      "id": 2,
      "nombre": "Marta Diseño"
    },
    "fecha": "2026-01-09T11:00:00",
    "texto": "He preparado 3 rutas: tipográfica, isotipo y combo."
  },
  {
    "id": 2,
    "usuario": {
      "id": 3,
      "nombre": "Carlos Ilustración"
    },
    "fecha": "2026-01-10T14:00:00",
    "texto": "Propongo ilustración minimal para el isotipo."
  }
]
```

---

### 📜 Historial de Estados

#### GET /historial/{trabajoId}

Obtiene el historial completo de cambios de estado de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/historial/1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "trabajo": {
      "id": 1,
      "titulo": "Identidad corporativa - Cafetería Nómada"
    },
    "estado": "CREADO",
    "fecha": "2026-01-07T09:00:00",
    "usuario": {
      "id": 1,
      "nombre": "Luis Admin"
    },
    "motivo": "Trabajo creado y listo para asignación."
  },
  {
    "id": 2,
    "trabajo": {
      "id": 1,
      "titulo": "Identidad corporativa - Cafetería Nómada"
    },
    "estado": "EN_PROGRESO",
    "fecha": "2026-01-08T10:30:00",
    "usuario": {
      "id": 2,
      "nombre": "Marta Diseño"
    },
    "motivo": "Comenzamos bocetos y exploración de logo."
  }
]
```

---

### 📌 Requisitos

#### POST /trabajos/{id}/requisitos

Añade un requisito a un trabajo.

**Autorización:** ADMIN

**Request:**
```http
POST /api/trabajos/1/requisitos
Authorization: Bearer {token}
Content-Type: application/json

{
  "descripcion": "Versión del logo para redes sociales (perfil circular)",
  "adjuntoUrl": "https://drive.google.com/file/ejemplo"
}
```

**Response (201 Created):**
```json
{
  "id": 9,
  "trabajoId": 1,
  "descripcion": "Versión del logo para redes sociales (perfil circular)",
  "adjuntoUrl": "https://drive.google.com/file/ejemplo"
}
```

---

#### GET /trabajos/{id}/requisitos

Obtiene los requisitos de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1/requisitos
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "descripcion": "Logotipo principal + versión monocroma + favicon.",
    "adjuntoUrl": null
  },
  {
    "id": 2,
    "descripcion": "Aplicación en vaso, bolsa y tarjeta.",
    "adjuntoUrl": null
  }
]
```

---

## 🚨 Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Petición exitosa (GET, PUT) |
| 201 | Created | Recurso creado (POST) |
| 204 | No Content | Petición exitosa sin contenido (DELETE) |
| 400 | Bad Request | Datos inválidos o faltantes |
| 401 | Unauthorized | Token inválido o expirado |
| 403 | Forbidden | Sin permisos para realizar la acción |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto (ej: transición de estado inválida) |
| 500 | Internal Server Error | Error del servidor |

---

## 🛡️ Formato de Errores

Todos los errores siguen este formato:

```json
{
  "timestamp": "2026-02-09T17:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "El campo 'titulo' es obligatorio",
  "path": "/api/trabajos"
}
```

---

## 🧪 Ejemplos de Uso

### Flujo Completo: Login → Listar Trabajos → Ver Detalle

```bash
# 1. Login
TOKEN=$(curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@designworks.com", "password": "Admin1234!"}' \
  | jq -r '.token')

# 2. Listar trabajos
curl -X GET http://localhost:8080/api/trabajos \
  -H "Authorization: Bearer $TOKEN"

# 3. Ver detalle del trabajo 1
curl -X GET http://localhost:8080/api/trabajos/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Crear Trabajo y Añadir Comentario

```bash
# 1. Crear trabajo
TRABAJO_ID=$(curl -X POST http://localhost:8080/api/trabajos \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Diseño web landing",
    "cliente": "Tech Startup",
    "prioridad": "ALTA",
    "descripcion": "Landing page moderna y responsive"
  }' | jq -r '.id')

# 2. Añadir comentario
curl -X POST http://localhost:8080/api/trabajos/$TRABAJO_ID/comentarios \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"texto": "Empiezo con los wireframes"}'
```

---

## 📚 Documentación Interactiva (Futuro)

Se planea integrar **Swagger/OpenAPI** para documentación interactiva:

- **URL (local)**: `http://localhost:8080/swagger-ui.html`
- **Especificación OpenAPI**: `http://localhost:8080/api-docs`

Esto permitirá:
- Explorar todos los endpoints
- Probar peticiones directamente desde el navegador
- Ver esquemas de datos automáticamente

---

## 🔄 Versionado de API

Actualmente: **v1.0** (sin prefijo de versión en URLs)

En el futuro, si se realizan cambios incompatibles:
- Nueva versión: `/api/v2/trabajos`
- Versión actual: `/api/v1/trabajos` o `/api/trabajos` (deprecated)

---

## 📝 Notas Importantes

1. **Puertos según OS:**
   - macOS: `8080`
   - Windows: `8082`

2. **CORS:** Configurado para permitir peticiones desde Flutter app

3. **Rate Limiting:** No implementado actualmente (futuro)

4. **Paginación:** No implementada actualmente (futuro)

5. **Sorting:** No implementado actualmente (futuro)

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM

**⚠️ Nota:** Esta documentación es preliminar. Algunos endpoints están en desarrollo.

## 📡 Información General

- **Base URL (macOS)**: `http://localhost:8080/api`
- **Base URL (Windows)**: `http://localhost:8082/api`
- **Formato**: JSON
- **Autenticación**: JWT (Bearer Token)
- **Versión**: v1.0

---

## 🔐 Autenticación

Todos los endpoints (excepto `/auth/login`) requieren un token JWT válido en el header:

```http
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBkZXNpZ253...
```

### Flujo de Autenticación

```
1. Cliente → POST /auth/login (email + password)
2. Servidor → Valida credenciales
3. Servidor → Genera JWT
4. Servidor → Responde { token, rol, nombre }
5. Cliente → Almacena token de forma segura
6. Cliente → Envía token en cada petición subsiguiente
```

---

## 📋 Endpoints

### 🔑 Autenticación

#### POST /auth/login

Autentica un usuario y devuelve un token JWT.

**Request:**
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@designworks.com",
  "password": "Admin1234!"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBkZXNpZ253b3Jrcy5jb20iLCJ1c2VySWQiOjEsInJvbCI6IkFETUlOIiwibm9tYnJlIjoiTHVpcyBBZG1pbiIsImlhdCI6MTcwNzQ5NDQwMCwiZXhwIjoxNzA3NTgwODAwfQ.signature",
  "tipo": "Bearer",
  "rol": "ADMIN",
  "nombre": "Luis Admin",
  "email": "admin@designworks.com"
}
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Email o contraseña faltante |
| 401 | Credenciales inválidas |
| 403 | Usuario inactivo |

**Ejemplo de uso:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@designworks.com",
    "password": "Admin1234!"
  }'
```

---

### 📊 Trabajos

#### GET /trabajos

Lista todos los trabajos del sistema (solo ADMIN).

**Autorización:** ADMIN

**Request:**
```http
GET /api/trabajos?estado=EN_PROGRESO&prioridad=ALTA
Authorization: Bearer {token}
```

**Query Parameters:**

| Parámetro | Tipo | Descripción | Ejemplo |
|-----------|------|-------------|---------|
| `estado` | String | Filtrar por estado | `EN_PROGRESO` |
| `prioridad` | String | Filtrar por prioridad | `ALTA` |
| `cliente` | String | Filtrar por nombre de cliente | `Cafetería` |
| `fechaDesde` | Date | Filtrar desde fecha | `2026-01-01` |
| `fechaHasta` | Date | Filtrar hasta fecha | `2026-01-31` |

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada",
    "cliente": "Cafetería Nómada",
    "prioridad": "URGENTE",
    "fechaInicio": "2026-01-07",
    "fechaFin": "2026-01-22",
    "estadoActual": "EN_PROGRESO",
    "descripcion": "Diseño de logotipo, paleta y aplicaciones básicas para cafetería.",
    "creadoPor": {
      "id": 1,
      "nombre": "Luis Admin",
      "email": "admin@designworks.com"
    },
    "participantes": [
      {
        "id": 2,
        "nombre": "Marta Diseño",
        "rolEnTrabajo": "DISENADOR"
      },
      {
        "id": 3,
        "nombre": "Carlos Ilustración",
        "rolEnTrabajo": "DISENADOR"
      }
    ]
  }
]
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 401 | Token inválido o expirado |
| 403 | Acceso denegado (no es ADMIN) |

---

#### GET /trabajos/mis

Lista los trabajos asignados al usuario autenticado.

**Autorización:** ADMIN, DISEÑADOR

**Request:**
```http
GET /api/trabajos/mis?estado=EN_PROGRESO
Authorization: Bearer {token}
```

**Query Parameters:** (mismos que GET /trabajos)

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada",
    "cliente": "Cafetería Nómada",
    "prioridad": "URGENTE",
    "fechaInicio": "2026-01-07",
    "fechaFin": "2026-01-22",
    "estadoActual": "EN_PROGRESO",
    "miRol": "DISENADOR"
  }
]
```

---

#### GET /trabajos/{id}

Obtiene el detalle completo de un trabajo específico.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "titulo": "Identidad corporativa - Cafetería Nómada",
  "cliente": "Cafetería Nómada",
  "prioridad": "URGENTE",
  "fechaInicio": "2026-01-07",
  "fechaFin": "2026-01-22",
  "estadoActual": "EN_PROGRESO",
  "descripcion": "Diseño de logotipo, paleta y aplicaciones básicas para cafetería.",
  "creadoPor": {
    "id": 1,
    "nombre": "Luis Admin",
    "email": "admin@designworks.com"
  },
  "participantes": [
    {
      "id": 1,
      "nombre": "Luis Admin",
      "rolEnTrabajo": "ADMIN"
    },
    {
      "id": 2,
      "nombre": "Marta Diseño",
      "rolEnTrabajo": "DISENADOR"
    }
  ],
  "requisitos": [
    {
      "id": 1,
      "descripcion": "Logotipo principal + versión monocroma + favicon.",
      "adjuntoUrl": null
    },
    {
      "id": 2,
      "descripcion": "Aplicación en vaso, bolsa y tarjeta.",
      "adjuntoUrl": null
    }
  ],
  "comentarios": [
    {
      "id": 1,
      "usuario": {
        "id": 2,
        "nombre": "Marta Diseño"
      },
      "fecha": "2026-01-09T11:00:00",
      "texto": "He preparado 3 rutas: tipográfica, isotipo y combo. Subo bocetos en breve."
    }
  ]
}
```

**Errores:**

| Código | Descripción |
|--------|-------------|
| 404 | Trabajo no encontrado |
| 403 | No tiene permiso para ver este trabajo |

---

#### POST /trabajos

Crea un nuevo trabajo.

**Autorización:** ADMIN

**Request:**
```http
POST /api/trabajos
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Diseño packaging - Miel Artesanal",
  "cliente": "Miel del Valle",
  "prioridad": "MEDIA",
  "fechaInicio": "2026-02-10",
  "fechaFin": "2026-03-01",
  "descripcion": "Diseño de etiqueta y caja para producto artesanal",
  "participantesIds": [2, 3]
}
```

**Response (201 Created):**
```json
{
  "id": 7,
  "titulo": "Diseño packaging - Miel Artesanal",
  "cliente": "Miel del Valle",
  "prioridad": "MEDIA",
  "fechaInicio": "2026-02-10",
  "fechaFin": "2026-03-01",
  "estadoActual": "CREADO",
  "descripcion": "Diseño de etiqueta y caja para producto artesanal",
  "creadoPor": {
    "id": 1,
    "nombre": "Luis Admin"
  }
}
```

**Validaciones:**

| Campo | Regla |
|-------|-------|
| `titulo` | Obligatorio, máx 150 caracteres |
| `cliente` | Obligatorio, máx 150 caracteres |
| `prioridad` | Obligatorio, valores: BAJA, MEDIA, ALTA, URGENTE |
| `fechaInicio` | Opcional, formato: YYYY-MM-DD |
| `fechaFin` | Opcional, debe ser posterior a fechaInicio |
| `descripcion` | Opcional |
| `participantesIds` | Opcional, array de IDs de usuarios existentes |

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Datos de validación inválidos |
| 403 | Acceso denegado (no es ADMIN) |

---

#### PUT /trabajos/{id}

Actualiza un trabajo existente.

**Autorización:** ADMIN

**Request:**
```http
PUT /api/trabajos/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "titulo": "Identidad corporativa - Cafetería Nómada [ACTUALIZADO]",
  "fechaFin": "2026-01-25",
  "prioridad": "ALTA"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "titulo": "Identidad corporativa - Cafetería Nómada [ACTUALIZADO]",
  "prioridad": "ALTA",
  "fechaFin": "2026-01-25"
}
```

**Restricciones:**
- No se puede editar un trabajo en estado `ENTREGADO` o `CANCELADO`

**Errores:**

| Código | Descripción |
|--------|-------------|
| 404 | Trabajo no encontrado |
| 403 | Acceso denegado |
| 400 | No se puede editar trabajo finalizado |

---

#### PUT /trabajos/{id}/estado

Cambia el estado de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
PUT /api/trabajos/1/estado
Authorization: Bearer {token}
Content-Type: application/json

{
  "nuevoEstado": "EN_REVISION",
  "motivo": "Diseño terminado, pendiente de aprobación del cliente"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "estadoActual": "EN_REVISION",
  "historial": {
    "id": 14,
    "estadoAnterior": "EN_PROGRESO",
    "estadoNuevo": "EN_REVISION",
    "fecha": "2026-02-09T15:30:00",
    "usuario": "Marta Diseño",
    "motivo": "Diseño terminado, pendiente de aprobación del cliente"
  }
}
```

**Transiciones Permitidas:**

| Desde | Hacia |
|-------|-------|
| CREADO | EN_PROGRESO, CANCELADO |
| EN_PROGRESO | EN_REVISION, CANCELADO |
| EN_REVISION | EN_PROGRESO, ENTREGADO |
| ENTREGADO | (ninguno - estado final) |
| CANCELADO | (ninguno - estado final) |

**Errores:**

| Código | Descripción |
|--------|-------------|
| 400 | Transición de estado no permitida |
| 403 | No tiene permiso para cambiar el estado |
| 404 | Trabajo no encontrado |

---

### 📝 Comentarios

#### POST /trabajos/{id}/comentarios

Añade un comentario a un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
POST /api/trabajos/1/comentarios
Authorization: Bearer {token}
Content-Type: application/json

{
  "texto": "He actualizado el isotipo con los colores aprobados por el cliente."
}
```

**Response (201 Created):**
```json
{
  "id": 7,
  "trabajo": {
    "id": 1,
    "titulo": "Identidad corporativa - Cafetería Nómada"
  },
  "usuario": {
    "id": 2,
    "nombre": "Marta Diseño"
  },
  "fecha": "2026-02-09T16:45:00",
  "texto": "He actualizado el isotipo con los colores aprobados por el cliente."
}
```

**Validaciones:**

| Campo | Regla |
|-------|-------|
| `texto` | Obligatorio, mínimo 1 carácter |

---

#### GET /trabajos/{id}/comentarios

Obtiene todos los comentarios de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1/comentarios
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "usuario": {
      "id": 2,
      "nombre": "Marta Diseño"
    },
    "fecha": "2026-01-09T11:00:00",
    "texto": "He preparado 3 rutas: tipográfica, isotipo y combo."
  },
  {
    "id": 2,
    "usuario": {
      "id": 3,
      "nombre": "Carlos Ilustración"
    },
    "fecha": "2026-01-10T14:00:00",
    "texto": "Propongo ilustración minimal para el isotipo."
  }
]
```

---

### 📜 Historial de Estados

#### GET /historial/{trabajoId}

Obtiene el historial completo de cambios de estado de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/historial/1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "trabajo": {
      "id": 1,
      "titulo": "Identidad corporativa - Cafetería Nómada"
    },
    "estado": "CREADO",
    "fecha": "2026-01-07T09:00:00",
    "usuario": {
      "id": 1,
      "nombre": "Luis Admin"
    },
    "motivo": "Trabajo creado y listo para asignación."
  },
  {
    "id": 2,
    "trabajo": {
      "id": 1,
      "titulo": "Identidad corporativa - Cafetería Nómada"
    },
    "estado": "EN_PROGRESO",
    "fecha": "2026-01-08T10:30:00",
    "usuario": {
      "id": 2,
      "nombre": "Marta Diseño"
    },
    "motivo": "Comenzamos bocetos y exploración de logo."
  }
]
```

---

### 📌 Requisitos

#### POST /trabajos/{id}/requisitos

Añade un requisito a un trabajo.

**Autorización:** ADMIN

**Request:**
```http
POST /api/trabajos/1/requisitos
Authorization: Bearer {token}
Content-Type: application/json

{
  "descripcion": "Versión del logo para redes sociales (perfil circular)",
  "adjuntoUrl": "https://drive.google.com/file/ejemplo"
}
```

**Response (201 Created):**
```json
{
  "id": 9,
  "trabajoId": 1,
  "descripcion": "Versión del logo para redes sociales (perfil circular)",
  "adjuntoUrl": "https://drive.google.com/file/ejemplo"
}
```

---

#### GET /trabajos/{id}/requisitos

Obtiene los requisitos de un trabajo.

**Autorización:** ADMIN o participante del trabajo

**Request:**
```http
GET /api/trabajos/1/requisitos
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "descripcion": "Logotipo principal + versión monocroma + favicon.",
    "adjuntoUrl": null
  },
  {
    "id": 2,
    "descripcion": "Aplicación en vaso, bolsa y tarjeta.",
    "adjuntoUrl": null
  }
]
```

---

## 🚨 Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Petición exitosa (GET, PUT) |
| 201 | Created | Recurso creado (POST) |
| 204 | No Content | Petición exitosa sin contenido (DELETE) |
| 400 | Bad Request | Datos inválidos o faltantes |
| 401 | Unauthorized | Token inválido o expirado |
| 403 | Forbidden | Sin permisos para realizar la acción |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto (ej: transición de estado inválida) |
| 500 | Internal Server Error | Error del servidor |

---

## 🛡️ Formato de Errores

Todos los errores siguen este formato:

```json
{
  "timestamp": "2026-02-09T17:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "El campo 'titulo' es obligatorio",
  "path": "/api/trabajos"
}
```

---

## 🧪 Ejemplos de Uso

### Flujo Completo: Login → Listar Trabajos → Ver Detalle

```bash
# 1. Login
TOKEN=$(curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@designworks.com", "password": "Admin1234!"}' \
  | jq -r '.token')

# 2. Listar trabajos
curl -X GET http://localhost:8080/api/trabajos \
  -H "Authorization: Bearer $TOKEN"

# 3. Ver detalle del trabajo 1
curl -X GET http://localhost:8080/api/trabajos/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Crear Trabajo y Añadir Comentario

```bash
# 1. Crear trabajo
TRABAJO_ID=$(curl -X POST http://localhost:8080/api/trabajos \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Diseño web landing",
    "cliente": "Tech Startup",
    "prioridad": "ALTA",
    "descripcion": "Landing page moderna y responsive"
  }' | jq -r '.id')

# 2. Añadir comentario
curl -X POST http://localhost:8080/api/trabajos/$TRABAJO_ID/comentarios \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"texto": "Empiezo con los wireframes"}'
```

---

## 📚 Documentación Interactiva (Futuro)

Se planea integrar **Swagger/OpenAPI** para documentación interactiva:

- **URL (local)**: `http://localhost:8080/swagger-ui.html`
- **Especificación OpenAPI**: `http://localhost:8080/api-docs`

Esto permitirá:
- Explorar todos los endpoints
- Probar peticiones directamente desde el navegador
- Ver esquemas de datos automáticamente

---

## 🔄 Versionado de API

Actualmente: **v1.0** (sin prefijo de versión en URLs)

En el futuro, si se realizan cambios incompatibles:
- Nueva versión: `/api/v2/trabajos`
- Versión actual: `/api/v1/trabajos` o `/api/trabajos` (deprecated)

---

## 📝 Notas Importantes

1. **Puertos según OS:**
   - macOS: `8080`
   - Windows: `8082`

2. **CORS:** Configurado para permitir peticiones desde Flutter app

3. **Rate Limiting:** No implementado actualmente (futuro)

4. **Paginación:** No implementada actualmente (futuro)

5. **Sorting:** No implementado actualmente (futuro)

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM

**⚠️ Nota:** Esta documentación es preliminar. Algunos endpoints están en desarrollo.