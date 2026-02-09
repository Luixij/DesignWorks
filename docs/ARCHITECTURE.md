# Arquitectura del Sistema - DesignWorks

## 📐 Visión General

DesignWorks es una aplicación full-stack para la gestión de trabajos en estudios de diseño gráfico. Implementa una arquitectura de **3 capas** con separación clara de responsabilidades, comunicación mediante API REST y autenticación basada en JWT.

```
┌─────────────────────────────────────────────────────────┐
│                    CAPA DE PRESENTACIÓN                  │
│                                                           │
│  Flutter App (Android/iOS)                               │
│  - Material Design 3                                     │
│  - Riverpod (State Management)                           │
│  - GoRouter (Navigation)                                 │
│  - Dio (HTTP Client)                                     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ HTTP/REST + JWT
                      │
┌─────────────────────▼───────────────────────────────────┐
│                    CAPA DE NEGOCIO                       │
│                                                           │
│  Spring Boot API (Java 17)                               │
│  - Spring Security + JWT                                 │
│  - Spring Data JPA                                       │
│  - RESTful Controllers                                   │
│  - Business Logic Services                               │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ JPA/Hibernate
                      │
┌─────────────────────▼───────────────────────────────────┐
│                   CAPA DE PERSISTENCIA                   │
│                                                           │
│  MariaDB 11                                              │
│  - 6 tablas principales                                  │
│  - Relaciones FK con CASCADE                             │
│  - Índices optimizados                                   │
└─────────────────────────────────────────────────────────┘
```

---

## 🏗️ Componentes Principales

### 1. Frontend - Flutter App

**Tecnologías:**
- **Framework**: Flutter 3.7+
- **Lenguaje**: Dart 3.7+
- **State Management**: Riverpod 2.5+
- **Navegación**: GoRouter 14.2+
- **HTTP Client**: Dio 5.4+
- **Almacenamiento Seguro**: flutter_secure_storage 9.2+
- **Serialización**: json_serializable 6.8+

**Arquitectura Interna:**
```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # Configuración API_BASE_URL
│   ├── network/
│   │   ├── api_client.dart          # Cliente Dio configurado
│   │   └── api_endpoints.dart       # Constantes de endpoints
│   ├── storage/
│   │   └── secure_storage.dart      # Wrapper de flutter_secure_storage
│   └── utils/
│       └── validators.dart          # Validadores de formularios
├── data/
│   ├── models/
│   │   ├── usuario.dart
│   │   ├── trabajo.dart
│   │   ├── comentario.dart
│   │   ├── requisito.dart
│   │   └── historial_estado.dart
│   └── repositories/
│       ├── auth_repository.dart
│       └── trabajo_repository.dart
├── features/
│   ├── auth/
│   │   ├── data/                    # DTOs específicos de auth
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── login_screen.dart
│   │   │   └── widgets/
│   │   │       └── login_form.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── trabajos/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── trabajos_list_screen.dart
│   │   │   │   └── trabajo_detail_screen.dart
│   │   │   └── widgets/
│   │   └── providers/
│   ├── home/
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart
│   └── perfil/
└── main.dart                         # Entry point
```

**Flujo de Datos (Riverpod):**
```
Widget → Provider → Repository → API Client → Backend
   ↑                    ↓
   └────────────────────┘
        notifyListeners()
```

---

### 2. Backend - Spring Boot API

**Tecnologías:**
- **Framework**: Spring Boot 3.3.1
- **Lenguaje**: Java 17
- **Seguridad**: Spring Security + JWT (jjwt 0.12.5)
- **ORM**: Spring Data JPA + Hibernate
- **Base de Datos**: MariaDB Connector 3.x
- **Validación**: Spring Validation
- **Utilidades**: Lombok

