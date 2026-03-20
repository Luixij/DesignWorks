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
- **Backend**: Visual Studio Code *(recomendado)* / IntelliJ IDEA
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
MARIADB_ROOT_PASSWORD=cDa-20Jetl.
MARIADB_DATABASE=design_works
MARIADB_USER=dsing_user
MARIADB_PASSWORD=FcfR_El21
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

### ⚠️ Estructura real de carpetas del backend

En este proyecto, el backend Maven/Spring Boot **no está directamente en `backend/`**, sino en:

```
DesignWorks/
└── backend/
    └── backend/
        ├── pom.xml
        ├── mvnw
        ├── mvnw.cmd
        ├── src/
        └── ...
```

Para ejecutar Spring Boot, tests o cualquier comando Maven, debes situarte en la carpeta que **contiene directamente `pom.xml`**, es decir `backend/backend/`.

---

### ▶️ Método Recomendado: Visual Studio Code

> ✅ **Este es el método recomendado** para ejecutar el backend. No requiere configurar variables de entorno manualmente ni usar la terminal.

#### Pasos

1. Abre Visual Studio Code directamente en la carpeta:
   ```
   backend/backend
   ```
   ⚠️ **Importante**: Debes abrir exactamente esta carpeta, no la raíz del proyecto.

2. Pulsa `Ctrl + Shift + D` para abrir el panel de ejecución.

3. Selecciona la configuración **`Spring Boot (dev)`** en el menú desplegable.

4. Pulsa el botón ▶️ **(Run)**.

El backend se iniciará automáticamente con todas las variables de entorno configuradas a través del archivo `launch.json` incluido en el repositorio:

```
backend/backend/.vscode/launch.json
```

> **Nota**: El archivo `launch.json` está incluido en el repositorio para facilitar la ejecución del proyecto sin configuración manual.

#### Resultado

- Backend ejecutándose en el puerto correspondiente a tu sistema operativo.
- Variables de entorno configuradas automáticamente.
- Sin necesidad de usar la terminal.

---

### 🔧 Método Alternativo: Terminal

Si prefieres usar la terminal, sigue estos pasos:

#### 1. Navegar a la Carpeta Correcta del Backend

**macOS / Linux:**
```bash
cd backend/backend
```

**Windows (PowerShell):**
```powershell
cd .\backend\backend
```

#### 2. Verificar que Estás en la Carpeta Correcta

**macOS / Linux:**
```bash
pwd
ls
```

**Windows (PowerShell):**
```powershell
Get-Location
dir
Test-Path .\pom.xml
```

Debes ver archivos como `pom.xml`, `mvnw`, `mvnw.cmd` y `src/`. Si `pom.xml` no aparece, estás un nivel por encima y Maven dará errores como:

```
No plugin found for prefix 'spring-boot'
```

#### 3. Configurar Variables de Entorno

**macOS / Linux:**
```bash
export DB_URL=jdbc:mariadb://127.0.0.1:3306/design_works
export DB_USER=dsing_user
export DB_PASS=FcfR_El21
```

**Windows (PowerShell):**
```powershell
$env:DB_URL="jdbc:mariadb://127.0.0.1:3306/design_works"
$env:DB_USER="dsing_user"
$env:DB_PASS="FcfR_El21"
```

#### 4. Ejecutar Spring Boot

**macOS / Linux:**
```bash
./mvnw spring-boot:run
```

**Windows:**
```powershell
.\mvnw.cmd spring-boot:run
```

También es posible ejecutar con un perfil específico:
```bash
mvn "-Dspring-boot.run.profiles=local" spring-boot:run
```

---

### 4. Verificar que el Backend Está Corriendo

**⚠️ El puerto varía según el sistema operativo:**
- **macOS**: `http://localhost:8080`
- **Windows**: `http://localhost:8082`

URLs disponibles:

