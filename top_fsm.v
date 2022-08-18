////////////////////////////////////////////////////////////////////////////////
// Filename    : top_fsm.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module top_fsm(
    //-----------------------
    //clk and reset
    clk,
    rst_n,
    //-----------------------
    //input
    i_start,
    i_cmp,
    i_cmp_mark,
    i_bottom_reg,
    i_out_of_range,
    i_mem_rddata,
    i_mark_fix,
    //-----------------------
    //output
    o_addr_gen_rstn,
    o_addr_gen_en,
    o_addr_gen_en_mark,
    o_addr_decrease,
    o_num_gen_rstn,
    o_num_gen_en,
    o_we,
    o_we_mark,
    o_mark_value,
    o_wr_zero,
    o_get_num_from_mem,
    o_get_pre_num,
    o_pre_data,
    o_done
);
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter                           IDLE        =       2'b00;
    parameter                           INIT        =       2'b01;
    parameter                           SOLVE       =       2'b11;
    parameter                           FINISH      =       2'b10;
    
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
    input                               i_cmp;
    input                               i_cmp_mark;
    input                               i_bottom_reg;
    input                               i_out_of_range;
    input   [3:0]                       i_mem_rddata;
    input                               i_mark_fix;
    //-----------------------
    //output
    output                              o_addr_gen_rstn;
    output                              o_addr_gen_en;
    output                              o_addr_gen_en_mark;
    output                              o_addr_decrease;
    output                              o_num_gen_rstn;
    output                              o_num_gen_en;
    output                              o_we;
    output                              o_we_mark;
    output                              o_mark_value;
    output                              o_wr_zero;
    output                              o_get_num_from_mem;
    output                              o_get_pre_num;
    output  [3:0]                       o_pre_data;
    output                              o_done;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //top fsm
    reg     [1:0]                       state;
    reg     [1:0]                       nxt_state;
    
    //-----------------------
    //top fsm interface
    wire  [1:0]                         top_sel;
    wire                                idle_addr_gen_rstn;
    wire                                idle_addr_gen_en;
    wire                                clk_gating_pre_data;
    reg   [3:0]                         nxt_pre_data;
    
    //-----------------------
    //init fsm interface
    wire                                init_start;
    wire                                init_addr_gen_rstn;
    wire                                init_addr_gen_en;
    wire                                init_we_mark;
    wire                                init_mark_value;
    wire                                init_done;
    
    //-----------------------
    //solve fsm interface
    reg                                 solve_start;
    wire                                solve_addr_gen_en;
    wire                                solve_addr_gen_mark;
    wire                                solve_num_gen_rstn;
    wire                                solve_num_gen_en;
    wire                                solve_we;
    wire                                solve_we_mark;
    wire                                solve_mark_value;
    wire                                solve_store_pre_data;
    wire                                solve_done;
    

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //--------------------------------------------------------------------------
    //INIT FSM
    //--------------------------------------------------------------------------
    init_fsm init_fsm(
        //-----------------------
        //clk and reset
        .clk(clk),
        .rst_n(rst_n),
        //-----------------------
        //input
        .i_start(init_start),
        .i_cmp(i_cmp),
        .i_bottom_reg(i_bottom_reg),
        //-----------------------
        //output
        .init_addr_gen_rstn(init_addr_gen_rstn),
        .init_addr_gen_en(init_addr_gen_en),
        .init_we_mark(init_we_mark),
        .init_mark_value(init_mark_value),
        .init_done(init_done)
    );
    
    //--------------------------------------------------------------------------
    //SOLVE FSM
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            solve_start <= 1'b0;
        end else begin
            solve_start <= init_done;
        end
    end
    solve_fsm solve_fsm(
        //-----------------------
        //clk and reset
        .clk(clk),
        .rst_n(rst_n),
        //-----------------------
        //input
        .i_init_done(solve_start),
        .i_cmp(i_cmp),
        .i_cmp_mark(i_cmp_mark),
        .i_bottom_reg(i_bottom_reg),
        .i_out_of_range(i_out_of_range),
        .i_mark_fix(i_mark_fix),
        //-----------------------
        //output
        .solve_addr_gen_en(solve_addr_gen_en),
        .solve_addr_gen_mark(solve_addr_gen_mark),
        .solve_addr_decrease(o_addr_decrease),
        .solve_num_gen_rstn(solve_num_gen_rstn),
        .solve_num_gen_en(solve_num_gen_en),
        .solve_we(solve_we),
        .solve_we_mark(solve_we_mark),
        .solve_mark_value(solve_mark_value),
        .solve_wr_zero(o_wr_zero),
        .solve_store_pre_data(solve_store_pre_data),
        .solve_get_pre_num(o_get_pre_num),
        .solve_done(solve_done)
    );
    
    //--------------------------------------------------------------------------
    //TOP FSM
    //--------------------------------------------------------------------------
    //-----------------------
    //combinational logic define next state
    always @(*) begin
        case(state)
            IDLE: begin
                nxt_state = i_start ? INIT : IDLE;
            end
            
            INIT: begin
                nxt_state = init_done ? SOLVE : INIT;
            end
            
            SOLVE: begin
                nxt_state = solve_done ? FINISH : SOLVE;
            end
            
            FINISH: begin
                nxt_state = FINISH;
            end
            
            default: begin
                nxt_state = IDLE;
            end
        endcase
    end
    
    //-----------------------
    //sequential logic update next state
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end else begin
            state <= nxt_state;
        end
    end
    
    //-----------------------
    //combinational logic define output
    assign init_start = (state == INIT) ? 1'b1 : 1'b0;
    assign top_sel = (state == INIT) ? 2'b01 :
                        (state == SOLVE) ? 2'b10 :
                        (state == FINISH) ? 2'b11 :
                        2'b00;
    assign idle_addr_gen_rstn = 1'b1;
    assign idle_addr_gen_en = (state == IDLE) ? 1'b0 : 1'b1;
    assign o_done = (state == FINISH) ? 1'b1 : 1'b0;
    
    //--------------------------------------------------------------------------
    //output connection
    //--------------------------------------------------------------------------
    assign o_addr_gen_rstn = top_sel[1] ? 1'b1 : (
                                    top_sel[0] ? init_addr_gen_rstn : idle_addr_gen_rstn
                                );
                                
    assign o_addr_gen_en = (top_sel == 2'b00) ? idle_addr_gen_en : (
                                (top_sel == 2'b01) ? init_addr_gen_en : (
                                    (top_sel == 2'b10) ? solve_addr_gen_en : 1'b0
                                )
                            );
                          
    assign o_addr_gen_en_mark = (top_sel == 2'b00) ? 1'b1 : (
                                    (top_sel == 2'b01) ? 1'b1 : (
                                        (top_sel == 2'b10) ? solve_addr_gen_mark : 1'b0
                                    )
                                );
                                
    assign o_num_gen_rstn = solve_num_gen_rstn;
    
    assign o_num_gen_en = solve_num_gen_en;
    
    assign o_we = solve_we;
    
    assign o_we_mark = (top_sel == 2'b00) ? 1'b0 : (
                                (top_sel == 2'b01) ? init_we_mark : (
                                    (top_sel == 2'b10) ? solve_we_mark : 1'b0
                                )
                            );
                            
    assign o_mark_value = (top_sel == 2'b00) ? 1'b0 : (
                                (top_sel == 2'b01) ? init_mark_value : (
                                    (top_sel == 2'b10) ? solve_mark_value : 1'b0
                                )
                            );
    
    assign clk_gating_pre_data = (~clk) & solve_store_pre_data;
    always @(posedge clk_gating_pre_data or negedge rst_n) begin
        if(!rst_n) begin
            nxt_pre_data <= 4'b0000;
        end else begin
            nxt_pre_data <= i_mem_rddata;
        end
    end
    assign o_pre_data = nxt_pre_data;
    
    assign o_get_num_from_mem = (top_sel == 2'b01) ? 1'b1 : 1'b0;

endmodule
