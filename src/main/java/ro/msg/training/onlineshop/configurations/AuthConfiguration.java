package ro.msg.training.onlineshop.configurations;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;

@Configuration
@RequiredArgsConstructor
public class AuthConfiguration {

    @Bean
    public UserDetailsService users(PasswordEncoder encoder) {
        UserDetails user = User.builder()
                .username("user")
                .password(encoder.encode("password"))
                .roles("USER")
                .build();
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http.cors()
                .and().csrf()
                .disable()
                .authorizeRequests()
                .antMatchers("/api/**")
                .hasRole("USER")
                .anyRequest()
                .permitAll()
                .and()
                .formLogin()
                .loginProcessingUrl("/login")
                .usernameParameter("username")
                .passwordParameter("password")
                .successHandler((req, res, auth) -> res.setStatus(200))
                .failureHandler((req, res, auth) -> res.setStatus(401))
                .and()
                .exceptionHandling()
                .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
                .and().build();
    }
}
