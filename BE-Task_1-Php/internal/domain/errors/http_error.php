<?php

declare(strict_types=1);

namespace App\Internal\Domain\Errors;

use RuntimeException;

abstract class HttpError extends RuntimeException
{
    public function __construct(
        private readonly int $statusCode,
        private readonly string $errorCode,
        string $message,
    ) {
        parent::__construct($message);
    }

    public function statusCode(): int
    {
        return $this->statusCode;
    }

    public function errorCode(): string
    {
        return $this->errorCode;
    }
}

final class ValidationError extends HttpError
{
    public function __construct(string $message = 'Validation failed.')
    {
        parent::__construct(400, 'validation_failed', $message);
    }
}

final class UnauthorizedError extends HttpError
{
    public function __construct(string $message = 'Authentication failed.')
    {
        parent::__construct(401, 'auth_failed', $message);
    }
}

final class ForbiddenError extends HttpError
{
    public function __construct(string $message = 'Action is forbidden.')
    {
        parent::__construct(403, 'forbidden', $message);
    }
}

final class NotFoundError extends HttpError
{
    public function __construct(string $message = 'Resource not found.')
    {
        parent::__construct(404, 'not_found', $message);
    }
}

final class PolicyRejectedError extends HttpError
{
    public function __construct(string $message = 'Policy rejected the request.')
    {
        parent::__construct(422, 'policy_rejected', $message);
    }
}
