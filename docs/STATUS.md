# Estado del Proyecto - DesignWorks
## Entrega Intermedia

**Fecha**: 9 de Febrero de 2026  
**Fase Actual**: Desarrollo Avanzado (Backend Funcional + Frontend Funcional)  
**Entrega Intermedia**: 16 de Febrero de 2026  
**Entrega Final**: 27 de Marzo de 2026

---

## 📊 Resumen Ejecutivo

El proyecto **DesignWorks** se encuentra en la fase de desarrollo inicial, habiendo completado satisfactoriamente las fases de análisis y diseño. La infraestructura base está configurada y operativa, y se está avanzando en la implementación tanto del backend (Spring Boot) como del frontend (Flutter).

### Progreso Global: ~75%

```
Análisis       ████████████████████ 100%
Diseño         ████████████████████ 100%
Infraestructura ███████████████████░  95%
Backend        ████████████████░░░░  80%
Frontend       ███████████████░░░░░  75%
Tests          ░░░░░░░░░░░░░░░░░░░░   0%
UI/UX Final    ████████████████░░░░  80% (Figma completo, falta implementación)
```

---

## ✅ Completado

### 📝 Documentación (100%)

#### Fase de Análisis
- [x] Análisis de requerimientos funcionales (RF1-RF14)
- [x] Requerimientos no funcionales (RNF1-RNF13)
- [x] Identificación de roles (Administrador, Diseñador)
- [x] Elaboración de casos de uso UML (CU1-CU12)
- [x] Diagramas de casos de uso

**Entregable**: `docs/imaicela_jaramillo_luis_PROYECTO_DAM_FASE_ANALISIS.pdf`

#### Fase de Diseño
- [x] Diagrama de arquitectura del sistema (3 capas)
- [x] Diseño de base de datos:
  - Modelo Entidad-Relación
  - Modelo relacional (6 tablas principales)
  - Especificación de tipos de datos
- [x] Diagramas UML:
  - Diagrama de clases (dominio, servicios, controladores)
  - Diagramas de secuencia (CU3, CU10, CU11)
  - Diagrama de estados del trabajo
- [x] Definición de endpoints REST (Swagger preliminar)
- [x] Wireframes iniciales
- [x] Matriz de permisos y seguridad JWT

**Entregable**: `docs/imaicela_jaramillo_luis_PROYECTO_DAM_FASE_DISENO.pdf`

---

### 🐳 Infraestructura (75%)

#### Docker & Base de Datos
- [x] Docker Compose configurado
  - Servicio MariaDB en puerto 3306
  - Servicio Adminer en puerto 8081
- [x] Script de inicialización de BD (`init.sql`)
  - Creación de tablas
  - Relaciones y claves foráneas
  - Índices optimizados
- [x] Variables de entorno configuradas (`.env`)
- [x] Gestor de BD web (Adminer) funcional

**Acceso a Adminer**: http://localhost:8081
- Servidor: `mariadb`
- Usuario: `dsing_user`
- Contraseña: `FcfR_El21`
- Base de datos: `design_works`

#### Pendiente en Infraestructura
- [ ] Scripts de backup automatizado
- [ ] Configuración de CI/CD
- [ ] Dockerfile para el backend
- [ ] Dockerfile para el frontend (APK build)

---

### ⚙️ Backend - Spring Boot (80% - FUNCIONAL)

#### Estructura del Proyecto
- [x] Proyecto Maven inicializado
- [x] Configuración de `pom.xml` con dependencias:
  - Spring Boot 3.x
  - Spring Security
  - Spring Data JPA
  - MariaDB Connector
  - JWT (jjwt)
  - Lombok
  - Validation
- [x] Estructura de paquetes organizada:
  ```
  com.designworks/
  ├── config/
  ├── security/
  ├── controllers/
  ├── services/
  ├── repositories/
  ├── entities/
  ├── dto/
  └── exceptions/
  ```

