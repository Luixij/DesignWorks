package com.designworks.backend.exceptions;

/**
 * Excepción personalizada para recursos duplicados.
 * Se lanza cuando se intenta crear un recurso que ya existe (ej: email duplicado, nombre único repetido).
 * Retorna un código HTTP 409 (Conflict) cuando es capturada por GlobalExceptionHandler.
 */
public class DuplicateResourceException extends RuntimeException {
    
    /**
     * Constructor con mensaje personalizado
     * @param message Mensaje descriptivo del conflicto
     * Ejemplo: new DuplicateResourceException("El email ya está registrado")
     */
    public DuplicateResourceException(String message) {
        super(message);
    }
}