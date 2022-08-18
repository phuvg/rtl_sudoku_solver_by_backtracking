////////////////////////////////////////////////////////////////////////////////
// Filename    : compare.v
// Description : 
//
// Author      : Phu Vuong
// History     : Jul, 31 2022 : Initial 	
//
////////////////////////////////////////////////////////////////////////////////
module compare(
	//-----------------------
	//data compare input
	i_rddata,
	//-----------------------
	//mark compare input
	i_rddata_mark_row,
	i_rddata_mark_col,
	i_rddata_mark_matrix,
	//-----------------------
	//data compare output
	o_cmp,
	//-----------------------
	//mark compare output
	o_cmp_mark
);
	////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//data compare input
	input	[3:0]				i_rddata;
	//-----------------------
	//mark compare input
	input						i_rddata_mark_row;
	input						i_rddata_mark_col;
	input						i_rddata_mark_matrix;
	//-----------------------
	//data compare output
	output                      o_cmp;
	//-----------------------
	//mark compare output
	output						o_cmp_mark;
	////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
	wire						cmp_data_3;
	wire						cmp_data_2;
	wire						cmp_data_1;
	wire						cmp_data_0;
	wire						cmp_or_1;
	wire						cmp_or_0;
	////////////////////////////////////////////////////////////////////////////
    //compare block description
    ////////////////////////////////////////////////////////////////////////////
	//-----------------------
	//compare data
	assign cmp_data_3 = i_rddata[3] ^ 1'b0;
	assign cmp_data_2 = i_rddata[2] ^ 1'b0;
	assign cmp_data_1 = i_rddata[1] ^ 1'b0;
	assign cmp_data_0 = i_rddata[0] ^ 1'b0;
	assign cmp_or_1 = cmp_data_3 | cmp_data_2;
	assign cmp_or_0 = cmp_data_1 | cmp_data_0;
	assign o_cmp = cmp_or_1 | cmp_or_0;
	//compare mark
	assign o_cmp_mark = i_rddata_mark_row | i_rddata_mark_col | i_rddata_mark_matrix;
endmodule
