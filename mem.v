////////////////////////////////////////////////////////////////////////////////
// Filename    : mem.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial     
//
////////////////////////////////////////////////////////////////////////////////
module mem(
    //-----------------------
    //clk and reset
    clk,
    //-----------------------
    //input
    i_we,
    i_we_mark,
    i_wrdata,
    i_wrdata_mark_row,
    i_wrdata_mark_col,
    i_wrdata_mark_matrix,
    i_addr,
    i_addr_mark_row,
    i_addr_mark_col,
    i_addr_mark_matrix,
    //-----------------------
    //output
    o_rddata,
    o_rddata_mark_row,
    o_rddata_mark_col,
    o_rddata_mark_matrix,
    o_rddata_mark_fix
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
    //-----------------------
    //input
    input                               i_we;
    input                               i_we_mark;
    input   [3:0]                       i_wrdata;
    input                               i_wrdata_mark_row;
    input                               i_wrdata_mark_col;
    input                               i_wrdata_mark_matrix;
    input   [6:0]                       i_addr;
    input   [6:0]                       i_addr_mark_row;
    input   [6:0]                       i_addr_mark_col;
    input   [6:0]                       i_addr_mark_matrix;
    //-----------------------
    //output
    output  [3:0]                       o_rddata;
    output                              o_rddata_mark_row;
    output                              o_rddata_mark_col;
    output                              o_rddata_mark_matrix;
    output                              o_rddata_mark_fix;
    
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //memory
    reg     [7:0]                       mem[0:80];
    //data - mark row - mark col - mark matrix
    reg     [3:0]                       nxt_rddata;
    reg                                 nxt_rddata_mark_row;
    reg                                 nxt_rddata_mark_col;
    reg                                 nxt_rddata_mark_matrix;
    reg                                 nxt_rddata_mark_fix;

    ////////////////////////////////////////////////////////////////////////////
    //design description
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //memory
    always @(posedge clk) begin
        if(i_we) begin
            //write data
            mem[i_addr][3:0] <= i_wrdata; 
        end else begin
            //read data
            nxt_rddata <= mem[i_addr][3:0];
        end
        
        if(i_we_mark) begin
            //write mark
            mem[i_addr_mark_row][4] <= i_wrdata_mark_row;
        end else begin
            //read mark
            nxt_rddata_mark_row <= mem[i_addr_mark_row][4];
        end
        
        if(i_we_mark) begin
            //write mark
            mem[i_addr_mark_col][5] <= i_wrdata_mark_col;
        end else begin
            //read mark
            nxt_rddata_mark_col <= mem[i_addr_mark_col][5];
        end
        
        if(i_we_mark) begin
            //write mark
            mem[i_addr_mark_matrix][6] <= i_wrdata_mark_matrix;
        end else begin
            //read mark
            nxt_rddata_mark_matrix <= mem[i_addr_mark_matrix][6];
        end
        
        nxt_rddata_mark_fix <= mem[i_addr][7];
    end
    
    //-----------------------
    //output
    assign o_rddata = nxt_rddata;
    assign o_rddata_mark_row = nxt_rddata_mark_row;
    assign o_rddata_mark_col = nxt_rddata_mark_col;
    assign o_rddata_mark_matrix = nxt_rddata_mark_matrix;
    assign o_rddata_mark_fix = nxt_rddata_mark_fix;

endmodule
