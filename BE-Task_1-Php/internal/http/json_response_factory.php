<?php

declare(strict_types=1);

namespace App\Internal\Http;

use Psr\Http\Message\ResponseInterface;
use React\Http\Message\Response;

final class JsonResponseFactory
{
    public function create(int $statusCode, array $payload, array $headers = []): ResponseInterface
    {
        $json = json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

        if ($json === false) {
            $json = '{"status":"error","error":{"code":"encoding_failed","message":"Unable to encode response."}}';
            $statusCode = 500;
        }

        return new Response(
            $statusCode,
            [
                'Content-Type' => 'application/json; charset=utf-8',
            ] + $headers,
            $json,
        );
    }
}
