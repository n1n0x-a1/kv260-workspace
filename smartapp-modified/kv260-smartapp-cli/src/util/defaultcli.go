package util

import (
	"flag"
	"fmt"
)

type DefaultCommand struct {
	Subcommand
}

func NewDefaultCommand() *DefaultCommand {
	dc := &DefaultCommand{
		initSubcommand(flag.NewFlagSet("", flag.ContinueOnError)),
	}

	dc.Subcommand.fs.Bool("help", false, "Show help")
	dc.Subcommand.fs.Bool("version", false, "Show version")
	return dc
}

func (g *Subcommand) ShowVersion() string {
	return g.version
}

func (g *Subcommand) HelpAll(a ...[]Runner) {
	fmt.Println("ninoctl is a command line interface for AI automation on Xilinx FPGA")
	fmt.Println("Usage ninoctl [subcommand] [flags]")

	for _, cmd := range a[0] {
		cmd.Help()
		if cmd.Name() == "model" {
			for _, subcmd := range a[1] {
				print(" ")
				subcmd.Help()
			}
		}
	}
}