#### Entidades JPA
- [x] `Usuario` - Mapeado y validado
- [x] `Trabajo` - Mapeado con relaciones
- [x] `Comentario` - Mapeado
- [x] `Requisito` - Mapeado
- [x] `TrabajoParticipante` - Relación N:M resuelta
- [x] `HistorialEstado` - Mapeado para auditoría

#### Configuración
- [x] `application.properties` configurado
  - Conexión a MariaDB via variables de entorno
  - JPA/Hibernate configurado
  - Logging configurado
- [x] Perfiles de ejecución (local, dev)

#### Repositorios JPA (100%)
- [x] `UsuarioRepository`
- [x] `TrabajoRepository`
- [x] `ComentarioRepository`
- [x] `RequisitoRepository`
- [x] `HistorialEstadoRepository`
- [x] `TrabajoParticipanteRepository`

#### Servicios de Negocio (100%)
- [x] `AuthService` - Login y autenticación
- [x] `TrabajoService` - CRUD completo + validaciones
- [x] `ComentarioService` - Gestión de comentarios
- [x] `HistorialService` - Registro de cambios de estado
- [x] `RequisitoService` - Gestión de requisitos

#### Spring Security + JWT (100% - IMPLEMENTADO)
- [x] Configuración de Spring Security
- [x] Generación de tokens JWT
- [x] Validación de tokens
- [x] Filtro de autenticación (`JwtAuthFilter`)
- [x] Control de acceso basado en roles (`@PreAuthorize`)

#### Controllers REST (100% - FUNCIONALES)
- [x] `AuthController` (`POST /auth/login`)
- [x] `TrabajoController` (`/trabajos/*`)
  - [x] GET /trabajos (listar todos)
  - [x] GET /trabajos/mis (trabajos del usuario)
  - [x] GET /trabajos/{id} (detalle)
  - [x] POST /trabajos (crear)
  - [x] PUT /trabajos/{id} (actualizar)
  - [x] PUT /trabajos/{id}/estado (cambiar estado)
- [x] `ComentarioController` (`/trabajos/{id}/comentarios`)
- [x] `HistorialController` (`/historial/{trabajoId}`)
- [x] `RequisitoController` (`/trabajos/{id}/requisitos`)

#### DTOs (Request/Response) (100%)
- [x] LoginRequest / LoginResponse
- [x] TrabajoCreateRequest / TrabajoResponse
- [x] ComentarioCreateRequest / ComentarioResponse
- [x] RequisitoCreateRequest / RequisitoResponse
- [x] HistorialEstadoResponse
- [x] UsuarioBasicResponse

#### Validaciones y Manejo de Errores (100%)
- [x] Validaciones con `@Valid`
- [x] Manejo global de excepciones (`@ControllerAdvice`)
- [x] Excepciones personalizadas:
  - [x] `ResourceNotFoundException`
  - [x] `UnauthorizedException`
  - [x] `InvalidOperationException`
- [x] Validación de transiciones de estado

#### Pendiente
- [ ] Documentación Swagger/OpenAPI
- [ ] Tests unitarios (servicios)
- [ ] Tests de integración (endpoints)
- [ ] Optimizaciones adicionales (paginación, cache)

**Estado**: ✅ **BACKEND FUNCIONAL** - Todas las funcionalidades core implementadas y probadas

**Puerto de Ejecución**:
- macOS: `http://localhost:8080`
- Windows: `http://localhost:8082`

---

### 📱 Frontend - Flutter (75% - FUNCIONAL)

#### Estructura del Proyecto
- [x] Proyecto Flutter inicializado
- [x] Configuración de `pubspec.yaml` con dependencias:
  - `dio` (cliente HTTP)
  - `flutter_riverpod` (gestión de estado)
  - `flutter_secure_storage` (almacenamiento seguro)
  - `go_router` (navegación)
  - `intl` (formateo de fechas)
  - `json_serializable` (serialización JSON)
