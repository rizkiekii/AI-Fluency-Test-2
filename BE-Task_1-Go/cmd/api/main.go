package main

import (
	"fmt"
	"os"

	"gotest/entrypoint"
)

func main() {
	if err := entrypoint.Run(); err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "server failed: %v\n", err)
		os.Exit(1)
	}
}
