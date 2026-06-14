// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xv_multi_scaler.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XV_multi_scaler_CfgInitialize(XV_multi_scaler *InstancePtr, XV_multi_scaler_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Ctrl_BaseAddress = ConfigPtr->Ctrl_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XV_multi_scaler_Start(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL) & 0x80;
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XV_multi_scaler_IsDone(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XV_multi_scaler_IsIdle(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XV_multi_scaler_IsReady(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XV_multi_scaler_Continue(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL) & 0x80;
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL, Data | 0x10);
}

void XV_multi_scaler_EnableAutoRestart(XV_multi_scaler *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL, 0x80);
}

void XV_multi_scaler_DisableAutoRestart(XV_multi_scaler *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL, 0);
}

void XV_multi_scaler_Set_num_outs(XV_multi_scaler *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_NUM_OUTS_DATA, Data);
}

u32 XV_multi_scaler_Get_num_outs(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_NUM_OUTS_DATA);
    return Data;
}

void XV_multi_scaler_Set_start_addr(XV_multi_scaler *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_START_ADDR_DATA, (u32)(Data));
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_START_ADDR_DATA + 4, (u32)(Data >> 32));
}

u64 XV_multi_scaler_Get_start_addr(XV_multi_scaler *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_START_ADDR_DATA);
    Data += (u64)XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_START_ADDR_DATA + 4) << 32;
    return Data;
}

void XV_multi_scaler_Set_ms_maxi_srcbuf(XV_multi_scaler *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_SRCBUF_DATA, (u32)(Data));
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_SRCBUF_DATA + 4, (u32)(Data >> 32));
}

u64 XV_multi_scaler_Get_ms_maxi_srcbuf(XV_multi_scaler *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_SRCBUF_DATA);
    Data += (u64)XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_SRCBUF_DATA + 4) << 32;
    return Data;
}

void XV_multi_scaler_Set_ms_maxi_dstbuf(XV_multi_scaler *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_DSTBUF_DATA, (u32)(Data));
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_DSTBUF_DATA + 4, (u32)(Data >> 32));
}

u64 XV_multi_scaler_Get_ms_maxi_dstbuf(XV_multi_scaler *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_DSTBUF_DATA);
    Data += (u64)XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_DSTBUF_DATA + 4) << 32;
    return Data;
}

void XV_multi_scaler_Set_ms_status(XV_multi_scaler *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_STATUS_DATA, Data);
}

u32 XV_multi_scaler_Get_ms_status(XV_multi_scaler *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_MS_STATUS_DATA);
    return Data;
}

void XV_multi_scaler_InterruptGlobalEnable(XV_multi_scaler *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_GIE, 1);
}

void XV_multi_scaler_InterruptGlobalDisable(XV_multi_scaler *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_GIE, 0);
}

void XV_multi_scaler_InterruptEnable(XV_multi_scaler *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_IER);
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_IER, Register | Mask);
}

void XV_multi_scaler_InterruptDisable(XV_multi_scaler *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_IER);
    XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_IER, Register & (~Mask));
}

void XV_multi_scaler_InterruptClear(XV_multi_scaler *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XV_multi_scaler_WriteReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_ISR, Mask);
}

u32 XV_multi_scaler_InterruptGetEnabled(XV_multi_scaler *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_IER);
}

u32 XV_multi_scaler_InterruptGetStatus(XV_multi_scaler *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XV_multi_scaler_ReadReg(InstancePtr->Ctrl_BaseAddress, XV_MULTI_SCALER_CTRL_ADDR_ISR);
}

