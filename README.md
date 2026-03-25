# DesignWorks
> Sistema de gestión de trabajos para estudios de diseño gráfico

## 🎥 Video Demo

Se ha preparado una demostración completa del funcionamiento de la aplicación:

👉 [Ver video demo](https://drive.google.com/file/d/1q9Xe_oLDmNpsCgmnV3ms7Eq1vey68HV1/view)

⚠️ **Nota**: El acceso al video está restringido únicamente a cuentas de Gmail bajo el dominio de **Educación Navarra**.

ℹ️ **Información adicional**:  
Para testear la aplicación en local, se recomienda el uso de un **dispositivo físico conectado por cable USB** y con el **modo desarrollador activado**, tal y como se explica en detalle en la **[guía de configuración](https://github.com/Luixij/DesignWorks/blob/main/docs/SETUP.md)**.

En el video demo se muestra la ejecución mediante **depuración inalámbrica por WiFi**, como alternativa al uso de cable.

## 🟢 Estado del sistema

El sistema se encuentra **completamente funcional** y listo para la fase final de:

- testing automatizado
- documentación Swagger
- optimización final

Backend y frontend están completamente integrados y operativos.

[![Estado](https://img.shields.io/badge/Estado-Funcional-success)](https://github.com/tuusuario/designworks)
[![Backend](https://img.shields.io/badge/Backend-90%25-blue)](docs/STATUS.md)
[![Frontend](https://img.shields.io/badge/Frontend-85%25-success)](docs/STATUS.md)
[![Tests](https://img.shields.io/badge/Tests-50%25-yellow)](docs/STATUS.md)

## 📋 Descripción

**DesignWorks** es una aplicación full-stack que permite a estudios de diseño gráfico gestionar sus proyectos de forma centralizada. Incluye seguimiento de estados, asignación de equipos, comunicación interna y auditoría completa de cambios.

### Estado del Proyecto - Marzo 2026

**Entrega Intermedia (16 Feb)**: Backend y Frontend completamente funcionales  
**Entrega Final (27 Mar)**: Proyecto completo con tests y diseño final

**Progreso Global: 75%**

```
✅ Backend:           ██████████████████░░ 90% - FUNCIONAL + SWAGGER
✅ Frontend:          █████████████████░░░ 85% - FUNCIONAL
✅ UI/UX (Figma):     ████████████████████ 100% - COMPLETO
✅ UI Implementación: ████████████████████ 100% - COMPLETO
⚠️ Tests: ██████████░░░░░░░░░░ 50% - EN PROGRESO
```

## 🏗️ Arquitectura

```
┌──────────────────┐
│   Flutter App    │  ← Riverpod + GoRouter + Dio
│   (Android/iOS)  │
└────────┬─────────┘
         │ HTTP/REST + JWT
         ↓
┌────────────────────┐
│  Spring Boot API   │  ← Spring Security + JPA
│    (Java 17)       │
└────────┬───────────┘
         │ JPA/Hibernate
         ↓
┌────────────────────┐
│    MariaDB 11      │  ← 6 tablas + índices
└────────────────────┘
```

## 🚀 Quick Start

Actualmente, el proyecto **no está desplegado en producción**, ya que todavía no se ha contratado un VPS.  
Por este motivo, las pruebas y validaciones de la aplicación se realizan **en entorno local**.

### Entorno recomendado para pruebas

Para ejecutar correctamente el proyecto y disponer de toda la configuración necesaria, se recomienda seguir la **configuración detallada**, donde se explica el proceso completo paso a paso tanto para backend como para frontend, base de datos e infraestructura local.

### Configuración Detallada

Ver **[docs/SETUP.md](docs/SETUP.md)** para las instrucciones completas de instalación, configuración y puesta en marcha en local.

## 📁 Estructura del Proyecto

```
DesignWorks/
├── backend/              # API REST - Spring Boot
│   └── backend/
│       ├── src/main/java/
│       │   └── com/designworks/
│       │       ├── controllers/    ✅ Completo
│       │       ├── services/       ✅ Completo
│       │       ├── repositories/   ✅ Completo
│       │       ├── entities/       ✅ Completo
│       │       ├── security/       ✅ JWT implementado
│       │       └── dto/            ✅ Completo
│       └── pom.xml
│
├── frontend/             # App móvil - Flutter
│   ├── lib/
│   │   ├── core/              ✅ Completo
│   │   ├── data/models/       ✅ Completo
│   │   ├── features/
│   │   │   ├── auth/          ✅ Completo
│   │   │   ├── trabajos/      ✅ Completo
│   │   │   ├── home/          ✅ Completo
│   │   │   └── perfil/        ✅ Completo
│   │   └── main.dart
│   └── pubspec.yaml
│
├── infra/                # Docker + Scripts
│   ├── docker-compose.yml
│   ├── sql/init.sql
│   └── .env
│
└── docs/                 # Documentación
    ├── SETUP.md                    # Configuración
    ├── DEVELOPMENT.md              # Guía de desarrollo
    ├── STATUS.md                   # Estado actual
    ├── ARCHITECTURE.md             # Arquitectura
    ├── DATABASE.md                 # Diseño de BD
    ├── API.md                      # Endpoints REST
    │
    ├── fase/                       # Documentación de fases
    │   ├── imaicela_*_ANALISIS.pdf # Fase análisis
    │   └── imaicela_*_DISENO.pdf   # Fase diseño
    │
    ├── entregables/                # Entregables finales
    │   ├── *_MEMORIA.pdf
    │   ├── *_MANUAL_USO.pdf
    │   └── *_PLAN_PRUEBAS.pdf
    │
    └── test/                       # Documentación de testing
        ├── TESTING.md
        ├── TEST_RESULTS.md
        ├── TRAZABILIDAD.md
        └── evidencias/
```

## 📚 Documentación

### Guías Técnicas
- **[📖 Guía de Configuración](docs/SETUP.md)** - Instalación y setup completo
- **[💻 Guía de Desarrollo](docs/DEVELOPMENT.md)** - Estándares y convenciones
- **[📊 Estado del Proyecto](docs/STATUS.md)** - Progreso detallado y objetivos
- **[🏛️ Arquitectura del Sistema](docs/ARCHITECTURE.md)** - Diseño técnico completo
- **[🗄️ Base de Datos](docs/DATABASE.md)** - Esquema y modelos
- **[🔌 API REST](docs/API.md)** - Endpoints y ejemplos

### Documentos de Fase
- [📄 Fase de Análisis (PDF)](docs/fase/imaicela_jaramillo_luis_PROYECTO_DAM_FASE_ANALISIS.pdf)
- [📄 Fase de Diseño (PDF)](docs/fase/imaicela_jaramillo_luis_PROYECTO_DAM_FASE_DISENO.pdf)

### 📄 Entregables Finales
- [📘 Memoria](docs/entregables/imaicela_jaramillo_luis_PROYECTO_DAM_MEMORIA.pdf)
- [📗 Manual de Uso](docs/entregables/imaicela_jaramillo_luis_PROYECTO_DAM_MANUAL_USO.pdf)
- [🧪 Plan de Pruebas](docs/entregables/imaicela_jaramillo_luis_PROYECTO_DAM_PLAN_PRUEBAS.pdf)

### Diseño y Prototipo
- **[🎨 Prototipo en Figma](https://www.figma.com/proto/5QfdQWsQ9NVGnyYWs5vkfv/DESIGNWORKS?page-id=0%3A1&node-id=1-3&viewport=474%2C252%2C0.63&t=mKCYhBM2FJWI9Tbb-1&scaling=scale-down&content-scaling=fixed&starting-point-node-id=1%3A3)** - Diseño interactivo de la aplicación

## ✨ Funcionalidades Implementadas

### ✅ Backend (Completamente Funcional)
- [x] Autenticación JWT con roles (ADMIN, DISEÑADOR)
- [x] CRUD completo de trabajos
- [x] Sistema de participantes en trabajos
- [x] Comentarios en trabajos
- [x] Requisitos de clientes
- [x] Historial de cambios de estado (auditoría)
- [x] Validación de transiciones de estado
- [x] Control de acceso basado en roles
- [x] Manejo centralizado de errores

### ✅ Frontend (Completamente Funcional)
- [x] Login con validación y JWT
- [x] Lista de todos los trabajos (ADMIN)
- [x] "Mis trabajos" (trabajos asignados)
- [x] Detalle completo de trabajo
- [x] Cambio de estado con validación
- [x] Sistema de comentarios
- [x] Visualización de requisitos
- [x] Historial de cambios
- [x] Navegación completa
- [x] Gestión de estado global (Riverpod)
- [x] Almacenamiento seguro de tokens
- [x] Crear nuevo trabajo (solo ADMIN)
- [x] Control de visibilidad por rol en tiempo real
- [x] Barra de navegación fija con teclado
- [x] Diálogo de confirmación al salir sin guardar

### 🔄 En Desarrollo
- Tests unitarios e integración
- Animaciones y transiciones

### ⏳ Pendiente (Entrega Final)
- [ ] Tests unitarios e integración
- [ ] Optimizaciones de rendimiento

## 🎯 Roles del Sistema

### 👨‍💼 Administrador
- Crear, editar y cancelar trabajos
- Asignar diseñadores a proyectos
- Ver todos los trabajos del sistema
- Cambiar estados de cualquier trabajo
- Definir requisitos del cliente

### 👨‍🎨 Diseñador
- Ver trabajos asignados
- Añadir comentarios
- Cambiar estado de sus trabajos
- Consultar requisitos y detalles
- Ver historial de cambios

## 🔒 Seguridad

- ✅ Autenticación JWT
- ✅ Control de acceso basado en roles (RBAC)
- ✅ Contraseñas hasheadas con BCrypt
- ✅ Tokens almacenados de forma segura (flutter_secure_storage)
- ✅ Validación de permisos en cada endpoint
- ✅ CORS configurado

## 🧪 Testing

**Estado actual**: Pendiente para entrega final

```bash
# Backend (cuando esté implementado)
cd backend
./mvnw test

# Frontend (cuando esté implementado)
cd frontend
flutter test
```

**Objetivo**: Cobertura mínima del 60%

## 📦 Tecnologías Principales

### Backend
- **Framework**: Spring Boot 3.3.1
- **Lenguaje**: Java 17
- **Base de Datos**: MariaDB 11
- **Seguridad**: Spring Security + JWT (jjwt 0.12.5)
- **ORM**: Spring Data JPA
- **Build**: Maven

### Frontend
- **Framework**: Flutter 3.7+
- **Lenguaje**: Dart 3.7+
- **State Management**: Riverpod 2.5.1
- **Navegación**: GoRouter 14.2.0
- **HTTP**: Dio 5.4.0
- **Storage**: flutter_secure_storage 9.2.2

### Infraestructura
- **Contenedores**: Docker + Docker Compose
- **Gestor BD**: Adminer (web)
- **Control versiones**: Git

## 🌐 URLs de Desarrollo

| Servicio | macOS | Windows |
|----------|-------|---------|
| Backend API | http://localhost:8080 | http://localhost:8082 |
| **Swagger UI** | **http://localhost:8080/swagger-ui/index.html** | **http://localhost:8082/swagger-ui/index.html** |
| Adminer (BD) | http://localhost:8081 | http://localhost:8081 |

### Credenciales de Desarrollo

**Base de Datos:**
- Usuario: `dsing_user`
- Contraseña: `FcfR_El21`
- BD: `design_works`

**Usuario Administrador:**
- Email: `admin@designworks.com`
- Contraseña: `Admin1234!`

**Usuarios Diseñadores:**
- Email: `marta@designworks.com`, `carlos@designworks.com`, etc.
- Contraseña: `Design1234!`

## 📅 Cronograma

| Fase | Fecha | Estado |
|------|-------|--------|
| Propuesta inicial | 1-24 Oct 2025 | ✅ Completado |
| Aceptación | 25-29 Oct 2025 | ✅ Completado |
| Fase de análisis | 30 Oct - 15 Dic 2025 | ✅ Completado |
| Fase de diseño | 16 Dic - 29 Ene 2026 | ✅ Completado |
| **Entrega intermedia** | **16 Feb 2026** | ✅ Completado |
| Desarrollo avanzado | 17 Feb - 26 Mar 2026 | ✅ Completado |
| **Entrega final** | **27 Mar 2026** | ⏳ Pendiente |
| Validación | 1-3 Abr 2026 | ⏳ Pendiente |
| Defensa | 7-16 Abr 2026 | ⏳ Pendiente |

## 👨‍💻 Autor

**Luis Imaicela**  
Proyecto Final - Desarrollo de Aplicaciones Multiplataforma (DAM)  
Curso 2025/2026

**Tutor**: Santiago Roman Viguera

## 📞 Contacto

- 🌐 Web: [luisimaicela.com](https://luisimaicela.com)
- 📧 Email: limaicejar@educacion.navarra.es

## 📄 Licencia

Este proyecto es un trabajo académico desarrollado para el módulo de Proyecto Final del ciclo DAM.

---

**Última actualización**: 25 de marzo de 2026  
**Versión**: 1.0 (Entrega Final)