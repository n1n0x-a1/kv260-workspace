// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// CTRL
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 4  - ap_continue (Read/Write/SC)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/COR)
//        bit 0 - ap_done (Read/COR)
//        bit 1 - ap_ready (Read/COR)
//        others - reserved
// 0x20 : Data signal of num_outs
//        bit 7~0 - num_outs[7:0] (Read/Write)
//        others  - reserved
// 0x24 : reserved
// 0x30 : Data signal of start_addr
//        bit 31~0 - start_addr[31:0] (Read/Write)
// 0x34 : Data signal of start_addr
//        bit 31~0 - start_addr[63:32] (Read/Write)
// 0x38 : reserved
// 0x40 : Data signal of ms_maxi_srcbuf
//        bit 31~0 - ms_maxi_srcbuf[31:0] (Read/Write)
// 0x44 : Data signal of ms_maxi_srcbuf
//        bit 31~0 - ms_maxi_srcbuf[63:32] (Read/Write)
// 0x48 : reserved
// 0x50 : Data signal of ms_maxi_dstbuf
//        bit 31~0 - ms_maxi_dstbuf[31:0] (Read/Write)
// 0x54 : Data signal of ms_maxi_dstbuf
//        bit 31~0 - ms_maxi_dstbuf[63:32] (Read/Write)
// 0x58 : reserved
// 0x60 : Data signal of ms_status
//        bit 7~0 - ms_status[7:0] (Read/Write)
//        others  - reserved
// 0x64 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XV_MULTI_SCALER_CTRL_ADDR_AP_CTRL             0x00
#define XV_MULTI_SCALER_CTRL_ADDR_GIE                 0x04
#define XV_MULTI_SCALER_CTRL_ADDR_IER                 0x08
#define XV_MULTI_SCALER_CTRL_ADDR_ISR                 0x0c
#define XV_MULTI_SCALER_CTRL_ADDR_NUM_OUTS_DATA       0x20
#define XV_MULTI_SCALER_CTRL_BITS_NUM_OUTS_DATA       8
#define XV_MULTI_SCALER_CTRL_ADDR_START_ADDR_DATA     0x30
#define XV_MULTI_SCALER_CTRL_BITS_START_ADDR_DATA     64
#define XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_SRCBUF_DATA 0x40
#define XV_MULTI_SCALER_CTRL_BITS_MS_MAXI_SRCBUF_DATA 64
#define XV_MULTI_SCALER_CTRL_ADDR_MS_MAXI_DSTBUF_DATA 0x50
#define XV_MULTI_SCALER_CTRL_BITS_MS_MAXI_DSTBUF_DATA 64
#define XV_MULTI_SCALER_CTRL_ADDR_MS_STATUS_DATA      0x60
#define XV_MULTI_SCALER_CTRL_BITS_MS_STATUS_DATA      8

