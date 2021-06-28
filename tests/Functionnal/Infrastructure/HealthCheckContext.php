<?php

declare(strict_types=1);

namespace App\Tests\Functionnal\Infrastructure;

use Behat\Behat\Context\Context;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Webmozart\Assert\Assert;
use Symfony\Component\HttpKernel\KernelInterface;

final class HealthCheckContext implements Context
{
    const HEALTH_CHECK_PATH = '/healthcheck';

    private ?Response $response;

    private KernelInterface $kernel;

    public function __construct(KernelInterface $kernel)
    {
        $this->kernel = $kernel;
    }

    /**
     * @When I check the health of my application
     */
    public function whenICyheckTheHealthOfMyApplication(): void
    {
        $this->response = $this->kernel->handle(
            Request::create(self::HEALTH_CHECK_PATH, 'GET')
        );
    }

    /**
     * @Then I know that my application is ok
     */
    public function thenIKnowThatMyApplicationIsOk(): void
    {
        $decodedResponse = \json_decode($this->response->getContent());
        Assert::notEmpty($decodedResponse);
        Assert::eq($decodedResponse->status, 'ok');
    }
}
