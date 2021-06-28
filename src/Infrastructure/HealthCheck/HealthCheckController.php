<?php

namespace App\Infrastructure\HealthCheck;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;

class HealthCheckController extends AbstractController
{
    public function __invoke(): Response
    {
        return $this->json(['status' => 'ok']);
    }
}