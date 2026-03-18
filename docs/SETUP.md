# Guía de Configuración del Entorno de Desarrollo - DesignWorks

## 📋 Requisitos Previos

### Software Necesario
- **Java**: JDK 17 o superior
- **Maven**: 3.8+ (incluido con el wrapper `mvnw`)
- **Flutter**: 3.x
- **Docker**: 20.10+ y Docker Compose
- **MariaDB**: 10.x (o usar Docker)
- **Git**: Para control de versiones

### IDEs Recomendados
- **Backend**: IntelliJ IDEA / Visual Studio Code
- **Frontend**: Android Studio / Visual Studio Code
- **Base de Datos**: Adminer (incluido en Docker) o DBeaver

---

## 🐳 Configuración con Docker (Recomendado)

### 1. Clonar el Repositorio
```bash
git clone [URL_DEL_REPOSITORIO]
cd DesignWorks
```

### 2. Configurar Variables de Entorno

Crea el archivo `.env` en la carpeta `infra/`:

```env
# Base de Datos (MariaDB)
COMPOSE_PROJECT_NAME=design_works
MARIADB_ROOT_PASSWORD=root
MARIADB_DATABASE=dam_db
MARIADB_USER=dam_user
MARIADB_PASSWORD=dam_pass
MARIADB_PORT=3306

# Adminer (Gestor de BD)
ADMINER_PORT=8081
```

### 3. Iniciar los Contenedores

Desde la carpeta raíz del proyecto:

```bash
cd infra
docker-compose up -d
```

Esto levantará:
- **MariaDB** en el puerto `3306`
- **Adminer** (gestor web de BD) en `http://localhost:8081`

### 4. Verificar la Base de Datos

#### Opción A: Usando Adminer (Interfaz Web)
Accede a: **http://localhost:8081**

Credenciales:
- **Servidor**: `mariadb`
- **Usuario**: `dsing_user`
- **Contraseña**: `FcfR_El21`
- **Base de datos**: `design_works`

#### Opción B: Usando CLI de MariaDB
```bash
docker exec -it designWorks_mariadb mariadb -u dsing_user -pFcfR_El21 design_works
```

Comandos útiles dentro de MariaDB:
```sql
SHOW TABLES;
SELECT COUNT(*) FROM usuarios;
SELECT COUNT(*) FROM trabajos;
SELECT * FROM trabajos ORDER BY id;
```

---

## ⚙️ Configuración del Backend (Spring Boot)

### 1. Navegar a la Carpeta del Backend
## ⚠️ Estructura real de carpetas del backend

En este proyecto, el backend Maven/Spring Boot **no está directamente en `backend/`**, sino en:

```text
DesignWorks/
└── backend/
    └── backend/
        ├── pom.xml
        ├── mvnw
        ├── mvnw.cmd
        ├── src/
        └── ...


Eso significa que para ejecutar Spring Boot, tests o cualquier comando Maven, debes situarte en la carpeta que **contiene directamente `pom.xml`**.

### 1. Navegar a la Carpeta Correcta del Backend

#### macOS / Linux:
```bash
cd backend/backend
```

#### Windows (PowerShell):
```powershell
cd .\backend\backend
```

### 2. Verificar que Estás en la Carpeta Correcta

#### macOS / Linux:
```bash
pwd
ls
```

#### Windows (PowerShell):
```powershell
Get-Location
dir
Test-Path .\pom.xml
```

Debes ver archivos como:
- `pom.xml`
- `mvnw`
- `mvnw.cmd`
- `src`

Si `pom.xml` **no aparece**, estás un nivel por encima y Maven dará errores como:

```text
No plugin found for prefix 'spring-boot'
```


### 2. Configurar Variables de Entorno

#### En macOS / Linux:
```bash
export DB_URL=jdbc:mariadb://127.0.0.1:3306/design_works
export DB_USER=dsing_user
export DB_PASS=FcfR_El21
```

#### En Windows (PowerShell):
```powershell
$env:DB_URL="jdbc:mariadb://127.0.0.1:3306/design_works"
$env:DB_USER="dsing_user"
$env:DB_PASS="FcfR_El21"
```

### 3. Ejecutar Spring Boot

#### Método 1: Maven Wrapper (Recomendado)

**macOS/Linux:**
```bash
./mvnw spring-boot:run
```

**Windows:**
```powershell
.\mvnw.cmd spring-boot:run
```

#### Método 2: Con Perfil Específico
```bash
mvn "-Dspring-boot.run.profiles=local" spring-boot:run
```

### 4. Verificar que el Backend Está Corriendo

**⚠️ IMPORTANTE: El puerto varía según el sistema operativo:**
- **macOS**: `http://localhost:8080`
- **Windows**: `http://localhost:8082`

Accede al endpoint de health (si está configurado):
```
http://localhost:8080/actuator/health
```

### 5. Configuración con Visual Studio Code

