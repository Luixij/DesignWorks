# Resultados de Pruebas

## 1. Alcance de este documento

Este documento registra el estado actual de los casos de prueba definidos para el proyecto **DesignWorks**.

Se distinguen dos tipos de verificación:

- **Verificado por implementación:** el comportamiento queda respaldado por el código revisado.
- **Pendiente de ejecución con evidencia:** requiere prueba manual o automática para adjuntar capturas, JSON reales, tiempos o logs.

Este enfoque permite entregar un documento honesto: no se inventan resultados que todavía no hayan sido medidos en entorno real.

---

## 2. Resumen general

| Estado | Significado |
|---|---|
| Verificado por implementación | El caso está respaldado por el código fuente revisado |
| Pendiente de ejecución | Requiere comprobación manual con Swagger/Postman/App |
| No aplicable | No corresponde a la versión actual |

---

## 3. Resultados por bloque

### 3.1 Autenticación

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-AUTH-01 | Verificado por implementación | Existe `POST /auth/login` y DTO real de request/response | Falta adjuntar ejemplo real de token emitido |
| TP-AUTH-02 | Pendiente de ejecución | Requiere prueba con credenciales incorrectas | Debe registrarse código exacto y mensaje |
| TP-AUTH-03 | Verificado por implementación | `GET /auth/me` depende de `Principal`; sin autenticación devuelve 401 | Conviene adjuntar captura |
| TP-AUTH-04 | Pendiente de ejecución | Requiere prueba con token corrupto | Debe registrarse código exacto |
| TP-AUTH-05 | Verificado por implementación | `GET /auth/me` existe y devuelve usuario autenticado | Falta evidencia JSON real |

### 3.2 Trabajos

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-TRAB-01 | Verificado por implementación | Existe `POST /trabajos` con `TrabajoCreateRequest` | Falta request/response real |
| TP-TRAB-02 | Pendiente de ejecución | Requiere enviar payload inválido | Debe comprobarse validación real en runtime |
| TP-TRAB-03 | Verificado por implementación | `POST /trabajos` está restringido a `ADMIN` | Falta captura de acceso denegado |
| TP-TRAB-04 | Verificado por implementación | Existe `GET /trabajos` solo `ADMIN` | Falta evidencia con datos reales |
| TP-TRAB-05 | Verificado por implementación | Seguridad declarada por `@PreAuthorize` | Falta prueba manual con `DISENADOR` |
| TP-TRAB-06 | Verificado por implementación | Existe `GET /trabajos/mis` para `ADMIN` y `DISENADOR` | Falta evidencia con usuario real |
| TP-TRAB-07 | Verificado por implementación | Existe `GET /trabajos/{id}` con control por participante | Falta captura |
| TP-TRAB-08 | Verificado por implementación | Seguridad por pertenencia aplicada | Conviene confirmar si la respuesta final es 403 |

### 3.3 Estados

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-EST-01 | Verificado por implementación | Existe `PUT /trabajos/{id}/estado` | Requiere prueba real con datos |
| TP-EST-02 | Verificado por implementación | El endpoint permite `ADMIN` o participante | Requiere usuario participante |
| TP-EST-03 | Verificado por implementación | Un no participante debe quedar bloqueado por seguridad | Confirmar código final en runtime |
| TP-EST-04 | Pendiente de ejecución | Requiere probar transición concreta | Adjuntar historial generado |
| TP-EST-05 | Pendiente de ejecución | Requiere probar transición concreta | Adjuntar evidencia |
| TP-EST-06 | Pendiente de ejecución | Requiere probar transición concreta | Adjuntar evidencia |

### 3.4 Requisitos

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-REQ-01 | Verificado por implementación | Existe `POST /trabajos/{trabajoId}/requisitos` solo `ADMIN` | Falta request/response real |
| TP-REQ-02 | Verificado por implementación | Existe `GET /trabajos/{trabajoId}/requisitos` | Falta evidencia |
| TP-REQ-03 | Verificado por implementación | El alta está restringida a `ADMIN` | Falta prueba manual |

