package com.designworks.backend.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Manejador global de excepciones para toda la aplicación.
 * 
 * @RestControllerAdvice hace que Spring detecte automáticamente esta clase al iniciar
 * y la use para capturar excepciones lanzadas desde cualquier @RestController.
 * 
 * Centraliza el manejo de errores, evitando try-catch repetitivos en los controladores
 * y garantizando respuestas JSON consistentes.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Maneja ResourceNotFoundException (recursos no encontrados)
     * Se activa cuando se lanza: throw new ResourceNotFoundException(...)
     * Retorna: HTTP 404 Not Found
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(
            ResourceNotFoundException ex, HttpServletRequest request) {
        
        // Construye la respuesta de error con los datos de la excepción
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),  // 404
            "Not Found",
            ex.getMessage(),  // Mensaje personalizado de la excepción
            request.getRequestURI()  // Ruta donde ocurrió el error
        );
        
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    /**
     * Maneja DuplicateResourceException (recursos duplicados)
     * Se activa cuando se lanza: throw new DuplicateResourceException(...)
     * Retorna: HTTP 409 Conflict
     */
    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ErrorResponse> handleDuplicateResource(
            DuplicateResourceException ex, HttpServletRequest request) {
        
        ErrorResponse error = new ErrorResponse(
            HttpStatus.CONFLICT.value(),  // 409
            "Conflict",
            ex.getMessage(),
            request.getRequestURI()
        );
        
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    /**
     * Maneja InvalidOperationException (operaciones inválidas)
     * Se activa cuando se lanza: throw new InvalidOperationException(...)
     * Retorna: HTTP 400 Bad Request
     */
    @ExceptionHandler(InvalidOperationException.class)
    public ResponseEntity<ErrorResponse> handleInvalidOperation(
            InvalidOperationException ex, HttpServletRequest request) {
        
        ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),  // 400
            "Bad Request",
            ex.getMessage(),
            request.getRequestURI()
        );
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    /**
     * Maneja BadCredentialsException (credenciales inválidas de Spring Security)
     * Se activa automáticamente cuando falla la autenticación en login
     * Retorna: HTTP 401 Unauthorized
     */
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ErrorResponse> handleBadCredentials(
            BadCredentialsException ex, HttpServletRequest request) {
        
        ErrorResponse error = new ErrorResponse(
            HttpStatus.UNAUTHORIZED.value(),  // 401
            "Unauthorized",
            "Credenciales inválidas",  // Mensaje genérico por seguridad
            request.getRequestURI()
        );
        
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
    }

    /**
     * Maneja errores de validación de @Valid en request bodies
     * Se activa automáticamente cuando falla una validación (ej: @NotBlank, @Email)
     * Retorna: HTTP 400 Bad Request con todos los errores de validación
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationErrors(
            MethodArgumentNotValidException ex, HttpServletRequest request) {
        
        // Extrae todos los errores de validación y los concatena en un solo mensaje
        String message = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .reduce((a, b) -> a + ", " + b)  // Une múltiples errores con comas
            .orElse("Error de validación");
        
        ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),  // 400
            "Validation Error",
            message,  // Ej: "email: must not be blank, password: must not be blank"
            request.getRequestURI()
        );
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    /**
     * Maneja cualquier excepción no capturada por los handlers anteriores
     * Es el catch-all final para evitar que la aplicación exponga stack traces
     * Retorna: HTTP 500 Internal Server Error
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(
            Exception ex, HttpServletRequest request) {
        
        // IMPORTANTE: En producción, loguea ex.getMessage() para debugging
        // pero NO lo expongas al usuario por razones de seguridad
        
        ErrorResponse error = new ErrorResponse(
            HttpStatus.INTERNAL_SERVER_ERROR.value(),  // 500
            "Internal Server Error",
            "Ha ocurrido un error inesperado",  // Mensaje genérico
            request.getRequestURI()
        );
        
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}