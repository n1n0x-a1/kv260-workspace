package util

import (
	"flag"
	"fmt"
)

// Expect pytorch input

type ModelCommand struct {
	Subcommand
	quant   *QuantSubcommand
	compile *CompileSubcommand
	deploy  *DeploySubcommand
}

type QuantSubcommand struct {
	Subcommand
	model_name string
	data_dir   string
	model_dir  string
}

type CompileSubcommand struct {
	Subcommand
	x string
	a string
	o string
	n string
}

type DeploySubcommand struct {
	Subcommand
	model string
}

func NewModelCommand() *ModelCommand {
	bc := &ModelCommand{
		initSubcommand(flag.NewFlagSet("model", flag.ContinueOnError)),
		&QuantSubcommand{initSubcommand(flag.NewFlagSet("quantize", flag.ContinueOnError)), "", "", ""},
		&CompileSubcommand{initSubcommand(flag.NewFlagSet("compile", flag.ContinueOnError)), "", "", "", ""},
		&DeploySubcommand{initSubcommand(flag.NewFlagSet("deploy", flag.ContinueOnError)), ""},
	}
	bc.quant.fs.StringVar(&bc.quant.model_name, "model_name", "", "float model to be quantized")
	bc.quant.fs.StringVar(&bc.quant.data_dir, "data_dir", "", "path to training/validation dataset")
	bc.quant.fs.StringVar(&bc.quant.model_dir, "model_dir", "", "path to the directory containing float model")

	bc.compile.fs.StringVar(&bc.compile.x, "x", "", "path to quantized xmodel")
	bc.compile.fs.StringVar(&bc.compile.a, "a", "arch.json", "path to arch.json")
	bc.compile.fs.StringVar(&bc.compile.o, "o", "", "path to the directory for generated output")
	bc.compile.fs.StringVar(&bc.compile.o, "n", "", "name of compiled model")

	bc.deploy.fs.StringVar(&bc.deploy.model, "model", "", "path to packaged model directory")

	return bc
}

func (g *Subcommand) QuantizedModel(model_name string, data_dir string, model_dir string) error {
	// (input) .pth .pth.tar -> output_dir "*.py", "meta.json"
	// --data_dir, --model_dir
	// -deploy -> .onnx .xmodel

	fmt.Println("Beginning generate quantize model...")
	quant_command := fmt.Sprintf("python -u /home/workspace/src/Vitis-AI-Quantizer/vai_q_pytorch/example/resnet18_quant.py --quant_mode calib --data_dir  %s --model_dir %s --model_name %s", data_dir, model_dir, model_name)
	tcp_client("10.1.2.147:8082", quant_command)
	fmt.Println("Finished quantizing")

	fmt.Println("Beginning generate xmodel and onnx...")
	deploy_command := fmt.Sprintf("python /home/workspace/src/Vitis-AI-Quantizer/vai_q_pytorch/example/resnet18_quant.py --quant_mode test --model_dir %s --data_dir %s --subset_len 1 --batch_size 1 --deploy", model_dir, data_dir)
	tcp_client("10.1.2.147:8082", deploy_command)
	fmt.Println("xmodel and onnx generated")
	return nil
}

func (g *Subcommand) CompileModel(xmodel_path string, arch_path string, out_dir string, out_model string) error {
	fmt.Println("This will compile model")

	compile_command := fmt.Sprintf("vai_c_xir -x %s -a %s -o %s -n %s", xmodel_path, arch_path, out_dir, out_model)

	tcp_client("10.1.2.147:8082", compile_command)

	return nil
}

func (g *Subcommand) DeployModel(dirname string) error {
	// send xmutil loadapp <bitstream>
	rm := fmt.Sprintf("rm -rf /home/workspace/%s", dirname)
	mkdir := fmt.Sprintf("mkdir /home/workspace/%s", dirname)
	cp_xmodel := fmt.Sprintf("cp /home/workspace/quantize_result/%s.xmodel %s", dirname, dirname)
	cp_meta := fmt.Sprintf("cp /home/workspace/quantize_result/meta.json %s", dirname)
	cp_md5sum := fmt.Sprintf("cp /home/workspace/quantize_result/md5sum.txt %s", dirname)
	cp_proto := fmt.Sprintf("cp /home/workspace/*.prototxt %s", dirname)
	deploy_model := fmt.Sprintf("scp -r /home/workspace/%s /opt/xilinx/kv260-vvas-sms/models.b3136/", dirname)
	tcp_client("10.1.2.147:8082", rm)
	tcp_client("10.1.2.147:8082", mkdir)
	tcp_client("10.1.2.147:8082", cp_xmodel)
	tcp_client("10.1.2.147:8082", cp_meta)
	tcp_client("10.1.2.147:8082", cp_md5sum)
	tcp_client("10.1.2.147:8082", cp_proto)
	tcp_client("10.1.2.147:8082", deploy_model)

	fmt.Println("Model deployed to target")

	return nil
}
