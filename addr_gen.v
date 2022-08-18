////////////////////////////////////////////////////////////////////////////////
// Filename    : addr_gen.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module addr_gen(
    //-----------------------
    //clk and reset
    clk,
    rst_n,
    //-----------------------
    //input
    i_enable,
    i_enable_mark,
    i_addr,
    i_num,
    i_decrease,
    //-----------------------
    //output
    o_addr,
    o_addr_mark_row,
    o_addr_mark_col,
    o_addr_mark_matrix,
    o_bottom_reg
);
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //clk and reset
    input                               clk;
    input                               rst_n;
    //-----------------------
    //input
    input                               i_enable;
    input                               i_enable_mark;
    input   [6:0]                       i_addr;
    input   [3:0]                       i_num;
    input                               i_decrease;
    //-----------------------
    //output
    output  [6:0]                       o_addr;
    output  [6:0]                       o_addr_mark_row;
    output  [6:0]                       o_addr_mark_col;
    output  [6:0]                       o_addr_mark_matrix;
    output                              o_bottom_reg;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //int enable
    reg                                 nxt_int_enable;
    wire                                int_enable;
    //int enable mark
    reg                                 nxt_int_enable_mark;
    wire                                int_enable_mark;
    //alu
    wire    [6:0]                       addr_add;
    wire    [6:0]                       addr_sub;
    wire    [6:0]                       cur_addr;
    //output addr
    reg     [6:0]                       nxt_addr;
    wire                                addr_clk_gating;
    //output addr row
    reg     [6:0]                       nxt_addr_row;
    wire                                addr_row_clk_gating;
    wire    [6:0]                       cur_addr_row;
    //output addr col
    reg     [6:0]                       nxt_addr_col;
    wire                                addr_col_clk_gating;
    wire    [6:0]                       cur_addr_col;
    //output addr matrix
    reg     [6:0]                       nxt_addr_matrix;
    wire                                addr_matrix_clk_gating;
    wire    [6:0]                       cur_addr_matrix;
    //output bottom reg
    wire    [6:0]                       xor_output;

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //int enable
    always @(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            nxt_int_enable <= 1'b0;
        end else begin
            nxt_int_enable <= i_enable;
        end
    end
    assign int_enable = nxt_int_enable;
    
    //-----------------------
    //int enable mark
    always @(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            nxt_int_enable_mark <= 1'b0;
        end else begin
            nxt_int_enable_mark <= i_enable_mark;
        end
    end
    assign int_enable_mark = nxt_int_enable_mark;
    
    //-----------------------
    //alu
    full_adder_7_bit adder(.i_a(i_addr), .i_b(7'b000_0001), .o_s(addr_add));
    full_subtractor_7_bit sub(.i_a(i_addr), .i_b(7'b000_0001), .o_d(addr_sub));
    assign cur_addr = (i_decrease) ? addr_sub : addr_add;
    
    //-----------------------
    //output addr
    assign addr_clk_gating = clk & int_enable;
    always @(posedge addr_clk_gating or negedge rst_n) begin
        if(!rst_n) begin
            nxt_addr <= 7'b111_1111;
        end else begin
            nxt_addr <= cur_addr;
        end
    end
    assign o_addr = nxt_addr;
    
    //-----------------------
    //output addr row
    add_decoder_row addr_row_decoder(.i_addr(i_addr), .i_num(i_num), .o_addr_row(cur_addr_row));
    assign addr_row_clk_gating = clk & int_enable_mark;
    always @(posedge addr_row_clk_gating or negedge rst_n) begin
        if(!rst_n) begin
            nxt_addr_row <= 7'b000_0000;
        end else begin
            nxt_addr_row <= cur_addr_row;
        end
    end
    assign o_addr_mark_row = nxt_addr_row;
    
    //-----------------------
    //output addr col
    add_decoder_col addr_col_decoder(.i_addr(i_addr), .i_num(i_num), .o_addr_col(cur_addr_col));
    assign addr_col_clk_gating = clk & int_enable_mark;
    always @(posedge addr_col_clk_gating or negedge rst_n) begin
        if(!rst_n) begin
            nxt_addr_col <= 7'b000_0000;
        end else begin
            nxt_addr_col <= cur_addr_col;
        end
    end
    assign o_addr_mark_col = nxt_addr_col;

    //-----------------------
    //output addr matrix
    add_decoder_matrix addr_matrix_decoder(.i_addr(i_addr), .i_num(i_num), .o_addr_matrix(cur_addr_matrix));
    assign addr_matrix_clk_gating = clk & int_enable_mark;
    always @(posedge addr_matrix_clk_gating or negedge rst_n) begin
        if(!rst_n) begin
            nxt_addr_matrix <= 7'b000_0000;
        end else begin
            nxt_addr_matrix <= cur_addr_matrix;
        end
    end
    assign o_addr_mark_matrix = nxt_addr_matrix;
    
    //-----------------------
    //output bottom reg
    assign xor_output = cur_addr ^ (7'd82);
    assign o_bottom_reg = ~(|(xor_output[6:0]));
endmodule
