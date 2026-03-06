# Plan de Pruebas

## 1. Identificación del documento

- **Proyecto:** DesignWorks
- **Tipo de sistema:** Aplicación de gestión de trabajos de diseño
- **Backend:** Spring Boot + Spring Security + JWT + JPA
- **Frontend:** Flutter + Riverpod + GoRouter
- **Base de datos:** MariaDB 11
- **Infraestructura local:** Docker Compose con MariaDB y Adminer
- **Versión del documento:** 1.0
- **Estado:** Basado en la implementación actual del proyecto

---

## 2. Objetivo

Este documento define el plan de pruebas del proyecto **DesignWorks**, con el fin de verificar el correcto funcionamiento de los módulos implementados en backend y frontend, así como validar los requisitos funcionales y no funcionales observables en la versión actual del sistema.

El documento se ha construido a partir de la implementación real disponible en el proyecto. Por tanto, los casos aquí descritos están alineados con los controladores, DTO, enums, configuración de infraestructura y pantallas Flutter actualmente presentes en el código.

---

## 3. Alcance

El alcance de este plan de pruebas cubre los siguientes bloques:

### 3.1 Backend

- Autenticación con JWT
- Obtención del usuario autenticado
- Gestión de trabajos
- Consulta de trabajos propios
- Detalle de trabajo
- Cambio de estado
- Gestión de requisitos
- Gestión de comentarios
- Consulta de historial
- Seguridad por rol y por pertenencia al trabajo

### 3.2 Frontend

- Pantalla de login
- Pantalla principal con estadísticas
- Pantalla de perfil
- Pantalla de trabajos
- Persistencia de sesión y cierre de sesión
- Manejo de estados de carga y error

### 3.3 No funcionales

- Usabilidad de la interfaz
- Validaciones básicas de formularios
- Seguridad de acceso
- Portabilidad en backend y frontend
- Organización por capas y mantenibilidad

---

## 4. Fuentes reales utilizadas

Este plan se apoya en la implementación actual del proyecto:

- El login se implementa en `POST /auth/login` y la consulta del usuario autenticado en `GET /auth/me`. El request de login exige `email` y `password`, y la respuesta devuelve `token` y `rol`. Los endpoints y DTO están definidos en el backend actual. 
- Los roles disponibles son `ADMIN` y `DISENADOR`.
- Los estados reales del trabajo son `CREADO`, `EN_PROGRESO`, `EN_REVISION`, `ENTREGADO` y `CANCELADO`.
- El módulo de trabajos expone creación, listado general, listado de trabajos propios, detalle y cambio de estado.
- El módulo de comentarios expone alta y listado por trabajo.
- El módulo de historial expone listado por trabajo.
- El módulo de requisitos expone alta y listado por trabajo.
- La infraestructura local usa MariaDB 11 y Adminer mediante Docker Compose.
- El frontend contiene pantallas reales de login, home, perfil y trabajos.

---

## 5. Entorno de pruebas

### 5.1 Entorno backend

- **Framework:** Spring Boot
- **Seguridad:** Spring Security con JWT
- **Persistencia:** Spring Data JPA
- **Base de datos:** MariaDB 11
- **Contenedores disponibles:** `mariadb` y `adminer`
- **Ejecución habitual:** local, con perfil de desarrollo/local

### 5.2 Entorno frontend

- **Framework:** Flutter
- **Gestión de estado:** Riverpod
- **Navegación:** GoRouter
- **Almacenamiento local seguro:** Secure Storage
- **Ejecución Android:** `flutter run --dart-define=API_BASE_URL=...`
- **Build release Android:** `flutter build apk --release --dart-define=API_BASE_URL=...`

### 5.3 Herramientas recomendadas para ejecución

- Swagger / OpenAPI o navegador de endpoints
- Postman
- Emulador Android o dispositivo real
- Docker Compose
- Consola del backend para logs
- Adminer para verificación de datos

---

## 6. Criterios de entrada y salida

### 6.1 Criterios de entrada

Para ejecutar las pruebas deben cumplirse estas condiciones:

- La base de datos MariaDB debe estar levantada.
- El backend debe iniciar correctamente y aceptar conexiones.
- El frontend debe apuntar a la URL correcta de la API.
- Debe existir al menos un usuario válido para autenticación.
- Deben existir datos base o posibilidad de crear trabajos desde el rol `ADMIN`.

### 6.2 Criterios de salida

Se considerará válida una iteración de pruebas cuando:

- Los casos críticos de autenticación se ejecuten sin errores bloqueantes.
- Se verifique el control de acceso por rol y pertenencia.
- Se valide al menos una ruta completa de negocio: login → listado → detalle → comentario / historial / cambio de estado.
- No existan errores bloqueantes en el frontend para navegación básica.