- [x] Estructura de carpetas completa:
  ```
  lib/
  ├── core/
  │   ├── config/
  │   ├── network/
  │   └── storage/
  ├── data/
  │   └── models/
  ├── features/
  │   ├── auth/
  │   ├── trabajos/
  │   ├── home/
  │   └── perfil/
  └── main.dart
  ```

#### Configuración
- [x] Inyección de `API_BASE_URL` via `--dart-define`
- [x] Configuración para emulador Android (`10.0.2.2`)
- [x] Configuración para dispositivo físico (USB y WiFi)
- [x] ADB reverse configurado para desarrollo
- [x] Cliente Dio configurado con interceptores

#### Modelos de Datos (100%)
- [x] `Usuario` - Con serialización JSON
- [x] `Trabajo` - Con serialización JSON
- [x] `Comentario` - Con serialización JSON
- [x] `Requisito` - Con serialización JSON
- [x] `HistorialEstado` - Con serialización JSON
- [x] `LoginRequest` / `LoginResponse`
- [x] Todos los modelos con `fromJson` y `toJson`

#### Servicios (100%)
- [x] `ApiClient` - Cliente HTTP base con Dio
- [x] `AuthService` - Login y gestión de tokens
- [x] `TrabajoService` - CRUD completo de trabajos
- [x] `ComentarioService` - Gestión de comentarios
- [x] `RequisitoService` - Gestión de requisitos
- [x] `HistorialService` - Consulta de historial
- [x] `SecureStorageService` - Almacenamiento de tokens JWT
- [x] Interceptores HTTP para inyección automática de tokens
- [x] Manejo de errores de red centralizado

#### Providers (Riverpod) (100%)
- [x] `authProvider` - Estado de autenticación
- [x] `trabajosProvider` - Lista de trabajos
- [x] `misTrabajosProvider` - Trabajos del usuario
- [x] `trabajoDetailProvider` - Detalle de trabajo específico
- [x] `comentariosProvider` - Comentarios de un trabajo
- [x] Gestión de estados (loading, data, error)

#### Pantallas/Widgets (100% - Funcionales)
- [x] `LoginScreen` - Completa y funcional
  - [x] Formulario de email y contraseña
  - [x] Validaciones
  - [x] Integración con API
  - [x] Manejo de estados (loading, error, success)
  - [x] Navegación post-login
- [x] `HomeScreen` - Dashboard principal
- [x] `TrabajosListScreen` - Lista de todos los trabajos (ADMIN)
- [x] `MisTrabajosScreen` - Trabajos asignados (DISEÑADOR)
- [x] `TrabajoDetailScreen` - Detalle completo
  - [x] Información del trabajo
  - [x] Lista de participantes
  - [x] Requisitos
  - [x] Comentarios
  - [x] Cambio de estado
- [x] `ComentarioDialog` - Añadir comentarios
- [x] `CambiarEstadoDialog` - Cambiar estado del trabajo
- [x] `PerfilScreen` - Perfil de usuario y logout

#### Navegación (100%)
- [x] Rutas definidas con GoRouter
- [x] Navegación entre pantallas
- [x] Guards de autenticación
- [x] Deep linking preparado
- [x] Redirección post-login

#### UI/UX
- [x] **Diseño en Figma** - ✅ 100% COMPLETO
  - [x] Wireframes de alta fidelidad
  - [x] Sistema de diseño (colores, tipografías, componentes)
  - [x] Todas las pantallas diseñadas
  - [x] Flujos de interacción definidos
  - [x] Responsive design considerado
- [~] **Implementación en Flutter** - 🔄 60% COMPLETADO
  - [x] Estructura básica de todas las pantallas
  - [x] Funcionalidad completa
  - [x] Material Design 3 básico
  - [ ] Diseño final de Figma adaptado completamente
  - [ ] Animaciones y transiciones suaves
  - [ ] Micro-interacciones
  - [ ] Polish final de UI

#### Widgets Reutilizables
- [x] `CustomTextField` - Input personalizado
- [x] `CustomButton` - Botón personalizado
- [x] `TrabajoCard` - Tarjeta de trabajo
- [x] `LoadingIndicator` - Indicador de carga
- [x] `ErrorWidget` - Widget de error
- [x] `EmptyStateWidget` - Estado vacío

