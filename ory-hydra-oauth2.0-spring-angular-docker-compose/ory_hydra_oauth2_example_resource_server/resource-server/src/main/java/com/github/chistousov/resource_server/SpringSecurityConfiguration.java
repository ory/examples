package com.github.chistousov.resource_server;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;

@OpenAPIDefinition(info = @Info(description = "Example resource server"), security = {
    @SecurityRequirement(name = "Introspect OAuth 2.0")
})
@SecurityScheme(name = "Introspect OAuth 2.0", scheme = "bearer", type = SecuritySchemeType.HTTP, bearerFormat = "opaque token", in = SecuritySchemeIn.HEADER)
@Configuration
@EnableWebFluxSecurity
public class SpringSecurityConfiguration {

  @Bean
  public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
    http
        .authorizeExchange(
            ex -> ex
                .pathMatchers("/actuator/health", "/v3/api-docs/**", "/webjars/swagger-ui/**")
                .permitAll()
                .pathMatchers("/statistics")
                .hasAuthority("SCOPE_read")
                .pathMatchers("/calculate")
                .hasAuthority("SCOPE_write"))
        .csrf(csrf -> csrf.disable())
        .oauth2ResourceServer()
        .opaqueToken();

    return http.build();
  }

}
