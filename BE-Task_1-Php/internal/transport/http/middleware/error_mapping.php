<?php

declare(strict_types=1);

namespace App\Internal\Transport\Http\Middleware;

use App\Internal\Domain\Errors\ForbiddenError;
use App\Internal\Domain\Errors\HttpError;
use App\Internal\Domain\Errors\NotFoundError;
use App\Internal\Domain\Errors\PolicyRejectedError;
use App\Internal\Domain\Errors\UnauthorizedError;
use App\Internal\Domain\Errors\ValidationError;
use App\Internal\Http\JsonResponseFactory;
use App\Internal\Logging\Events;
use App\Internal\Logging\JsonStreamLogger;
use Psr\Http\Message\ResponseInterface;
use Throwable;

final readonly class ErrorMapping
{
    public function __construct(
        private JsonResponseFactory $responses,
        private JsonStreamLogger $logger,
    ) {
    }

    public function toResponse(Throwable $exception, array $context): ResponseInterface
    {
        $statusCode = 500;
        $errorCode = 'processing_error';
        $message = 'Internal server error.';
        $event = Events::REFUND_PROCESSING_ERROR;

        if ($exception instanceof HttpError) {
            $statusCode = $exception->statusCode();
            $errorCode = $exception->errorCode();
            $message = $exception->getMessage();
            $event = match (true) {
                $exception instanceof ValidationError => Events::REFUND_VALIDATION_FAILED,
                $exception instanceof UnauthorizedError => Events::REFUND_AUTH_FAILED,
                $exception instanceof ForbiddenError => Events::REFUND_FORBIDDEN,
                $exception instanceof NotFoundError => Events::REFUND_PURCHASE_NOT_FOUND,
                $exception instanceof PolicyRejectedError => Events::REFUND_POLICY_REJECTED,
                default => Events::REFUND_PROCESSING_ERROR,
            };
        }

        $this->logger->error($event, [
            'request_id' => $context['request_id'],
            'trace_id' => $context['trace_id'],
            'error_code' => $errorCode,
            'message' => $message,
        ]);

        return $this->responses->create($statusCode, [
            'status' => 'error',
            'error' => [
                'code' => $errorCode,
                'message' => $message,
            ],
            'request_id' => $context['request_id'],
            'trace_id' => $context['trace_id'],
        ]);
    }
}
