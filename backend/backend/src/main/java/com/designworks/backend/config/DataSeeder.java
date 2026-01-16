package com.designworks.backend.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.designworks.backend.entities.Rol;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.UsuarioRepository;

@Configuration
public class DataSeeder implements CommandLineRunner {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (!usuarioRepository.existsByEmail("admin@designworks.com")) {
            usuarioRepository.save(Usuario.builder()
                    .nombre("Luis Admin")
                    .email("admin@designworks.com")
                    .rol(Rol.ADMIN)
                    .passwordHash(passwordEncoder.encode("Admin1234"))
                    .activo(true)
                    .build());
        }

        if (!usuarioRepository.existsByEmail("marta@designworks.com")) {
            usuarioRepository.save(Usuario.builder()
                    .nombre("Marta Diseño")
                    .email("marta@designworks.com")
                    .rol(Rol.DISENADOR)
                    .passwordHash(passwordEncoder.encode("Design1234!"))
                    .activo(true)
                    .build());
        }
    }
}