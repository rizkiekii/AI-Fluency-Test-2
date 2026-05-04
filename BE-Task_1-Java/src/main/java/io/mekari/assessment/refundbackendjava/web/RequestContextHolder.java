package io.mekari.assessment.refundbackendjava.web;

public final class RequestContextHolder {
    private static final ThreadLocal<String> REQUEST_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> TRACE_ID = new ThreadLocal<>();

    private RequestContextHolder() {
    }

    public static void set(String requestId, String traceId) {
        REQUEST_ID.set(requestId);
        TRACE_ID.set(traceId);
    }

    public static String getRequestId() {
        return REQUEST_ID.get();
    }

    public static String getTraceId() {
        return TRACE_ID.get();
    }

    public static void clear() {
        REQUEST_ID.remove();
        TRACE_ID.remove();
    }
}
