package util

import (
	"errors"
	"flag"
	"fmt"
	"os"
)

var version string = "v0.1.1"

// model example argument provide by user:
// quantize
// --model_name -> "model_best"
// --data_dir -> "/home/workspace/ALLFORDEMO/imagenet"
// --model_dir -> "/home/workspace/ALLFORDEMO"

// compile
// -x -> "/home/workspace/quantize_result/ResNet_int.xmodel"
// -a -> "/home/workspace/arch.json"
// -o -> "/home/workspace/quantize_result/"
// -n -> "my_model"

// deploy
// --model -> "my_model" (provide final model name that will be the name of xmodel)

type Subcommand struct {
	fs      *flag.FlagSet
	version string
	help    bool
}

func initSubcommand(fs *flag.FlagSet) Subcommand {
	s := Subcommand{}
	s.fs = fs
	s.version = version
	s.help = false
	return s
}

func (g *Subcommand) Name() string {
	return g.fs.Name()
}

func (g *Subcommand) Init(args []string) error {
	return g.fs.Parse(args)
}

func (g *Subcommand) Flag() *flag.FlagSet {
	return g.fs
}

func (g *Subcommand) Help() {
	g.fs.Usage()
}

type Runner interface {
	ListBitstream()
	UnloadBitream()
	LoadBitstream(string)
	QuantizedModel(string, string, string) error
	CompileModel(string, string, string, string) error
	DeployModel(string) error
	ConfigureApp()
	RunApp(string)
	Name() string
	Init([]string) error
	Help()
	HelpAll(...[]Runner)
	ShowVersion() string
	Flag() *flag.FlagSet
}

func helper_isFlagPassed(f *flag.FlagSet, name string) bool {
	found := false
	f.Visit(func(f *flag.Flag) {
		if f.Name == name {
			found = true
		}
	})
	return found
}

func helper_FlagStringValue(f *flag.FlagSet, name string) string {
	s := ""
	f.Visit(func(f *flag.Flag) {
		if f.Name == name {
			s = f.Value.String()
		}
	})
	return s
}

func bool2int(b bool) int {
	if b {
		return 1
	}
	return 0
}

func contains(s []string, str string) bool {
	for _, v := range s {
		if v == str {
			return true
		}
	}
	return false
}

func Root(args []string) error {
	if len(args) < 1 {
		return errors.New("You must pass a command")
	}

	var dc = NewDefaultCommand()
	var bc = NewBitstreamCommand()
	var mc = NewModelCommand()
	var ac = NewAppCommand()

	cmds := []Runner{dc, mc, bc, ac}

	sub_cmds := []Runner{mc.quant, mc.compile, mc.deploy}

	set_parse := false

	// command: "", "bitstream", "model", "app"
	// model has subcommand: "quantize", "compile", "deploy"
	// General guidelines:
	// 1. check minimum args len > 0
	// 2. check if all argument are parsed and matched
	// 3. check flag associated with functionality is equal to 1 (only one function will be executed at a time)
	// 4. call the associated function with updated flag argument
	for _, cmd := range cmds {
		firstArg := os.Args[1]
		if firstArg == cmd.Name() {

			if len(os.Args[2:]) < 1 {
				cmd.Help()
				return errors.New("Not enough arguments")
			}

			switch firstArg {
			case "bitstream":

				if cmd.Init(os.Args[2:]) != nil {
					return errors.New("Argument not identified")
				}

				load := helper_isFlagPassed(cmd.Flag(), "load")
				unload := helper_isFlagPassed(cmd.Flag(), "unload")
				list := helper_isFlagPassed(cmd.Flag(), "list")

				if bool2int(load)+bool2int(unload)+bool2int(list) != 1 {
					cmd.Help()
					return errors.New("too many or too few flags")
				} else {
					set_parse = true
					if unload {
						cmd.UnloadBitream()
					} else if load {
						s := helper_FlagStringValue(cmd.Flag(), "load")
						cmd.LoadBitstream(s)
					} else {
						cmd.ListBitstream()
					}
					break
				}
			case "app":
				if cmd.Init(os.Args[2:]) != nil {
					return errors.New("Argument not identified")
				}

				config := helper_isFlagPassed(cmd.Flag(), "configure")
				run := helper_isFlagPassed(cmd.Flag(), "run")

				if bool2int(config)+bool2int(run) != 1 {
					cmd.Help()
					return errors.New("too many or too few flags")
				} else {
					set_parse = true
					if config {
						cmd.ConfigureApp()
					} else {
						s := helper_FlagStringValue(cmd.Flag(), "run")
						cmd.RunApp(s)
					}
					break
				}
			case "model":

				command := []string{"quantize", "compile", "deploy"}
				subcommand := os.Args[2]

				if !contains(command, subcommand) {
					cmd.HelpAll(cmds, sub_cmds)
					return errors.New("provide invalid subcommand or argument")
				} else {
					set_parse = true
					if subcommand == "quantize" {
						var s_flagset = Runner(mc.quant)
						if s_flagset.Init(os.Args[3:]) != nil {
							return errors.New("Argument not identified")
						}
						float_model := helper_FlagStringValue(s_flagset.Flag(), "model_name")
						data_dir := helper_FlagStringValue(s_flagset.Flag(), "data_dir")
						float_dir := helper_FlagStringValue(s_flagset.Flag(), "model_dir")
						cmd.QuantizedModel(float_model, data_dir, float_dir)
					} else if subcommand == "compile" {
						var s_flagset = Runner(mc.compile)
						if s_flagset.Init(os.Args[3:]) != nil {
							return errors.New("Argument not identified")
						}
						xmodel := helper_FlagStringValue(s_flagset.Flag(), "x")
						arch_json := helper_FlagStringValue(s_flagset.Flag(), "a")
						quant_output := helper_FlagStringValue(s_flagset.Flag(), "o")
						quant_model := helper_FlagStringValue(s_flagset.Flag(), "n")
						cmd.CompileModel(xmodel, arch_json, quant_output, quant_model)
					} else {
						var s_flagset = Runner(mc.deploy)
						if s_flagset.Init(os.Args[3:]) != nil {
							return errors.New("Argument not identified")
						}
						deploy_model := helper_FlagStringValue(s_flagset.Flag(), "model")
						cmd.DeployModel(deploy_model)
					}
					break
				}
			}
		} else if cmd.Name() == "" && cmd.Init(os.Args[1:]) == nil && cmd.Flag().NArg() == 0 {
			set_parse = true
			help := helper_isFlagPassed(cmd.Flag(), "help")
			version := helper_isFlagPassed(cmd.Flag(), "version")

			if bool2int(help)+bool2int(version) != 1 {
				return errors.New("too many or too few arguments")
			} else if help {
				cmd.HelpAll(cmds, sub_cmds)
			} else {
				fmt.Println(cmd.ShowVersion())
			}
			break
		} else {
			continue
		}
	}

	if set_parse {
		return nil
	} else {
		return errors.New("Unable to recognize arguments. Please use -help to check the command")
	}
}
