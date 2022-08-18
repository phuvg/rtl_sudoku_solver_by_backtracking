////////////////////////////////////////////////////////////////////////////////
// Filename    : tb_top.v
// Description : 
//
// Author      : Phu Vuong
// History     : Aug, 01 2022 : Initial 	
//
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module tb_top();
	////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
	parameter					CLK_PERIOD = 1; //T=1ns => F=1GHz
	
	////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//clk and reset
    reg                             clk;
    reg                             rst_n;
	//-----------------------
	//input
    reg                             start;
	//-----------------------
	//output
    wire                            done;
	
	////////////////////////////////////////////////////////////////////////////
    //testbench reg/wire declaration
    ////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
    //instance
    ////////////////////////////////////////////////////////////////////////////
    sudoku_solver sudoku_solver_00(
    //-----------------------
    //clk and reset
    .clk(clk),
    .rst_n(rst_n),
    //-----------------------
    //input
    .i_start(start),
    //-----------------------
    //output
    .o_done(done)
    );
	
	////////////////////////////////////////////////////////////////////////////
    //testbench internal logic
    ////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
    //testbench
    ////////////////////////////////////////////////////////////////////////////
    //testbench
    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        
        #(4.5*CLK_PERIOD) rst_n = 1'b1;
        #(4.5*CLK_PERIOD) start = 1'b1;
    end
    
    //test input
    initial begin
        //$readmemb("test1_input.txt", sudoku_solver_00.mem.mem);
        //$readmemb("test2_input.txt", sudoku_solver_00.mem.mem);
        //$readmemb("test3_input.txt", sudoku_solver_00.mem.mem);
        //$readmemb("test4_input.txt", sudoku_solver_00.mem.mem);
        //$readmemb("test5_input.txt", sudoku_solver_00.mem.mem);
        //$readmemb("test6_input.txt", sudoku_solver_00.mem.mem);
        $readmemb("testn_input.txt", sudoku_solver_00.mem.mem);
    end
    
    always @(posedge sudoku_solver_00.top_fsm.init_fsm.init_done) begin
        //$writememb("test1_output_init.txt", sudoku_solver_00.mem.mem);
        //$writememb("test2_output_init.txt", sudoku_solver_00.mem.mem);
        //$writememb("test3_output_init.txt", sudoku_solver_00.mem.mem);
        //$writememb("test4_output_init.txt", sudoku_solver_00.mem.mem);
        //$writememb("test5_output_init.txt", sudoku_solver_00.mem.mem);
        //$writememb("test6_output_init.txt", sudoku_solver_00.mem.mem);
        $writememb("testn_output_init.txt", sudoku_solver_00.mem.mem);
    end
    
    always @(posedge done) begin
        //$writememh("test1_output_solve.txt", sudoku_solver_00.mem.mem);
        //$writememh("test2_output_solve.txt", sudoku_solver_00.mem.mem);
        //$writememh("test3_output_solve.txt", sudoku_solver_00.mem.mem);
        //$writememh("test4_output_solve.txt", sudoku_solver_00.mem.mem);
        //$writememh("test5_output_solve.txt", sudoku_solver_00.mem.mem);
        //$writememh("test6_output_solve.txt", sudoku_solver_00.mem.mem);
        $writememh("testn_output_solve.txt", sudoku_solver_00.mem.mem);
        #(10*CLK_PERIOD); $finish();
    end
    
    //clock
    always begin
        #(0.5*CLK_PERIOD) clk <= ~clk;
    end
    
	////////////////////////////////////////////////////////////////////////////
    //task
    ////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
    //dump waveform
    ////////////////////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wf_top.vcd");
        $dumpvars(tb_top);
    end
endmodule
