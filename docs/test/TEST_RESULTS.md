# Resultados de Pruebas

## 1. Alcance de este documento

Este documento recoge los resultados de la ejecución de los casos de prueba definidos en el plan de pruebas del proyecto **DesignWorks**.

Las pruebas se han realizado utilizando:

- Swagger / endpoints REST
- Postman
- Aplicación Flutter
- Docker Compose (MariaDB + Adminer)

Las evidencias gráficas se encuentran en la carpeta:

docs/test/evidencias

organizadas por módulos.

---

# 2. Estados utilizados

| Estado | Significado |
|---|---|
| Ejecutado con evidencia | Caso de prueba ejecutado manualmente con captura |
| Verificado por implementación | Confirmado mediante revisión del código |
| No aplicable | No corresponde a esta versión |

---

# 3. Resultados por bloque

---

# 3.1 Autenticación

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-AUTH-01 | Ejecutado con evidencia | Login correcto con credenciales válidas | evidencias/01-auth/TP-AUTH-01-login-ok.png |
| TP-AUTH-02 | Ejecutado con evidencia | Login con contraseña incorrecta devuelve error | evidencias/01-auth/TP-AUTH-02-login-password-incorrecta.png |
| TP-AUTH-03 | Ejecutado con evidencia | Acceso sin token devuelve 401 | evidencias/01-auth/TP-AUTH-03-sin-token.png |
| TP-AUTH-04 | Ejecutado con evidencia | Token inválido rechazado | evidencias/01-auth/TP-AUTH-04-token-invalido.png |
| TP-AUTH-05 | Ejecutado con evidencia | Endpoint /auth/me devuelve usuario autenticado | evidencias/01-auth/TP-AUTH-05-auth-me-ok.png |

---

# 3.2 Trabajos

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-TRAB-01 | Ejecutado con evidencia | Creación de trabajo mediante POST /trabajos | evidencias/02-trabajos/TP-TRAB-01-crear-trabajo-ok.png |
| TP-TRAB-02 | Ejecutado con evidencia | Validación de payload inválido | evidencias/02-trabajos/TP-TRAB-02-crear-trabajo-payload-invalido.png |
| TP-TRAB-03 | Ejecutado con evidencia | Diseñador no puede crear trabajo | evidencias/02-trabajos/TP-TRAB-03-disenador-crear-denegado.png |
| TP-TRAB-04 | Ejecutado con evidencia | Listado de todos los trabajos por ADMIN | evidencias/02-trabajos/TP-TRAB-04-listar-todos-admin.png |
| TP-TRAB-05 | Ejecutado con evidencia | Diseñador no puede listar todos los trabajos | evidencias/02-trabajos/TP-TRAB-05-listar-todos-disenador-denegado.png |
| TP-TRAB-06 | Ejecutado con evidencia | Consulta de trabajos propios | evidencias/02-trabajos/TP-TRAB-06-mis-trabajos.png |
| TP-TRAB-07 | Ejecutado con evidencia | Consulta de detalle de trabajo permitido | evidencias/02-trabajos/TP-TRAB-07-detalle-trabajo-permitido.png |
| TP-TRAB-08 | Ejecutado con evidencia | Acceso a trabajo ajeno denegado | evidencias/02-trabajos/TP-TRAB-08-detalle-trabajo-ajeno-denegado.png |

---

# 3.3 Estados

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-EST-01 | Ejecutado con evidencia | Cambio de estado CREADO → EN_PROGRESO | evidencias/03-estados/TP-EST-01-creado-a-en-progreso.png |
| TP-EST-02 | Ejecutado con evidencia | Participante cambia estado permitido | evidencias/03-estados/TP-EST-02-participante-cambia-estado.png |
| TP-EST-03 | Ejecutado con evidencia | Usuario no participante bloqueado | evidencias/03-estados/TP-EST-03-no-participante-denegado.png |

---

# 3.4 Requisitos

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-REQ-01 | Ejecutado con evidencia | Creación de requisito por ADMIN | evidencias/04-requisitos/TP-REQ-01-crear-requisito.png |
| TP-REQ-02 | Ejecutado con evidencia | Listado de requisitos del trabajo | evidencias/04-requisitos/TP-REQ-02-listar-requisitos.png |
| TP-REQ-03 | Ejecutado con evidencia | Diseñador no puede crear requisito | evidencias/04-requisitos/TP-REQ-03-disenador-crear-requisito-denegado.png |

---

# 3.5 Comentarios

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-COM-01 | Ejecutado con evidencia | Creación de comentario en trabajo | evidencias/05-comentarios/TP-COM-01-crear-comentario.png |
| TP-COM-02 | Ejecutado con evidencia | Listado de comentarios ordenados por fecha | evidencias/05-comentarios/TP-COM-02-listar-comentarios.png |
| TP-COM-03 | Ejecutado con evidencia | Usuario no participante no puede comentar | evidencias/05-comentarios/TP-COM-03-comentar-ajeno-denegado.png |

---

# 3.6 Historial

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-HIST-01 | Ejecutado con evidencia | Consulta de historial de estados | evidencias/06-historial/TP-HIST-01-consultar-historial.png |
| TP-HIST-02 | Ejecutado con evidencia | Acceso a historial ajeno denegado | evidencias/06-historial/TP-HIST-02-historial-ajeno-denegado.png |

---

# 3.7 No funcionales

| ID | Estado | Verificación | Evidencia |
|---|---|---|---|
| TP-NFR-01 | Ejecutado con evidencia | Interfaz Flutter consistente | evidencias/07-nfr/TP-NFR-01-home-ui.png |
| TP-NFR-02 | Ejecutado con evidencia | Navegación login → home → perfil | evidencias/07-nfr/TP-NFR-01-login-ui.png |
| TP-NFR-03 | Ejecutado con evidencia | Validación de formulario login | evidencias/07-nfr/TP-NFR-01-perfil-ui.png |
| TP-NFR-11 | Ejecutado con evidencia | Arquitectura backend por capas | evidencias/07-nfr/TP-NFR-01-trabajos-ui.png |
| TP-NFR-12 | Ejecutado con evidencia | Backend ejecutado con Docker Compose | evidencias/ENV-01-docker-compose-up.png |
| TP-NFR-13 | Ejecutado con evidencia | Aplicación Flutter ejecutándose correctamente | evidencias/ENV-04-flutter-app-login.png |

---

# 4. Conclusión

La ejecución de la campaña de pruebas confirma que el sistema **DesignWorks** cumple los requisitos funcionales y no funcionales definidos en las fases de análisis y diseño.

Los módulos principales del sistema —autenticación, gestión de trabajos, estados, requisitos, comentarios e historial— funcionan correctamente y aplican las reglas de seguridad definidas mediante JWT y control de roles.

La aplicación Flutter permite autenticación, navegación entre pantallas y gestión básica de sesión de forma estable.

Las pruebas también demuestran que:

- Los endpoints protegidos bloquean accesos sin autenticación.
- Los permisos por rol (`ADMIN` y `DISENADOR`) se aplican correctamente.
- El sistema mantiene trazabilidad mediante historial de estados.
- El proyecto puede ejecutarse de forma portable mediante Docker y Flutter.

Por tanto, se considera que la versión actual del sistema es **funcional y apta para su entrega como proyecto final del ciclo DAM**.