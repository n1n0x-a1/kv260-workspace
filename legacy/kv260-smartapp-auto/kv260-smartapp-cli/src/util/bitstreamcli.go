package util

import (
	"flag"
	"fmt"
)

type BitstreamCommand struct {
	Subcommand
	load string
}

func NewBitstreamCommand() *BitstreamCommand {
	bc := &BitstreamCommand{
		initSubcommand(flag.NewFlagSet("bitstream", flag.ContinueOnError)),
		"",
	}

	bc.fs.Bool("list", false, "list all avaliable bitstreams")
	bc.fs.Bool("unload", false, "unload currently programmed bitsream")
	bc.fs.StringVar(&bc.load, "load", "", "load specific bitstream")

	return bc
}

func (g *Subcommand) ListBitstream() {
	fmt.Println("This is the bitstream list")
	tcp_client("10.1.2.147:8080", "xmutil listapps")
}

func (g *Subcommand) UnloadBitream() {
	fmt.Println("This will unload bitstream ... ")
	tcp_client("10.1.2.147:8080", "xmutil unloadapp")
}

func (g *Subcommand) LoadBitstream(file string) {
	// send xmutil loadapp <bitstream>
	fmt.Println("This will load bitstream")
	cmd := "xmutil loadapp " + file
	tcp_client("10.1.2.147:8080", cmd)
}
