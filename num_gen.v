////////////////////////////////////////////////////////////////////////////////
// Filename    : num_gen.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial 	
//
////////////////////////////////////////////////////////////////////////////////
module num_gen(
	//-----------------------
	//clk and reset
	clk,
	rst_n,
	//input
	i_wrdata,
	i_enable,
	//-----------------------
	//output
	o_wrdata,
	o_out_of_range
);
	////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//clk and reset
	input						clk;
	input						rst_n;
	//-----------------------
	//input
	input	[3:0]				i_wrdata;
	input						i_enable;
	//-----------------------
	//output
	output	[3:0]				o_wrdata;
	output						o_out_of_range;
	////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//alu 4 bit
	wire	[3:0]				alu_add;
	wire	[3:0]				alu_sub;
	wire	[3:0]				cur_data; //output of alu
	//-----------------------
	//enable detection
	reg							int_enable;
	wire						clk_gate;
	//-----------------------
	//wrdata output
	reg		[3:0]				reg_wrdata;
	//-----------------------
	//range checker
	wire	[3:0]				checker;
	////////////////////////////////////////////////////////////////////////////
    //num_gen description
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//alu 4 bit
	full_adder_4_bit adder(.i_a(i_wrdata[3:0]), .i_b(4'b0001), .o_s(alu_add));
	assign cur_data = alu_add;
	//-----------------------
	//enable detection
	always @(negedge clk or negedge rst_n) begin
		if(!rst_n) begin
			int_enable <= 1'b0;
		end else begin
			int_enable <= i_enable;
		end
	end
	assign clk_gate = clk & int_enable;
	//-----------------------
	//wrdata output
	always @(posedge clk_gate or negedge rst_n) begin
		if(!rst_n) begin
			reg_wrdata <= 4'b0;
		end else begin
			reg_wrdata <= cur_data;
		end
	end
	assign o_wrdata = reg_wrdata;
	//-----------------------
	//range checker
	assign checker = i_wrdata ~^ 4'b1010;
	assign o_out_of_range = checker[3] & checker[2] & checker[1] & checker[0];
endmodule
