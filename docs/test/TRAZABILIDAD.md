# Matriz de Trazabilidad

## 1. Objetivo

Esta matriz relaciona los requisitos funcionales y no funcionales del proyecto con los casos de uso, endpoints implementados y casos de prueba definidos en el plan de pruebas.

Se ha elaborado a partir de la implementación real disponible en el proyecto, por lo que solo se incluyen relaciones verificables con el código actual.

---

## 2. Requisitos funcionales

| Req | Descripción | CU | Endpoint / módulo | Tests asociados |
|---|---|---|---|---|
| RF1 | Iniciar sesión mediante JWT | CU1 | `POST /auth/login`, `GET /auth/me` | TP-AUTH-01, TP-AUTH-02, TP-AUTH-03, TP-AUTH-04, TP-AUTH-05 |
| RF4 | Crear trabajo | CU3 | `POST /trabajos` | TP-TRAB-01, TP-TRAB-02, TP-TRAB-03 |
| RF7 | Definir requisitos del trabajo | CU6 | `POST /trabajos/{trabajoId}/requisitos`, `GET /trabajos/{trabajoId}/requisitos` | TP-REQ-01, TP-REQ-02, TP-REQ-03 |
| RF8 | Gestionar estados del trabajo | CU10 | `PUT /trabajos/{id}/estado` | TP-EST-01, TP-EST-02, TP-EST-03, TP-EST-04, TP-EST-05, TP-EST-06 |
| RF9 | Cambiar estado con control de permisos y trazabilidad | CU10 | `PUT /trabajos/{id}/estado`, `GET /trabajos/{trabajoId}/historial` | TP-EST-01, TP-EST-02, TP-HIST-01 |
| RF10 | Gestionar comentarios del trabajo | CU11 | `POST /trabajos/{trabajoId}/comentarios`, `GET /trabajos/{trabajoId}/comentarios` | TP-COM-01, TP-COM-02, TP-COM-03 |
| RF11 | Vista general de trabajos | CU7 | `GET /trabajos` | TP-TRAB-04, TP-TRAB-05 |
| RF12 | Vista de trabajos propios | CU8 | `GET /trabajos/mis` | TP-TRAB-06 |
| RF13 | Consultar detalle de trabajo | CU9 | `GET /trabajos/{id}` | TP-TRAB-07, TP-TRAB-08 |
| RF14 | Consultar historial del trabajo | CU12 | `GET /trabajos/{trabajoId}/historial` | TP-HIST-01, TP-HIST-02 |

---

## 3. Requisitos no funcionales

| RNF | Descripción | Ámbito | Tests asociados |
|---|---|---|---|
| RNF1 | UI clara y consistente | Flutter | TP-NFR-01 |
| RNF2 | Navegación simple y directa | Flutter | TP-NFR-02 |
| RNF3 | Validación de formularios y mensajes claros | Flutter + API | TP-NFR-03, TP-TRAB-02 |
| RNF4 | Rendimiento aceptable en operaciones comunes | API | TP-NFR-04 |
| RNF5 | Eficiencia básica de consultas | BD + API | TP-NFR-05 |
| RNF6 | Seguridad JWT y protección de endpoints | API | TP-AUTH-03, TP-AUTH-04, TP-AUTH-05, TP-NFR-06 |
| RNF7 | Persistencia segura del token | Flutter | TP-NFR-07 |
| RNF8 | Control de permisos por rol y pertenencia | API + Flutter | TP-TRAB-03, TP-TRAB-05, TP-TRAB-08, TP-REQ-03, TP-COM-03, TP-HIST-02, TP-EST-03, TP-NFR-08 |
| RNF9 | Robustez transaccional | API | TP-NFR-09 |
| RNF10 | Logging y tratamiento de errores | API | TP-NFR-10 |
| RNF11 | Arquitectura mantenible por capas | Backend + repo | TP-NFR-11 |
| RNF12 | Portabilidad backend con Docker | Infraestructura | TP-NFR-12 |
| RNF13 | Portabilidad frontend Flutter | Frontend | TP-NFR-13 |

---

## 4. Trazabilidad por endpoint

| Endpoint | Función | Permisos | Requisitos relacionados | Tests asociados |
|---|---|---|---|---|
| `POST /auth/login` | Autenticar usuario | Público | RF1, RNF6 | TP-AUTH-01, TP-AUTH-02 |
| `GET /auth/me` | Obtener usuario autenticado | Token válido | RF1, RNF6 | TP-AUTH-03, TP-AUTH-04, TP-AUTH-05 |
| `POST /trabajos` | Crear trabajo | `ADMIN` | RF4, RNF8 | TP-TRAB-01, TP-TRAB-02, TP-TRAB-03 |
| `GET /trabajos` | Listar todos los trabajos | `ADMIN` | RF11, RNF8 | TP-TRAB-04, TP-TRAB-05 |
| `GET /trabajos/mis` | Listar trabajos del usuario | `ADMIN`, `DISENADOR` | RF12 | TP-TRAB-06 |
| `GET /trabajos/{id}` | Ver detalle del trabajo | `ADMIN` o participante | RF13, RNF8 | TP-TRAB-07, TP-TRAB-08 |
| `PUT /trabajos/{id}/estado` | Cambiar estado | `ADMIN` o participante | RF8, RF9, RNF8 | TP-EST-01, TP-EST-02, TP-EST-03, TP-EST-04, TP-EST-05, TP-EST-06 |
| `POST /trabajos/{trabajoId}/requisitos` | Crear requisito | `ADMIN` | RF7, RNF8 | TP-REQ-01, TP-REQ-03 |
| `GET /trabajos/{trabajoId}/requisitos` | Listar requisitos | `ADMIN` o participante | RF7 | TP-REQ-02 |
| `POST /trabajos/{trabajoId}/comentarios` | Crear comentario | `ADMIN` o participante | RF10, RNF8 | TP-COM-01, TP-COM-03 |
| `GET /trabajos/{trabajoId}/comentarios` | Listar comentarios | `ADMIN` o participante | RF10 | TP-COM-02 |
| `GET /trabajos/{trabajoId}/historial` | Consultar historial | `ADMIN` o participante | RF14, RF9, RNF8 | TP-HIST-01, TP-HIST-02 |

---

## 5. Trazabilidad por pantalla Flutter

| Pantalla | Función principal | Requisitos asociados | Tests relacionados |
|---|---|---|---|
| `LoginScreen` | Inicio de sesión y validación local | RF1, RNF1, RNF2, RNF3, RNF7 | TP-AUTH-01, TP-AUTH-02, TP-NFR-01, TP-NFR-02, TP-NFR-03, TP-NFR-07 |
| `HomeScreen` | Visualización de estadísticas y saludo contextual | RNF1, RNF2 | TP-NFR-01, TP-NFR-02 |
| `PerfilScreen` | Datos del usuario, rol, estadísticas y logout | RF1, RNF1, RNF2, RNF7 | TP-AUTH-05, TP-NFR-01, TP-NFR-02, TP-NFR-07 |
| `TrabajosScreen` | Verificación básica de sesión/rol | RNF1, RNF7 | TP-NFR-01, TP-NFR-07 |

---

## 6. Observaciones

1. Esta matriz refleja la implementación actual del proyecto, no funcionalidades futuras no presentes en el código.
2. No se han incluido endpoints de edición completa de trabajo, borrado, recuperación de contraseña o gestión dedicada de participantes porque no han quedado confirmados en los archivos revisados.
3. Si se amplía el backend, esta matriz debe actualizarse junto con el plan de pruebas.