### 3.5 Comentarios

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-COM-01 | Verificado por implementación | Existe `POST /trabajos/{trabajoId}/comentarios` | Falta comentario real creado |
| TP-COM-02 | Verificado por implementación | Existe `GET /trabajos/{trabajoId}/comentarios` y repositorio ordena por fecha ascendente | Conviene validar orden real con varios registros |
| TP-COM-03 | Verificado por implementación | Seguridad por pertenencia aplicada | Falta captura |

### 3.6 Historial

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-HIST-01 | Verificado por implementación | Existe `GET /trabajos/{trabajoId}/historial` | Requiere historial real generado |
| TP-HIST-02 | Verificado por implementación | Seguridad por pertenencia aplicada | Confirmar respuesta final |

### 3.7 No funcionales

| ID | Estado actual | Base de verificación | Observaciones |
|---|---|---|---|
| TP-NFR-01 | Verificado por implementación | Existen pantallas Flutter con estilo coherente | Falta colección de capturas |
| TP-NFR-02 | Verificado por implementación | Se observa navegación entre login, home y perfil | Falta recorrido grabado |
| TP-NFR-03 | Verificado por implementación | Login valida campos vacíos, email inválido y password vacía | Falta captura en ejecución |
| TP-NFR-04 | Pendiente de ejecución | No se han medido tiempos reales | Registrar response time en Postman |
| TP-NFR-05 | Pendiente de ejecución | No se aportan métricas o explain reales | Revisar rendimiento con datos reales |
| TP-NFR-06 | Verificado por implementación | Seguridad por JWT y roles visible en controladores | Falta suite ejecutada |
| TP-NFR-07 | Verificado por implementación | El frontend usa almacenamiento seguro y limpia sesión al salir | Adjuntar evidencia visual |
| TP-NFR-08 | Verificado por implementación | Hay protección por rol y pertenencia | Confirmar con pruebas reales negativas |
| TP-NFR-09 | Pendiente de revisión | Necesita revisar servicios o pruebas de integración | No confirmado solo con controladores |
| TP-NFR-10 | Pendiente de ejecución | Necesita provocar errores y revisar logs | Registrar consola |
| TP-NFR-11 | Verificado por implementación | El proyecto presenta estructura por capas y documentación | Adjuntar captura del árbol del repo |
| TP-NFR-12 | Verificado por implementación | Existe `docker-compose.yml` con MariaDB y Adminer | Falta captura de arranque |
| TP-NFR-13 | Verificado por implementación | Existen comandos de ejecución y build Flutter | Falta captura de compilación |

---

## 4. Hallazgos actuales

### 4.1 Confirmaciones positivas

- El proyecto dispone de autenticación mediante JWT con endpoint de login y endpoint para usuario autenticado.
- El backend define roles reales `ADMIN` y `DISENADOR`.
- El control de acceso está reforzado con `@PreAuthorize` en trabajos, requisitos, comentarios e historial.
- El diseñador no tiene acceso global a todos los trabajos; el acceso depende de participar en el trabajo.
- El frontend incluye validación local del formulario de login y manejo de sesión.
- La infraestructura local está preparada para MariaDB mediante Docker Compose.

### 4.2 Aspectos pendientes de evidenciar

- Códigos exactos devueltos por todos los casos negativos en ejecución real.
- Tiempos reales de respuesta.
- Respuestas JSON completas de los módulos de trabajos, requisitos, comentarios e historial.
- Capturas finales del frontend y de Postman/Swagger.

---

## 5. Próximos pasos para cerrar la campaña

1. Ejecutar los casos `TP-AUTH-*` desde Postman o Swagger.
2. Crear datos semilla suficientes para probar trabajos propios y ajenos.
3. Recorrer en la app Flutter el flujo login → home → perfil → logout.
4. Adjuntar capturas de errores de validación del login.
5. Medir y registrar tiempos básicos de `login`, `GET /trabajos`, `GET /trabajos/mis` y comentarios.
6. Guardar una carpeta de evidencias con nombres alineados con los IDs de prueba.

---

## 6. Conclusión

A fecha de esta revisión, el proyecto presenta una base funcional y técnica suficiente para sostener una campaña de pruebas completa. Una parte importante de los casos ya puede considerarse **verificada por implementación**, especialmente en autenticación, seguridad, módulos REST y flujo básico de interfaz. No obstante, para cerrar formalmente la validación del sistema, todavía deben añadirse evidencias de ejecución real y mediciones no funcionales.
