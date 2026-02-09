package com.designworks.backend.exceptions;

/**
 * Excepción personalizada para recursos no encontrados.
 * Se lanza cuando se busca un recurso (Trabajo, Usuario, etc.) que no existe en la base de datos.
 * Retorna un código HTTP 404 (Not Found) cuando es capturada por GlobalExceptionHandler.
 */
public class ResourceNotFoundException extends RuntimeException {
    
    /**
     * Constructor básico con mensaje personalizado
     * @param message Mensaje descriptivo del error
     */
    public ResourceNotFoundException(String message) {
        super(message);
    }
    
    /**
     * Constructor con formato automático para recursos por ID
     * @param resource Nombre del recurso (ej: "Trabajo", "Usuario")
     * @param id ID del recurso que no fue encontrado
     * Ejemplo: new ResourceNotFoundException("Trabajo", 123L) 
     *          → "Trabajo con id 123 no encontrado"
     */
    public ResourceNotFoundException(String resource, Long id) {
        super(String.format("%s con id %d no encontrado", resource, id));
    }
}