---

## 7. Estrategia de pruebas

Se aplicará una estrategia mixta:

### 7.1 Pruebas funcionales

Validan los casos de uso principales del sistema mediante llamadas reales a la API y recorridos por la interfaz.

### 7.2 Pruebas de seguridad

Validan que los endpoints protegidos rechazan accesos sin token, con token inválido o con permisos insuficientes.

### 7.3 Pruebas de integración

Comprueban la interacción entre backend, base de datos y frontend en los flujos principales.

### 7.4 Pruebas no funcionales

Validan aspectos de usabilidad, validación de formularios, portabilidad y mantenibilidad observables en la versión implementada.

---

## 8. Inventario real de endpoints implementados

### 8.1 Autenticación

- `POST /auth/login`
- `GET /auth/me`

### 8.2 Trabajos

- `POST /trabajos` — solo `ADMIN`
- `GET /trabajos` — solo `ADMIN`
- `GET /trabajos/mis` — `ADMIN` o `DISENADOR`
- `GET /trabajos/{id}` — `ADMIN` o participante
- `PUT /trabajos/{id}/estado` — `ADMIN` o participante

### 8.3 Requisitos

- `POST /trabajos/{trabajoId}/requisitos` — solo `ADMIN`
- `GET /trabajos/{trabajoId}/requisitos` — `ADMIN` o participante

### 8.4 Comentarios

- `POST /trabajos/{trabajoId}/comentarios` — `ADMIN` o participante
- `GET /trabajos/{trabajoId}/comentarios` — `ADMIN` o participante

### 8.5 Historial

- `GET /trabajos/{trabajoId}/historial` — `ADMIN` o participante

---

## 9. Casos de prueba funcionales

> Nota: los casos están alineados con la implementación actual. Los identificadores no usados en esta versión quedan reservados para futuras ampliaciones.

### 9.1 Autenticación

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-AUTH-01 | RF1 | CU1 | `POST /auth/login` | ADMIN / DISENADOR | Usuario existente | Enviar email y password válidos | `200 OK`, respuesta con `token` y `rol` | Captura Swagger/Postman + JSON |
| TP-AUTH-02 | RF1 | CU1 | `POST /auth/login` | ADMIN / DISENADOR | Usuario existente | Enviar password incorrecta | Error de autenticación (`401` o el código configurado) | Captura respuesta |
| TP-AUTH-03 | RNF6 | CU1 | Endpoint protegido | Cualquiera | Sin token | Invocar `GET /auth/me` o cualquier endpoint protegido sin cabecera `Bearer` | Acceso rechazado | Captura |
| TP-AUTH-04 | RNF6 | CU1 | Endpoint protegido | Cualquiera | Token inválido | Invocar endpoint protegido con token corrupto | Acceso rechazado | Captura |
| TP-AUTH-05 | RF1 / RNF6 | CU1 | `GET /auth/me` | ADMIN / DISENADOR | Token válido | Invocar endpoint con `Authorization: Bearer ...` | `200 OK` y datos básicos del usuario | Captura + JSON |

### 9.2 Trabajos

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-TRAB-01 | RF4 | CU3 | `POST /trabajos` | ADMIN | Token ADMIN válido | Crear un trabajo con título, cliente, descripción, prioridad, fecha fin y, opcionalmente, participantes/requisitos | Trabajo creado y devuelto como detalle | Captura request/response |
| TP-TRAB-02 | RNF3 | CU3 | `POST /trabajos` | ADMIN | Token ADMIN válido | Enviar payload incompleto o con datos inválidos | Error controlado, sin caída del sistema | Captura |
| TP-TRAB-03 | RNF8 | CU3 | `POST /trabajos` | DISENADOR | Token DISENADOR válido | Intentar crear trabajo | Acceso denegado | Captura |
| TP-TRAB-04 | RF11 | CU7 | `GET /trabajos` | ADMIN | Existen trabajos | Listar todos los trabajos | Lista completa de trabajos | Captura |
| TP-TRAB-05 | RNF8 | CU7 | `GET /trabajos` | DISENADOR | Token DISENADOR válido | Intentar listar todos los trabajos | Acceso denegado | Captura |
| TP-TRAB-06 | RF12 | CU8 | `GET /trabajos/mis` | ADMIN / DISENADOR | Usuario autenticado | Consultar trabajos propios | Lista de trabajos asociados al usuario | Captura |
| TP-TRAB-07 | RF13 | CU9 | `GET /trabajos/{id}` | ADMIN o participante | Trabajo existente | Consultar detalle de un trabajo permitido | Detalle completo del trabajo | Captura |
| TP-TRAB-08 | RNF8 | CU9 | `GET /trabajos/{id}` | DISENADOR no participante | Trabajo ajeno | Consultar detalle de trabajo sin participación | Acceso denegado | Captura |