| Servicio | macOS | Windows |
|----------|-------|---------|
| API REST | `http://localhost:8080` | `http://localhost:8082` |
| Swagger UI | `http://localhost:8080/swagger-ui/index.html` | `http://localhost:8082/swagger-ui/index.html` |
| API Docs (JSON) | `http://localhost:8080/v3/api-docs` | `http://localhost:8082/v3/api-docs` |

---

### Credenciales de Spring (configuración interna)

Usuario técnico utilizado por Spring para operaciones internas, definido en `backend/backend/src/main/resources/application-dev.yml`:

- **Email**: `admin@designworks.com`
- **Contraseña**: `d.MCmq2des`

---

### 5. Credenciales de Acceso a la App

Una vez el backend y la base de datos están corriendo, puedes acceder a la app con estos usuarios precargados:

**👨‍💼 Administrador:**
| Campo | Valor |
|-------|-------|
| Email | `admin@designworks.com` |
| Contraseña | `Admin1234!` |

**👨‍🎨 Diseñadores:**
| Email | Contraseña |
|-------|------------|
| `marta@designworks.com` | `Design1234!` |
| `carlos@designworks.com` | `Design1234!` |
| `ana@designworks.com` | `Design1234!` |
| `javi@designworks.com` | `Design1234!` |

> Estos usuarios se crean automáticamente al iniciar la aplicación mediante el script `infra/sql/init.sql`.


---

## 📱 Configuración del Frontend (Flutter)

