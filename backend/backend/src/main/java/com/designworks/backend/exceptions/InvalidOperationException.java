package com.designworks.backend.exceptions;

/**
 * Excepción personalizada para operaciones de negocio inválidas.
 * Se lanza cuando una operación no puede completarse por violar reglas de negocio.
 * Ejemplos: cambiar estado de trabajo de forma inválida, realizar una acción no permitida.
 * Retorna un código HTTP 400 (Bad Request) cuando es capturada por GlobalExceptionHandler.
 */
public class InvalidOperationException extends RuntimeException {
    
    /**
     * Constructor con mensaje personalizado
     * @param message Mensaje que explica por qué la operación es inválida
     * Ejemplo: new InvalidOperationException("No se puede cambiar de estado FINALIZADO a EN_PROCESO")
     */
    public InvalidOperationException(String message) {
        super(message);
    }
}