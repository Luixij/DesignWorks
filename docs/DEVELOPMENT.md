# Guía de Desarrollo - DesignWorks

## 📐 Estándares de Código

### Backend (Java / Spring Boot)

#### Convenciones de Nomenclatura

**Paquetes:**
```java
com.designworks.config
com.designworks.security
com.designworks.controllers
com.designworks.services
com.designworks.repositories
com.designworks.entities
com.designworks.dto
com.designworks.exceptions
```

**Clases:**
- **Entidades**: `Usuario`, `Trabajo`, `Comentario` (sustantivos en singular)
- **Servicios**: `TrabajoService`, `AuthService` (sufijo `Service`)
- **Repositorios**: `TrabajoRepository`, `UsuarioRepository` (sufijo `Repository`)
- **Controllers**: `TrabajoController`, `AuthController` (sufijo `Controller`)
- **DTOs**: `TrabajoResponse`, `LoginRequest` (sufijo descriptivo)

**Métodos:**
- Usar camelCase: `crearTrabajo()`, `obtenerTrabajoPorId()`
- Verbos descriptivos: `get`, `create`, `update`, `delete`, `validate`

**Constantes:**
```java
public static final String JWT_SECRET_KEY = "...";
public static final int TOKEN_EXPIRATION_TIME = 3600000;
```

#### Estructura de una Entidad
```java
@Entity
@Table(name = "trabajos")
public class Trabajo {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String titulo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "creado_por")
    private Usuario creadoPor;
    
    // Getters y Setters
    // Constructores
    // toString, equals, hashCode si es necesario
}
```

#### Estructura de un Service
```java
@Service
@Transactional
public class TrabajoService {
    
    private final TrabajoRepository trabajoRepository;
    private final UsuarioRepository usuarioRepository;
    
    @Autowired
    public TrabajoService(TrabajoRepository trabajoRepository, 
                          UsuarioRepository usuarioRepository) {
        this.trabajoRepository = trabajoRepository;
        this.usuarioRepository = usuarioRepository;
    }
    
    public TrabajoResponse crearTrabajo(TrabajoCreateRequest request) {
        // Validaciones
        // Lógica de negocio
        // Persistencia
        // Retorno de DTO
    }
}
```

#### Manejo de Excepciones
```java
// Excepciones personalizadas
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}

// Global Exception Handler
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(
            ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),
            ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }
}
```

---

### Frontend (Dart / Flutter)

#### Convenciones de Nomenclatura

**Archivos:**
- Usar snake_case: `login_screen.dart`, `trabajo_service.dart`
- Un widget principal por archivo

**Clases:**
- PascalCase: `LoginScreen`, `TrabajoListItem`, `ApiClient`
- Widgets: sufijo descriptivo si es necesario (`LoginForm`, `TrabajoCard`)

**Variables y Funciones:**
- camelCase: `trabajosList`, `fetchTrabajos()`, `isLoading`

**Constantes:**
```dart
const String kApiBaseUrl = String.fromEnvironment('API_BASE_URL');
const int kMaxRetries = 3;
```

#### Estructura de Directorios
```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── api_endpoints.dart
│   ├── storage/
│   │   └── secure_storage.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── trabajo.dart
│   │   ├── usuario.dart
│   │   └── comentario.dart
│   └── repositories/
│       └── trabajo_repository.dart
├── features/
│   ├── auth/
│   │   ├── data/
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
│   │   └── providers/
│   └── home/
└── main.dart
```

#### Estructura de un Widget
```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Widgets...
          ],
        ),
      ),
    );
  }
  
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Lógica de login
    }
  }
}
```

#### Gestión de Estado
```dart
// Usando Provider
class TrabajoProvider extends ChangeNotifier {
  List<Trabajo> _trabajos = [];
  bool _isLoading = false;
  String? _error;

  List<Trabajo> get trabajos => _trabajos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTrabajos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trabajos = await trabajoRepository.getTrabajos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## 🌿 Git Workflow

### Estrategia de Branching

**Ramas Principales:**
- `main`: Código en producción / entregable
- `develop`: Integración de features en desarrollo

**Ramas de Features:**
```bash
git checkout -b feature/nombre-funcionalidad
# Ejemplo: feature/auth-jwt
# Ejemplo: feature/trabajo-list
```

**Ramas de Fixes:**
```bash
git checkout -b fix/descripcion-bug
# Ejemplo: fix/login-validation
```

### Convención de Commits

Usar mensajes descriptivos siguiendo el formato:

```
tipo(ámbito): descripción breve

