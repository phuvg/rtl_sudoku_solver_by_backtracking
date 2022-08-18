////////////////////////////////////////////////////////////////////////////////
// Filename    : init_fsm.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module init_fsm(
    //-----------------------
    //clk and reset
    clk,
    rst_n,
    //-----------------------
    //input
    i_start,
    i_cmp,
    i_bottom_reg,
    //-----------------------
    //output
    init_addr_gen_rstn,
    init_addr_gen_en,
    init_we_mark,
    init_mark_value,
    init_done
);
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter                           INIT_IDLE               =       3'b000;
    parameter                           INIT_NULL               =       3'b001;
    parameter                           INIT_READ_MEM_AND_CMP   =       3'b011;
    parameter                           INIT_PREPARE_ADDR_MARK  =       3'b010;
    parameter                           INIT_NOPE               =       3'b110;
    parameter                           INIT_WRITE_MARK         =       3'b111;
    parameter                           INIT_UPDATE_ADDR        =       3'b101;
    parameter                           INIT_DONE               =       3'b100;
    
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
    input                               i_bottom_reg;
    //-----------------------
    //output
    output                              init_addr_gen_rstn;
    output                              init_addr_gen_en;
    output                              init_we_mark;
    output                              init_mark_value;
    output                              init_done;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //fsm
    reg     [2:0]                       init_state;
    reg     [2:0]                       init_nxt_state;

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //--------------------------------------------------------------------------
    //init fsm
    //--------------------------------------------------------------------------
    //-----------------------
    //combinational logic define next state
    always @(*) begin
        case(init_state)
            INIT_IDLE: begin
                init_nxt_state = i_start ? INIT_NULL : INIT_IDLE;
            end
            
            INIT_NULL: begin
                init_nxt_state = INIT_READ_MEM_AND_CMP;
            end
            
            INIT_READ_MEM_AND_CMP: begin
                init_nxt_state = i_cmp ? INIT_PREPARE_ADDR_MARK : INIT_NOPE;
            end
            
            INIT_PREPARE_ADDR_MARK: begin
                init_nxt_state = INIT_WRITE_MARK;
            end
            
            INIT_NOPE: begin
                init_nxt_state = INIT_UPDATE_ADDR;
            end
            
            INIT_WRITE_MARK: begin
                init_nxt_state = INIT_UPDATE_ADDR;
            end
            
            INIT_UPDATE_ADDR: begin
                init_nxt_state = i_bottom_reg ? INIT_DONE : INIT_READ_MEM_AND_CMP;
            end
            
            INIT_DONE: begin
                init_nxt_state = INIT_DONE;
            end
            
            default: begin
                init_nxt_state = INIT_IDLE;
            end
        endcase
    end
    
    //-----------------------
    //sequential logic update state
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            init_state <= INIT_IDLE;
        end else begin
            init_state <= init_nxt_state;
        end
    end
    
    //-----------------------
    //combinational logic define output
    assign init_addr_gen_rstn = (init_state == INIT_DONE) ? 1'b0 : 1'b1;
    assign init_addr_gen_en = (init_state == INIT_IDLE
                                || init_state == INIT_WRITE_MARK
                                || init_state == INIT_NOPE
                                || init_state == INIT_DONE) ? 1'b1 : 1'b0;
    assign init_we_mark = (init_state == INIT_WRITE_MARK) ? 1'b1 : 1'b0;
    assign init_mark_value = (init_state == INIT_WRITE_MARK) ? 1'b1 : 1'b0;
    assign init_done = (init_state == INIT_DONE) ? 1'b1 : 1'b0;

endmodule
