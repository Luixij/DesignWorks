# DesignWorks Backend API

API REST desarrollada con **Spring Boot** para la gestión de trabajos de diseño, requisitos, comentarios e historial de estados.

La aplicación implementa:

* Autenticación mediante **JWT**
* Control de acceso por **roles (ADMIN / DISENADOR)**
* Arquitectura **REST**
* Documentación automática con **OpenAPI / Swagger**

---

# Tecnologías utilizadas

* Java 17
* Spring Boot 3
* Spring Security
* JWT (JSON Web Token)
* JPA / Hibernate
* MariaDB
* SpringDoc OpenAPI (Swagger)

---

# Ejecutar el proyecto

Desde la carpeta `backend` ejecutar:

```
mvn clean install
mvn spring-boot:run
```

La aplicación se iniciará en:

```
http://localhost:8080
```

---

# Documentación de la API

La documentación de la API se genera automáticamente mediante **OpenAPI / Swagger**.

## Swagger UI

Interfaz interactiva para probar la API desde el navegador:

```
http://localhost:8080/swagger-ui.html
```

En esta interfaz es posible:

* visualizar todos los endpoints disponibles
* consultar parámetros de entrada
* ver los modelos de datos
* ejecutar peticiones directamente

---

## OpenAPI JSON

Especificación OpenAPI en formato JSON:

```
http://localhost:8080/v3/api-docs
```

Este documento puede ser utilizado para:

* generar clientes de API
* integraciones con otras aplicaciones
* herramientas de testing automático
* documentación técnica

---

# Autenticación

La API utiliza **JWT (JSON Web Token)**.

## Paso 1 — Login

Endpoint:

```
POST /auth/login
```

Ejemplo de body:

```json
{
  "email": "usuario@email.com",
  "password": "password"
}
```

Respuesta:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR..."
}
```

---

## Paso 2 — Usar el token

En Swagger UI:

1. Pulsar **Authorize**
2. Introducir el token con el formato:

```
Bearer TU_TOKEN
```

Una vez autorizado se podrán ejecutar los endpoints protegidos.

---

# Principales endpoints

## Autenticación

```
POST /auth/login
GET  /auth/me
```

---

## Trabajos

```
GET  /trabajos
GET  /trabajos/mis
GET  /trabajos/{id}
POST /trabajos
PUT  /trabajos/{id}/estado
```

---

## Requisitos

```
GET  /trabajos/{trabajoId}/requisitos
POST /trabajos/{trabajoId}/requisitos
```

---

## Comentarios

```
GET  /trabajos/{trabajoId}/comentarios
POST /trabajos/{trabajoId}/comentarios
```

---

## Historial

```
GET /trabajos/{trabajoId}/historial
```

---

# Estructura del proyecto

```
backend
 ├ controllers
 ├ services
 ├ repositories
 ├ dto
 ├ entities
 ├ security
 └ config
```

---

# Documentación técnica

La documentación del proyecto se encuentra en la carpeta:

```
docs/
```

Incluye:

* fase de análisis
* fase de diseño
* plan de pruebas
* matriz de trazabilidad
* resultados de pruebas
