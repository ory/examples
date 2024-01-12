package com.github.chistousov.write_and_read_backend;

import java.util.Arrays;
import java.util.stream.Collectors;

import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.SecurityWebFiltersOrder;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.oauth2.client.registration.ReactiveClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestCustomizers;
import org.springframework.security.oauth2.client.web.reactive.function.client.ServerOAuth2AuthorizedClientExchangeFilterFunction;
import org.springframework.security.oauth2.client.web.server.DefaultServerOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.server.ServerOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.server.ServerOAuth2AuthorizedClientRepository;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.csrf.CookieServerCsrfTokenRepository;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.chistousov.write_and_read_backend.security.auth.logout.success_handlers.CustomServerLogoutSuccessHandler;
import com.github.chistousov.write_and_read_backend.security.auth.oauth2.handlers.CustomServerAuthenticationFailureHandler;
import com.github.chistousov.write_and_read_backend.security.filters.AuthenticateFrontendWebFilter;
import com.github.chistousov.write_and_read_backend.security.filters.IsAuthenticatedCheckWebFilter;

@EnableWebFluxSecurity
public class SpringSecurityConfiguration {

  private String pathFrontendErrorPage;
  private String pathReauthenticationLocation;

  public SpringSecurityConfiguration(Environment env) {

    String clientId = env.getRequiredProperty(
        "spring.security.oauth2.client.registration.client-write-and-read.client-id");

    this.pathReauthenticationLocation = Arrays.asList(
        "oauth2",
        "authorization",
        clientId)
        .stream()
        .collect(Collectors.joining("/"));

    this.pathFrontendErrorPage = env.getRequiredProperty(
        "application.frontend.error-oauth2-page");

  }

  @Bean
  public SecurityWebFilterChain settingsSec(ServerHttpSecurity http,
      ServerOAuth2AuthorizationRequestResolver resolver) throws JsonProcessingException {
    return http.authorizeExchange(
        ex -> ex.pathMatchers("/actuator/health")
            .permitAll()
            // все запросы должны быть аутентифицированы
            .anyExchange()
            .authenticated()

    )
        // CSRF для SPA приложений
        .csrf(csrf -> csrf.csrfTokenRepository(
            CookieServerCsrfTokenRepository.withHttpOnlyFalse()))
        .oauth2Login()
        .authorizationRequestResolver(resolver)
        .authenticationFailureHandler(
            new CustomServerAuthenticationFailureHandler(pathFrontendErrorPage,
                pathReauthenticationLocation))
        .and()
        // конфигурация logout
        .logout()
        .logoutSuccessHandler(new CustomServerLogoutSuccessHandler())
        .and()
        .addFilterBefore(new IsAuthenticatedCheckWebFilter(),
            SecurityWebFiltersOrder.HTTP_BASIC)
        .addFilterBefore(new AuthenticateFrontendWebFilter(),
            SecurityWebFiltersOrder.HTTP_BASIC)
        .build();
  }

  @Bean
  public ServerOAuth2AuthorizationRequestResolver pkceResolver(ReactiveClientRegistrationRepository repo) {
    var resolver = new DefaultServerOAuth2AuthorizationRequestResolver(repo);
    resolver.setAuthorizationRequestCustomizer(OAuth2AuthorizationRequestCustomizers.withPkce());
    return resolver;
  }

  @Bean
  WebClient webClient(ReactiveClientRegistrationRepository clientRegistrations,
      ServerOAuth2AuthorizedClientRepository authorizedClients) {
    ServerOAuth2AuthorizedClientExchangeFilterFunction oauth = new ServerOAuth2AuthorizedClientExchangeFilterFunction(
        clientRegistrations,
        authorizedClients);
    return WebClient.builder()
        .filter(oauth)
        .build();
  }
}