#### Pendiente
- [ ] Implementar diseño final de Figma (estimado: 2 semanas)
- [ ] Tests de widgets
- [ ] Tests de integración
- [ ] Animaciones avanzadas
- [ ] Optimización de rendimiento

**Estado**: ✅ **FRONTEND FUNCIONAL** - Todas las funcionalidades implementadas, falta aplicar diseño final de Figma

---

## 🔄 En Progreso Activo

### Backend
1. **Documentación Swagger/OpenAPI** (Prioridad: Media)
   - Configuración de Springdoc
   - Anotaciones en controllers
   - Generación de documentación interactiva

### Frontend
1. **Implementación de diseño final de Figma** (Prioridad: Alta)
   - Adaptar todas las pantallas al diseño definitivo
   - Aplicar sistema de colores y tipografías
   - Implementar componentes personalizados
   - Añadir animaciones y transiciones


### Testing (Prioridad: Alta para entrega final)
- Tests unitarios del backend
- Tests de integración de endpoints
- Tests de widgets en Flutter

---

## ⏳ Pendiente (Para Entrega Final - 27 de Marzo)

### Testing (CRÍTICO)
- [ ] Tests unitarios del backend (servicios, repositorios)
- [ ] Tests de integración (endpoints completos)
- [ ] Tests de widgets en Flutter
- [ ] Cobertura mínima: 60%

### UI/UX (ALTA PRIORIDAD)
- [ ] Implementar diseño completo de Figma en todas las pantallas
- [ ] Animaciones y transiciones entre pantallas
- [ ] Micro-interacciones y feedback visual
- [ ] Polish final de la experiencia de usuario

### Documentación
- [ ] Swagger/OpenAPI completo y funcional
- [ ] README actualizado con ejemplos de uso
- [ ] Guías de usuario final (opcional)
- [ ] Video demo de la aplicación (opcional)

### Optimizaciones
- [ ] Paginación en listados largos
- [ ] Cache de datos en Flutter
- [ ] Optimización de consultas SQL
- [ ] Manejo de imágenes/archivos (si se implementa)

---

## 🐛 Issues Conocidos

| ID | Descripción | Severidad | Estado | Asignado |
|----|-------------|-----------|--------|----------|
| #001 | JWT no implementa refresh token | Baja | Pendiente (mejora futura) | Backend |
| #002 | Puertos diferentes en macOS (8080) y Windows (8082) | Baja | Documentado | Infra |
| #003 | Falta implementar diseño final de Figma en Flutter | Media | En progreso | Frontend |
| #004 | Sin tests automatizados | Alta | Pendiente para entrega final | Ambos |
| #005 | Falta documentación Swagger | Media | Pendiente | Backend |

---

## 📈 Métricas de Progreso

### Código
- **Backend**:
  - Líneas de código: ~4,500
  - Clases Java: 45+
  - Endpoints funcionales: 15
  - Cobertura de tests: 0% (pendiente)

- **Frontend**:
  - Líneas de código: ~3,200
  - Widgets: 25+
  - Pantallas: 8
  - Modelos de datos: 10+
  - Cobertura de tests: 0% (pendiente)

### Base de Datos
- Tablas creadas: 6/6 (100%)
- Datos de prueba: 5 usuarios, 6 trabajos, 14 participantes, 6 comentarios
- Registros de prueba: Dataset completo y funcional

### Funcionalidades Implementadas
- ✅ Autenticación completa con JWT
- ✅ CRUD de trabajos
- ✅ Sistema de participantes
- ✅ Comentarios en trabajos
- ✅ Requisitos de trabajos
- ✅ Historial de estados completo
- ✅ Validación de transiciones de estado
- ✅ Control de acceso por roles

---

## 🎯 Objetivos y Cronograma

### Entrega Intermedia (16 de Febrero 2026) ✅

