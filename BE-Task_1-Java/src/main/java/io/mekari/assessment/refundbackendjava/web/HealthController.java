package io.mekari.assessment.refundbackendjava.web;

import io.mekari.assessment.refundbackendjava.logging.StructuredJsonLogger;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
    private final StructuredJsonLogger logger;
    private final String serviceName;

    public HealthController(
        StructuredJsonLogger logger,
        @Value("${spring.application.name}") String serviceName
    ) {
        this.logger = logger;
        this.serviceName = serviceName;
    }

    @GetMapping("/healthz")
    public Map<String, Object> healthz() {
        logger.info("health_check_requested", Map.of("path", "/healthz"));

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "ok");
        body.put("service", serviceName);
        body.put("request_id", RequestContextHolder.getRequestId());
        body.put("trace_id", RequestContextHolder.getTraceId());
        body.put("timestamp", Instant.now().toString());
        return body;
    }
}
