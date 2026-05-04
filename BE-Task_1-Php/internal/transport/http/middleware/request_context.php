<?php

declare(strict_types=1);

namespace App\Internal\Transport\Http\Middleware;

use Psr\Http\Message\ServerRequestInterface;

final class RequestContext
{
    public function create(ServerRequestInterface $request): array
    {
        $requestId = trim($request->getHeaderLine('X-Request-Id'));
        $traceId = trim($request->getHeaderLine('X-Trace-Id'));

        return [
            'request_id' => $requestId !== '' ? $requestId : $this->generateRequestId(),
            'trace_id' => $traceId !== '' ? $traceId : null,
            'request_method' => strtoupper($request->getMethod()),
            'request_path' => $request->getUri()->getPath(),
            'received_at' => gmdate(DATE_ATOM),
        ];
    }

    private function generateRequestId(): string
    {
        try {
            return bin2hex(random_bytes(16));
        } catch (\Throwable) {
            return str_replace('.', '', uniqid('', true));
        }
    }
}
