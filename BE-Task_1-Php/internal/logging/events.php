<?php

declare(strict_types=1);

namespace App\Internal\Logging;

final class Events
{
    public const APPLICATION_STARTED = 'application_started';
    public const APPLICATION_STOPPED = 'application_stopped';

    public const REFUND_REQUEST_RECEIVED = 'refund_request_received';
    public const REFUND_AUTH_FAILED = 'refund_auth_failed';
    public const REFUND_VALIDATION_FAILED = 'refund_validation_failed';
    public const REFUND_PURCHASE_NOT_FOUND = 'refund_purchase_not_found';
    public const REFUND_FORBIDDEN = 'refund_forbidden';
    public const REFUND_POLICY_REJECTED = 'refund_policy_rejected';
    public const REFUND_PROCESSED = 'refund_processed';
    public const REFUND_PROCESSING_ERROR = 'refund_processing_error';
}
