#!/bin/bash

ARCH=arch.json
TARGET=models.b3136
CACHE=cache

function build_model() {
	for file in `ls $1`
	do
		if [ -d $1"/"$file ];
		then
			build_model $1"/"$file
		elif [ -f $1"/"$file ];
		then
			echo "**********************************************************************"
			echo "***** $1/$file"
			echo "**********************************************************************"

			num=$(($(grep -c "type: float & quantized" $1"/"$file)+1))

			grep -m 1 "download link:" $1"/"$file | head -1 > download_list.txt
			grep -m $num "download link:" $1"/"$file | tail -1 >> download_list.txt
			sed -i 's/^.................//' download_list.txt

			grep -m 1 -r "name:" $1"/"$file | head -1 > name_list.txt
			grep -m $num -r "name:" $1"/"$file | tail -1 >> name_list.txt
			sed -i 's/^........//' name_list.txt

			grep -m 1 -r "checksum:" $1"/"$file | head -1 > checksum_list.txt
			grep -m $num -r "checksum:" $1"/"$file | tail -1 >> checksum_list.txt
			sed -i 's/^............//' checksum_list.txt

			echo $1 > model_path.txt
			sed -i 's/^.............//' model_path.txt
			framework_prefix=$(cut -c1-3 model_path.txt)
                        #echo "$framework_prefix"

                        # float&quantized model
                        download1=$(sed -n '1p' download_list.txt)
			checksum1=$(sed -n '1p' checksum_list.txt)
			archive1=$(echo $download1 | cut -f2 -d=)

			file1="${CACHE}/$archive1"
			echo "$download1 => $archive1"


			# zcu and kv260 board pre-trained
			download2=$(sed -n '2p' download_list.txt)
			checksum2=$(sed -n '2p' checksum_list.txt)
			archive2=$(echo $download2 | cut -f2 -d=)

			file2="${CACHE}/$archive2"

			modelpath=$(sed -n '1p' model_path.txt)
			sourcename=$(sed -n '1p' name_list.txt)
                        netname=$(sed -n '2p' name_list.txt)

                        if [[ -d "${TARGET}/$netname" ]]; then
				echo "Skipping $modelpath since ${TARGET}/$netname already exists ..."
                        else
				if [ "$framework_prefix" != "tor" ]; then
                                        if [[ -f "$file1" ]]; then
						echo "Skipping download of $archive1 since already in cache ..."
					else
						echo "Downloading $archive1 ..."
						wget $download1 -O $file1
					fi
					#check_result=`md5sum -c <<<"$checksum1 $file1"`
					#if [ "$check_result" != "$file1: OK" ]; then
	   				#	echo "md5sum check failed! Please try to download again."
	   				#	exit 1
					#else
						if [ `command -v unzip` ]; then
	      						unzip -o $file1
	   					else
	      						sudo apt install unzip
	      						unzip -o $file1
	   					fi
						#rm $file1
					#fi
					if [[ -f "$file2" ]]; then
						echo "Skipping download of $archive2 since already in cache ..."
					else
						echo "Downloading $archive2 ..."
						wget $download2 -O $file2
					fi
					tar -xvzf $file2
				else
					echo "Torchvision has no float&quantized model"
				fi


				source /opt/vitis_ai/conda/etc/profile.d/conda.sh

				echo "**************************************************"
				echo "* VITIS_AI Compilation - Start ...                "
				echo "**************************************************"

				if [ "$framework_prefix" == "tf_" ]; then
			                echo "Compiling tensorflow model $modelpath as $netname"
					conda activate vitis-ai-tensorflow2
					if [ "$modelpath" == "tf_yolov3_voc_416_416_65.63G_2.5" ]; then
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
		         				--arch ${ARCH} \
		         				--output_dir ${TARGET}/$netname \
		         				--net_name $netname \
							--options '{"input_shape": "1,416,416,3"}'
					elif [ "$modelpath" == "tf_ssdmobilenetv2_coco_300_300_3.75G_2.5" ]; then
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
		                                        --arch ${ARCH} \
		                                        --output_dir ${TARGET}/$netname \
		                                        --net_name $netname \
		                                        --options '{"input_shape": "1,300,300,3"}'
					elif [ "$modelpath" == "tf_refinedet_VOC_320_320_81.9G_2.5" ]; then
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
		                                        --arch ${ARCH} \
		                                        --output_dir ${TARGET}/$netname \
		                                        --net_name $netname \
		                                        --options '{"input_shape": "1,320,320,3"}'
					elif [ "$modelpath" == "tf_mobilenetv2_1.4_imagenet_224_224_1.16G_2.5" ]; then
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
		                                        --arch ${ARCH} \
		                                        --output_dir ${TARGET}/$netname \
		                                        --net_name $netname \
		                                        --options '{"input_shape": "1,224,224,3"}'
					elif [ "$modelpath" == "tf_inceptionv1_imagenet_224_224_3G_2.5" ]; then
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
                                                        --arch ${ARCH} \
                                                        --output_dir ${TARGET}/$netname \
                                                        --net_name $netname \
                                                        --options '{"input_shape": "1,224,224,3"}'
					else
						vai_c_tensorflow --frozen_pb $modelpath/quantized/*quantize_eval_model.pb \
		                                        --arch ${ARCH} \
		                                        --output_dir ${TARGET}/$netname \
		                                        --net_name $netname
					fi
					conda deactivate
				elif [ "$framework_prefix" == "tf2" ]; then
			                echo "Compiling tensorflow 2 model $modelpath as $netname"
					conda activate vitis-ai-tensorflow2
					if [ "$modelpath" == "tf2_mobilenetv3_imagenet_224_224_132M_2.0" ]; then
						vai_c_tensorflow2 -m $modelpath/quantized/quantized_mobilenet_v3_small_1.0.h5 \
			          			-a ${ARCH} \
			          			-o ${TARGET}/$netname \
			          			-n $netname
					else
						vai_c_tensorflow2 -m $modelpath/quantized/quantized.h5 \
			          			-a ${ARCH} \
			          			-o ${TARGET}/$netname \
			          			-n $netname
					fi
					conda deactivate
				elif [ "$framework_prefix" == "pt_" ]; then
			                echo "Compiling pytorch model $modelpath as $netname"
					conda activate vitis-ai-pytorch
					if [ "$modelpath" == "pt_resnet50_imagenet_224_224_8.2G_2.5" ]; then
						vai_c_xir -x $modelpath/qat/*int.xmodel \
		                                       -a ${ARCH} \
		                                       -o ${TARGET}/$netname \
		                                       -n $netname
					elif [ "$modelpath" == "pt_OFA-resnet50_imagenet_224_224_15G_2.5" ]; then
						vai_c_xir -x $modelpath/quantized/*int.xmodel \
		                                       -a ${ARCH} \
		                                       -o ${TARGET}/$netname \
		                                       -n $netname
					elif [ "$modelpath" == "pt_facerec-resnet20_mixed_112_96_3.5G_2.5" ]; then
                                                vai_c_xir -x $modelpath/quantized/*int.xmodel \
                                                       -a ${ARCH} \
                                                       -o ${TARGET}/$netname \
                                                       -n $netname
					elif [ "$modelpath" == "pt_face-mask-detection_512_512_0.59G_2.5" ]; then
						vai_c_xir -x $modelpath/quantized/*int.xmodel \
		                                       -a ${ARCH} \
		                                       -o ${TARGET}/$netname \
		                                       -n $netname
					else
						vai_c_xir -x $modelpath/quantized/*int.xmodel \
		                                       -a ${ARCH} \
		                                       -o ${TARGET}/$netname \
		                                       -n $netname
					fi
					conda deactivate
				elif [ "$framework_prefix" == "tor" ]; then
			                echo "WARNING : Cannot compile torchvision model $modelpath"
				else
			                echo "ERROR : Cannot compile model $modelpath"
				fi

				rm -rf $sourcename

                                # additional prep for use with vitis-ai-library
				if [[ -d "${TARGET}/$netname" ]]; then
					# remove unused _org.xmodel files
					if [[ -f "${TARGET}/${netname}/${netname}_org.xmodel" ]]; then
						echo "Removing ${TARGET}/${netname}/${netname}_org.xmodel ..."
						rm ${TARGET}/${netname}/${netname}_org.xmodel
					fi
					# create ${netname}_officialcfg.prototxt file based on pre-built zcu102/zcu104 model
					if [[ -f "${netname}/${netname}_officialcfg.prototxt" ]]; then
						echo "Copying ${netname}_officialcfg.prototxt file from pre-built zcu102/zcu104 model"
						cp ${netname}/${netname}_officialcfg.prototxt ${TARGET}/${netname}/.
					fi
					# create ${netname}.prototxt file based on pre-built zcu102/zcu104 model
					if [[ -f "${netname}/${netname}.prototxt" ]]; then
						echo "Copying $netname.prototxt file from pre-built zcu102/zcu104 model"
						cp ${netname}/${netname}.prototxt ${TARGET}/${netname}/.
					fi
				fi

				rm -rf $netname

			fi

			# Special case of accuracy testing model
			if [[ -d "${netname}_acc" ]]; then
				mkdir -p ${TARGET}/${netname}_acc
				# copy accuracy testing specific prototxt file
				if [[ -f "${netname}_acc/${netname}_acc.prototxt" ]]; then
					echo "Copying ${netname}_acc.prototxt file from pre-built zcu102/zcu104 model"
					cp ${netname}_acc/${netname}_acc.prototxt ${TARGET}/${netname}_acc/.
				fi
				# create ${netname}_acc_officialcfg.prototxt file based on pre-built zcu102/zcu104 model
				if [[ -f "${netname}_acc/${netname}_acc_officialcfg.prototxt" ]]; then
					echo "Copying ${netname}_acc_officialcfg.prototxt file from pre-built zcu102/zcu104 model"
					cp ${netname}_acc/${netname}_acc_officialcfg.prototxt ${TARGET}/${netname}_acc/.
				fi
				# copy xmodel (same as previously built)
				if [[ -f "${TARGET}/${netname}/${netname}.xmodel" ]]; then
					#echo "Copying ${netname}_acc.xmodel file from previously built model"
					#cp ${TARGET}/${netname}/${netname}.xmodel ${TARGET}/${netname}_acc/${netname}_acc.xmodel
					echo "Linking ${netname}_acc.xmodel file to previously built model"
					cd ${TARGET}/${netname}_acc/
					ln -sf ../${netname}/${netname}.xmodel ${netname}_acc.xmodel
					cd -
				fi
				rm -rf ${netname}_acc
                       fi

		else
			echo $1"/"$file
		fi
	done
}

mkdir -p ${TARGET}
path='./model-list'
build_model $path
#rm download_list.txt name_list.txt checksum_list.txt model_path.txt
echo "All models are built succesfully."