**Dependencias Clave (pom.xml):**
```xml
<!-- Spring Boot Starters -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.5</version>
</dependency>

<!-- MariaDB -->
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
</dependency>

<!-- Lombok -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

**Arquitectura Interna (Capas):**
```
com.designworks/
├── config/
│   ├── SecurityConfig.java          # Configuración Spring Security
│   └── CorsConfig.java              # Configuración CORS
├── security/
│   ├── JwtService.java              # Generación y validación JWT
│   ├── JwtAuthFilter.java           # Filtro de autenticación
│   └── AuthUserProvider.java        # Provider de autenticación
├── controllers/
│   ├── AuthController.java          # POST /auth/login
│   ├── TrabajoController.java       # CRUD /trabajos
│   ├── ComentarioController.java    # /trabajos/{id}/comentarios
│   └── HistorialController.java     # /historial/{trabajoId}
├── services/
│   ├── AuthService.java             # Lógica de autenticación
│   ├── TrabajoService.java          # Lógica de trabajos
│   ├── ComentarioService.java       # Lógica de comentarios
│   └── HistorialService.java        # Lógica de historial
├── repositories/
│   ├── UsuarioRepository.java       # JpaRepository<Usuario, Long>
│   ├── TrabajoRepository.java
│   ├── ComentarioRepository.java
│   ├── RequisitoRepository.java
│   └── HistorialEstadoRepository.java
├── entities/
│   ├── Usuario.java                 # @Entity
│   ├── Trabajo.java
│   ├── TrabajoParticipante.java
│   ├── Comentario.java
│   ├── Requisito.java
│   └── HistorialEstado.java
├── dto/
│   ├── request/
│   │   ├── LoginRequest.java
│   │   ├── TrabajoCreateRequest.java
│   │   └── ComentarioCreateRequest.java
│   └── response/
│       ├── LoginResponse.java
│       ├── TrabajoResponse.java
│       └── UsuarioBasicResponse.java
└── exceptions/
    ├── ResourceNotFoundException.java
    ├── UnauthorizedException.java
    ├── InvalidOperationException.java
    └── GlobalExceptionHandler.java
