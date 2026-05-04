<?php

declare(strict_types=1);

$appEnv = getenv('APP_ENV') ?: 'dev';
$appName = getenv('APP_NAME') ?: 'refund-backend-php-react';
$appVersion = getenv('APP_VERSION') ?: '1.0.0';
$appHost = getenv('APP_HOST') ?: '0.0.0.0';
$appPort = (int) (getenv('APP_PORT') ?: '8585');

return [
    'application' => [
        'service_name' => $appName,
        'version' => $appVersion,
        'environment' => $appEnv,
        'php_constraint' => '^8.5',
        'runtime_baseline' => 'ReactPHP with explicit wiring and PSR HTTP messages',
    ],
    'server' => [
        'host' => $appHost,
        'port' => $appPort,
    ],
    'logging' => [
        'stdout' => 'php://stdout',
        'stderr' => 'php://stderr',
    ],
    'clock' => [
        'timezone' => 'UTC',
    ],
];
