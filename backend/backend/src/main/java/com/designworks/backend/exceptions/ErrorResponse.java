package com.designworks.backend.exceptions;

import java.time.LocalDateTime;

/**
 * Clase que representa la estructura estándar de respuesta para errores en la API.
 * Proporciona un formato JSON consistente para todos los errores.
 * 
 * Ejemplo de respuesta JSON:
 * {
 *   "timestamp": "2026-02-09T10:30:45",
 *   "status": 404,
 *   "error": "Not Found",
 *   "message": "Trabajo con id 123 no encontrado",
 *   "path": "/trabajos/123"
 * }
 */
public class ErrorResponse {
    
    /** Momento exacto en que ocurrió el error */
    private LocalDateTime timestamp;
    
    /** Código HTTP del error (404, 409, 400, 401, 500, etc.) */
    private int status;
    
    /** Nombre descriptivo del tipo de error (Not Found, Conflict, etc.) */
    private String error;
    
    /** Mensaje detallado explicando qué salió mal */
    private String message;
    
    /** Ruta del endpoint donde ocurrió el error */
    private String path;
    
    /**
     * Constructor que inicializa la respuesta de error
     * @param status Código HTTP (ej: 404, 400, 500)
     * @param error Tipo de error (ej: "Not Found", "Bad Request")
     * @param message Descripción del error
     * @param path URL del endpoint que falló
     */
    public ErrorResponse(int status, String error, String message, String path) {
        this.timestamp = LocalDateTime.now(); // Captura el momento actual automáticamente
        this.status = status;
        this.error = error;
        this.message = message;
        this.path = path;
    }
    
    // Getters - necesarios para que Spring Boot convierta esto a JSON
    
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    
    public int getStatus() {
        return status;
    }
    
    public String getError() {
        return error;
    }
    
    public String getMessage() {
        return message;
    }
    
    public String getPath() {
        return path;
    }
}