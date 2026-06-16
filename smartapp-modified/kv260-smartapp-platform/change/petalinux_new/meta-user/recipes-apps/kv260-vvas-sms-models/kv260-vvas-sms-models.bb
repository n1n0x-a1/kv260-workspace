#
# This file is the kv260-vvas-sms-models recipe.
#

SUMMARY = "Pre-compiled models for kv260-vvas-sms application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
     file://models.b3136/face_mask_detection_pt/md5sum.txt \
     file://models.b3136/face_mask_detection_pt/meta.json \
     file://models.b3136/face_mask_detection_pt/face_mask_detection_pt.prototxt \
     file://models.b3136/face_mask_detection_pt/face_mask_detection_pt.xmodel \
     file://models.b3136/face_mask_detection_pt/label.json \
     file://models.b3136/inception_v1_tf/md5sum.txt \
     file://models.b3136/inception_v1_tf/meta.json \
     file://models.b3136/inception_v1_tf/inception_v1_tf.prototxt \
     file://models.b3136/inception_v1_tf/inception_v1_tf.xmodel \
     file://models.b3136/mobilenet_v2_1_4_224_tf/md5sum.txt \
     file://models.b3136/mobilenet_v2_1_4_224_tf/meta.json \
     file://models.b3136/mobilenet_v2_1_4_224_tf/mobilenet_v2_1_4_224_tf.prototxt \
     file://models.b3136/mobilenet_v2_1_4_224_tf/mobilenet_v2_1_4_224_tf.xmodel \
     file://models.b3136/refinedet_VOC_tf/md5sum.txt \
     file://models.b3136/refinedet_VOC_tf/meta.json \
     file://models.b3136/refinedet_VOC_tf/refinedet_VOC_tf.prototxt \
     file://models.b3136/refinedet_VOC_tf/refinedet_VOC_tf.xmodel \
     file://models.b3136/resnet50_pt/md5sum.txt \
     file://models.b3136/resnet50_pt/meta.json \
     file://models.b3136/resnet50_pt/resnet50_pt.prototxt \
     file://models.b3136/resnet50_pt/resnet50_pt.xmodel \
     file://models.b3136/yolov3_voc_tf/md5sum.txt \
     file://models.b3136/yolov3_voc_tf/meta.json \
     file://models.b3136/yolov3_voc_tf/yolov3_voc_tf.prototxt \
     file://models.b3136/yolov3_voc_tf/yolov3_voc_tf.xmodel \
     file://models.b3136/yolov3_voc_tf/label.json"

S = "${WORKDIR}"
do_install() {
     install -d ${D}/opt/xilinx
     install -d ${D}/opt/xilinx/kv260-vvas-sms
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136

     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt
     install -m 0755 models.b3136/face_mask_detection_pt/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt
#     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt
#     install -m 0755 models.b3136/facerec-resnet20_mixed_pt/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf
     install -m 0755 models.b3136/inception_v1_tf/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf
     install -m 0755 models.b3136/mobilenet_v2_1_4_224_tf/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf
     install -m 0755 models.b3136/refinedet_VOC_tf/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt
     install -m 0755 models.b3136/resnet50_pt/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt
 #    install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf
 #    install -m 0755 models.b3136/ssd_mobilenet_v2_coco_tf/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf
     install -d ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf
     install -m 0755 models.b3136/yolov3_voc_tf/* ${D}/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf    
}

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/face_mask_detection_pt.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/face_mask_detection_pt.xmodel"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/label.json"

#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt/md5sum.txt"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt/meta.json"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt/facerec-resnet20_mixed_pt.prototxt"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/facerec-resnet20_mixed_pt/facerec-resnet20_mixed_pt.xmodel"

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf/inception_v1_tf.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/inception_v1_tf/inception_v1_tf.xmodel"

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf/mobilenet_v2_1_4_224_tf.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/mobilenet_v2_1_4_224_tf/mobilenet_v2_1_4_224_tf.xmodel"

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf/refinedet_VOC_tf.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/refinedet_VOC_tf/refinedet_VOC_tf.xmodel"

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt/resnet50_pt.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/resnet50_pt/resnet50_pt.xmodel"

#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf/md5sum.txt"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf/meta.json"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf/ssd_mobilenet_v2_coco_tf.prototxt"
#FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/ssd_mobilenet_v2_coco_tf/ssd_mobilenet_v2_coco_tf.xmodel"

FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf/md5sum.txt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf/meta.json"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf/yolov3_voc_tf.prototxt"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf/yolov3_voc_tf.xmodel"
FILES:${PN} += "/opt/xilinx/kv260-vvas-sms/models.b3136/yolov3_voc_tf/label.json"