Descripción detallada (opcional)
```

**Tipos:**
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, sin cambios de código
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

**Ejemplos:**
```bash
git commit -m "feat(auth): implementar login con JWT"
git commit -m "fix(trabajos): corregir validación de estado"
git commit -m "docs(readme): actualizar instrucciones de setup"
git commit -m "refactor(services): extraer lógica común"
```

### Pull Requests

**Antes de crear un PR:**
1. Asegurarse de que el código compila sin errores
2. Ejecutar tests: `./mvnw test` (backend) y `flutter test` (frontend)
3. Actualizar documentación si es necesario

**Plantilla de PR:**
```markdown
## Descripción
[Breve descripción de los cambios]

## Tipo de cambio
- [ ] Nueva funcionalidad
- [ ] Corrección de bug
- [ ] Refactorización
- [ ] Documentación

## Checklist
- [ ] El código compila sin errores
- [ ] Se ejecutaron los tests
- [ ] Se actualizó la documentación
- [ ] Se probó manualmente la funcionalidad
```

---

## 🧪 Testing

### Backend (JUnit + Mockito)

**Ubicación:** `backend/src/test/java/`

**Ejemplo de Test de Servicio:**
```java
@ExtendWith(MockitoExtension.class)
class TrabajoServiceTest {
    
    @Mock
    private TrabajoRepository trabajoRepository;
    
    @Mock
    private UsuarioRepository usuarioRepository;
    
    @InjectMocks
    private TrabajoService trabajoService;
    
    @Test
    void crearTrabajo_DeberiaRetornarTrabajoCreado() {
        // Arrange
        TrabajoCreateRequest request = new TrabajoCreateRequest();
        request.setTitulo("Diseño Logo");
        
        Usuario admin = new Usuario();
        admin.setId(1L);
        
        Trabajo trabajo = new Trabajo();
        trabajo.setId(1L);
        trabajo.setTitulo("Diseño Logo");
        
        when(usuarioRepository.findById(1L)).thenReturn(Optional.of(admin));
        when(trabajoRepository.save(any(Trabajo.class))).thenReturn(trabajo);
        
        // Act
        TrabajoResponse response = trabajoService.crearTrabajo(request, 1L);
        
        // Assert
        assertNotNull(response);
        assertEquals("Diseño Logo", response.getTitulo());
        verify(trabajoRepository, times(1)).save(any(Trabajo.class));
    }
}
```

**Ejecutar tests:**
```bash
./mvnw test
```

### Frontend (Flutter Test)

**Ubicación:** `frontend/test/`

**Ejemplo de Test de Widget:**
```dart
void main() {
  testWidgets('LoginScreen debería mostrar formulario', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verificar que existen los campos
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
```

**Ejecutar tests:**
```bash
flutter test
```

**Cobertura mínima:** 60% (objetivo: 80%)

---

## 📊 Estado Actual del Desarrollo

### ✅ Completado

#### Documentación
- [x] Fase de Análisis
- [x] Fase de Diseño
- [x] Modelo Entidad-Relación
- [x] Diagramas UML (Clases, Secuencia, Estados)
- [x] Definición de API REST
- [x] Wireframes completos
- [x] **Diseño UI/UX completo en Figma**

#### Infraestructura
- [x] Configuración de Docker Compose
- [x] Scripts de inicialización de BD
- [x] Configuración de Adminer
- [x] Variables de entorno

#### Backend (✅ FUNCIONAL - 80%)
- [x] Estructura base del proyecto Spring Boot
- [x] Configuración de dependencias Maven
- [x] Entidades JPA mapeadas (6 entidades)
- [x] Repositorios JPA completos
- [x] **Servicios de negocio implementados**
  - [x] AuthService
  - [x] TrabajoService
  - [x] ComentarioService
  - [x] RequisitoService
  - [x] HistorialService
- [x] **Spring Security + JWT completo**
  - [x] JwtService
  - [x] JwtAuthFilter
  - [x] SecurityConfig
  - [x] Control de acceso basado en roles
- [x] **Controllers REST funcionales**
  - [x] AuthController
  - [x] TrabajoController
  - [x] ComentarioController
  - [x] RequisitoController
  - [x] HistorialController
- [x] DTOs Request/Response
- [x] Validaciones con @Valid
- [x] Manejo global de excepciones
- [x] Validación de transiciones de estado
- [ ] Documentación Swagger/OpenAPI (pendiente)
- [ ] Tests unitarios (pendiente)

#### Frontend (✅ FUNCIONAL - 75%)
- [x] Estructura base del proyecto Flutter
- [x] Configuración de dependencias (pubspec.yaml)
- [x] **Modelos de datos completos con serialización JSON**
  - [x] Usuario, Trabajo, Comentario, Requisito, HistorialEstado
- [x] **Servicios completos**
  - [x] ApiClient con Dio
  - [x] AuthService
  - [x] TrabajoService
  - [x] ComentarioService
  - [x] RequisitoService
  - [x] HistorialService
  - [x] SecureStorageService
- [x] **Providers (Riverpod) completos**
  - [x] authProvider
  - [x] trabajosProvider
  - [x] misTrabajosProvider
  - [x] trabajoDetailProvider
  - [x] comentariosProvider
- [x] **Pantallas funcionales**
  - [x] LoginScreen
  - [x] HomeScreen
  - [x] TrabajosListScreen
  - [x] MisTrabajosScreen
  - [x] TrabajoDetailScreen
  - [x] PerfilScreen
- [x] Navegación completa con GoRouter
- [x] Guards de autenticación
- [x] Gestión de estado global
- [x] Manejo de errores
- [x] **Diseño UI/UX completo en Figma** ✅
- [~] Implementación de diseño Figma en Flutter (60%)
- [ ] Tests de widgets (pendiente)

### 🔄 En Progreso

- **Frontend**: Implementación del diseño final de Figma
- **Backend**: Configuración de Swagger/OpenAPI
- **Testing**: Preparación de suite de tests

### ⏳ Pendiente (Para Entrega Final - 27 de Marzo)

- Tests unitarios (Backend)
- Tests de widgets (Frontend)
- Tests de integración
- Documentación Swagger completa
- Implementación completa del diseño Figma
- Animaciones y transiciones
- Modo claro/oscuro
- Optimizaciones de rendimiento

---

## 🐛 Issues Conocidos

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| #1 | Configurar refresh token para JWT | Media | Pendiente |
| #2 | Validar transiciones de estado en backend | Alta | En progreso |
| #3 | Implementar manejo de errores de red en Flutter | Media | Pendiente |

---

## 📝 Notas para Desarrollo

### Puertos Utilizados

| Servicio | macOS | Windows |
|----------|-------|---------|
| Spring Boot | 8080 | 8082 |
| MariaDB | 3306 | 3306 |
| Adminer | 8081 | 8081 |

### Variables de Entorno Requeridas

**Backend:**
```
DB_URL=jdbc:mariadb://127.0.0.1:3306/design_works
DB_USER=dsing_user
DB_PASS=FcfR_El21
```

**Frontend:**
```
API_BASE_URL=http://10.0.2.2:8080 (emulador)
API_BASE_URL=http://[IP_LOCAL]:8080 (dispositivo físico)
```

---

## 🎯 Próximos Pasos

1. **Entrega Intermedia (16 de Febrero) - LISTO**:
   - ✅ Backend completamente funcional
   - ✅ Frontend completamente funcional
   - ✅ Integración completa
   - ✅ Diseño UI/UX en Figma completo

2. **Fase de Refinamiento (17 Feb - 2 Mar)**:
   - Implementar diseño final de Figma en Flutter
   - Añadir animaciones y transiciones
   - Implementar modo oscuro
   - Polish de experiencia de usuario

3. **Fase de Testing (3 Mar - 16 Mar)**:
   - Tests unitarios del backend
   - Tests de integración de endpoints
   - Tests de widgets en Flutter
   - Cobertura mínima del 60%

4. **Fase Final (17 Mar - 27 Mar)**:
   - Documentación Swagger completa
   - Optimizaciones de rendimiento
   - Documentación de usuario
   - Video demo (opcional)
   - Preparación de la defensa

---

**Última actualización**: Febrero 2026  
**Autor**: Luis Imaicela  
**Proyecto**: DesignWorks - Proyecto Final DAM 2025/2026