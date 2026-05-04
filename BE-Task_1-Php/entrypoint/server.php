<?php

declare(strict_types=1);

use App\Internal\Application\HealthCheckService;
use App\Internal\Http\JsonResponseFactory;
use App\Internal\Logging\Events;
use App\Internal\Logging\JsonStreamLogger;
use App\Internal\Repository\Memory\AgentRepository;
use App\Internal\Repository\Memory\PurchaseRepository;
use App\Internal\Repository\Memory\RefundRepository;
use App\Internal\Repository\Memory\Seed;
use App\Internal\Repository\Memory\Store;
use App\Internal\Repository\Interfaces\AgentRepositoryInterface;
use App\Internal\Repository\Interfaces\PurchaseRepositoryInterface;
use App\Internal\Repository\Interfaces\RefundRepositoryInterface;
use App\Internal\Transport\Http\Middleware\ErrorMapping;
use App\Internal\Transport\Http\Middleware\RequestContext;
use App\Internal\Transport\Http\Router;
use Psr\Http\Message\ServerRequestInterface;
use React\Http\HttpServer;
use React\Socket\SocketServer;

function buildRouter(
    array $config,
    JsonStreamLogger $logger,
    JsonResponseFactory $responses,
    RequestContext $requestContext,
    ErrorMapping $errorMapping,
    HealthCheckService $healthCheckService,
    AgentRepositoryInterface $agents,
    PurchaseRepositoryInterface $purchases,
    RefundRepositoryInterface $refunds,
): Router {
    $refundServiceClass = 'App\\Internal\\Application\\RefundService';
    $refundHandlerClass = 'App\\Internal\\Transport\\Http\\RefundHandler';

    if (class_exists($refundServiceClass) && class_exists($refundHandlerClass)) {
        $refundService = new $refundServiceClass(
            $agents,
            $purchases,
            $refunds,
            static fn(): \DateTimeImmutable => new \DateTimeImmutable('now', new \DateTimeZone('UTC')),
            static function (): string {
                try {
                    return 'REF-' . strtoupper(bin2hex(random_bytes(8)));
                } catch (\Throwable) {
                    return 'REF-' . str_replace('.', '', uniqid('', true));
                }
            },
        );

        $refundHandler = new $refundHandlerClass(
            $responses,
            $refundService,
            $logger,
            $config,
        );

        return new Router(
            $responses,
            $requestContext,
            $errorMapping,
            $healthCheckService,
            $refundHandler,
            $config,
        );
    }

    return new Router(
        $responses,
        $requestContext,
        $errorMapping,
        $healthCheckService,
        $config,
    );
}

$root = dirname(__DIR__);
$autoloadPath = $root . '/vendor/autoload.php';

if (!file_exists($autoloadPath)) {
    fwrite(STDERR, "Composer dependencies are missing. Run 'composer install' first.\n");
    exit(1);
}

require_once $autoloadPath;

$config = require $root . '/config/app.php';
date_default_timezone_set($config['clock']['timezone']);

$logger = new JsonStreamLogger($config['logging']['stdout'], $config['logging']['stderr']);
$store = new Store();
$startupReference = new \DateTimeImmutable('now', new \DateTimeZone('UTC'));
Seed::apply($store, $startupReference);

$agents = new AgentRepository($store);
$purchases = new PurchaseRepository($store);
$refunds = new RefundRepository($store);

$healthCheckService = new HealthCheckService(
    $config,
    $agents,
    $purchases,
    $refunds,
    $startupReference,
);

$responses = new JsonResponseFactory();
$requestContext = new RequestContext();
$errorMapping = new ErrorMapping($responses, $logger);

$router = buildRouter(
    $config,
    $logger,
    $responses,
    $requestContext,
    $errorMapping,
    $healthCheckService,
    $agents,
    $purchases,
    $refunds,
);

$server = new HttpServer(
    static fn(ServerRequestInterface $request) => $router->handle($request),
);

$address = sprintf('%s:%d', $config['server']['host'], $config['server']['port']);
$socket = new SocketServer($address);
$server->listen($socket);

$logger->info(Events::APPLICATION_STARTED, [
    'service' => $config['application']['service_name'],
    'version' => $config['application']['version'],
    'environment' => $config['application']['environment'],
    'listen_address' => $address,
]);

if (function_exists('pcntl_async_signals') && function_exists('pcntl_signal')) {
    pcntl_async_signals(true);

    $shutdown = static function (int $signal) use ($logger, $socket): void {
        $logger->info(Events::APPLICATION_STOPPED, ['signal' => $signal]);
        $socket->close();
        exit(0);
    };

    pcntl_signal(SIGINT, $shutdown);
    pcntl_signal(SIGTERM, $shutdown);
}