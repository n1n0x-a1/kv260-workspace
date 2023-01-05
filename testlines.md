# Test lines

## default

```bash 
ninoctl

ninoctl -FLAGS
```


## model quantize

**Standard**
```bash
ninoctl model quantize -model_name model_best -data_dir /home/workspace/ALLFORDEMO/imagenet -model_dir /home/workspace/ALLFORDEMO

ninoctl model compile -x /home/workspace/quantize_result/ResNet_int.xmodel -a /home/workspace/arch.json -o /home/workspace/quantize_result/ -n my_model

ninoctl model deploy -dirname quantize_result -modelname my_model
```

**Test Lines**
```
ninoctl model #{ nothing follows, permutation of flags}
ninoctl model -SOMEFLAGS

ninoctl model quantize #{nothing follows, permutation of flags}
ninoctl model compile #{nothing follows, permutation of flags}
ninoctl model deploy #{nothing follows, permutation of flags}
```

**Note**
- Any modification in server.py will apply AFTER the pod restart.
