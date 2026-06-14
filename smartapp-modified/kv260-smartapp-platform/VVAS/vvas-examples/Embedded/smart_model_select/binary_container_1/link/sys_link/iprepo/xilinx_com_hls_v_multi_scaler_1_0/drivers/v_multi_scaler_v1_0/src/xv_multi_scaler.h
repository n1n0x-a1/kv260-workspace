// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XV_MULTI_SCALER_H
#define XV_MULTI_SCALER_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xv_multi_scaler_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Ctrl_BaseAddress;
} XV_multi_scaler_Config;
#endif

typedef struct {
    u64 Ctrl_BaseAddress;
    u32 IsReady;
} XV_multi_scaler;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XV_multi_scaler_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XV_multi_scaler_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XV_multi_scaler_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XV_multi_scaler_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XV_multi_scaler_Initialize(XV_multi_scaler *InstancePtr, u16 DeviceId);
XV_multi_scaler_Config* XV_multi_scaler_LookupConfig(u16 DeviceId);
int XV_multi_scaler_CfgInitialize(XV_multi_scaler *InstancePtr, XV_multi_scaler_Config *ConfigPtr);
#else
int XV_multi_scaler_Initialize(XV_multi_scaler *InstancePtr, const char* InstanceName);
int XV_multi_scaler_Release(XV_multi_scaler *InstancePtr);
#endif

void XV_multi_scaler_Start(XV_multi_scaler *InstancePtr);
u32 XV_multi_scaler_IsDone(XV_multi_scaler *InstancePtr);
u32 XV_multi_scaler_IsIdle(XV_multi_scaler *InstancePtr);
u32 XV_multi_scaler_IsReady(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_Continue(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_EnableAutoRestart(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_DisableAutoRestart(XV_multi_scaler *InstancePtr);

void XV_multi_scaler_Set_num_outs(XV_multi_scaler *InstancePtr, u32 Data);
u32 XV_multi_scaler_Get_num_outs(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_Set_start_addr(XV_multi_scaler *InstancePtr, u64 Data);
u64 XV_multi_scaler_Get_start_addr(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_Set_ms_maxi_srcbuf(XV_multi_scaler *InstancePtr, u64 Data);
u64 XV_multi_scaler_Get_ms_maxi_srcbuf(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_Set_ms_maxi_dstbuf(XV_multi_scaler *InstancePtr, u64 Data);
u64 XV_multi_scaler_Get_ms_maxi_dstbuf(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_Set_ms_status(XV_multi_scaler *InstancePtr, u32 Data);
u32 XV_multi_scaler_Get_ms_status(XV_multi_scaler *InstancePtr);

void XV_multi_scaler_InterruptGlobalEnable(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_InterruptGlobalDisable(XV_multi_scaler *InstancePtr);
void XV_multi_scaler_InterruptEnable(XV_multi_scaler *InstancePtr, u32 Mask);
void XV_multi_scaler_InterruptDisable(XV_multi_scaler *InstancePtr, u32 Mask);
void XV_multi_scaler_InterruptClear(XV_multi_scaler *InstancePtr, u32 Mask);
u32 XV_multi_scaler_InterruptGetEnabled(XV_multi_scaler *InstancePtr);
u32 XV_multi_scaler_InterruptGetStatus(XV_multi_scaler *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