> ℹ️ Si es la primera vez que configuras Flutter o Android Studio en tu equipo, consulta primero el [**Anexo: Guía de Configuración del Entorno Android**](#-anexo-guía-de-configuración-del-entorno-android), donde se explica cómo instalar Flutter, qué SDK Tools son necesarios y cómo activar las opciones de desarrollador en el dispositivo.

> ⚠️ Los comandos de esta sección deben ejecutarse en la **terminal integrada de Android Studio** (`View → Tool Windows → Terminal`), no en una terminal del sistema, para asegurar que el entorno Flutter y las variables del SDK están correctamente cargadas.

### 1. Navegar a la Carpeta del Frontend
```bash
cd DesignWorks/frontend
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

Para probar en dispositivos físicos sin depuración:

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
cd backend/backend
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
- **NUNCA** subas archivos `.env`.
- El archivo `launch.json` está incluido para facilitar el entorno de desarrollo.
- Las credenciales mostradas aquí son **solo para desarrollo local**.
- Para producción, usar variables de entorno seguras y secretos gestionados.

---

## 📞 Soporte

Si encuentras problemas durante la configuración:
1. Revisa la sección de Troubleshooting
2. Consulta los logs del backend: `backend/logs/`
3. Consulta los logs de Docker: `docker-compose logs`

---

## 📎 Anexo: Guía de Configuración del Entorno Android

> ℹ️ **Nota**: Esta sección se incluye a modo de ayuda complementaria, tras la revisión realizada con el tutor. No forma parte del flujo principal del proyecto, pero puede ser útil para quien necesite configurar el entorno Android desde cero o resolver problemas de depuración.

---

### 🛠️ Instalación de Flutter (Windows)

1. Descarga el SDK de Flutter desde: https://docs.flutter.dev/get-started/install/windows
2. Descomprime el archivo en una ruta **sin espacios ni caracteres especiales**, por ejemplo:
   ```
   C:\flutter
   ```
   ⚠️ **Evita rutas como** `C:\Users\Tu Nombre\flutter` — los espacios causan problemas con las herramientas del SDK de Android.

3. Añade `C:\flutter\bin` a la variable de entorno `PATH`:
   - Busca "Variables de entorno" en el menú inicio.
   - En "Variables del sistema", edita `Path` y añade la ruta.

4. Abre una terminal nueva y verifica la instalación:
   ```bash
   flutter doctor
   ```
   Revisa los puntos marcados con ❌ o ⚠️ y resuélvelos antes de continuar.

5. Acepta las licencias de Android:
   ```bash
   flutter doctor --android-licenses
   ```
   Responde `y` a todas las preguntas.

---

### ⚙️ Android SDK Tools necesarios para depuración

Desde Android Studio, ve a **Settings → Languages & Frameworks → Android SDK → SDK Tools** y verifica que están instalados (o instálalos):

| Herramienta | Versión instalada | Para qué sirve |
|---|---|---|
| **Android SDK Build-Tools** | 36.0.0 | Compilar y empaquetar la APK |
| **Android Emulator** | 35.4.9+ | Ejecutar el emulador virtual |
| **Android Emulator Hypervisor Driver** | 2.2.0 | Aceleración de hardware del emulador (imprescindible en Windows) |
| **Android SDK Platform-Tools** | 35.0.2+ | Incluye `adb`, necesario para depuración USB y WiFi |
| **Android SDK Command-line Tools** | 19.0+ | Herramientas de línea de comandos del SDK |
| **NDK (Side by side)** | cualquiera | Solo necesario si hay código nativo (C/C++) |
| **CMake** | cualquiera | Solo necesario si hay código nativo (C/C++) |

> ✅ Para este proyecto, los más críticos son **Build-Tools**, **Platform-Tools** (adb), **Emulator** e **Hypervisor Driver**.

> ℹ️ Si aparece "Update Available" en alguna herramienta, puedes actualizarla marcando la casilla y aplicando los cambios. No es obligatorio para que funcione, pero es recomendable.

---

### 📲 Activar Opciones de Desarrollador en Android

Las opciones de desarrollador están ocultas por defecto. Para activarlas:

1. Ve a **Ajustes → Acerca del teléfono** (o "Información del software" según el fabricante).
2. Localiza el campo **Número de compilación** (Build number).
3. Pulsa sobre él **7 veces seguidas**.
4. Se mostrará el mensaje: *"¡Ya eres desarrollador!"*
5. Las **Opciones para desarrolladores** aparecerán en el menú de Ajustes (a veces dentro de "Sistema" o "Ajustes adicionales").

#### Opciones a activar dentro de "Opciones para desarrolladores"

| Opción | Para qué sirve |
|---|---|
| **Depuración USB** | Permite conectar el móvil al PC por cable y ejecutar/depurar apps |
| **Depuración inalámbrica** | Permite conectar el móvil por WiFi sin cable (Android 11+) |
| **Instalar vía USB** | Permite instalar APKs directamente desde el PC |

---

### 📡 Configurar Depuración Inalámbrica (WiFi)

Requiere Android 11 o superior y que el móvil y el PC estén en la **misma red WiFi**.

#### Pasos

1. En el móvil, ve a **Opciones para desarrolladores → Depuración inalámbrica** y actívala.

2. Dentro de "Depuración inalámbrica", toca **Vincular dispositivo con código de vinculación**.
   El móvil mostrará una **IP:puerto** y un **código de 6 dígitos**.

3. En el PC, ejecuta:
   ```bash
   adb pair <IP_MÓVIL>:<PUERTO_VINCULACIÓN>
   # Ejemplo: adb pair 192.168.0.28:35453
   ```
   Cuando lo pida, introduce el código de 6 dígitos.

4. Una vez vinculado, conéctate (usa el puerto de conexión, distinto al de vinculación):
   ```bash
   adb connect <IP_MÓVIL>:<PUERTO_CONEXIÓN>
   # Ejemplo: adb connect 192.168.0.28:42587
   ```

5. Verifica que el dispositivo aparece:
   ```bash
   adb devices
   ```

6. Ejecuta la app Flutter apuntando a la IP del PC en la red local:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://192.168.0.15:8082
   ```
   > Reemplaza `192.168.0.15` con la IP real de tu equipo (`ipconfig` en Windows, `ifconfig` en macOS/Linux).

---

**Última actualización**: Marzo 2026  
**Autor**: Luis Imaicela