### 9.3 Estados

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-EST-01 | RF8 / RF9 | CU10 | `PUT /trabajos/{id}/estado` | ADMIN | Trabajo existente | Cambiar estado de `CREADO` a `EN_PROGRESO` | Cambio aplicado correctamente | Captura |
| TP-EST-02 | RF8 / RF9 | CU10 | `PUT /trabajos/{id}/estado` | Participante | Trabajo asignado al usuario | Cambiar estado permitido | Cambio aplicado correctamente | Captura |
| TP-EST-03 | RNF8 | CU10 | `PUT /trabajos/{id}/estado` | DISENADOR no participante | Trabajo ajeno | Intentar cambiar el estado | Acceso denegado | Captura |
| TP-EST-04 | RF8 | CU10 | `PUT /trabajos/{id}/estado` | ADMIN / participante | Trabajo existente | Cambiar a `EN_REVISION` | Cambio aplicado | Captura |
| TP-EST-05 | RF8 | CU10 | `PUT /trabajos/{id}/estado` | ADMIN / participante | Trabajo existente | Cambiar a `ENTREGADO` | Cambio aplicado | Captura |
| TP-EST-06 | RF8 | CU10 | `PUT /trabajos/{id}/estado` | ADMIN | Trabajo existente | Cambiar a `CANCELADO` | Cambio aplicado | Captura |

### 9.4 Requisitos

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-REQ-01 | RF7 | CU6 | `POST /trabajos/{trabajoId}/requisitos` | ADMIN | Trabajo existente | Añadir un requisito al trabajo | Requisito creado | Captura |
| TP-REQ-02 | RF7 | CU6 | `GET /trabajos/{trabajoId}/requisitos` | ADMIN o participante | Trabajo existente | Consultar requisitos del trabajo | Lista de requisitos | Captura |
| TP-REQ-03 | RNF8 | CU6 | `POST /trabajos/{trabajoId}/requisitos` | DISENADOR | Token DISENADOR válido | Intentar crear requisito | Acceso denegado | Captura |

### 9.5 Comentarios

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-COM-01 | RF10 | CU11 | `POST /trabajos/{trabajoId}/comentarios` | ADMIN o participante | Trabajo accesible | Crear comentario | Comentario creado | Captura |
| TP-COM-02 | RF10 | CU11 | `GET /trabajos/{trabajoId}/comentarios` | ADMIN o participante | Existen comentarios o el trabajo es accesible | Consultar comentarios del trabajo | Lista ordenada por fecha ascendente | Captura |
| TP-COM-03 | RNF8 | CU11 | `POST /trabajos/{trabajoId}/comentarios` | DISENADOR no participante | Trabajo ajeno | Intentar comentar | Acceso denegado | Captura |

### 9.6 Historial

| ID | Requisito | CU | Endpoint / área | Rol | Precondición | Pasos resumidos | Resultado esperado | Evidencia |
|---|---|---|---|---|---|---|---|---|
| TP-HIST-01 | RF14 | CU12 | `GET /trabajos/{trabajoId}/historial` | ADMIN o participante | Trabajo accesible | Consultar historial del trabajo | Lista de cambios de estado | Captura |
| TP-HIST-02 | RNF8 | CU12 | `GET /trabajos/{trabajoId}/historial` | DISENADOR no participante | Trabajo ajeno | Intentar consultar historial | Acceso denegado | Captura |

---

## 10. Casos de prueba no funcionales