```

**Configuración (application.properties):**
```properties
# Base de Datos (via variables de entorno)
spring.datasource.url=${DB_URL:jdbc:mariadb://localhost:3306/design_works}
spring.datasource.username=${DB_USER:dsing_user}
spring.datasource.password=${DB_PASS:FcfR_El21}

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true

# Puerto (varía por OS)
server.port=8080  # macOS
# server.port=8082  # Windows

# JWT
jwt.secret=${JWT_SECRET:designworks_secret_key_2026}
jwt.expiration=86400000  # 24 horas en ms
```

---

### 3. Base de Datos - MariaDB

**Versión**: MariaDB 11
**Motor**: InnoDB
**Charset**: utf8mb4

**Esquema de Tablas:**

```sql
┌─────────────────┐
│    USUARIOS     │
├─────────────────┤
│ id (PK)         │
│ nombre          │
│ email (UNIQUE)  │
│ rol             │
│ contrasena_hash │
│ activo          │
└────────┬────────┘
         │
         │ 1:N (creado_por_id)
         ↓
┌────────────────────┐         ┌──────────────────────┐
│     TRABAJOS       │    N:M  │ TRABAJO_PARTICIPANTES│
├────────────────────┤◄────────┤──────────────────────┤
│ id (PK)            │         │ trabajo_id (FK, PK)  │
│ titulo             │         │ usuario_id (FK, PK)  │
│ cliente            │         │ rol_en_trabajo       │
│ prioridad          │         └──────────────────────┘
│ fecha_inicio       │
│ fecha_fin          │
│ estado_actual      │
│ descripcion        │
│ creado_por_id (FK) │
└────────┬───────────┘
         │
         │ 1:N
         ├──────────────────────────────────┐
         │                                  │
         ↓                                  ↓
┌──────────────────┐              ┌──────────────────┐
│   COMENTARIOS    │              │    REQUISITOS    │
├──────────────────┤              ├──────────────────┤
│ id (PK)          │              │ id (PK)          │
│ trabajo_id (FK)  │              │ trabajo_id (FK)  │
│ usuario_id (FK)  │              │ descripcion      │
│ fecha            │              │ adjunto_url      │
│ texto            │              └──────────────────┘
└──────────────────┘
         
         ↓ 1:N
┌──────────────────────┐
│  HISTORIAL_ESTADOS   │
├──────────────────────┤
│ id (PK)              │
│ trabajo_id (FK)      │
│ estado               │
│ fecha                │
│ usuario_id (FK)      │
│ motivo               │
└──────────────────────┘
```

**Índices Optimizados:**
- `trabajos`: `estado_actual`, `prioridad`, `cliente`
- `comentarios`: `(trabajo_id, fecha)`
- `historial_estados`: `(trabajo_id, fecha)`, `estado`
- `trabajo_participantes`: `usuario_id`
- `requisitos`: `trabajo_id`

---

### 4. Infraestructura - Docker Compose

**Archivo**: `infra/docker-compose.yml`

**Servicios:**

#### a) MariaDB
```yaml
services:
  mariadb:
    image: mariadb:11
    container_name: designWorks_mariadb
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_DATABASE: design_works
      MARIADB_USER: dsing_user
      MARIADB_PASSWORD: FcfR_El21
    ports:
      - "3306:3306"
    volumes:
      - mariadb_data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d:ro
```

**Características:**
- Puerto expuesto: `3306`
- Persistencia: volumen `mariadb_data`
- Inicialización automática: scripts en `./sql/init.sql`

#### b) Adminer (Gestor Web de BD)
```yaml
  adminer:
    image: adminer:latest
    container_name: designWorks_adminer
    depends_on:
      - mariadb
    ports:
      - "8081:8080"
```

**Acceso**: http://localhost:8081
- Servidor: `mariadb`
- Usuario: `dsing_user`
- Contraseña: `FcfR_El21`
- BD: `design_works`

**Variables de Entorno (.env):**
```env
MARIADB_ROOT_PASSWORD=root_secure_password
MARIADB_DATABASE=design_works
MARIADB_USER=dsing_user
MARIADB_PASSWORD=FcfR_El21
MARIADB_PORT=3306
```

---

## 🔄 Flujo de Comunicación

### 1. Autenticación (Login)

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ POST /auth/login           │                          │
     │ {email, password}          │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ SELECT * FROM usuarios   │
     │                            │ WHERE email = ?          │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ Usuario (con hash)       │
     │                            │                          │
     │                            │ BCrypt.verify()          │
     │                            │                          │
     │                            │ JWT.generate()           │
     │                            │                          │
     │ { token, rol, nombre }     │                          │
     │<───────────────────────────┤                          │
     │                            │                          │
     │ SecureStorage.save(token)  │                          │
     │                            │                          │
```

### 2. Consulta de Trabajos (con JWT)

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ GET /trabajos              │                          │
     │ Authorization: Bearer JWT  │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ JwtAuthFilter.verify()   │
     │                            │                          │
     │                            │ TrabajoService           │
     │                            │ .getTrabajos()           │
     │                            │                          │
     │                            │ SELECT * FROM trabajos   │
     │                            │ WHERE ...                │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ List<Trabajo>            │
     │                            │                          │
     │                            │ toDTO()                  │
     │                            │                          │
     │ [ TrabajoResponse ]        │                          │
     │<───────────────────────────┤                          │
     │                            │                          │
     │ Provider.notifyListeners() │                          │
     │                            │                          │
```

### 3. Crear Trabajo

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ POST /trabajos             │                          │
     │ Authorization: Bearer JWT  │                          │
     │ { titulo, cliente, ... }   │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ @Valid                   │
     │                            │ validarDatos()           │
     │                            │                          │
     │                            │ verificarPermisos()      │
     │                            │ (solo ADMIN)             │
     │                            │                          │
     │                            │ INSERT INTO trabajos     │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ id generado              │
     │                            │                          │
     │                            │ INSERT historial_estados │
     │                            ├─────────────────────────>│
     │                            │                          │
     │ { id, titulo, estado, ... }│                          │
     │<───────────────────────────┤                          │
     │                            │                          │
```

---

## 🔐 Seguridad y Autenticación

### JWT (JSON Web Token)

**Estructura del Token:**
```json
{
  "header": {
    "alg": "HS512",
    "typ": "JWT"
  },
  "payload": {
    "sub": "admin@designworks.com",
    "userId": 1,
    "rol": "ADMIN",
    "nombre": "Luis Admin",
    "iat": 1707494400,
    "exp": 1707580800
  },
  "signature": "..."
}
```

**Flujo de Seguridad:**

1. **Login**: Usuario envía credenciales → Backend valida → Genera JWT
2. **Almacenamiento**: Flutter guarda JWT en `flutter_secure_storage`
3. **Peticiones**: Cada request incluye header `Authorization: Bearer {token}`
4. **Validación**: `JwtAuthFilter` intercepta, verifica firma y claims
5. **Autorización**: `@PreAuthorize` valida roles según endpoint

**Matriz de Permisos:**

| Endpoint | ADMIN | DISEÑADOR |
|----------|-------|-----------|
| POST /trabajos | ✅ | ❌ |
| GET /trabajos | ✅ | ❌ |
| GET /trabajos/mis | ✅ | ✅ |
| PUT /trabajos/{id} | ✅ | ❌ |
| PUT /trabajos/{id}/estado | ✅ | ✅ (si participa) |
| POST /trabajos/{id}/comentarios | ✅ | ✅ (si participa) |

---

## 📊 Patrones de Diseño Implementados

### Backend
- **Repository Pattern**: Abstracción de acceso a datos (JpaRepository)
- **Service Layer Pattern**: Lógica de negocio centralizada
- **DTO Pattern**: Separación entre entidades y respuestas
- **Dependency Injection**: IoC con Spring
- **Filter Pattern**: JwtAuthFilter para autenticación

### Frontend
- **Provider Pattern**: Gestión de estado con Riverpod
- **Repository Pattern**: Abstracción de fuentes de datos
- **MVVM**: Separación presentation/data/domain

---

## 🚀 Despliegue

### Desarrollo Local

**1. Infraestructura:**
```bash
cd infra
docker-compose up -d
```

**2. Backend:**
```bash
cd backend
export DB_URL=jdbc:mariadb://127.0.0.1:3306/design_works
export DB_USER=dsing_user
export DB_PASS=FcfR_El21
./mvnw spring-boot:run
```

**3. Frontend:**
```bash
cd frontend
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### Producción (Futuro)

- **Backend**: JAR desplegado en servidor con JRE 17
- **Frontend**: APK/AAB publicado en Play Store
- **BD**: MariaDB gestionada o contenedor con backups automáticos

---

## 📈 Escalabilidad y Rendimiento

### Optimizaciones Actuales
- Índices en columnas de búsqueda frecuente
- Fetch LAZY en relaciones JPA
- Conexión pool de BBDD (HikariCP)
- Cache de segundo nivel en Hibernate (futuro)

### Mejoras Futuras
- Redis para cache de sesiones JWT
- Paginación en listados de trabajos
- Compresión GZIP en API
- CDN para assets estáticos

---

## 🔧 Tecnologías y Versiones

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Frontend Framework | Flutter | 3.7+ |
| Frontend Language | Dart | 3.7+ |
| Backend Framework | Spring Boot | 3.3.1 |
| Backend Language | Java | 17 |
| Database | MariaDB | 11 |
| Containerization | Docker | 20.10+ |
| Build Tool (Backend) | Maven | 3.8+ |
| State Management | Riverpod | 2.5.1 |
| HTTP Client | Dio | 5.4.0 |
| Routing | GoRouter | 14.2.0 |
| JWT Library | jjwt | 0.12.5 |

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM

## 📐 Visión General

DesignWorks es una aplicación full-stack para la gestión de trabajos en estudios de diseño gráfico. Implementa una arquitectura de **3 capas** con separación clara de responsabilidades, comunicación mediante API REST y autenticación basada en JWT.

```
┌─────────────────────────────────────────────────────────┐
│                    CAPA DE PRESENTACIÓN                  │
│                                                           │
│  Flutter App (Android/iOS)                               │
│  - Material Design 3                                     │
│  - Riverpod (State Management)                           │
│  - GoRouter (Navigation)                                 │
│  - Dio (HTTP Client)                                     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ HTTP/REST + JWT
                      │
┌─────────────────────▼───────────────────────────────────┐
│                    CAPA DE NEGOCIO                       │
│                                                           │
│  Spring Boot API (Java 17)                               │
│  - Spring Security + JWT                                 │
│  - Spring Data JPA                                       │
│  - RESTful Controllers                                   │
│  - Business Logic Services                               │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ JPA/Hibernate
                      │
┌─────────────────────▼───────────────────────────────────┐
│                   CAPA DE PERSISTENCIA                   │
│                                                           │
│  MariaDB 11                                              │
│  - 6 tablas principales                                  │
│  - Relaciones FK con CASCADE                             │
│  - Índices optimizados                                   │
└─────────────────────────────────────────────────────────┘
```

---

## 🏗️ Componentes Principales

### 1. Frontend - Flutter App

**Tecnologías:**
- **Framework**: Flutter 3.7+
- **Lenguaje**: Dart 3.7+
- **State Management**: Riverpod 2.5+
- **Navegación**: GoRouter 14.2+
- **HTTP Client**: Dio 5.4+
- **Almacenamiento Seguro**: flutter_secure_storage 9.2+
- **Serialización**: json_serializable 6.8+

**Arquitectura Interna:**
```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # Configuración API_BASE_URL
│   ├── network/
│   │   ├── api_client.dart          # Cliente Dio configurado
│   │   └── api_endpoints.dart       # Constantes de endpoints
│   ├── storage/
│   │   └── secure_storage.dart      # Wrapper de flutter_secure_storage
│   └── utils/
│       └── validators.dart          # Validadores de formularios
├── data/
│   ├── models/
│   │   ├── usuario.dart
│   │   ├── trabajo.dart
│   │   ├── comentario.dart
│   │   ├── requisito.dart
│   │   └── historial_estado.dart
│   └── repositories/
│       ├── auth_repository.dart
│       └── trabajo_repository.dart
├── features/
│   ├── auth/
│   │   ├── data/                    # DTOs específicos de auth
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── login_screen.dart
│   │   │   └── widgets/
│   │   │       └── login_form.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── trabajos/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── trabajos_list_screen.dart
│   │   │   │   └── trabajo_detail_screen.dart
│   │   │   └── widgets/
│   │   └── providers/
│   ├── home/
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart
│   └── perfil/
└── main.dart                         # Entry point
```

**Flujo de Datos (Riverpod):**
```
Widget → Provider → Repository → API Client → Backend
   ↑                    ↓
   └────────────────────┘
        notifyListeners()
```

---

### 2. Backend - Spring Boot API

**Tecnologías:**
- **Framework**: Spring Boot 3.3.1
- **Lenguaje**: Java 17
- **Seguridad**: Spring Security + JWT (jjwt 0.12.5)
- **ORM**: Spring Data JPA + Hibernate
- **Base de Datos**: MariaDB Connector 3.x
- **Validación**: Spring Validation
- **Utilidades**: Lombok

**Dependencias Clave (pom.xml):**
```xml
<!-- Spring Boot Starters -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.5</version>
</dependency>

<!-- MariaDB -->
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
</dependency>

<!-- Lombok -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

**Arquitectura Interna (Capas):**
```
com.designworks/
├── config/
│   ├── SecurityConfig.java          # Configuración Spring Security
│   └── CorsConfig.java              # Configuración CORS
├── security/
│   ├── JwtService.java              # Generación y validación JWT
│   ├── JwtAuthFilter.java           # Filtro de autenticación
│   └── AuthUserProvider.java        # Provider de autenticación
├── controllers/
│   ├── AuthController.java          # POST /auth/login
│   ├── TrabajoController.java       # CRUD /trabajos
│   ├── ComentarioController.java    # /trabajos/{id}/comentarios
│   └── HistorialController.java     # /historial/{trabajoId}
├── services/
│   ├── AuthService.java             # Lógica de autenticación
│   ├── TrabajoService.java          # Lógica de trabajos
│   ├── ComentarioService.java       # Lógica de comentarios
│   └── HistorialService.java        # Lógica de historial
├── repositories/
│   ├── UsuarioRepository.java       # JpaRepository<Usuario, Long>
│   ├── TrabajoRepository.java
│   ├── ComentarioRepository.java
│   ├── RequisitoRepository.java
│   └── HistorialEstadoRepository.java
├── entities/
│   ├── Usuario.java                 # @Entity
│   ├── Trabajo.java
│   ├── TrabajoParticipante.java
│   ├── Comentario.java
│   ├── Requisito.java
│   └── HistorialEstado.java
├── dto/
│   ├── request/
│   │   ├── LoginRequest.java
│   │   ├── TrabajoCreateRequest.java
│   │   └── ComentarioCreateRequest.java
│   └── response/
│       ├── LoginResponse.java
│       ├── TrabajoResponse.java
│       └── UsuarioBasicResponse.java
└── exceptions/
    ├── ResourceNotFoundException.java
    ├── UnauthorizedException.java
    ├── InvalidOperationException.java
    └── GlobalExceptionHandler.java
```

**Configuración (application.properties):**
```properties
# Base de Datos (via variables de entorno)
spring.datasource.url=${DB_URL:jdbc:mariadb://localhost:3306/design_works}
spring.datasource.username=${DB_USER:dsing_user}
spring.datasource.password=${DB_PASS:FcfR_El21}

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true

# Puerto (varía por OS)
server.port=8080  # macOS
# server.port=8082  # Windows

# JWT
jwt.secret=${JWT_SECRET:designworks_secret_key_2026}
jwt.expiration=86400000  # 24 horas en ms
```

---

### 3. Base de Datos - MariaDB

**Versión**: MariaDB 11
**Motor**: InnoDB
**Charset**: utf8mb4

**Esquema de Tablas:**

```sql
┌─────────────────┐
│    USUARIOS     │
├─────────────────┤
│ id (PK)         │
│ nombre          │
│ email (UNIQUE)  │
│ rol             │
│ contrasena_hash │
│ activo          │
└────────┬────────┘
         │
         │ 1:N (creado_por_id)
         ↓
┌────────────────────┐         ┌──────────────────────┐
│     TRABAJOS       │    N:M  │ TRABAJO_PARTICIPANTES│
├────────────────────┤◄────────┤──────────────────────┤
│ id (PK)            │         │ trabajo_id (FK, PK)  │
│ titulo             │         │ usuario_id (FK, PK)  │
│ cliente            │         │ rol_en_trabajo       │
│ prioridad          │         └──────────────────────┘
│ fecha_inicio       │
│ fecha_fin          │
│ estado_actual      │
│ descripcion        │
│ creado_por_id (FK) │
└────────┬───────────┘
         │
         │ 1:N
         ├──────────────────────────────────┐
         │                                  │
         ↓                                  ↓
┌──────────────────┐              ┌──────────────────┐
│   COMENTARIOS    │              │    REQUISITOS    │
├──────────────────┤              ├──────────────────┤
│ id (PK)          │              │ id (PK)          │
│ trabajo_id (FK)  │              │ trabajo_id (FK)  │
│ usuario_id (FK)  │              │ descripcion      │
│ fecha            │              │ adjunto_url      │
│ texto            │              └──────────────────┘
└──────────────────┘
         
         ↓ 1:N
┌──────────────────────┐
│  HISTORIAL_ESTADOS   │
├──────────────────────┤
│ id (PK)              │
│ trabajo_id (FK)      │
│ estado               │
│ fecha                │
│ usuario_id (FK)      │
│ motivo               │
└──────────────────────┘
```

**Índices Optimizados:**
- `trabajos`: `estado_actual`, `prioridad`, `cliente`
- `comentarios`: `(trabajo_id, fecha)`
- `historial_estados`: `(trabajo_id, fecha)`, `estado`
- `trabajo_participantes`: `usuario_id`
- `requisitos`: `trabajo_id`

---

### 4. Infraestructura - Docker Compose

**Archivo**: `infra/docker-compose.yml`

**Servicios:**

#### a) MariaDB
```yaml
services:
  mariadb:
    image: mariadb:11
    container_name: designWorks_mariadb
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_DATABASE: design_works
      MARIADB_USER: dsing_user
      MARIADB_PASSWORD: FcfR_El21
    ports:
      - "3306:3306"
    volumes:
      - mariadb_data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d:ro
```

**Características:**
- Puerto expuesto: `3306`
- Persistencia: volumen `mariadb_data`
- Inicialización automática: scripts en `./sql/init.sql`

#### b) Adminer (Gestor Web de BD)
```yaml
  adminer:
    image: adminer:latest
    container_name: designWorks_adminer
    depends_on:
      - mariadb
    ports:
      - "8081:8080"
```

**Acceso**: http://localhost:8081
- Servidor: `mariadb`
- Usuario: `dsing_user`
- Contraseña: `FcfR_El21`
- BD: `design_works`

**Variables de Entorno (.env):**
```env
MARIADB_ROOT_PASSWORD=root_secure_password
MARIADB_DATABASE=design_works
MARIADB_USER=dsing_user
MARIADB_PASSWORD=FcfR_El21
MARIADB_PORT=3306
```

---

## 🔄 Flujo de Comunicación

### 1. Autenticación (Login)

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ POST /auth/login           │                          │
     │ {email, password}          │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ SELECT * FROM usuarios   │
     │                            │ WHERE email = ?          │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ Usuario (con hash)       │
     │                            │                          │
     │                            │ BCrypt.verify()          │
     │                            │                          │
     │                            │ JWT.generate()           │
     │                            │                          │
     │ { token, rol, nombre }     │                          │
     │<───────────────────────────┤                          │
     │                            │                          │
     │ SecureStorage.save(token)  │                          │
     │                            │                          │
```

### 2. Consulta de Trabajos (con JWT)

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ GET /trabajos              │                          │
     │ Authorization: Bearer JWT  │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ JwtAuthFilter.verify()   │
     │                            │                          │
     │                            │ TrabajoService           │
     │                            │ .getTrabajos()           │
     │                            │                          │
     │                            │ SELECT * FROM trabajos   │
     │                            │ WHERE ...                │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ List<Trabajo>            │
     │                            │                          │
     │                            │ toDTO()                  │
     │                            │                          │
     │ [ TrabajoResponse ]        │                          │
     │<───────────────────────────┤                          │
     │                            │                          │
     │ Provider.notifyListeners() │                          │
     │                            │                          │
```

### 3. Crear Trabajo

```
┌──────────┐                ┌────────────┐              ┌──────────┐
│  Flutter │                │  Spring    │              │ MariaDB  │
│   App    │                │  Boot API  │              │          │
└────┬─────┘                └─────┬──────┘              └────┬─────┘
     │                            │                          │
     │ POST /trabajos             │                          │
     │ Authorization: Bearer JWT  │                          │
     │ { titulo, cliente, ... }   │                          │
     ├───────────────────────────>│                          │
     │                            │                          │
     │                            │ @Valid                   │
     │                            │ validarDatos()           │
     │                            │                          │
     │                            │ verificarPermisos()      │
     │                            │ (solo ADMIN)             │
     │                            │                          │
     │                            │ INSERT INTO trabajos     │
     │                            ├─────────────────────────>│
     │                            │                          │
     │                            │<─────────────────────────┤
     │                            │ id generado              │
     │                            │                          │
     │                            │ INSERT historial_estados │
     │                            ├─────────────────────────>│
     │                            │                          │
     │ { id, titulo, estado, ... }│                          │
     │<───────────────────────────┤                          │
     │                            │                          │
```

---

## 🔐 Seguridad y Autenticación

### JWT (JSON Web Token)

**Estructura del Token:**
```json
{
  "header": {
    "alg": "HS512",
    "typ": "JWT"
  },
  "payload": {
    "sub": "admin@designworks.com",
    "userId": 1,
    "rol": "ADMIN",
    "nombre": "Luis Admin",
    "iat": 1707494400,
    "exp": 1707580800
  },
  "signature": "..."
}
```

**Flujo de Seguridad:**

1. **Login**: Usuario envía credenciales → Backend valida → Genera JWT
2. **Almacenamiento**: Flutter guarda JWT en `flutter_secure_storage`
3. **Peticiones**: Cada request incluye header `Authorization: Bearer {token}`
4. **Validación**: `JwtAuthFilter` intercepta, verifica firma y claims
5. **Autorización**: `@PreAuthorize` valida roles según endpoint

**Matriz de Permisos:**

| Endpoint | ADMIN | DISEÑADOR |
|----------|-------|-----------|
| POST /trabajos | ✅ | ❌ |
| GET /trabajos | ✅ | ❌ |
| GET /trabajos/mis | ✅ | ✅ |
| PUT /trabajos/{id} | ✅ | ❌ |
| PUT /trabajos/{id}/estado | ✅ | ✅ (si participa) |
| POST /trabajos/{id}/comentarios | ✅ | ✅ (si participa) |

---

## 📊 Patrones de Diseño Implementados

### Backend
- **Repository Pattern**: Abstracción de acceso a datos (JpaRepository)
- **Service Layer Pattern**: Lógica de negocio centralizada
- **DTO Pattern**: Separación entre entidades y respuestas
- **Dependency Injection**: IoC con Spring
- **Filter Pattern**: JwtAuthFilter para autenticación

### Frontend
- **Provider Pattern**: Gestión de estado con Riverpod
- **Repository Pattern**: Abstracción de fuentes de datos
- **MVVM**: Separación presentation/data/domain

---

## 🚀 Despliegue

### Desarrollo Local

**1. Infraestructura:**
```bash
cd infra
docker-compose up -d
```

**2. Backend:**
```bash
cd backend
export DB_URL=jdbc:mariadb://127.0.0.1:3306/design_works
export DB_USER=dsing_user
export DB_PASS=FcfR_El21
./mvnw spring-boot:run
```

**3. Frontend:**
```bash
cd frontend
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### Producción (Futuro)

- **Backend**: JAR desplegado en servidor con JRE 17
- **Frontend**: APK/AAB publicado en Play Store
- **BD**: MariaDB gestionada o contenedor con backups automáticos

---

## 📈 Escalabilidad y Rendimiento

### Optimizaciones Actuales
- Índices en columnas de búsqueda frecuente
- Fetch LAZY en relaciones JPA
- Conexión pool de BBDD (HikariCP)
- Cache de segundo nivel en Hibernate (futuro)

### Mejoras Futuras (a expensas de tiempo)
- Redis para cache de sesiones JWT
- Paginación en listados de trabajos
- Compresión GZIP en API
- CDN para assets estáticos

---

## 🔧 Tecnologías y Versiones

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Frontend Framework | Flutter | 3.7+ |
| Frontend Language | Dart | 3.7+ |
| Backend Framework | Spring Boot | 3.3.1 |
| Backend Language | Java | 17 |
| Database | MariaDB | 11 |
| Containerization | Docker | 20.10+ |
| Build Tool (Backend) | Maven | 3.8+ |
| State Management | Riverpod | 2.5.1 |
| HTTP Client | Dio | 5.4.0 |
| Routing | GoRouter | 14.2.0 |
| JWT Library | jjwt | 0.12.5 |

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM
