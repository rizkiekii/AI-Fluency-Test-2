<?php

declare(strict_types=1);

namespace App\Internal\Transport\Http;

use App\Internal\Application\HealthCheckService;
use App\Internal\Http\JsonResponseFactory;
use App\Internal\Transport\Http\Middleware\ErrorMapping;
use App\Internal\Transport\Http\Middleware\RequestContext;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Throwable;

final readonly class Router
{
    public function __construct(
        private JsonResponseFactory $responses,
        private RequestContext $requestContext,
        private ErrorMapping $errorMapping,
        private HealthCheckService $healthCheckService,
        private array $config,
    ) {
    }

    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $context = $this->requestContext->create($request);

        try {
            $method = strtoupper($request->getMethod());
            $path = $request->getUri()->getPath();

            if ($method === 'GET' && $path === '/healthz') {
                return $this->responses->create(200, [
                    'status' => 'ok',
                    'service' => $this->config['application']['service_name'],
                    'request_id' => $context['request_id'],
                    'trace_id' => $context['trace_id'],
                ]);
            }

            if ($method === 'GET' && $path === '/') {
                return $this->responses->create(200, [
                    'status' => 'success',
                    'data' => $this->healthCheckService->status(),
                    'request_id' => $context['request_id'],
                    'trace_id' => $context['trace_id'],
                ]);
            }

            return $this->responses->create(404, [
                'status' => 'error',
                'error' => [
                    'code' => 'not_found',
                    'message' => 'Route not found.',
                ],
                'request_id' => $context['request_id'],
                'trace_id' => $context['trace_id'],
            ]);
        } catch (Throwable $exception) {
            return $this->errorMapping->toResponse($exception, $context);
        }
    }
}