| ID | RNF | Qué se valida | Cómo se prueba | Resultado esperado | Evidencia |
|---|---|---|---|---|---|
| TP-NFR-01 | RNF1 | Interfaz clara y consistente | Revisar login, home, perfil y trabajos | Estilo coherente y navegación comprensible | Capturas |
| TP-NFR-02 | RNF2 | Navegación simple | Flujo login → home → perfil → logout | Flujo directo sin pasos innecesarios | Capturas / vídeo |
| TP-NFR-03 | RNF3 | Validación en formularios | Probar email vacío, email inválido y password vacía en login | Mensajes claros y sin crash | Captura |
| TP-NFR-04 | RNF4 | Rendimiento básico API | Medir tiempos en login, listar trabajos y comentarios | Tiempos aceptables en entorno local | Export de Postman |
| TP-NFR-05 | RNF5 | Eficiencia de consultas | Revisar consultas a trabajos, historial y comentarios | Comportamiento estable | Logs / observación |
| TP-NFR-06 | RNF6 | Seguridad JWT y protección de endpoints | Suite de pruebas sin token / token inválido / rol insuficiente | Accesos no autorizados bloqueados | Capturas |
| TP-NFR-07 | RNF7 | Almacenamiento seguro del token | Revisar uso de secure storage y cierre de sesión | Token persistido y eliminado al cerrar sesión | Capturas / revisión de código |
| TP-NFR-08 | RNF8 | Control de permisos por rol y pertenencia | Probar accesos a trabajos ajenos y acciones restringidas | Acceso denegado cuando corresponde | Capturas |
| TP-NFR-09 | RNF9 | Robustez transaccional | Revisar operaciones críticas de trabajo y cambio de estado | No quedan datos inconsistentes | Logs / test integración |
| TP-NFR-10 | RNF10 | Logging y manejo de errores | Provocar errores controlados y revisar logs | Errores visibles y trazables | Consola backend |
| TP-NFR-11 | RNF11 | Mantenibilidad | Revisar organización `controller/service/repository`, DTO y docs | Arquitectura clara y mantenible | Captura árbol del proyecto |
| TP-NFR-12 | RNF12 | Portabilidad backend | Levantar BD con Docker Compose y conectar backend | Arranque correcto | Captura terminal |
| TP-NFR-13 | RNF13 | Portabilidad frontend | Ejecutar app Android y generar APK | App funcional y build válida | Captura build |

---

## 11. Pruebas de interfaz Flutter

### 11.1 Pantalla de login

Validaciones observables en la implementación actual:

- Si email y contraseña están vacíos, muestra mensaje de error.
- Si el email tiene formato inválido, muestra mensaje específico.
- Si la contraseña está vacía, impide el envío.
- Evita doble submit mientras `_loading` es `true`.
- Limpia el error visual cuando el usuario vuelve a escribir.
- Al autenticarse correctamente, navega a `/home`.

### 11.2 Home

Comportamientos observables:

- Carga estadísticas con estado `loading`, `error` y `data`.
- Muestra saludo dinámico según usuario autenticado.
- Presenta tarjetas de conteo por estados: en progreso, en revisión, entregados, creados y cancelados.

### 11.3 Perfil

Comportamientos observables:

- Muestra nombre, email y rol.
- Distingue mensajes según rol `ADMIN` o `DISENADOR`.
- Muestra estadísticas personales.
- Permite cerrar sesión limpiando almacenamiento seguro y redirigiendo a `/login`.

### 11.4 Trabajos

Comportamientos observables en la versión actual:

- Pantalla funcional mínima con lectura del rol desde almacenamiento seguro.
- Útil como verificación de sesión y persistencia del rol.

---

## 12. Datos de prueba recomendados

Para ejecutar el plan conviene preparar estos datos mínimos:

- 1 usuario con rol `ADMIN`
- 1 usuario con rol `DISENADOR`
- 1 trabajo en estado `CREADO`
- 1 trabajo asignado al diseñador
- 1 trabajo no asignado al diseñador
- 1 comentario asociado a un trabajo
- 1 requisito asociado a un trabajo
- 1 o más entradas de historial tras cambios de estado

---

## 13. Riesgos detectados

- La calidad final de los resultados depende de contar con usuarios y trabajos semilla correctamente cargados.
- Algunas verificaciones, como tiempos exactos de respuesta o comportamiento transaccional, requieren ejecución real y no solo inspección de código.
- La pantalla `TrabajosScreen` aún está en versión mínima, por lo que parte de la validación funcional del módulo de trabajos se apoya sobre todo en la API.

---

## 14. Resultado esperado de la campaña de pruebas

La campaña debe demostrar que:

- El acceso está protegido por JWT.
- Los roles `ADMIN` y `DISENADOR` tienen permisos distintos.
- El diseñador solo puede operar sobre trabajos en los que participa.
- Los módulos de comentarios, historial y requisitos respetan el control de acceso.
- El frontend valida correctamente el login y gestiona la sesión.
- El proyecto puede ejecutarse de forma portable en entorno local con MariaDB y Flutter.

---

## 15. Conclusión

La versión actual del proyecto permite construir un plan de pruebas sólido y alineado con la implementación real. El backend presenta una estructura clara por controladores y reglas de seguridad declaradas con `@PreAuthorize`, mientras que el frontend ya cubre los flujos principales de acceso, visualización de estadísticas, perfil y persistencia de sesión.

La siguiente fase natural consiste en ejecutar cada caso, recoger evidencias reales y completar una tabla de resultados finales con capturas, tiempos y observaciones.
