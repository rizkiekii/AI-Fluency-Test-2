package config

import "time"

type App struct {
	ServiceName     string
	HTTPAddress     string
	ShutdownTimeout time.Duration
}

func Load() App {
	return App{
		ServiceName:     "be-task-1-go",
		HTTPAddress:     "0.0.0.0:8585",
		ShutdownTimeout: 10 * time.Second,
	}
}
