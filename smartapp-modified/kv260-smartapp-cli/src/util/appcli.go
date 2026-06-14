package util

import (
	"flag"
	"fmt"
)

type AppCommand struct {
	Subcommand
	run string
}

func NewAppCommand() *AppCommand {
	bc := &AppCommand{
		initSubcommand(flag.NewFlagSet("app", flag.ContinueOnError)),
		"",
	}

	bc.fs.Bool("configure", false, "configure environment setup")
	bc.fs.StringVar(&bc.run, "run", "", "run the target application")

	return bc
}

func (g *Subcommand) ConfigureApp() {
	fmt.Println("This is configure env")
	tcp_client(AppAddr(), ". /opt/xilinx/kv260-vvas-sms/app/setup.sh")
}

func (g *Subcommand) RunApp(file string) {
	// send xmutil loadapp <bitstream>
	fmt.Println("This will run app")
	cmd := "stdbuf -oL " + file
	tcp_client(AppAddr(), cmd)
}
