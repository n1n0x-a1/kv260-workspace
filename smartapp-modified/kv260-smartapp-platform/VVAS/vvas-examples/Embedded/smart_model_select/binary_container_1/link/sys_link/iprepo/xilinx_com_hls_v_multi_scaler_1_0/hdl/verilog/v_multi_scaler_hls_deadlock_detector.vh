
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [5:0] proc_0_data_FIFO_blk;
    wire [5:0] proc_0_data_PIPO_blk;
    wire [5:0] proc_0_start_FIFO_blk;
    wire [5:0] proc_0_TLF_FIFO_blk;
    wire [5:0] proc_0_input_sync_blk;
    wire [5:0] proc_0_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_0;
    reg [5:0] proc_dep_vld_vec_0_reg;
    wire [5:0] in_chan_dep_vld_vec_0;
    wire [95:0] in_chan_dep_data_vec_0;
    wire [5:0] token_in_vec_0;
    wire [5:0] out_chan_dep_vld_vec_0;
    wire [15:0] out_chan_dep_data_0;
    wire [5:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [15:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_2_0;
    wire [15:0] dep_chan_data_2_0;
    wire token_2_0;
    wire dep_chan_vld_4_0;
    wire [15:0] dep_chan_data_4_0;
    wire token_4_0;
    wire dep_chan_vld_8_0;
    wire [15:0] dep_chan_data_8_0;
    wire token_8_0;
    wire dep_chan_vld_9_0;
    wire [15:0] dep_chan_data_9_0;
    wire token_9_0;
    wire dep_chan_vld_15_0;
    wire [15:0] dep_chan_data_15_0;
    wire token_15_0;
    wire [4:0] proc_1_data_FIFO_blk;
    wire [4:0] proc_1_data_PIPO_blk;
    wire [4:0] proc_1_start_FIFO_blk;
    wire [4:0] proc_1_TLF_FIFO_blk;
    wire [4:0] proc_1_input_sync_blk;
    wire [4:0] proc_1_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_1;
    reg [4:0] proc_dep_vld_vec_1_reg;
    wire [13:0] in_chan_dep_vld_vec_1;
    wire [223:0] in_chan_dep_data_vec_1;
    wire [13:0] token_in_vec_1;
    wire [4:0] out_chan_dep_vld_vec_1;
    wire [15:0] out_chan_dep_data_1;
    wire [4:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [15:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_2_1;
    wire [15:0] dep_chan_data_2_1;
    wire token_2_1;
    wire dep_chan_vld_3_1;
    wire [15:0] dep_chan_data_3_1;
    wire token_3_1;
    wire dep_chan_vld_4_1;
    wire [15:0] dep_chan_data_4_1;
    wire token_4_1;
    wire dep_chan_vld_5_1;
    wire [15:0] dep_chan_data_5_1;
    wire token_5_1;
    wire dep_chan_vld_6_1;
    wire [15:0] dep_chan_data_6_1;
    wire token_6_1;
    wire dep_chan_vld_7_1;
    wire [15:0] dep_chan_data_7_1;
    wire token_7_1;
    wire dep_chan_vld_8_1;
    wire [15:0] dep_chan_data_8_1;
    wire token_8_1;
    wire dep_chan_vld_9_1;
    wire [15:0] dep_chan_data_9_1;
    wire token_9_1;
    wire dep_chan_vld_10_1;
    wire [15:0] dep_chan_data_10_1;
    wire token_10_1;
    wire dep_chan_vld_11_1;
    wire [15:0] dep_chan_data_11_1;
    wire token_11_1;
    wire dep_chan_vld_12_1;
    wire [15:0] dep_chan_data_12_1;
    wire token_12_1;
    wire dep_chan_vld_13_1;
    wire [15:0] dep_chan_data_13_1;
    wire token_13_1;
    wire dep_chan_vld_14_1;
    wire [15:0] dep_chan_data_14_1;
    wire token_14_1;
    wire [3:0] proc_2_data_FIFO_blk;
    wire [3:0] proc_2_data_PIPO_blk;
    wire [3:0] proc_2_start_FIFO_blk;
    wire [3:0] proc_2_TLF_FIFO_blk;
    wire [3:0] proc_2_input_sync_blk;
    wire [3:0] proc_2_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_2;
    reg [3:0] proc_dep_vld_vec_2_reg;
    wire [4:0] in_chan_dep_vld_vec_2;
    wire [79:0] in_chan_dep_data_vec_2;
    wire [4:0] token_in_vec_2;
    wire [3:0] out_chan_dep_vld_vec_2;
    wire [15:0] out_chan_dep_data_2;
    wire [3:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_0_2;
    wire [15:0] dep_chan_data_0_2;
    wire token_0_2;
    wire dep_chan_vld_1_2;
    wire [15:0] dep_chan_data_1_2;
    wire token_1_2;
    wire dep_chan_vld_3_2;
    wire [15:0] dep_chan_data_3_2;
    wire token_3_2;
    wire dep_chan_vld_4_2;
    wire [15:0] dep_chan_data_4_2;
    wire token_4_2;
    wire dep_chan_vld_9_2;
    wire [15:0] dep_chan_data_9_2;
    wire token_9_2;
    wire [3:0] proc_3_data_FIFO_blk;
    wire [3:0] proc_3_data_PIPO_blk;
    wire [3:0] proc_3_start_FIFO_blk;
    wire [3:0] proc_3_TLF_FIFO_blk;
    wire [3:0] proc_3_input_sync_blk;
    wire [3:0] proc_3_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_3;
    reg [3:0] proc_dep_vld_vec_3_reg;
    wire [4:0] in_chan_dep_vld_vec_3;
    wire [79:0] in_chan_dep_data_vec_3;
    wire [4:0] token_in_vec_3;
    wire [3:0] out_chan_dep_vld_vec_3;
    wire [15:0] out_chan_dep_data_3;
    wire [3:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_1_3;
    wire [15:0] dep_chan_data_1_3;
    wire token_1_3;
    wire dep_chan_vld_4_3;
    wire [15:0] dep_chan_data_4_3;
    wire token_4_3;
    wire dep_chan_vld_6_3;
    wire [15:0] dep_chan_data_6_3;
    wire token_6_3;
    wire dep_chan_vld_13_3;
    wire [15:0] dep_chan_data_13_3;
    wire token_13_3;
    wire dep_chan_vld_14_3;
    wire [15:0] dep_chan_data_14_3;
    wire token_14_3;
    wire [5:0] proc_4_data_FIFO_blk;
    wire [5:0] proc_4_data_PIPO_blk;
    wire [5:0] proc_4_start_FIFO_blk;
    wire [5:0] proc_4_TLF_FIFO_blk;
    wire [5:0] proc_4_input_sync_blk;
    wire [5:0] proc_4_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_4;
    reg [5:0] proc_dep_vld_vec_4_reg;
    wire [4:0] in_chan_dep_vld_vec_4;
    wire [79:0] in_chan_dep_data_vec_4;
    wire [4:0] token_in_vec_4;
    wire [5:0] out_chan_dep_vld_vec_4;
    wire [15:0] out_chan_dep_data_4;
    wire [5:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_0_4;
    wire [15:0] dep_chan_data_0_4;
    wire token_0_4;
    wire dep_chan_vld_1_4;
    wire [15:0] dep_chan_data_1_4;
    wire token_1_4;
    wire dep_chan_vld_2_4;
    wire [15:0] dep_chan_data_2_4;
    wire token_2_4;
    wire dep_chan_vld_5_4;
    wire [15:0] dep_chan_data_5_4;
    wire token_5_4;
    wire dep_chan_vld_9_4;
    wire [15:0] dep_chan_data_9_4;
    wire token_9_4;
    wire [2:0] proc_5_data_FIFO_blk;
    wire [2:0] proc_5_data_PIPO_blk;
    wire [2:0] proc_5_start_FIFO_blk;
    wire [2:0] proc_5_TLF_FIFO_blk;
    wire [2:0] proc_5_input_sync_blk;
    wire [2:0] proc_5_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_5;
    reg [2:0] proc_dep_vld_vec_5_reg;
    wire [1:0] in_chan_dep_vld_vec_5;
    wire [31:0] in_chan_dep_data_vec_5;
    wire [1:0] token_in_vec_5;
    wire [2:0] out_chan_dep_vld_vec_5;
    wire [15:0] out_chan_dep_data_5;
    wire [2:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_4_5;
    wire [15:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_6_5;
    wire [15:0] dep_chan_data_6_5;
    wire token_6_5;
    wire [3:0] proc_6_data_FIFO_blk;
    wire [3:0] proc_6_data_PIPO_blk;
    wire [3:0] proc_6_start_FIFO_blk;
    wire [3:0] proc_6_TLF_FIFO_blk;
    wire [3:0] proc_6_input_sync_blk;
    wire [3:0] proc_6_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_6;
    reg [3:0] proc_dep_vld_vec_6_reg;
    wire [2:0] in_chan_dep_vld_vec_6;
    wire [47:0] in_chan_dep_data_vec_6;
    wire [2:0] token_in_vec_6;
    wire [3:0] out_chan_dep_vld_vec_6;
    wire [15:0] out_chan_dep_data_6;
    wire [3:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_3_6;
    wire [15:0] dep_chan_data_3_6;
    wire token_3_6;
    wire dep_chan_vld_5_6;
    wire [15:0] dep_chan_data_5_6;
    wire token_5_6;
    wire dep_chan_vld_7_6;
    wire [15:0] dep_chan_data_7_6;
    wire token_7_6;
    wire [2:0] proc_7_data_FIFO_blk;
    wire [2:0] proc_7_data_PIPO_blk;
    wire [2:0] proc_7_start_FIFO_blk;
    wire [2:0] proc_7_TLF_FIFO_blk;
    wire [2:0] proc_7_input_sync_blk;
    wire [2:0] proc_7_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_7;
    reg [2:0] proc_dep_vld_vec_7_reg;
    wire [1:0] in_chan_dep_vld_vec_7;
    wire [31:0] in_chan_dep_data_vec_7;
    wire [1:0] token_in_vec_7;
    wire [2:0] out_chan_dep_vld_vec_7;
    wire [15:0] out_chan_dep_data_7;
    wire [2:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_6_7;
    wire [15:0] dep_chan_data_6_7;
    wire token_6_7;
    wire dep_chan_vld_8_7;
    wire [15:0] dep_chan_data_8_7;
    wire token_8_7;
    wire [4:0] proc_8_data_FIFO_blk;
    wire [4:0] proc_8_data_PIPO_blk;
    wire [4:0] proc_8_start_FIFO_blk;
    wire [4:0] proc_8_TLF_FIFO_blk;
    wire [4:0] proc_8_input_sync_blk;
    wire [4:0] proc_8_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_8;
    reg [4:0] proc_dep_vld_vec_8_reg;
    wire [3:0] in_chan_dep_vld_vec_8;
    wire [63:0] in_chan_dep_data_vec_8;
    wire [3:0] token_in_vec_8;
    wire [4:0] out_chan_dep_vld_vec_8;
    wire [15:0] out_chan_dep_data_8;
    wire [4:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_0_8;
    wire [15:0] dep_chan_data_0_8;
    wire token_0_8;
    wire dep_chan_vld_7_8;
    wire [15:0] dep_chan_data_7_8;
    wire token_7_8;
    wire dep_chan_vld_9_8;
    wire [15:0] dep_chan_data_9_8;
    wire token_9_8;
    wire dep_chan_vld_10_8;
    wire [15:0] dep_chan_data_10_8;
    wire token_10_8;
    wire [6:0] proc_9_data_FIFO_blk;
    wire [6:0] proc_9_data_PIPO_blk;
    wire [6:0] proc_9_start_FIFO_blk;
    wire [6:0] proc_9_TLF_FIFO_blk;
    wire [6:0] proc_9_input_sync_blk;
    wire [6:0] proc_9_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_9;
    reg [6:0] proc_dep_vld_vec_9_reg;
    wire [6:0] in_chan_dep_vld_vec_9;
    wire [111:0] in_chan_dep_data_vec_9;
    wire [6:0] token_in_vec_9;
    wire [6:0] out_chan_dep_vld_vec_9;
    wire [15:0] out_chan_dep_data_9;
    wire [6:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_0_9;
    wire [15:0] dep_chan_data_0_9;
    wire token_0_9;
    wire dep_chan_vld_1_9;
    wire [15:0] dep_chan_data_1_9;
    wire token_1_9;
    wire dep_chan_vld_2_9;
    wire [15:0] dep_chan_data_2_9;
    wire token_2_9;
    wire dep_chan_vld_4_9;
    wire [15:0] dep_chan_data_4_9;
    wire token_4_9;
    wire dep_chan_vld_8_9;
    wire [15:0] dep_chan_data_8_9;
    wire token_8_9;
    wire dep_chan_vld_10_9;
    wire [15:0] dep_chan_data_10_9;
    wire token_10_9;
    wire dep_chan_vld_11_9;
    wire [15:0] dep_chan_data_11_9;
    wire token_11_9;
    wire [3:0] proc_10_data_FIFO_blk;
    wire [3:0] proc_10_data_PIPO_blk;
    wire [3:0] proc_10_start_FIFO_blk;
    wire [3:0] proc_10_TLF_FIFO_blk;
    wire [3:0] proc_10_input_sync_blk;
    wire [3:0] proc_10_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_10;
    reg [3:0] proc_dep_vld_vec_10_reg;
    wire [2:0] in_chan_dep_vld_vec_10;
    wire [47:0] in_chan_dep_data_vec_10;
    wire [2:0] token_in_vec_10;
    wire [3:0] out_chan_dep_vld_vec_10;
    wire [15:0] out_chan_dep_data_10;
    wire [3:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_8_10;
    wire [15:0] dep_chan_data_8_10;
    wire token_8_10;
    wire dep_chan_vld_9_10;
    wire [15:0] dep_chan_data_9_10;
    wire token_9_10;
    wire dep_chan_vld_11_10;
    wire [15:0] dep_chan_data_11_10;
    wire token_11_10;
    wire [3:0] proc_11_data_FIFO_blk;
    wire [3:0] proc_11_data_PIPO_blk;
    wire [3:0] proc_11_start_FIFO_blk;
    wire [3:0] proc_11_TLF_FIFO_blk;
    wire [3:0] proc_11_input_sync_blk;
    wire [3:0] proc_11_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_11;
    reg [3:0] proc_dep_vld_vec_11_reg;
    wire [2:0] in_chan_dep_vld_vec_11;
    wire [47:0] in_chan_dep_data_vec_11;
    wire [2:0] token_in_vec_11;
    wire [3:0] out_chan_dep_vld_vec_11;
    wire [15:0] out_chan_dep_data_11;
    wire [3:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_9_11;
    wire [15:0] dep_chan_data_9_11;
    wire token_9_11;
    wire dep_chan_vld_10_11;
    wire [15:0] dep_chan_data_10_11;
    wire token_10_11;
    wire dep_chan_vld_12_11;
    wire [15:0] dep_chan_data_12_11;
    wire token_12_11;
    wire [2:0] proc_12_data_FIFO_blk;
    wire [2:0] proc_12_data_PIPO_blk;
    wire [2:0] proc_12_start_FIFO_blk;
    wire [2:0] proc_12_TLF_FIFO_blk;
    wire [2:0] proc_12_input_sync_blk;
    wire [2:0] proc_12_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_12;
    reg [2:0] proc_dep_vld_vec_12_reg;
    wire [1:0] in_chan_dep_vld_vec_12;
    wire [31:0] in_chan_dep_data_vec_12;
    wire [1:0] token_in_vec_12;
    wire [2:0] out_chan_dep_vld_vec_12;
    wire [15:0] out_chan_dep_data_12;
    wire [2:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_11_12;
    wire [15:0] dep_chan_data_11_12;
    wire token_11_12;
    wire dep_chan_vld_13_12;
    wire [15:0] dep_chan_data_13_12;
    wire token_13_12;
    wire [3:0] proc_13_data_FIFO_blk;
    wire [3:0] proc_13_data_PIPO_blk;
    wire [3:0] proc_13_start_FIFO_blk;
    wire [3:0] proc_13_TLF_FIFO_blk;
    wire [3:0] proc_13_input_sync_blk;
    wire [3:0] proc_13_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_13;
    reg [3:0] proc_dep_vld_vec_13_reg;
    wire [1:0] in_chan_dep_vld_vec_13;
    wire [31:0] in_chan_dep_data_vec_13;
    wire [1:0] token_in_vec_13;
    wire [3:0] out_chan_dep_vld_vec_13;
    wire [15:0] out_chan_dep_data_13;
    wire [3:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_12_13;
    wire [15:0] dep_chan_data_12_13;
    wire token_12_13;
    wire dep_chan_vld_14_13;
    wire [15:0] dep_chan_data_14_13;
    wire token_14_13;
    wire [3:0] proc_14_data_FIFO_blk;
    wire [3:0] proc_14_data_PIPO_blk;
    wire [3:0] proc_14_start_FIFO_blk;
    wire [3:0] proc_14_TLF_FIFO_blk;
    wire [3:0] proc_14_input_sync_blk;
    wire [3:0] proc_14_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_14;
    reg [3:0] proc_dep_vld_vec_14_reg;
    wire [2:0] in_chan_dep_vld_vec_14;
    wire [47:0] in_chan_dep_data_vec_14;
    wire [2:0] token_in_vec_14;
    wire [3:0] out_chan_dep_vld_vec_14;
    wire [15:0] out_chan_dep_data_14;
    wire [3:0] token_out_vec_14;
    wire dl_detect_out_14;
    wire dep_chan_vld_3_14;
    wire [15:0] dep_chan_data_3_14;
    wire token_3_14;
    wire dep_chan_vld_13_14;
    wire [15:0] dep_chan_data_13_14;
    wire token_13_14;
    wire dep_chan_vld_15_14;
    wire [15:0] dep_chan_data_15_14;
    wire token_15_14;
    wire [1:0] proc_15_data_FIFO_blk;
    wire [1:0] proc_15_data_PIPO_blk;
    wire [1:0] proc_15_start_FIFO_blk;
    wire [1:0] proc_15_TLF_FIFO_blk;
    wire [1:0] proc_15_input_sync_blk;
    wire [1:0] proc_15_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_15;
    reg [1:0] proc_dep_vld_vec_15_reg;
    wire [1:0] in_chan_dep_vld_vec_15;
    wire [31:0] in_chan_dep_data_vec_15;
    wire [1:0] token_in_vec_15;
    wire [1:0] out_chan_dep_vld_vec_15;
    wire [15:0] out_chan_dep_data_15;
    wire [1:0] token_out_vec_15;
    wire dl_detect_out_15;
    wire dep_chan_vld_0_15;
    wire [15:0] dep_chan_data_0_15;
    wire token_0_15;
    wire dep_chan_vld_14_15;
    wire [15:0] dep_chan_data_14_15;
    wire token_14_15;
    wire [15:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [15:0] origin;

    reg ap_done_reg_0;// for module grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_done & ~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_done & ~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.ap_done & ~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module grp_v_scaler_top_fu_576.v_vcresampler_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= grp_v_scaler_top_fu_576.v_vcresampler_U0.ap_done & ~grp_v_scaler_top_fu_576.v_vcresampler_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module grp_v_scaler_top_fu_576.v_hcresampler_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= grp_v_scaler_top_fu_576.v_hcresampler_U0.ap_done & ~grp_v_scaler_top_fu_576.v_hcresampler_U0.ap_continue;
        end
    end

    reg ap_done_reg_5;// for module grp_v_scaler_top_fu_576.v_vscaler_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_5 <= 'b0;
        end
        else begin
            ap_done_reg_5 <= grp_v_scaler_top_fu_576.v_vscaler_U0.ap_done & ~grp_v_scaler_top_fu_576.v_vscaler_U0.ap_continue;
        end
    end

    reg ap_done_reg_6;// for module grp_v_scaler_top_fu_576.v_hscaler_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_6 <= 'b0;
        end
        else begin
            ap_done_reg_6 <= grp_v_scaler_top_fu_576.v_hscaler_U0.ap_done & ~grp_v_scaler_top_fu_576.v_hscaler_U0.ap_continue;
        end
    end

    reg ap_done_reg_7;// for module grp_v_scaler_top_fu_576.v_csc_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_7 <= 'b0;
        end
        else begin
            ap_done_reg_7 <= grp_v_scaler_top_fu_576.v_csc_U0.ap_done & ~grp_v_scaler_top_fu_576.v_csc_U0.ap_continue;
        end
    end

    reg ap_done_reg_8;// for module grp_v_scaler_top_fu_576.v_hcresampler_1_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_8 <= 'b0;
        end
        else begin
            ap_done_reg_8 <= grp_v_scaler_top_fu_576.v_hcresampler_1_U0.ap_done & ~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.ap_continue;
        end
    end

    reg ap_done_reg_9;// for module grp_v_scaler_top_fu_576.v_vcresampler_2_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_9 <= 'b0;
        end
        else begin
            ap_done_reg_9 <= grp_v_scaler_top_fu_576.v_vcresampler_2_U0.ap_done & ~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.ap_continue;
        end
    end

    reg ap_done_reg_10;// for module grp_v_scaler_top_fu_576.preProcessKernel_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_10 <= 'b0;
        end
        else begin
            ap_done_reg_10 <= grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_done & ~grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_continue;
        end
    end

    reg ap_done_reg_11;// for module grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_11 <= 'b0;
        end
        else begin
            ap_done_reg_11 <= grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.ap_done & ~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process grp_v_scaler_top_fu_576.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (grp_v_scaler_top_fu_576.entry_proc_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process grp_v_scaler_top_fu_576.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (grp_v_scaler_top_fu_576.entry_proc_U0.ap_done == 1'b1 && grp_v_scaler_top_fu_576.entry_proc_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

    // Process: grp_v_scaler_top_fu_576.entry_proc_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 0, 6, 6) v_multi_scaler_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.entry_proc_U0.dstImgBuf0_c_blk_n) | (~grp_v_scaler_top_fu_576.entry_proc_U0.dstImgBuf1_c_blk_n) | (~grp_v_scaler_top_fu_576.entry_proc_U0.StrideOut_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.start_for_Bytes2AXIMMvideo_U0_U.if_full_n & grp_v_scaler_top_fu_576.entry_proc_U0.ap_start & ~grp_v_scaler_top_fu_576.entry_proc_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~grp_v_scaler_top_fu_576.start_for_Bytes2AXIMMvideo_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.entry_proc_U0.LineRate_c_blk_n);
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0;
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0;
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0;
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready & grp_v_scaler_top_fu_576.entry_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready);
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    assign proc_0_data_FIFO_blk[3] = 1'b0;
    assign proc_0_data_PIPO_blk[3] = 1'b0;
    assign proc_0_start_FIFO_blk[3] = 1'b0;
    assign proc_0_TLF_FIFO_blk[3] = 1'b0;
    assign proc_0_input_sync_blk[3] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready & grp_v_scaler_top_fu_576.entry_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready);
    assign proc_0_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_0[3] = dl_detect_out ? proc_dep_vld_vec_0_reg[3] : (proc_0_data_FIFO_blk[3] | proc_0_data_PIPO_blk[3] | proc_0_start_FIFO_blk[3] | proc_0_TLF_FIFO_blk[3] | proc_0_input_sync_blk[3] | proc_0_output_sync_blk[3]);
    assign proc_0_data_FIFO_blk[4] = 1'b0;
    assign proc_0_data_PIPO_blk[4] = 1'b0;
    assign proc_0_start_FIFO_blk[4] = 1'b0;
    assign proc_0_TLF_FIFO_blk[4] = 1'b0;
    assign proc_0_input_sync_blk[4] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready & grp_v_scaler_top_fu_576.entry_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready);
    assign proc_0_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_0[4] = dl_detect_out ? proc_dep_vld_vec_0_reg[4] : (proc_0_data_FIFO_blk[4] | proc_0_data_PIPO_blk[4] | proc_0_start_FIFO_blk[4] | proc_0_TLF_FIFO_blk[4] | proc_0_input_sync_blk[4] | proc_0_output_sync_blk[4]);
    assign proc_0_data_FIFO_blk[5] = 1'b0;
    assign proc_0_data_PIPO_blk[5] = 1'b0;
    assign proc_0_start_FIFO_blk[5] = 1'b0;
    assign proc_0_TLF_FIFO_blk[5] = 1'b0;
    assign proc_0_input_sync_blk[5] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready & grp_v_scaler_top_fu_576.entry_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready);
    assign proc_0_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_0[5] = dl_detect_out ? proc_dep_vld_vec_0_reg[5] : (proc_0_data_FIFO_blk[5] | proc_0_data_PIPO_blk[5] | proc_0_start_FIFO_blk[5] | proc_0_TLF_FIFO_blk[5] | proc_0_input_sync_blk[5] | proc_0_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[15 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_2_0;
    assign in_chan_dep_data_vec_0[31 : 16] = dep_chan_data_2_0;
    assign token_in_vec_0[1] = token_2_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_4_0;
    assign in_chan_dep_data_vec_0[47 : 32] = dep_chan_data_4_0;
    assign token_in_vec_0[2] = token_4_0;
    assign in_chan_dep_vld_vec_0[3] = dep_chan_vld_8_0;
    assign in_chan_dep_data_vec_0[63 : 48] = dep_chan_data_8_0;
    assign token_in_vec_0[3] = token_8_0;
    assign in_chan_dep_vld_vec_0[4] = dep_chan_vld_9_0;
    assign in_chan_dep_data_vec_0[79 : 64] = dep_chan_data_9_0;
    assign token_in_vec_0[4] = token_9_0;
    assign in_chan_dep_vld_vec_0[5] = dep_chan_vld_15_0;
    assign in_chan_dep_data_vec_0[95 : 80] = dep_chan_data_15_0;
    assign token_in_vec_0[5] = token_15_0;
    assign dep_chan_vld_0_15 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_15 = out_chan_dep_data_0;
    assign token_0_15 = token_out_vec_0[0];
    assign dep_chan_vld_0_8 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_8 = out_chan_dep_data_0;
    assign token_0_8 = token_out_vec_0[1];
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[2];
    assign dep_chan_vld_0_2 = out_chan_dep_vld_vec_0[3];
    assign dep_chan_data_0_2 = out_chan_dep_data_0;
    assign token_0_2 = token_out_vec_0[3];
    assign dep_chan_vld_0_4 = out_chan_dep_vld_vec_0[4];
    assign dep_chan_data_0_4 = out_chan_dep_data_0;
    assign token_0_4 = token_out_vec_0[4];
    assign dep_chan_vld_0_9 = out_chan_dep_vld_vec_0[5];
    assign dep_chan_data_0_9 = out_chan_dep_data_0;
    assign token_0_9 = token_out_vec_0[5];

    // Process: grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 1, 14, 5) v_multi_scaler_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.WidthIn_c106_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.WidthOut_c109_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.InPixelFmt_c110_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.OutPixelFmt_c112_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0;
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0;
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready);
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0;
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready);
    assign proc_1_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    assign proc_1_data_FIFO_blk[3] = 1'b0;
    assign proc_1_data_PIPO_blk[3] = 1'b0;
    assign proc_1_start_FIFO_blk[3] = 1'b0;
    assign proc_1_TLF_FIFO_blk[3] = 1'b0;
    assign proc_1_input_sync_blk[3] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready);
    assign proc_1_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_1[3] = dl_detect_out ? proc_dep_vld_vec_1_reg[3] : (proc_1_data_FIFO_blk[3] | proc_1_data_PIPO_blk[3] | proc_1_start_FIFO_blk[3] | proc_1_TLF_FIFO_blk[3] | proc_1_input_sync_blk[3] | proc_1_output_sync_blk[3]);
    assign proc_1_data_FIFO_blk[4] = 1'b0;
    assign proc_1_data_PIPO_blk[4] = 1'b0;
    assign proc_1_start_FIFO_blk[4] = 1'b0;
    assign proc_1_TLF_FIFO_blk[4] = 1'b0;
    assign proc_1_input_sync_blk[4] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Block_entry69_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready);
    assign proc_1_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_1[4] = dl_detect_out ? proc_dep_vld_vec_1_reg[4] : (proc_1_data_FIFO_blk[4] | proc_1_data_PIPO_blk[4] | proc_1_start_FIFO_blk[4] | proc_1_TLF_FIFO_blk[4] | proc_1_input_sync_blk[4] | proc_1_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[15 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[31 : 16] = dep_chan_data_2_1;
    assign token_in_vec_1[1] = token_2_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[47 : 32] = dep_chan_data_3_1;
    assign token_in_vec_1[2] = token_3_1;
    assign in_chan_dep_vld_vec_1[3] = dep_chan_vld_4_1;
    assign in_chan_dep_data_vec_1[63 : 48] = dep_chan_data_4_1;
    assign token_in_vec_1[3] = token_4_1;
    assign in_chan_dep_vld_vec_1[4] = dep_chan_vld_5_1;
    assign in_chan_dep_data_vec_1[79 : 64] = dep_chan_data_5_1;
    assign token_in_vec_1[4] = token_5_1;
    assign in_chan_dep_vld_vec_1[5] = dep_chan_vld_6_1;
    assign in_chan_dep_data_vec_1[95 : 80] = dep_chan_data_6_1;
    assign token_in_vec_1[5] = token_6_1;
    assign in_chan_dep_vld_vec_1[6] = dep_chan_vld_7_1;
    assign in_chan_dep_data_vec_1[111 : 96] = dep_chan_data_7_1;
    assign token_in_vec_1[6] = token_7_1;
    assign in_chan_dep_vld_vec_1[7] = dep_chan_vld_8_1;
    assign in_chan_dep_data_vec_1[127 : 112] = dep_chan_data_8_1;
    assign token_in_vec_1[7] = token_8_1;
    assign in_chan_dep_vld_vec_1[8] = dep_chan_vld_9_1;
    assign in_chan_dep_data_vec_1[143 : 128] = dep_chan_data_9_1;
    assign token_in_vec_1[8] = token_9_1;
    assign in_chan_dep_vld_vec_1[9] = dep_chan_vld_10_1;
    assign in_chan_dep_data_vec_1[159 : 144] = dep_chan_data_10_1;
    assign token_in_vec_1[9] = token_10_1;
    assign in_chan_dep_vld_vec_1[10] = dep_chan_vld_11_1;
    assign in_chan_dep_data_vec_1[175 : 160] = dep_chan_data_11_1;
    assign token_in_vec_1[10] = token_11_1;
    assign in_chan_dep_vld_vec_1[11] = dep_chan_vld_12_1;
    assign in_chan_dep_data_vec_1[191 : 176] = dep_chan_data_12_1;
    assign token_in_vec_1[11] = token_12_1;
    assign in_chan_dep_vld_vec_1[12] = dep_chan_vld_13_1;
    assign in_chan_dep_data_vec_1[207 : 192] = dep_chan_data_13_1;
    assign token_in_vec_1[12] = token_13_1;
    assign in_chan_dep_vld_vec_1[13] = dep_chan_vld_14_1;
    assign in_chan_dep_data_vec_1[223 : 208] = dep_chan_data_14_1;
    assign token_in_vec_1[13] = token_14_1;
    assign dep_chan_vld_1_3 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_3 = out_chan_dep_data_1;
    assign token_1_3 = token_out_vec_1[0];
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[1];
    assign dep_chan_vld_1_2 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_2 = out_chan_dep_data_1;
    assign token_1_2 = token_out_vec_1[2];
    assign dep_chan_vld_1_4 = out_chan_dep_vld_vec_1[3];
    assign dep_chan_data_1_4 = out_chan_dep_data_1;
    assign token_1_4 = token_out_vec_1[3];
    assign dep_chan_vld_1_9 = out_chan_dep_vld_vec_1[4];
    assign dep_chan_data_1_9 = out_chan_dep_data_1;
    assign token_1_9 = token_out_vec_1[4];

    // Process: grp_v_scaler_top_fu_576.v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 2, 5, 4) v_multi_scaler_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0;
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready);
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0;
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0;
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready);
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    assign proc_2_data_FIFO_blk[2] = 1'b0;
    assign proc_2_data_PIPO_blk[2] = 1'b0;
    assign proc_2_start_FIFO_blk[2] = 1'b0;
    assign proc_2_TLF_FIFO_blk[2] = 1'b0;
    assign proc_2_input_sync_blk[2] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready);
    assign proc_2_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_2[2] = dl_detect_out ? proc_dep_vld_vec_2_reg[2] : (proc_2_data_FIFO_blk[2] | proc_2_data_PIPO_blk[2] | proc_2_start_FIFO_blk[2] | proc_2_TLF_FIFO_blk[2] | proc_2_input_sync_blk[2] | proc_2_output_sync_blk[2]);
    assign proc_2_data_FIFO_blk[3] = 1'b0;
    assign proc_2_data_PIPO_blk[3] = 1'b0;
    assign proc_2_start_FIFO_blk[3] = 1'b0;
    assign proc_2_TLF_FIFO_blk[3] = 1'b0;
    assign proc_2_input_sync_blk[3] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready & grp_v_scaler_top_fu_576.v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready);
    assign proc_2_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_2[3] = dl_detect_out ? proc_dep_vld_vec_2_reg[3] : (proc_2_data_FIFO_blk[3] | proc_2_data_PIPO_blk[3] | proc_2_start_FIFO_blk[3] | proc_2_TLF_FIFO_blk[3] | proc_2_input_sync_blk[3] | proc_2_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_0_2;
    assign in_chan_dep_data_vec_2[15 : 0] = dep_chan_data_0_2;
    assign token_in_vec_2[0] = token_0_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_1_2;
    assign in_chan_dep_data_vec_2[31 : 16] = dep_chan_data_1_2;
    assign token_in_vec_2[1] = token_1_2;
    assign in_chan_dep_vld_vec_2[2] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[47 : 32] = dep_chan_data_3_2;
    assign token_in_vec_2[2] = token_3_2;
    assign in_chan_dep_vld_vec_2[3] = dep_chan_vld_4_2;
    assign in_chan_dep_data_vec_2[63 : 48] = dep_chan_data_4_2;
    assign token_in_vec_2[3] = token_4_2;
    assign in_chan_dep_vld_vec_2[4] = dep_chan_vld_9_2;
    assign in_chan_dep_data_vec_2[79 : 64] = dep_chan_data_9_2;
    assign token_in_vec_2[4] = token_9_2;
    assign dep_chan_vld_2_0 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_0 = out_chan_dep_data_2;
    assign token_2_0 = token_out_vec_2[0];
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[1];
    assign dep_chan_vld_2_4 = out_chan_dep_vld_vec_2[2];
    assign dep_chan_data_2_4 = out_chan_dep_data_2;
    assign token_2_4 = token_out_vec_2[2];
    assign dep_chan_vld_2_9 = out_chan_dep_vld_vec_2[3];
    assign dep_chan_data_2_9 = out_chan_dep_data_2;
    assign token_2_9 = token_out_vec_2[3];

    // Process: grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 3, 5, 4) v_multi_scaler_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0;
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.beta_reg_3_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_3_cast_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.beta_reg_4_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_4_cast_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.beta_reg_5_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_5_cast_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.alpha_reg_3_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_3_cast_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.alpha_reg_4_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_4_cast_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.alpha_reg_5_cast_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_5_cast_loc_channel_U.if_write);
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.InPixelFmt_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.WidthIn_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.OutPixelFmt_blk_n) | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.WidthOut_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0;
    assign proc_3_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.zext_ln754_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.zext_ln754_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.WidthIn_cast40_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.WidthIn_cast40_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.zext_ln755_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.zext_ln755_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.WidthOut_cast41_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.ap_idle & ~grp_v_scaler_top_fu_576.WidthOut_cast41_loc_channel_U.if_write);
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    assign proc_3_data_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.WidthIn_c105_blk_n);
    assign proc_3_data_PIPO_blk[2] = 1'b0;
    assign proc_3_start_FIFO_blk[2] = 1'b0;
    assign proc_3_TLF_FIFO_blk[2] = 1'b0;
    assign proc_3_input_sync_blk[2] = 1'b0;
    assign proc_3_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_3[2] = dl_detect_out ? proc_dep_vld_vec_3_reg[2] : (proc_3_data_FIFO_blk[2] | proc_3_data_PIPO_blk[2] | proc_3_start_FIFO_blk[2] | proc_3_TLF_FIFO_blk[2] | proc_3_input_sync_blk[2] | proc_3_output_sync_blk[2]);
    assign proc_3_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_scaler_top_Block_for_end_proc_U0.OutPixelFmt_c111_blk_n);
    assign proc_3_data_PIPO_blk[3] = 1'b0;
    assign proc_3_start_FIFO_blk[3] = 1'b0;
    assign proc_3_TLF_FIFO_blk[3] = 1'b0;
    assign proc_3_input_sync_blk[3] = 1'b0;
    assign proc_3_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_3[3] = dl_detect_out ? proc_dep_vld_vec_3_reg[3] : (proc_3_data_FIFO_blk[3] | proc_3_data_PIPO_blk[3] | proc_3_start_FIFO_blk[3] | proc_3_TLF_FIFO_blk[3] | proc_3_input_sync_blk[3] | proc_3_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_1_3;
    assign in_chan_dep_data_vec_3[15 : 0] = dep_chan_data_1_3;
    assign token_in_vec_3[0] = token_1_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[31 : 16] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign in_chan_dep_vld_vec_3[2] = dep_chan_vld_6_3;
    assign in_chan_dep_data_vec_3[47 : 32] = dep_chan_data_6_3;
    assign token_in_vec_3[2] = token_6_3;
    assign in_chan_dep_vld_vec_3[3] = dep_chan_vld_13_3;
    assign in_chan_dep_data_vec_3[63 : 48] = dep_chan_data_13_3;
    assign token_in_vec_3[3] = token_13_3;
    assign in_chan_dep_vld_vec_3[4] = dep_chan_vld_14_3;
    assign in_chan_dep_data_vec_3[79 : 64] = dep_chan_data_14_3;
    assign token_in_vec_3[4] = token_14_3;
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[0];
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[1];
    assign dep_chan_vld_3_6 = out_chan_dep_vld_vec_3[2];
    assign dep_chan_data_3_6 = out_chan_dep_data_3;
    assign token_3_6 = token_out_vec_3[2];
    assign dep_chan_vld_3_14 = out_chan_dep_vld_vec_3[3];
    assign dep_chan_data_3_14 = out_chan_dep_data_3;
    assign token_3_14 = token_out_vec_3[3];

    // Process: grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 4, 5, 6) v_multi_scaler_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.grp_AXIMMvideo2Bytes_Pipeline_VITIS_LOOP_119_1_fu_228.srcPlane0_blk_n) | (~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.grp_AXIMMvideo2Bytes_Pipeline_VITIS_LOOP_130_2_fu_238.srcPlane1_blk_n) | (~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.HeightIn_c99_blk_n) | (~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.InPixelFmt_c_blk_n) | (~grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.trunc_ln884_loc_c_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0;
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0;
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0;
    assign proc_4_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.trunc_ln884_loc_c114_channel_U.if_empty_n & grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.trunc_ln884_loc_c114_channel_U.if_write);
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    assign proc_4_data_FIFO_blk[2] = 1'b0;
    assign proc_4_data_PIPO_blk[2] = 1'b0;
    assign proc_4_start_FIFO_blk[2] = 1'b0;
    assign proc_4_TLF_FIFO_blk[2] = 1'b0;
    assign proc_4_input_sync_blk[2] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready & grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_4[2] = dl_detect_out ? proc_dep_vld_vec_4_reg[2] : (proc_4_data_FIFO_blk[2] | proc_4_data_PIPO_blk[2] | proc_4_start_FIFO_blk[2] | proc_4_TLF_FIFO_blk[2] | proc_4_input_sync_blk[2] | proc_4_output_sync_blk[2]);
    assign proc_4_data_FIFO_blk[3] = 1'b0;
    assign proc_4_data_PIPO_blk[3] = 1'b0;
    assign proc_4_start_FIFO_blk[3] = 1'b0;
    assign proc_4_TLF_FIFO_blk[3] = 1'b0;
    assign proc_4_input_sync_blk[3] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready & grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_4[3] = dl_detect_out ? proc_dep_vld_vec_4_reg[3] : (proc_4_data_FIFO_blk[3] | proc_4_data_PIPO_blk[3] | proc_4_start_FIFO_blk[3] | proc_4_TLF_FIFO_blk[3] | proc_4_input_sync_blk[3] | proc_4_output_sync_blk[3]);
    assign proc_4_data_FIFO_blk[4] = 1'b0;
    assign proc_4_data_PIPO_blk[4] = 1'b0;
    assign proc_4_start_FIFO_blk[4] = 1'b0;
    assign proc_4_TLF_FIFO_blk[4] = 1'b0;
    assign proc_4_input_sync_blk[4] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready & grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_4[4] = dl_detect_out ? proc_dep_vld_vec_4_reg[4] : (proc_4_data_FIFO_blk[4] | proc_4_data_PIPO_blk[4] | proc_4_start_FIFO_blk[4] | proc_4_TLF_FIFO_blk[4] | proc_4_input_sync_blk[4] | proc_4_output_sync_blk[4]);
    assign proc_4_data_FIFO_blk[5] = 1'b0;
    assign proc_4_data_PIPO_blk[5] = 1'b0;
    assign proc_4_start_FIFO_blk[5] = 1'b0;
    assign proc_4_TLF_FIFO_blk[5] = 1'b0;
    assign proc_4_input_sync_blk[5] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready & grp_v_scaler_top_fu_576.AXIMMvideo2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready);
    assign proc_4_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_4[5] = dl_detect_out ? proc_dep_vld_vec_4_reg[5] : (proc_4_data_FIFO_blk[5] | proc_4_data_PIPO_blk[5] | proc_4_start_FIFO_blk[5] | proc_4_TLF_FIFO_blk[5] | proc_4_input_sync_blk[5] | proc_4_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_0_4;
    assign in_chan_dep_data_vec_4[15 : 0] = dep_chan_data_0_4;
    assign token_in_vec_4[0] = token_0_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_1_4;
    assign in_chan_dep_data_vec_4[31 : 16] = dep_chan_data_1_4;
    assign token_in_vec_4[1] = token_1_4;
    assign in_chan_dep_vld_vec_4[2] = dep_chan_vld_2_4;
    assign in_chan_dep_data_vec_4[47 : 32] = dep_chan_data_2_4;
    assign token_in_vec_4[2] = token_2_4;
    assign in_chan_dep_vld_vec_4[3] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[63 : 48] = dep_chan_data_5_4;
    assign token_in_vec_4[3] = token_5_4;
    assign in_chan_dep_vld_vec_4[4] = dep_chan_vld_9_4;
    assign in_chan_dep_data_vec_4[79 : 64] = dep_chan_data_9_4;
    assign token_in_vec_4[4] = token_9_4;
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[0];
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[1];
    assign dep_chan_vld_4_0 = out_chan_dep_vld_vec_4[2];
    assign dep_chan_data_4_0 = out_chan_dep_data_4;
    assign token_4_0 = token_out_vec_4[2];
    assign dep_chan_vld_4_1 = out_chan_dep_vld_vec_4[3];
    assign dep_chan_data_4_1 = out_chan_dep_data_4;
    assign token_4_1 = token_out_vec_4[3];
    assign dep_chan_vld_4_2 = out_chan_dep_vld_vec_4[4];
    assign dep_chan_data_4_2 = out_chan_dep_data_4;
    assign token_4_2 = token_out_vec_4[4];
    assign dep_chan_vld_4_9 = out_chan_dep_vld_vec_4[5];
    assign dep_chan_data_4_9 = out_chan_dep_data_4;
    assign token_4_9 = token_out_vec_4[5];

    // Process: grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 5, 2, 3) v_multi_scaler_hls_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.grp_Bytes2MultiPixStream_Pipeline_VITIS_LOOP_308_1_fu_244.srcPlane0_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.grp_Bytes2MultiPixStream_Pipeline_VITIS_LOOP_308_1_fu_244.srcPlane1_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.HeightIn_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.trunc_ln884_loc_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.InPixelFmt_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0;
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.grp_Bytes2MultiPixStream_Pipeline_VITIS_LOOP_308_1_fu_244.stream_in_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.HeightIn_c98_blk_n);
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0;
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0;
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0;
    assign proc_5_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.WidthIn_cast42_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.Bytes2MultiPixStream_U0.ap_idle & ~grp_v_scaler_top_fu_576.WidthIn_cast42_loc_channel_U.if_write);
    assign proc_5_input_sync_blk[2] = 1'b0;
    assign proc_5_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[15 : 0] = dep_chan_data_4_5;
    assign token_in_vec_5[0] = token_4_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[31 : 16] = dep_chan_data_6_5;
    assign token_in_vec_5[1] = token_6_5;
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[0];
    assign dep_chan_vld_5_6 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_6 = out_chan_dep_data_5;
    assign token_5_6 = token_out_vec_5[1];
    assign dep_chan_vld_5_1 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_1 = out_chan_dep_data_5;
    assign token_5_1 = token_out_vec_5[2];

    // Process: grp_v_scaler_top_fu_576.v_vcresampler_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 6, 3, 4) v_multi_scaler_hls_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.grp_v_vcresampler_Pipeline_VITIS_LOOP_88_2_fu_168.stream_in_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.HeightIn_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0;
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.WidthIn_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    assign proc_6_data_FIFO_blk[2] = 1'b0;
    assign proc_6_data_PIPO_blk[2] = 1'b0;
    assign proc_6_start_FIFO_blk[2] = 1'b0;
    assign proc_6_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.bPassThruVcrUp_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_vcresampler_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruVcrUp_1_loc_channel_U.if_write);
    assign proc_6_input_sync_blk[2] = 1'b0;
    assign proc_6_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_6[2] = dl_detect_out ? proc_dep_vld_vec_6_reg[2] : (proc_6_data_FIFO_blk[2] | proc_6_data_PIPO_blk[2] | proc_6_start_FIFO_blk[2] | proc_6_TLF_FIFO_blk[2] | proc_6_input_sync_blk[2] | proc_6_output_sync_blk[2]);
    assign proc_6_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.grp_v_vcresampler_Pipeline_VITIS_LOOP_88_2_fu_168.stream_1_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.HeightIn_c97_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_U0.WidthIn_c104_blk_n);
    assign proc_6_data_PIPO_blk[3] = 1'b0;
    assign proc_6_start_FIFO_blk[3] = 1'b0;
    assign proc_6_TLF_FIFO_blk[3] = 1'b0;
    assign proc_6_input_sync_blk[3] = 1'b0;
    assign proc_6_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_6[3] = dl_detect_out ? proc_dep_vld_vec_6_reg[3] : (proc_6_data_FIFO_blk[3] | proc_6_data_PIPO_blk[3] | proc_6_start_FIFO_blk[3] | proc_6_TLF_FIFO_blk[3] | proc_6_input_sync_blk[3] | proc_6_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_3_6;
    assign in_chan_dep_data_vec_6[15 : 0] = dep_chan_data_3_6;
    assign token_in_vec_6[0] = token_3_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_5_6;
    assign in_chan_dep_data_vec_6[31 : 16] = dep_chan_data_5_6;
    assign token_in_vec_6[1] = token_5_6;
    assign in_chan_dep_vld_vec_6[2] = dep_chan_vld_7_6;
    assign in_chan_dep_data_vec_6[47 : 32] = dep_chan_data_7_6;
    assign token_in_vec_6[2] = token_7_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];
    assign dep_chan_vld_6_3 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_3 = out_chan_dep_data_6;
    assign token_6_3 = token_out_vec_6[1];
    assign dep_chan_vld_6_1 = out_chan_dep_vld_vec_6[2];
    assign dep_chan_data_6_1 = out_chan_dep_data_6;
    assign token_6_1 = token_out_vec_6[2];
    assign dep_chan_vld_6_7 = out_chan_dep_vld_vec_6[3];
    assign dep_chan_data_6_7 = out_chan_dep_data_6;
    assign token_6_7 = token_out_vec_6[3];

    // Process: grp_v_scaler_top_fu_576.v_hcresampler_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 7, 2, 3) v_multi_scaler_hls_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.grp_v_hcresampler_Pipeline_VITIS_LOOP_82_2_fu_214.stream_1_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.HeightIn_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.WidthIn_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0;
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0;
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0;
    assign proc_7_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.bPassThruHcrUp_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_hcresampler_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruHcrUp_1_loc_channel_U.if_write);
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    assign proc_7_data_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.grp_v_hcresampler_Pipeline_VITIS_LOOP_82_2_fu_214.stream_2_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.HeightIn_c_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_U0.WidthIn_c_blk_n);
    assign proc_7_data_PIPO_blk[2] = 1'b0;
    assign proc_7_start_FIFO_blk[2] = 1'b0;
    assign proc_7_TLF_FIFO_blk[2] = 1'b0;
    assign proc_7_input_sync_blk[2] = 1'b0;
    assign proc_7_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_7[2] = dl_detect_out ? proc_dep_vld_vec_7_reg[2] : (proc_7_data_FIFO_blk[2] | proc_7_data_PIPO_blk[2] | proc_7_start_FIFO_blk[2] | proc_7_TLF_FIFO_blk[2] | proc_7_input_sync_blk[2] | proc_7_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_6_7;
    assign in_chan_dep_data_vec_7[15 : 0] = dep_chan_data_6_7;
    assign token_in_vec_7[0] = token_6_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_8_7;
    assign in_chan_dep_data_vec_7[31 : 16] = dep_chan_data_8_7;
    assign token_in_vec_7[1] = token_8_7;
    assign dep_chan_vld_7_6 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_6 = out_chan_dep_data_7;
    assign token_7_6 = token_out_vec_7[0];
    assign dep_chan_vld_7_1 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_1 = out_chan_dep_data_7;
    assign token_7_1 = token_out_vec_7[1];
    assign dep_chan_vld_7_8 = out_chan_dep_vld_vec_7[2];
    assign dep_chan_data_7_8 = out_chan_dep_data_7;
    assign token_7_8 = token_out_vec_7[2];

    // Process: grp_v_scaler_top_fu_576.v_vscaler_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 8, 4, 5) v_multi_scaler_hls_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vscaler_U0.grp_v_vscaler_Pipeline_VITIS_LOOP_85_2_fu_126.stream_2_blk_n) | (~grp_v_scaler_top_fu_576.v_vscaler_U0.HeightIn_blk_n) | (~grp_v_scaler_top_fu_576.v_vscaler_U0.WidthIn_blk_n);
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0;
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    assign proc_8_data_FIFO_blk[1] = 1'b0;
    assign proc_8_data_PIPO_blk[1] = 1'b0;
    assign proc_8_start_FIFO_blk[1] = 1'b0;
    assign proc_8_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.HeightOut_cast_loc_c115_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_vscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.HeightOut_cast_loc_c115_channel_U.if_write) | (~grp_v_scaler_top_fu_576.bPassThruVsc_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_vscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruVsc_loc_channel_U.if_write);
    assign proc_8_input_sync_blk[1] = 1'b0;
    assign proc_8_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_8[1] = dl_detect_out ? proc_dep_vld_vec_8_reg[1] : (proc_8_data_FIFO_blk[1] | proc_8_data_PIPO_blk[1] | proc_8_start_FIFO_blk[1] | proc_8_TLF_FIFO_blk[1] | proc_8_input_sync_blk[1] | proc_8_output_sync_blk[1]);
    assign proc_8_data_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vscaler_U0.LineRate_blk_n);
    assign proc_8_data_PIPO_blk[2] = 1'b0;
    assign proc_8_start_FIFO_blk[2] = 1'b0;
    assign proc_8_TLF_FIFO_blk[2] = 1'b0;
    assign proc_8_input_sync_blk[2] = 1'b0;
    assign proc_8_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_8[2] = dl_detect_out ? proc_dep_vld_vec_8_reg[2] : (proc_8_data_FIFO_blk[2] | proc_8_data_PIPO_blk[2] | proc_8_start_FIFO_blk[2] | proc_8_TLF_FIFO_blk[2] | proc_8_input_sync_blk[2] | proc_8_output_sync_blk[2]);
    assign proc_8_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vscaler_U0.grp_v_vscaler_Pipeline_VITIS_LOOP_85_2_fu_126.stream_3_blk_n);
    assign proc_8_data_PIPO_blk[3] = 1'b0;
    assign proc_8_start_FIFO_blk[3] = 1'b0;
    assign proc_8_TLF_FIFO_blk[3] = 1'b0;
    assign proc_8_input_sync_blk[3] = 1'b0;
    assign proc_8_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_8[3] = dl_detect_out ? proc_dep_vld_vec_8_reg[3] : (proc_8_data_FIFO_blk[3] | proc_8_data_PIPO_blk[3] | proc_8_start_FIFO_blk[3] | proc_8_TLF_FIFO_blk[3] | proc_8_input_sync_blk[3] | proc_8_output_sync_blk[3]);
    assign proc_8_data_FIFO_blk[4] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vscaler_U0.HeightOut_cast_loc_c_blk_n);
    assign proc_8_data_PIPO_blk[4] = 1'b0;
    assign proc_8_start_FIFO_blk[4] = 1'b0;
    assign proc_8_TLF_FIFO_blk[4] = 1'b0;
    assign proc_8_input_sync_blk[4] = 1'b0;
    assign proc_8_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_8[4] = dl_detect_out ? proc_dep_vld_vec_8_reg[4] : (proc_8_data_FIFO_blk[4] | proc_8_data_PIPO_blk[4] | proc_8_start_FIFO_blk[4] | proc_8_TLF_FIFO_blk[4] | proc_8_input_sync_blk[4] | proc_8_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_0_8;
    assign in_chan_dep_data_vec_8[15 : 0] = dep_chan_data_0_8;
    assign token_in_vec_8[0] = token_0_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_7_8;
    assign in_chan_dep_data_vec_8[31 : 16] = dep_chan_data_7_8;
    assign token_in_vec_8[1] = token_7_8;
    assign in_chan_dep_vld_vec_8[2] = dep_chan_vld_9_8;
    assign in_chan_dep_data_vec_8[47 : 32] = dep_chan_data_9_8;
    assign token_in_vec_8[2] = token_9_8;
    assign in_chan_dep_vld_vec_8[3] = dep_chan_vld_10_8;
    assign in_chan_dep_data_vec_8[63 : 48] = dep_chan_data_10_8;
    assign token_in_vec_8[3] = token_10_8;
    assign dep_chan_vld_8_7 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_7 = out_chan_dep_data_8;
    assign token_8_7 = token_out_vec_8[0];
    assign dep_chan_vld_8_1 = out_chan_dep_vld_vec_8[1];
    assign dep_chan_data_8_1 = out_chan_dep_data_8;
    assign token_8_1 = token_out_vec_8[1];
    assign dep_chan_vld_8_0 = out_chan_dep_vld_vec_8[2];
    assign dep_chan_data_8_0 = out_chan_dep_data_8;
    assign token_8_0 = token_out_vec_8[2];
    assign dep_chan_vld_8_9 = out_chan_dep_vld_vec_8[3];
    assign dep_chan_data_8_9 = out_chan_dep_data_8;
    assign token_8_9 = token_out_vec_8[3];
    assign dep_chan_vld_8_10 = out_chan_dep_vld_vec_8[4];
    assign dep_chan_data_8_10 = out_chan_dep_data_8;
    assign token_8_10 = token_out_vec_8[4];

    // Process: grp_v_scaler_top_fu_576.v_hscaler_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 9, 7, 7) v_multi_scaler_hls_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hscaler_U0.grp_v_hscaler_Pipeline_VITIS_LOOP_94_2_fu_143.stream_3_blk_n);
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0;
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0;
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    assign proc_9_data_FIFO_blk[1] = 1'b0;
    assign proc_9_data_PIPO_blk[1] = 1'b0;
    assign proc_9_start_FIFO_blk[1] = 1'b0;
    assign proc_9_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.bPassThruHsc_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_hscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruHsc_1_loc_channel_U.if_write);
    assign proc_9_input_sync_blk[1] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready & grp_v_scaler_top_fu_576.v_hscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Block_entry69_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_9[1] = dl_detect_out ? proc_dep_vld_vec_9_reg[1] : (proc_9_data_FIFO_blk[1] | proc_9_data_PIPO_blk[1] | proc_9_start_FIFO_blk[1] | proc_9_TLF_FIFO_blk[1] | proc_9_input_sync_blk[1] | proc_9_output_sync_blk[1]);
    assign proc_9_data_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hscaler_U0.grp_v_hscaler_Pipeline_VITIS_LOOP_94_2_fu_143.stream_4_blk_n);
    assign proc_9_data_PIPO_blk[2] = 1'b0;
    assign proc_9_start_FIFO_blk[2] = 1'b0;
    assign proc_9_TLF_FIFO_blk[2] = 1'b0;
    assign proc_9_input_sync_blk[2] = 1'b0;
    assign proc_9_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_9[2] = dl_detect_out ? proc_dep_vld_vec_9_reg[2] : (proc_9_data_FIFO_blk[2] | proc_9_data_PIPO_blk[2] | proc_9_start_FIFO_blk[2] | proc_9_TLF_FIFO_blk[2] | proc_9_input_sync_blk[2] | proc_9_output_sync_blk[2]);
    assign proc_9_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hscaler_U0.HeightOut_c103_blk_n) | (~grp_v_scaler_top_fu_576.v_hscaler_U0.WidthOut_c108_blk_n);
    assign proc_9_data_PIPO_blk[3] = 1'b0;
    assign proc_9_start_FIFO_blk[3] = 1'b0;
    assign proc_9_TLF_FIFO_blk[3] = 1'b0;
    assign proc_9_input_sync_blk[3] = 1'b0;
    assign proc_9_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_9[3] = dl_detect_out ? proc_dep_vld_vec_9_reg[3] : (proc_9_data_FIFO_blk[3] | proc_9_data_PIPO_blk[3] | proc_9_start_FIFO_blk[3] | proc_9_TLF_FIFO_blk[3] | proc_9_input_sync_blk[3] | proc_9_output_sync_blk[3]);
    assign proc_9_data_FIFO_blk[4] = 1'b0;
    assign proc_9_data_PIPO_blk[4] = 1'b0;
    assign proc_9_start_FIFO_blk[4] = 1'b0;
    assign proc_9_TLF_FIFO_blk[4] = 1'b0;
    assign proc_9_input_sync_blk[4] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready & grp_v_scaler_top_fu_576.v_hscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_entry_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_9[4] = dl_detect_out ? proc_dep_vld_vec_9_reg[4] : (proc_9_data_FIFO_blk[4] | proc_9_data_PIPO_blk[4] | proc_9_start_FIFO_blk[4] | proc_9_TLF_FIFO_blk[4] | proc_9_input_sync_blk[4] | proc_9_output_sync_blk[4]);
    assign proc_9_data_FIFO_blk[5] = 1'b0;
    assign proc_9_data_PIPO_blk[5] = 1'b0;
    assign proc_9_start_FIFO_blk[5] = 1'b0;
    assign proc_9_TLF_FIFO_blk[5] = 1'b0;
    assign proc_9_input_sync_blk[5] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready & grp_v_scaler_top_fu_576.v_hscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_v_scaler_top_Loop_VITIS_LOOP_840_1_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_9[5] = dl_detect_out ? proc_dep_vld_vec_9_reg[5] : (proc_9_data_FIFO_blk[5] | proc_9_data_PIPO_blk[5] | proc_9_start_FIFO_blk[5] | proc_9_TLF_FIFO_blk[5] | proc_9_input_sync_blk[5] | proc_9_output_sync_blk[5]);
    assign proc_9_data_FIFO_blk[6] = 1'b0;
    assign proc_9_data_PIPO_blk[6] = 1'b0;
    assign proc_9_start_FIFO_blk[6] = 1'b0;
    assign proc_9_TLF_FIFO_blk[6] = 1'b0;
    assign proc_9_input_sync_blk[6] = 1'b0 | (grp_v_scaler_top_fu_576.ap_sync_v_hscaler_U0_ap_ready & grp_v_scaler_top_fu_576.v_hscaler_U0.ap_idle & ~grp_v_scaler_top_fu_576.ap_sync_AXIMMvideo2Bytes_U0_ap_ready);
    assign proc_9_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_9[6] = dl_detect_out ? proc_dep_vld_vec_9_reg[6] : (proc_9_data_FIFO_blk[6] | proc_9_data_PIPO_blk[6] | proc_9_start_FIFO_blk[6] | proc_9_TLF_FIFO_blk[6] | proc_9_input_sync_blk[6] | proc_9_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_0_9;
    assign in_chan_dep_data_vec_9[15 : 0] = dep_chan_data_0_9;
    assign token_in_vec_9[0] = token_0_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_1_9;
    assign in_chan_dep_data_vec_9[31 : 16] = dep_chan_data_1_9;
    assign token_in_vec_9[1] = token_1_9;
    assign in_chan_dep_vld_vec_9[2] = dep_chan_vld_2_9;
    assign in_chan_dep_data_vec_9[47 : 32] = dep_chan_data_2_9;
    assign token_in_vec_9[2] = token_2_9;
    assign in_chan_dep_vld_vec_9[3] = dep_chan_vld_4_9;
    assign in_chan_dep_data_vec_9[63 : 48] = dep_chan_data_4_9;
    assign token_in_vec_9[3] = token_4_9;
    assign in_chan_dep_vld_vec_9[4] = dep_chan_vld_8_9;
    assign in_chan_dep_data_vec_9[79 : 64] = dep_chan_data_8_9;
    assign token_in_vec_9[4] = token_8_9;
    assign in_chan_dep_vld_vec_9[5] = dep_chan_vld_10_9;
    assign in_chan_dep_data_vec_9[95 : 80] = dep_chan_data_10_9;
    assign token_in_vec_9[5] = token_10_9;
    assign in_chan_dep_vld_vec_9[6] = dep_chan_vld_11_9;
    assign in_chan_dep_data_vec_9[111 : 96] = dep_chan_data_11_9;
    assign token_in_vec_9[6] = token_11_9;
    assign dep_chan_vld_9_8 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_8 = out_chan_dep_data_9;
    assign token_9_8 = token_out_vec_9[0];
    assign dep_chan_vld_9_1 = out_chan_dep_vld_vec_9[1];
    assign dep_chan_data_9_1 = out_chan_dep_data_9;
    assign token_9_1 = token_out_vec_9[1];
    assign dep_chan_vld_9_10 = out_chan_dep_vld_vec_9[2];
    assign dep_chan_data_9_10 = out_chan_dep_data_9;
    assign token_9_10 = token_out_vec_9[2];
    assign dep_chan_vld_9_11 = out_chan_dep_vld_vec_9[3];
    assign dep_chan_data_9_11 = out_chan_dep_data_9;
    assign token_9_11 = token_out_vec_9[3];
    assign dep_chan_vld_9_0 = out_chan_dep_vld_vec_9[4];
    assign dep_chan_data_9_0 = out_chan_dep_data_9;
    assign token_9_0 = token_out_vec_9[4];
    assign dep_chan_vld_9_2 = out_chan_dep_vld_vec_9[5];
    assign dep_chan_data_9_2 = out_chan_dep_data_9;
    assign token_9_2 = token_out_vec_9[5];
    assign dep_chan_vld_9_4 = out_chan_dep_vld_vec_9[6];
    assign dep_chan_data_9_4 = out_chan_dep_data_9;
    assign token_9_4 = token_out_vec_9[6];

    // Process: grp_v_scaler_top_fu_576.v_csc_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 10, 3, 4) v_multi_scaler_hls_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_csc_U0.grp_v_csc_Pipeline_VITIS_LOOP_51_2_fu_94.stream_4_blk_n);
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0;
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0;
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    assign proc_10_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.v_csc_U0.HeightOut_cast_loc_blk_n);
    assign proc_10_data_PIPO_blk[1] = 1'b0;
    assign proc_10_start_FIFO_blk[1] = 1'b0;
    assign proc_10_TLF_FIFO_blk[1] = 1'b0;
    assign proc_10_input_sync_blk[1] = 1'b0;
    assign proc_10_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_10[1] = dl_detect_out ? proc_dep_vld_vec_10_reg[1] : (proc_10_data_FIFO_blk[1] | proc_10_data_PIPO_blk[1] | proc_10_start_FIFO_blk[1] | proc_10_TLF_FIFO_blk[1] | proc_10_input_sync_blk[1] | proc_10_output_sync_blk[1]);
    assign proc_10_data_FIFO_blk[2] = 1'b0;
    assign proc_10_data_PIPO_blk[2] = 1'b0;
    assign proc_10_start_FIFO_blk[2] = 1'b0;
    assign proc_10_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.WidthOut_cast43_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_csc_U0.ap_idle & ~grp_v_scaler_top_fu_576.WidthOut_cast43_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.ColorModeIn_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_csc_U0.ap_idle & ~grp_v_scaler_top_fu_576.ColorModeIn_loc_channel_U.if_write) | (~grp_v_scaler_top_fu_576.bPassThruCsc_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_csc_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruCsc_1_loc_channel_U.if_write);
    assign proc_10_input_sync_blk[2] = 1'b0;
    assign proc_10_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_10[2] = dl_detect_out ? proc_dep_vld_vec_10_reg[2] : (proc_10_data_FIFO_blk[2] | proc_10_data_PIPO_blk[2] | proc_10_start_FIFO_blk[2] | proc_10_TLF_FIFO_blk[2] | proc_10_input_sync_blk[2] | proc_10_output_sync_blk[2]);
    assign proc_10_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_csc_U0.grp_v_csc_Pipeline_VITIS_LOOP_51_2_fu_94.stream_4_csc_blk_n);
    assign proc_10_data_PIPO_blk[3] = 1'b0;
    assign proc_10_start_FIFO_blk[3] = 1'b0;
    assign proc_10_TLF_FIFO_blk[3] = 1'b0;
    assign proc_10_input_sync_blk[3] = 1'b0;
    assign proc_10_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_10[3] = dl_detect_out ? proc_dep_vld_vec_10_reg[3] : (proc_10_data_FIFO_blk[3] | proc_10_data_PIPO_blk[3] | proc_10_start_FIFO_blk[3] | proc_10_TLF_FIFO_blk[3] | proc_10_input_sync_blk[3] | proc_10_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_8_10;
    assign in_chan_dep_data_vec_10[15 : 0] = dep_chan_data_8_10;
    assign token_in_vec_10[0] = token_8_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_9_10;
    assign in_chan_dep_data_vec_10[31 : 16] = dep_chan_data_9_10;
    assign token_in_vec_10[1] = token_9_10;
    assign in_chan_dep_vld_vec_10[2] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[47 : 32] = dep_chan_data_11_10;
    assign token_in_vec_10[2] = token_11_10;
    assign dep_chan_vld_10_9 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_9 = out_chan_dep_data_10;
    assign token_10_9 = token_out_vec_10[0];
    assign dep_chan_vld_10_8 = out_chan_dep_vld_vec_10[1];
    assign dep_chan_data_10_8 = out_chan_dep_data_10;
    assign token_10_8 = token_out_vec_10[1];
    assign dep_chan_vld_10_1 = out_chan_dep_vld_vec_10[2];
    assign dep_chan_data_10_1 = out_chan_dep_data_10;
    assign token_10_1 = token_out_vec_10[2];
    assign dep_chan_vld_10_11 = out_chan_dep_vld_vec_10[3];
    assign dep_chan_data_10_11 = out_chan_dep_data_10;
    assign token_10_11 = token_out_vec_10[3];

    // Process: grp_v_scaler_top_fu_576.v_hcresampler_1_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 11, 3, 4) v_multi_scaler_hls_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.grp_v_hcresampler_1_Pipeline_VITIS_LOOP_82_2_fu_220.stream_4_csc_blk_n);
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0;
    assign proc_11_TLF_FIFO_blk[0] = 1'b0;
    assign proc_11_input_sync_blk[0] = 1'b0;
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.HeightOut_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.WidthOut_blk_n);
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0;
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0;
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    assign proc_11_data_FIFO_blk[2] = 1'b0;
    assign proc_11_data_PIPO_blk[2] = 1'b0;
    assign proc_11_start_FIFO_blk[2] = 1'b0;
    assign proc_11_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.bPassThruHcrDown_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_hcresampler_1_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruHcrDown_1_loc_channel_U.if_write);
    assign proc_11_input_sync_blk[2] = 1'b0;
    assign proc_11_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_11[2] = dl_detect_out ? proc_dep_vld_vec_11_reg[2] : (proc_11_data_FIFO_blk[2] | proc_11_data_PIPO_blk[2] | proc_11_start_FIFO_blk[2] | proc_11_TLF_FIFO_blk[2] | proc_11_input_sync_blk[2] | proc_11_output_sync_blk[2]);
    assign proc_11_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.grp_v_hcresampler_1_Pipeline_VITIS_LOOP_82_2_fu_220.stream_5_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.HeightOut_c102_blk_n) | (~grp_v_scaler_top_fu_576.v_hcresampler_1_U0.WidthOut_c107_blk_n);
    assign proc_11_data_PIPO_blk[3] = 1'b0;
    assign proc_11_start_FIFO_blk[3] = 1'b0;
    assign proc_11_TLF_FIFO_blk[3] = 1'b0;
    assign proc_11_input_sync_blk[3] = 1'b0;
    assign proc_11_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_11[3] = dl_detect_out ? proc_dep_vld_vec_11_reg[3] : (proc_11_data_FIFO_blk[3] | proc_11_data_PIPO_blk[3] | proc_11_start_FIFO_blk[3] | proc_11_TLF_FIFO_blk[3] | proc_11_input_sync_blk[3] | proc_11_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_9_11;
    assign in_chan_dep_data_vec_11[15 : 0] = dep_chan_data_9_11;
    assign token_in_vec_11[0] = token_9_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_10_11;
    assign in_chan_dep_data_vec_11[31 : 16] = dep_chan_data_10_11;
    assign token_in_vec_11[1] = token_10_11;
    assign in_chan_dep_vld_vec_11[2] = dep_chan_vld_12_11;
    assign in_chan_dep_data_vec_11[47 : 32] = dep_chan_data_12_11;
    assign token_in_vec_11[2] = token_12_11;
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[0];
    assign dep_chan_vld_11_9 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_9 = out_chan_dep_data_11;
    assign token_11_9 = token_out_vec_11[1];
    assign dep_chan_vld_11_1 = out_chan_dep_vld_vec_11[2];
    assign dep_chan_data_11_1 = out_chan_dep_data_11;
    assign token_11_1 = token_out_vec_11[2];
    assign dep_chan_vld_11_12 = out_chan_dep_vld_vec_11[3];
    assign dep_chan_data_11_12 = out_chan_dep_data_11;
    assign token_11_12 = token_out_vec_11[3];

    // Process: grp_v_scaler_top_fu_576.v_vcresampler_2_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 12, 2, 3) v_multi_scaler_hls_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.grp_v_vcresampler_2_Pipeline_VITIS_LOOP_88_2_fu_160.stream_5_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.HeightOut_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.WidthOut_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0;
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0;
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0;
    assign proc_12_TLF_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.bPassThruVcrDown_1_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.v_vcresampler_2_U0.ap_idle & ~grp_v_scaler_top_fu_576.bPassThruVcrDown_1_loc_channel_U.if_write);
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.grp_v_vcresampler_2_Pipeline_VITIS_LOOP_88_2_fu_160.stream_out_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.HeightOut_c101_blk_n) | (~grp_v_scaler_top_fu_576.v_vcresampler_2_U0.WidthOut_c_blk_n);
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0;
    assign proc_12_input_sync_blk[2] = 1'b0;
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_11_12;
    assign in_chan_dep_data_vec_12[15 : 0] = dep_chan_data_11_12;
    assign token_in_vec_12[0] = token_11_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_13_12;
    assign in_chan_dep_data_vec_12[31 : 16] = dep_chan_data_13_12;
    assign token_in_vec_12[1] = token_13_12;
    assign dep_chan_vld_12_11 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_11 = out_chan_dep_data_12;
    assign token_12_11 = token_out_vec_12[0];
    assign dep_chan_vld_12_1 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_1 = out_chan_dep_data_12;
    assign token_12_1 = token_out_vec_12[1];
    assign dep_chan_vld_12_13 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_13 = out_chan_dep_data_12;
    assign token_12_13 = token_out_vec_12[2];

    // Process: grp_v_scaler_top_fu_576.preProcessKernel_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 13, 2, 4) v_multi_scaler_hls_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.preProcessKernel_U0.grp_preProcessKernel_Pipeline_VITIS_LOOP_89_2_fu_138.stream_out_blk_n) | (~grp_v_scaler_top_fu_576.preProcessKernel_U0.HeightOut_blk_n) | (~grp_v_scaler_top_fu_576.preProcessKernel_U0.WidthOut_blk_n);
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0;
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0;
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.preProcessKernel_U0.grp_preProcessKernel_Pipeline_VITIS_LOOP_89_2_fu_138.dstStrm_blk_n) | (~grp_v_scaler_top_fu_576.preProcessKernel_U0.HeightOut_c100_blk_n);
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0;
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0;
    assign proc_13_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    assign proc_13_data_FIFO_blk[2] = 1'b0;
    assign proc_13_data_PIPO_blk[2] = 1'b0;
    assign proc_13_start_FIFO_blk[2] = 1'b0;
    assign proc_13_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.alpha_reg_1_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_1_U.if_write) | (~grp_v_scaler_top_fu_576.alpha_reg_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_U.if_write) | (~grp_v_scaler_top_fu_576.alpha_reg_2_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.alpha_reg_2_U.if_write) | (~grp_v_scaler_top_fu_576.beta_reg_2_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_2_U.if_write) | (~grp_v_scaler_top_fu_576.beta_reg_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_U.if_write) | (~grp_v_scaler_top_fu_576.beta_reg_1_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.beta_reg_1_U.if_write);
    assign proc_13_input_sync_blk[2] = 1'b0;
    assign proc_13_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_13[2] = dl_detect_out ? proc_dep_vld_vec_13_reg[2] : (proc_13_data_FIFO_blk[2] | proc_13_data_PIPO_blk[2] | proc_13_start_FIFO_blk[2] | proc_13_TLF_FIFO_blk[2] | proc_13_input_sync_blk[2] | proc_13_output_sync_blk[2]);
    assign proc_13_data_FIFO_blk[3] = 1'b0;
    assign proc_13_data_PIPO_blk[3] = 1'b0;
    assign proc_13_start_FIFO_blk[3] = 1'b0;
    assign proc_13_TLF_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.ColorModeOut_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.preProcessKernel_U0.ap_idle & ~grp_v_scaler_top_fu_576.ColorModeOut_loc_channel_U.if_write);
    assign proc_13_input_sync_blk[3] = 1'b0;
    assign proc_13_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_13[3] = dl_detect_out ? proc_dep_vld_vec_13_reg[3] : (proc_13_data_FIFO_blk[3] | proc_13_data_PIPO_blk[3] | proc_13_start_FIFO_blk[3] | proc_13_TLF_FIFO_blk[3] | proc_13_input_sync_blk[3] | proc_13_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_12_13;
    assign in_chan_dep_data_vec_13[15 : 0] = dep_chan_data_12_13;
    assign token_in_vec_13[0] = token_12_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_14_13;
    assign in_chan_dep_data_vec_13[31 : 16] = dep_chan_data_14_13;
    assign token_in_vec_13[1] = token_14_13;
    assign dep_chan_vld_13_12 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_12 = out_chan_dep_data_13;
    assign token_13_12 = token_out_vec_13[0];
    assign dep_chan_vld_13_14 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_14 = out_chan_dep_data_13;
    assign token_13_14 = token_out_vec_13[1];
    assign dep_chan_vld_13_3 = out_chan_dep_vld_vec_13[2];
    assign dep_chan_data_13_3 = out_chan_dep_data_13;
    assign token_13_3 = token_out_vec_13[2];
    assign dep_chan_vld_13_1 = out_chan_dep_vld_vec_13[3];
    assign dep_chan_data_13_1 = out_chan_dep_data_13;
    assign token_13_1 = token_out_vec_13[3];

    // Process: grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 14, 3, 4) v_multi_scaler_hls_deadlock_detect_unit_14 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_14),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_14),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_14),
        .token_in_vec(token_in_vec_14),
        .dl_detect_in(dl_detect_out),
        .origin(origin[14]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_14),
        .out_chan_dep_data(out_chan_dep_data_14),
        .token_out_vec(token_out_vec_14),
        .dl_detect_out(dl_in_vec[14]));

    assign proc_14_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.grp_MultiPixStream2Bytes_Pipeline_VITIS_LOOP_1279_1_fu_380.dstStrm_blk_n) | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.HeightOut_blk_n);
    assign proc_14_data_PIPO_blk[0] = 1'b0;
    assign proc_14_start_FIFO_blk[0] = 1'b0;
    assign proc_14_TLF_FIFO_blk[0] = 1'b0;
    assign proc_14_input_sync_blk[0] = 1'b0;
    assign proc_14_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_14[0] = dl_detect_out ? proc_dep_vld_vec_14_reg[0] : (proc_14_data_FIFO_blk[0] | proc_14_data_PIPO_blk[0] | proc_14_start_FIFO_blk[0] | proc_14_TLF_FIFO_blk[0] | proc_14_input_sync_blk[0] | proc_14_output_sync_blk[0]);
    assign proc_14_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.grp_MultiPixStream2Bytes_Pipeline_VITIS_LOOP_1279_1_fu_380.dstPlane0_blk_n) | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.grp_MultiPixStream2Bytes_Pipeline_VITIS_LOOP_1279_1_fu_380.dstPlane1_blk_n) | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.HeightOut_c_blk_n) | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.OutPixelFmt_c_blk_n) | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.trunc_ln936_loc_c_blk_n);
    assign proc_14_data_PIPO_blk[1] = 1'b0;
    assign proc_14_start_FIFO_blk[1] = 1'b0;
    assign proc_14_TLF_FIFO_blk[1] = 1'b0;
    assign proc_14_input_sync_blk[1] = 1'b0;
    assign proc_14_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_14[1] = dl_detect_out ? proc_dep_vld_vec_14_reg[1] : (proc_14_data_FIFO_blk[1] | proc_14_data_PIPO_blk[1] | proc_14_start_FIFO_blk[1] | proc_14_TLF_FIFO_blk[1] | proc_14_input_sync_blk[1] | proc_14_output_sync_blk[1]);
    assign proc_14_data_FIFO_blk[2] = 1'b0;
    assign proc_14_data_PIPO_blk[2] = 1'b0;
    assign proc_14_start_FIFO_blk[2] = 1'b0;
    assign proc_14_TLF_FIFO_blk[2] = 1'b0 | (~grp_v_scaler_top_fu_576.WidthOut_cast44_loc_channel_U.if_empty_n & grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.WidthOut_cast44_loc_channel_U.if_write);
    assign proc_14_input_sync_blk[2] = 1'b0;
    assign proc_14_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_14[2] = dl_detect_out ? proc_dep_vld_vec_14_reg[2] : (proc_14_data_FIFO_blk[2] | proc_14_data_PIPO_blk[2] | proc_14_start_FIFO_blk[2] | proc_14_TLF_FIFO_blk[2] | proc_14_input_sync_blk[2] | proc_14_output_sync_blk[2]);
    assign proc_14_data_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.OutPixelFmt_blk_n);
    assign proc_14_data_PIPO_blk[3] = 1'b0;
    assign proc_14_start_FIFO_blk[3] = 1'b0;
    assign proc_14_TLF_FIFO_blk[3] = 1'b0 | (~grp_v_scaler_top_fu_576.trunc_ln936_loc_c113_channel_U.if_empty_n & grp_v_scaler_top_fu_576.MultiPixStream2Bytes_U0.ap_idle & ~grp_v_scaler_top_fu_576.trunc_ln936_loc_c113_channel_U.if_write);
    assign proc_14_input_sync_blk[3] = 1'b0;
    assign proc_14_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_14[3] = dl_detect_out ? proc_dep_vld_vec_14_reg[3] : (proc_14_data_FIFO_blk[3] | proc_14_data_PIPO_blk[3] | proc_14_start_FIFO_blk[3] | proc_14_TLF_FIFO_blk[3] | proc_14_input_sync_blk[3] | proc_14_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_14_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_14_reg <= proc_dep_vld_vec_14;
        end
    end
    assign in_chan_dep_vld_vec_14[0] = dep_chan_vld_3_14;
    assign in_chan_dep_data_vec_14[15 : 0] = dep_chan_data_3_14;
    assign token_in_vec_14[0] = token_3_14;
    assign in_chan_dep_vld_vec_14[1] = dep_chan_vld_13_14;
    assign in_chan_dep_data_vec_14[31 : 16] = dep_chan_data_13_14;
    assign token_in_vec_14[1] = token_13_14;
    assign in_chan_dep_vld_vec_14[2] = dep_chan_vld_15_14;
    assign in_chan_dep_data_vec_14[47 : 32] = dep_chan_data_15_14;
    assign token_in_vec_14[2] = token_15_14;
    assign dep_chan_vld_14_13 = out_chan_dep_vld_vec_14[0];
    assign dep_chan_data_14_13 = out_chan_dep_data_14;
    assign token_14_13 = token_out_vec_14[0];
    assign dep_chan_vld_14_15 = out_chan_dep_vld_vec_14[1];
    assign dep_chan_data_14_15 = out_chan_dep_data_14;
    assign token_14_15 = token_out_vec_14[1];
    assign dep_chan_vld_14_1 = out_chan_dep_vld_vec_14[2];
    assign dep_chan_data_14_1 = out_chan_dep_data_14;
    assign token_14_1 = token_out_vec_14[2];
    assign dep_chan_vld_14_3 = out_chan_dep_vld_vec_14[3];
    assign dep_chan_data_14_3 = out_chan_dep_data_14;
    assign token_14_3 = token_out_vec_14[3];

    // Process: grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0
    v_multi_scaler_hls_deadlock_detect_unit #(16, 15, 2, 2) v_multi_scaler_hls_deadlock_detect_unit_15 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_15),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_15),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_15),
        .token_in_vec(token_in_vec_15),
        .dl_detect_in(dl_detect_out),
        .origin(origin[15]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_15),
        .out_chan_dep_data(out_chan_dep_data_15),
        .token_out_vec(token_out_vec_15),
        .dl_detect_out(dl_in_vec[15]));

    assign proc_15_data_FIFO_blk[0] = 1'b0 | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.grp_Bytes2AXIMMvideo_Pipeline_VITIS_LOOP_1649_1_fu_198.dstPlane0_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.grp_Bytes2AXIMMvideo_Pipeline_VITIS_LOOP_1660_2_fu_208.dstPlane1_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.HeightOut_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.trunc_ln936_loc_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.OutPixelFmt_blk_n);
    assign proc_15_data_PIPO_blk[0] = 1'b0;
    assign proc_15_start_FIFO_blk[0] = 1'b0;
    assign proc_15_TLF_FIFO_blk[0] = 1'b0;
    assign proc_15_input_sync_blk[0] = 1'b0;
    assign proc_15_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_15[0] = dl_detect_out ? proc_dep_vld_vec_15_reg[0] : (proc_15_data_FIFO_blk[0] | proc_15_data_PIPO_blk[0] | proc_15_start_FIFO_blk[0] | proc_15_TLF_FIFO_blk[0] | proc_15_input_sync_blk[0] | proc_15_output_sync_blk[0]);
    assign proc_15_data_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.dstImgBuf0_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.dstImgBuf1_blk_n) | (~grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.StrideOut_blk_n);
    assign proc_15_data_PIPO_blk[1] = 1'b0;
    assign proc_15_start_FIFO_blk[1] = 1'b0 | (~grp_v_scaler_top_fu_576.start_for_Bytes2AXIMMvideo_U0_U.if_empty_n & grp_v_scaler_top_fu_576.Bytes2AXIMMvideo_U0.ap_idle & ~grp_v_scaler_top_fu_576.start_for_Bytes2AXIMMvideo_U0_U.if_write);
    assign proc_15_TLF_FIFO_blk[1] = 1'b0;
    assign proc_15_input_sync_blk[1] = 1'b0;
    assign proc_15_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_15[1] = dl_detect_out ? proc_dep_vld_vec_15_reg[1] : (proc_15_data_FIFO_blk[1] | proc_15_data_PIPO_blk[1] | proc_15_start_FIFO_blk[1] | proc_15_TLF_FIFO_blk[1] | proc_15_input_sync_blk[1] | proc_15_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_15_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_15_reg <= proc_dep_vld_vec_15;
        end
    end
    assign in_chan_dep_vld_vec_15[0] = dep_chan_vld_0_15;
    assign in_chan_dep_data_vec_15[15 : 0] = dep_chan_data_0_15;
    assign token_in_vec_15[0] = token_0_15;
    assign in_chan_dep_vld_vec_15[1] = dep_chan_vld_14_15;
    assign in_chan_dep_data_vec_15[31 : 16] = dep_chan_data_14_15;
    assign token_in_vec_15[1] = token_14_15;
    assign dep_chan_vld_15_14 = out_chan_dep_vld_vec_15[0];
    assign dep_chan_data_15_14 = out_chan_dep_data_15;
    assign token_15_14 = token_out_vec_15[0];
    assign dep_chan_vld_15_0 = out_chan_dep_vld_vec_15[1];
    assign dep_chan_data_15_0 = out_chan_dep_data_15;
    assign token_15_0 = token_out_vec_15[1];


`include "v_multi_scaler_hls_deadlock_report_unit.vh"