**Estado actual del proyecto:**
1. ✅ Backend completamente funcional
   - Todos los endpoints implementados
   - JWT Security funcionando
   - Validaciones y manejo de errores
2. ✅ Frontend completamente funcional
   - Todas las pantallas implementadas
   - Integración completa con backend
   - Navegación y estado global
3. ✅ Diseño UI/UX en Figma completo
4. ✅ Base de datos con datos de prueba
5. ❌ Tests (pendiente para entrega final)
6. ❌ Swagger (pendiente)
7. ❌ Diseño final de Figma implementado en Flutter (60% completado)

### Entrega Final (27 de Marzo 2026) 🎯

**Objetivos críticos:**
1. ✅ **Testing completo**
   - Tests unitarios backend (60% cobertura mínimo)
   - Tests de integración
   - Tests de widgets Flutter
2. ✅ **UI/UX final**
   - Diseño de Figma 100% implementado
   - Animaciones y transiciones
   - Modo oscuro
   - Polish y refinamiento
3. ✅ **Documentación técnica**
   - Swagger/OpenAPI funcional
   - Documentación de usuario
   - Video demo (opcional)
4. ✅ **Optimizaciones**
   - Performance
   - Manejo de errores mejorado
   - Experiencia de usuario pulida

**Planificación:**
- **Semana 1-2 (17 Feb - 2 Mar)**: Implementar diseño de Figma + Animaciones
- **Semana 3-4 (3 Mar - 16 Mar)**: Testing completo (backend y frontend)
- **Semana 5-6 (17 Mar - 27 Mar)**: Swagger, optimizaciones, documentación final

---

## 📝 Notas Adicionales

### Decisiones Técnicas Tomadas
1. **Riverpod sobre Provider**: Mejor manejo de estado y más moderno
2. **GoRouter sobre Navigator**: Navegación declarativa y type-safe
3. **Dio sobre http**: Interceptores, mejor manejo de errores
4. **JWT sin refresh token inicialmente**: Para simplicidad, se añadirá después de la entrega final
5. **Diseño en Figma primero**: Asegurar coherencia visual antes de implementar

### Logros Destacados
- ✅ Sistema de autenticación robusto con JWT
- ✅ Validación completa de transiciones de estado
- ✅ Historial de auditoría completo
- ✅ Sistema de permisos por roles funcionando correctamente
- ✅ Integración frontend-backend sin problemas
- ✅ Diseño UI/UX profesional completado en Figma

### Próximos Desafíos
1. **Testing**: Implementar suite completa de tests (nunca hecho antes en Flutter)
2. **Animaciones**: Crear transiciones suaves y profesionales
3. **Performance**: Optimizar carga de datos y renderizado
4. **Documentación Swagger**: Aprender a configurar y anotar correctamente

### Lecciones Aprendidas
- La documentación previa (análisis y diseño) fue fundamental para el desarrollo
- Trabajar con Figma antes de codificar ahorra mucho tiempo
- Docker Compose simplifica enormemente el desarrollo
- La separación en capas (controller, service, repository) facilita el mantenimiento
- Riverpod requiere curva de aprendizaje pero vale la pena

---

## 🔄 Sincronización del Equipo (1 persona, 2 equipos)

### Repositorio Git
- **Último commit**: [Fecha del último commit]
- **Branch actual**: `main`
- **Commits totales**: ~25

### Configuración Multi-Equipo
- **Mac**: Backend en 8080, desarrollo principal
- **Windows**: Backend en 8082, testing en dispositivo físico

Sincronización:
```bash
git pull --ff-only origin main  # Antes de empezar
git push origin main            # Al finalizar sesión
```

---

## 📞 Contacto y Soporte

**Desarrollador**: Luis Imaicela  
**Tutor**: Santiago Roman Viguera  
**Email**: limaicejar@educacion.navarra.es 
**Web**: luisimaicela.com

---

**Documento generado**: 9 de Febrero de 2026  
**Próxima revisión**: 2 de Marzo de 2026 (Entrega 1)  
**Versión**: 1.0