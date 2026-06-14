package main

import (
	"fmt"
	"os"

	"github.com/hhuangpen/kv260-smart-auto/ninoctl/util"
)

func main() {
	if err := util.Root(os.Args[1:]); err != nil {
		fmt.Printf("Error: %s\n", err)
		os.Exit(1)
	}
}
