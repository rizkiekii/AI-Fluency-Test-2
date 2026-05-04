<?php

declare(strict_types=1);

namespace App\Internal\Logging;

use RuntimeException;

final class JsonStreamLogger
{
    /** @var resource */
    private $stdout;

    /** @var resource */
    private $stderr;

    public function __construct(string $stdoutPath, string $stderrPath)
    {
        $stdout = fopen($stdoutPath, 'ab');
        $stderr = fopen($stderrPath, 'ab');

        if ($stdout === false || $stderr === false) {
            throw new RuntimeException('Unable to open log streams.');
        }

        $this->stdout = $stdout;
        $this->stderr = $stderr;
    }

    public function info(string $event, array $context = []): void
    {
        $this->write($this->stdout, 'info', $event, $context);
    }

    public function error(string $event, array $context = []): void
    {
        $this->write($this->stderr, 'error', $event, $context);
    }

    /**
     * @param resource $stream
     */
    private function write($stream, string $level, string $event, array $context): void
    {
        $payload = [
            'timestamp' => gmdate(DATE_ATOM),
            'level' => $level,
            'event' => $event,
        ] + $context;

        $encoded = json_encode($payload, JSON_UNESCAPED_SLASHES);
        if ($encoded === false) {
            $encoded = '{"timestamp":"' . gmdate(DATE_ATOM) . '","level":"error","event":"logging_encoding_failed"}';
        }

        fwrite($stream, $encoded . PHP_EOL);
    }
}
