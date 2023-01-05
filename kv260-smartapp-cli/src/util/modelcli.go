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
	dirname string
	modelname string
}

func NewModelCommand() *ModelCommand {
	bc := &ModelCommand{
		initSubcommand(flag.NewFlagSet("model", flag.ContinueOnError)),
		&QuantSubcommand{initSubcommand(flag.NewFlagSet("quantize", flag.ContinueOnError)), "", "", ""},
		&CompileSubcommand{initSubcommand(flag.NewFlagSet("compile", flag.ContinueOnError)), "", "", "", ""},
		&DeploySubcommand{initSubcommand(flag.NewFlagSet("deploy", flag.ContinueOnError)), "", ""},
	}
	bc.quant.fs.StringVar(&bc.quant.model_name, "model_name", "", "float model to be quantized")
	bc.quant.fs.StringVar(&bc.quant.data_dir, "data_dir", "", "path to training/validation dataset")
	bc.quant.fs.StringVar(&bc.quant.model_dir, "model_dir", "", "path to the directory containing float model")

	bc.compile.fs.StringVar(&bc.compile.x, "x", "", "path to quantized xmodel")
	bc.compile.fs.StringVar(&bc.compile.a, "a", "arch.json", "path to arch.json")
	bc.compile.fs.StringVar(&bc.compile.o, "o", "", "path to the directory for generated output")
	bc.compile.fs.StringVar(&bc.compile.n, "n", "", "name of compiled model")

	bc.deploy.fs.StringVar(&bc.deploy.dirname, "dirname", "", "path to the packaged model")
	bc.deploy.fs.StringVar(&bc.deploy.modelname, "modelname", "", "name of the packaged model")

	return bc
}

func (g *Subcommand) QuantizedModel(model_name string, data_dir string, model_dir string) error {
	// stop empty strings
	if (len(model_name) == 0 || len(data_dir) == 0 || len(model_dir) == 0) {
	    fmt.Println("too many or too few flags")
	    return nil
	}

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
	// stop empty strings
	if (len(out_dir) == 0 || len(out_model) == 0 ) {
	    fmt.Println("too many or too few flags")
	    return nil
	}

	fmt.Println("This will compile model")

	compile_command := fmt.Sprintf("vai_c_xir -x %s -a %s -o %s -n %s", xmodel_path, arch_path, out_dir, out_model)

	tcp_client("10.1.2.147:8082", compile_command)

	return nil
}

func (g *Subcommand) DeployModel(dirname string, modelname string) error {
	// stop empty strings
	if (len(modelname) == 0) {
	    fmt.Println("too many or too few flags")
	    return nil
	}

        fmt.Println("Collecting files ...")

	rm := fmt.Sprintf("rm -rf %s", modelname)
	mkdir := fmt.Sprintf("mkdir %s", modelname)
	cp_xmodel := fmt.Sprintf("cp %s/%s.xmodel %s", dirname, modelname, modelname)
	cp_meta := fmt.Sprintf("cp %s/meta.json %s", dirname, modelname)
	cp_md5sum := fmt.Sprintf("cp %s/md5sum.txt %s", dirname, modelname)
	cp_proto := fmt.Sprintf("cp %s/*.prototxt %s", dirname, modelname)

	tcp_client("10.1.2.147:8082", rm)
	tcp_client("10.1.2.147:8082", mkdir)
	tcp_client("10.1.2.147:8082", cp_xmodel)
	tcp_client("10.1.2.147:8082", cp_meta)
	tcp_client("10.1.2.147:8082", cp_md5sum)
	tcp_client("10.1.2.147:8082", cp_proto)
////////////////////////////////////////////////////////////////////////////////////////
	fmt.Println("Deploying to kv260 ...")
        deploy_model := fmt.Sprintf("scp -r /home/workspace/%s /home/petalinux/%s", modelname, modelname)
//	deploy_model := fmt.Sprintf("scp -r /home/workspace/%s/* /opt/xilinx/kv260-vvas-sms/models.b3136", modelname, modelname)

//	rsync_model := fmt.Sprintf("rsync -avh /home/workspace/%s/ /home/petalinux/%s/", modelname, modelname)
//	to use rsync, we need to have it installed in both two sides (kv260 don't have)
//	tcp_client("10.1.2.147:8082", rsync_model)

	tcp_client("10.1.2.147:8082", deploy_model)

	fmt.Println("Processes complete.")

	return nil
}
