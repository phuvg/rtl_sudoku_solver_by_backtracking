////////////////////////////////////////////////////////////////////////////////
// Filename    : solve_fsm.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module solve_fsm(
    //-----------------------
    //clk and reset
    clk,
    rst_n,
    //-----------------------
    //input
    i_init_done,
    i_cmp,
    i_cmp_mark,
    i_bottom_reg,
    i_out_of_range,
    i_mark_fix,
    //-----------------------
    //output
    solve_addr_gen_en,
    solve_addr_gen_mark,
    solve_addr_decrease,
    solve_num_gen_rstn,
    solve_num_gen_en,
    solve_we,
    solve_we_mark,
    solve_mark_value,
    solve_wr_zero,
    solve_store_pre_data,
    solve_get_pre_num,
    solve_done
);
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter                           SOLVE_IDLE                      =   5'b00000;
    parameter                           SOLVE_NULL                      =   5'b10000;
    parameter                           SOLVE_TOP_LOOP_READ_NUM         =   5'b00001;
    parameter                           SOLVE_TOP_LOOP_NEXT_CELL        =   5'b00011;
    parameter                           SOLVE_TOP_LOOP_UPDATE_ADDR      =   5'b00010;
    parameter                           SOLVE_INT_LOOP_RST_NUMGEN       =   5'b00110;
    parameter                           SOLVE_INT_LOOP_WAIT             =   5'b10001;
    parameter                           SOLVE_INT_LOOP_GET_ADDR_MARK    =   5'b00111;
    parameter                           SOLVE_INT_LOOP_READ_MARKED      =   5'b00101;
    parameter                           SOLVE_INT_LOOP_WRITE_NUM        =   5'b00100;
    parameter                           SOLVE_INT_LOOP_PRE_MARK         =   5'b01100;
    parameter                           SOLVE_INT_LOOP_WRITE_MARK       =   5'b01101;
    parameter                           SOLVE_INT_LOOP_NEXT_LOOP        =   5'b01111;
    parameter                           SOLVE_INT_LOOP_GET_NEW_NUM      =   5'b01110;
    parameter                           SOLVE_INT_LOOP_UPDATE_NUM       =   5'b01010;
    parameter                           SOLVE_BACKTRACK                 =   5'b01011;
    parameter                           SOLVE_BACKTRACK_BACK_CELL       =   5'b01001;
    parameter                           SOLVE_BACKTRACK_READ_FIX        =   5'b11100;
    parameter                           SOLVE_BACKTRACK_READ_PRENUM     =   5'b01000;
    parameter                           SOLVE_BACKTRACK_STORE_PRENUM    =   5'b11000;
    parameter                           SOLVE_BACKTRACK_GET_ADDR_MARK   =   5'b11001;
    parameter                           SOLVE_BACKTRACK_REMARK_DATA     =   5'b11011;
    parameter                           SOLVE_DONE                      =   5'b11010;
    
    ////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //clk and reset
    input                               clk;
    input                               rst_n;
    //-----------------------
    //input
    input                               i_init_done;
    input                               i_cmp;
    input                               i_cmp_mark;
    input                               i_bottom_reg;
    input                               i_out_of_range;
    input                               i_mark_fix;
    //-----------------------
    //output
    output                              solve_addr_gen_en;
    output                              solve_addr_gen_mark;
    output                              solve_addr_decrease;
    output                              solve_num_gen_rstn;
    output                              solve_num_gen_en;
    output                              solve_we;
    output                              solve_we_mark;
    output                              solve_mark_value;
    output                              solve_wr_zero;
    output                              solve_store_pre_data;
    output                              solve_get_pre_num;
    output                              solve_done;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //fsm
    reg     [4:0]                       solve_state;
    reg     [4:0]                       nxt_solve_state;

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //--------------------------------------------------------------------------
    //solve fsm
    //--------------------------------------------------------------------------
    //-----------------------
    //combinational logic define next state
    always @(*) begin
        case(solve_state)
            SOLVE_IDLE: begin
                nxt_solve_state = i_init_done ? SOLVE_NULL : SOLVE_IDLE;
            end
            
            SOLVE_NULL: begin
                nxt_solve_state = SOLVE_TOP_LOOP_READ_NUM;
            end
            
            SOLVE_TOP_LOOP_READ_NUM: begin
                nxt_solve_state = i_cmp ? SOLVE_TOP_LOOP_NEXT_CELL : SOLVE_INT_LOOP_RST_NUMGEN;
            end
            
            SOLVE_TOP_LOOP_NEXT_CELL: begin
                nxt_solve_state = SOLVE_TOP_LOOP_UPDATE_ADDR;
            end
            
            SOLVE_TOP_LOOP_UPDATE_ADDR: begin
                nxt_solve_state = i_bottom_reg ? SOLVE_DONE : SOLVE_TOP_LOOP_READ_NUM;
            end
            
            SOLVE_INT_LOOP_RST_NUMGEN : begin
                nxt_solve_state = SOLVE_INT_LOOP_WAIT;
            end
            
            SOLVE_INT_LOOP_WAIT: begin
                nxt_solve_state = SOLVE_INT_LOOP_GET_ADDR_MARK;
            end
            
            SOLVE_INT_LOOP_GET_ADDR_MARK: begin
                nxt_solve_state = SOLVE_INT_LOOP_READ_MARKED;
            end
            
            SOLVE_INT_LOOP_READ_MARKED: begin
                nxt_solve_state = i_cmp_mark ? SOLVE_INT_LOOP_NEXT_LOOP : SOLVE_INT_LOOP_WRITE_NUM;
            end
            
            SOLVE_INT_LOOP_WRITE_NUM: begin
                nxt_solve_state = SOLVE_INT_LOOP_PRE_MARK;
            end
            
            SOLVE_INT_LOOP_PRE_MARK: begin
                nxt_solve_state = SOLVE_INT_LOOP_WRITE_MARK;
            end
            
            SOLVE_INT_LOOP_WRITE_MARK: begin
                nxt_solve_state = SOLVE_TOP_LOOP_NEXT_CELL;
            end
            
            SOLVE_INT_LOOP_NEXT_LOOP: begin
                nxt_solve_state = SOLVE_INT_LOOP_GET_NEW_NUM;
            end
            
            SOLVE_INT_LOOP_GET_NEW_NUM: begin
                nxt_solve_state = i_out_of_range ? SOLVE_BACKTRACK : SOLVE_INT_LOOP_UPDATE_NUM;
            end
            
            SOLVE_INT_LOOP_UPDATE_NUM: begin
                nxt_solve_state = SOLVE_INT_LOOP_GET_ADDR_MARK;
            end
            
            SOLVE_BACKTRACK: begin
                nxt_solve_state = SOLVE_BACKTRACK_BACK_CELL;
            end 
            
            SOLVE_BACKTRACK_BACK_CELL: begin
                nxt_solve_state = SOLVE_BACKTRACK_READ_FIX;
            end
            
            SOLVE_BACKTRACK_READ_FIX: begin
                nxt_solve_state = i_mark_fix ? SOLVE_BACKTRACK : SOLVE_BACKTRACK_READ_PRENUM;
            end
            
            SOLVE_BACKTRACK_READ_PRENUM: begin
                nxt_solve_state = SOLVE_BACKTRACK_STORE_PRENUM;
            end
            
            SOLVE_BACKTRACK_STORE_PRENUM: begin
                nxt_solve_state = SOLVE_BACKTRACK_GET_ADDR_MARK;
            end
            
            SOLVE_BACKTRACK_GET_ADDR_MARK: begin
                nxt_solve_state = SOLVE_BACKTRACK_REMARK_DATA;
            end
            
            SOLVE_BACKTRACK_REMARK_DATA: begin
                nxt_solve_state = SOLVE_INT_LOOP_GET_NEW_NUM;
            end
            
            SOLVE_DONE: begin
                nxt_solve_state = SOLVE_DONE;
            end
            
            default: begin
                nxt_solve_state = SOLVE_IDLE;
            end
        endcase
    end
    
    //-----------------------
    //sequential logic update state
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            solve_state <= SOLVE_IDLE;
        end else begin
            solve_state <= nxt_solve_state;
        end
    end
    
    //-----------------------
    //combinational logic define output
    assign solve_addr_gen_en = (solve_state == SOLVE_IDLE
                                || solve_state == SOLVE_TOP_LOOP_NEXT_CELL
                                || solve_state == SOLVE_BACKTRACK) ? 1'b1 : 1'b0;
    assign solve_addr_gen_mark = (solve_state == SOLVE_TOP_LOOP_READ_NUM
                                    || solve_state == SOLVE_INT_LOOP_RST_NUMGEN
                                    || solve_state == SOLVE_INT_LOOP_WAIT
                                    || solve_state == SOLVE_INT_LOOP_WRITE_NUM
                                    || solve_state == SOLVE_INT_LOOP_UPDATE_NUM
                                    || solve_state == SOLVE_BACKTRACK_STORE_PRENUM) ? 1'b1 : 1'b0;
    assign solve_addr_decrease = (solve_state == SOLVE_BACKTRACK) ? 1'b1 : 1'b0;
    assign solve_num_gen_rstn = (solve_state == SOLVE_TOP_LOOP_READ_NUM) ? 1'b0 : 1'b1;
    assign solve_num_gen_en = (solve_state == SOLVE_INT_LOOP_NEXT_LOOP
                                || solve_state == SOLVE_INT_LOOP_RST_NUMGEN
                                || solve_state == SOLVE_BACKTRACK_STORE_PRENUM
                                || solve_state == SOLVE_BACKTRACK_GET_ADDR_MARK
                                || solve_state == SOLVE_BACKTRACK_REMARK_DATA) ? 1'b1 : 1'b0;
    assign solve_we = (solve_state == SOLVE_INT_LOOP_WRITE_NUM
                        || solve_state == SOLVE_BACKTRACK_GET_ADDR_MARK) ? 1'b1 : 1'b0;
    assign solve_we_mark = (solve_state == SOLVE_INT_LOOP_PRE_MARK
                        || solve_state == SOLVE_BACKTRACK_GET_ADDR_MARK) ? 1'b1 : 1'b0;
    assign solve_mark_value = (solve_state == SOLVE_INT_LOOP_PRE_MARK) ? 1'b1 : 1'b0;
    assign solve_wr_zero = (solve_state == SOLVE_BACKTRACK_GET_ADDR_MARK) ? 1'b1 : 1'b0;
    assign solve_store_pre_data = (solve_state == SOLVE_BACKTRACK_READ_PRENUM) ? 1'b1 : 1'b0;
    assign solve_get_pre_num = (solve_state == SOLVE_BACKTRACK_STORE_PRENUM
                                || solve_state == SOLVE_BACKTRACK_GET_ADDR_MARK
                                || solve_state == SOLVE_BACKTRACK_REMARK_DATA) ? 1'b1 : 1'b0;
    assign solve_done = (solve_state == SOLVE_DONE) ? 1'b1 : 1'b0;
endmodule
