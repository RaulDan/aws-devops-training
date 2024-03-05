package ro.msg.training.onlineshop.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class HealthController {
    private final JdbcTemplate jdbcTemplate;

    @RequestMapping(value = "/health", produces = "application/json")
    public String checkHealth() {
        jdbcTemplate.execute("SELECT 1");
        return "{}";
    }
}
