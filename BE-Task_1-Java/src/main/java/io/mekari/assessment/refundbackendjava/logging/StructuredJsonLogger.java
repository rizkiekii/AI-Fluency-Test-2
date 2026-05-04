package io.mekari.assessment.refundbackendjava.logging;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.mekari.assessment.refundbackendjava.web.RequestContextHolder;
import java.io.PrintStream;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class StructuredJsonLogger {
    private static final Set<String> SENSITIVE_FIELDS = Set.of("authorization", "override_token");

    private final ObjectMapper objectMapper;
    private final String serviceName;
    private final PrintStream stdout;
    private final PrintStream stderr;

    public StructuredJsonLogger(
        ObjectMapper objectMapper,
        @Value("${spring.application.name}") String serviceName
    ) {
        this.objectMapper = objectMapper;
        this.serviceName = serviceName;
        this.stdout = System.out;
        this.stderr = System.err;
    }

    public void info(String event, Map<String, Object> fields) {
        write(stdout, "info", event, fields);
    }

    public void error(String event, Map<String, Object> fields) {
        write(stderr, "error", event, fields);
    }

    private void write(PrintStream destination, String level, String event, Map<String, Object> fields) {
        Map<String, Object> record = new LinkedHashMap<>();
        record.put("timestamp", Instant.now().toString());
        record.put("level", level);
        record.put("service", serviceName);
        record.put("event", event);

        String requestId = RequestContextHolder.getRequestId();
        String traceId = RequestContextHolder.getTraceId();
        if (requestId != null && !requestId.isBlank()) {
            record.put("request_id", requestId);
        }
        if (traceId != null && !traceId.isBlank()) {
            record.put("trace_id", traceId);
        }

        for (Map.Entry<String, Object> entry : fields.entrySet()) {
            if (!SENSITIVE_FIELDS.contains(entry.getKey().toLowerCase())) {
                record.put(entry.getKey(), entry.getValue());
            }
        }

        try {
            destination.println(objectMapper.writeValueAsString(record));
        } catch (JsonProcessingException exception) {
            destination.println(
                String.format(
                    "{\"level\":\"error\",\"event\":\"logger_encoding_failed\",\"service\":\"%s\",\"error\":\"%s\"}",
                    serviceName,
                    exception.getMessage()
                )
            );
        }
    }
}
