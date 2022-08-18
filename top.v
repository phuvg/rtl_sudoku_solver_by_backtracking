////////////////////////////////////////////////////////////////////////////////
// Filename    : top.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module sudoku_solver(
    //-----------------------
    //clk and reset
    clk,
    rst_n,
    //-----------------------
    //input
    i_start,
    //-----------------------
    //output
    o_done
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
    input                               i_start;
    //-----------------------
    //output
    output                              o_done;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //fsm interface
    wire                                fsm_addr_gen_rstn;
    wire                                fsm_addr_gen_en;
    wire                                fsm_addr_gen_en_mark;
    wire                                fsm_addr_decrease;
    wire                                fsm_num_gen_rstn;
    wire                                fsm_num_gen_en;
    wire                                fsm_we;
    wire                                fsm_we_mark;
    wire                                fsm_mark_value;
    wire                                fsm_wr_zero;
    wire                                fsm_get_num_from_mem;
    wire                                fsm_get_pre_num;
    wire    [3:0]                       fsm_pre_data;
    
    //-----------------------
    //num_gen interface
    wire    [3:0]                       num_gen_wrdata;
    wire                                num_gen_out_of_range;
    wire    [3:0]                       mux_write_num;
    
    //-----------------------
    //add_gen interface
    wire    [6:0]                       addr_gen_addr_out;
    wire    [6:0]                       addr_gen_addr_mark_row;
    wire    [6:0]                       addr_gen_addr_mark_col;
    wire    [6:0]                       addr_gen_addr_mark_matrix;
    wire                                addr_gen_bottom_reg;
    wire    [3:0]                       mux_addr_num;
    wire    [3:0]                       mux_addr_num_mem;
    wire                                addr_gen_rst;
    
    //-----------------------
    //mem interface
    wire    [3:0]                       mem_rddata;
    wire                                mem_rddata_mark_row;
    wire                                mem_rddata_mark_col;
    wire                                mem_rddata_mark_matrix;
    wire                                mem_rddata_mark_fix;
    wire    [3:0]                       mux_wrdata;
    
    //-----------------------
    //compare interface
    wire                                compare_out;
    wire                                compare_mark;

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //fsm
    top_fsm top_fsm(
        //-----------------------
        //clk and reset
        .clk(clk),
        .rst_n(rst_n),
        //-----------------------
        //input
        .i_start(i_start),
        .i_cmp(compare_out),
        .i_cmp_mark(compare_mark),
        .i_bottom_reg(addr_gen_bottom_reg),
        .i_out_of_range(num_gen_out_of_range),
        .i_mem_rddata(mem_rddata),
        .i_mark_fix(mem_rddata_mark_fix),
        //-----------------------
        //output
        .o_addr_gen_rstn(fsm_addr_gen_rstn),
        .o_addr_gen_en(fsm_addr_gen_en),
        .o_addr_gen_en_mark(fsm_addr_gen_en_mark),
        .o_addr_decrease(fsm_addr_decrease),
        .o_num_gen_rstn(fsm_num_gen_rstn),
        .o_num_gen_en(fsm_num_gen_en),
        .o_we(fsm_we),
        .o_we_mark(fsm_we_mark),
        .o_mark_value(fsm_mark_value),
        .o_wr_zero(fsm_wr_zero),
        .o_get_num_from_mem(fsm_get_num_from_mem),
        .o_get_pre_num(fsm_get_pre_num),
        .o_pre_data(fsm_pre_data),
        .o_done(o_done)
    );
    
    //-----------------------
    //num_gen
    assign num_gen_rst = rst_n & fsm_num_gen_rstn;
    assign mux_write_num = fsm_get_pre_num ? fsm_pre_data : num_gen_wrdata;
    num_gen num_gen(
        //-----------------------
        //clk and reset
        .clk(clk),
        .rst_n(num_gen_rst),
        //input
        .i_wrdata(mux_write_num),
        .i_enable(fsm_num_gen_en),
        //-----------------------
        //output
        .o_wrdata(num_gen_wrdata),
        .o_out_of_range(num_gen_out_of_range)
    );
    
    //-----------------------
    //addr_gen
    assign addr_gen_rst = rst_n & fsm_addr_gen_rstn;
    assign mux_addr_num_mem = fsm_get_num_from_mem ? mem_rddata : num_gen_wrdata;
    assign mux_addr_num = fsm_get_pre_num ? fsm_pre_data : mux_addr_num_mem;
    addr_gen addr_gen(
        //-----------------------
        //clk and reset
        .clk(clk),
        .rst_n(addr_gen_rst),
        //-----------------------
        //input
        .i_enable(fsm_addr_gen_en),
        .i_enable_mark(fsm_addr_gen_en_mark),
        .i_addr(addr_gen_addr_out),
        .i_num(mux_addr_num),
        .i_decrease(fsm_addr_decrease),
        //-----------------------
        //output
        .o_addr(addr_gen_addr_out),
        .o_addr_mark_row(addr_gen_addr_mark_row),
        .o_addr_mark_col(addr_gen_addr_mark_col),
        .o_addr_mark_matrix(addr_gen_addr_mark_matrix),
        .o_bottom_reg(addr_gen_bottom_reg)
    );
    
    //-----------------------
    //memory
    assign mux_wrdata = fsm_wr_zero ? 4'b0000 : num_gen_wrdata;
    mem mem(
        //-----------------------
        //clk and reset
        .clk(clk),
        //-----------------------
        //input
        .i_we(fsm_we),
        .i_we_mark(fsm_we_mark),
        .i_wrdata(mux_wrdata),
        .i_wrdata_mark_row(fsm_mark_value),
        .i_wrdata_mark_col(fsm_mark_value),
        .i_wrdata_mark_matrix(fsm_mark_value),
        .i_addr(addr_gen_addr_out),
        .i_addr_mark_row(addr_gen_addr_mark_row),
        .i_addr_mark_col(addr_gen_addr_mark_col),
        .i_addr_mark_matrix(addr_gen_addr_mark_matrix),
        //-----------------------
        //output
        .o_rddata(mem_rddata),
        .o_rddata_mark_row(mem_rddata_mark_row),
        .o_rddata_mark_col(mem_rddata_mark_col),
        .o_rddata_mark_matrix(mem_rddata_mark_matrix),
        .o_rddata_mark_fix(mem_rddata_mark_fix)
    );
    
    //-----------------------
    //compare
    compare compare(
        //-----------------------
        //data compare input
        .i_rddata(mem_rddata),
        //-----------------------
        //mark compare input
        .i_rddata_mark_row(mem_rddata_mark_row),
        .i_rddata_mark_col(mem_rddata_mark_col),
        .i_rddata_mark_matrix(mem_rddata_mark_matrix),
        //-----------------------
        //data compare output
        .o_cmp(compare_out),
        //-----------------------
        //mark compare output
        .o_cmp_mark(compare_mark)
    );

endmodule