Si usas VS Code, crea el archivo `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Spring Boot - Backend",
      "request": "launch",
      "mainClass": "com.designworks.BackendApplication",
      "projectName": "backend",
      "env": {
        "DB_URL": "jdbc:mariadb://127.0.0.1:3306/design_works",
        "DB_USER": "dsing_user",
        "DB_PASS": "FcfR_El21"
      }
    }
  ]
}
```

> **Nota**: No se incluye `launch.json` en el repositorio por seguridad. Se proporciona `launch.example.json` como plantilla.

### Credenciales de Usuario Administrador (Seeding)
Al iniciar la aplicación por primera vez, se crea un usuario administrador:

- **Email**: `admin@designworks.com`
- **Contraseña**: `d.MCmq2des`

---

## 📱 Configuración del Frontend (Flutter)

### 1. Navegar a la Carpeta del Frontend
```bash
cd frontend
```

### 2. Instalar Dependencias
```bash
flutter pub get
```

### 3. Ejecutar la Aplicación

#### Emulador Android (localhost)

**En macOS:**
```bash
flutter run --no-enable-impeller --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

**En Windows:**
```bash
flutter run --no-enable-impeller --dart-define=API_BASE_URL=http://10.0.2.2:8082
```

> **Nota**: `10.0.2.2` es la IP especial del emulador Android para acceder al localhost de la máquina host.

#### Dispositivo Físico (USB)

**1. Configurar ADB Reverse:**

Permite que el móvil acceda al puerto del backend en tu PC:

**macOS:**
```bash
adb reverse tcp:8080 tcp:8080
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080
```

**Windows:**
```bash
adb reverse tcp:8082 tcp:8082
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8082
```

**2. Desconectar ADB (si es necesario):**
```bash
adb disconnect
```

#### Dispositivo Físico (WiFi - Depuración Inalámbrica)

**1. Activar depuración inalámbrica en el móvil** y obtener IP y puerto.

**2. Vincular dispositivo:**
```bash
adb pair 192.168.0.28:35453
# Introducir código de vinculación cuando lo pida
```

**3. Ejecutar la app con la IP de tu equipo:**

Averigua la IP local de tu equipo:
- **macOS/Linux**: `ifconfig | grep inet`
- **Windows**: `ipconfig`

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.15:8082
```

> **⚠️ Importante**: Reemplaza `192.168.0.15` con la IP real de tu equipo en la red local.

#### Build de APK Release

**Para probar en dispositivos físicos sin depuración:**

```bash
flutter build apk --release --dart-define=API_BASE_URL=http://192.168.0.17:8082
```

La APK se generará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Parámetros de Configuración

- `--no-enable-impeller`: Desactiva Impeller para mayor estabilidad en algunos dispositivos.
- `--dart-define=API_BASE_URL=[URL]`: Inyecta la URL base de la API en tiempo de compilación.

Dentro de la app, se accede con:
```dart
const String apiUrl = String.fromEnvironment('API_BASE_URL');
```

---

## 🔄 Sincronización Git (Multi-Equipo)

### Subir Cambios al Repositorio Central
```bash
git add .
git commit -m "Descripción del cambio"
git push origin main
```

### Traer Cambios del Repositorio Central
```bash
git pull --ff-only origin main
```

### Ver Últimos Cambios
```bash
git log --oneline --max-count=5
```

---

## 🧪 Ejecutar Tests

### Backend
```bash
cd backend
./mvnw test
```

### Frontend
```bash
cd frontend
flutter test
```

---

## 🐛 Troubleshooting

### Problema: "No se puede conectar a MariaDB"

**Solución:**
1. Verificar que Docker está corriendo:
   ```bash
   docker ps
   ```
2. Reiniciar contenedores:
   ```bash
   cd infra
   docker-compose down
   docker-compose up -d
   ```

### Problema: "Flutter no encuentra el backend"

**Solución:**
1. Verificar que Spring Boot está corriendo en el puerto correcto.
2. En emulador Android, usar `10.0.2.2` en lugar de `localhost`.
3. En dispositivo físico, usar la IP local de tu equipo.

### Problema: "Puerto 8080/8082 ya en uso"

**Solución:**
```bash
# macOS/Linux
lsof -ti:8080 | xargs kill -9

# Windows
netstat -ano | findstr :8082
taskkill /PID [PID_NUMBER] /F
```

---

## 📦 Tecnologías y Versiones

| Tecnología | Versión |
|------------|---------|
| Java | 17+ |
| Spring Boot | 3.x |
| Flutter | 3.x |
| Dart | 3.x |
| MariaDB | 10.x |
| Docker | 20.10+ |
| Maven | 3.8+ |

---

## 🔐 Seguridad

**⚠️ IMPORTANTE**: 
- **NUNCA** subas archivos `.env` o `launch.json` al repositorio.
- Las credenciales mostradas aquí son **solo para desarrollo local**.
- Para producción, usar variables de entorno seguras y secretos gestionados.

---

## 📞 Soporte

Si encuentras problemas durante la configuración:
1. Revisa la sección de Troubleshooting
2. Consulta los logs del backend: `backend/logs/`
3. Consulta los logs de Docker: `docker-compose logs`

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela