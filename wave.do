onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/nxt_state
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/state
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/init_fsm/init_nxt_state
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/init_fsm/init_state
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/solve_fsm/nxt_solve_state
add wave -noupdate -radix binary /tb_top/sudoku_solver_00/top_fsm/solve_fsm/solve_state
add wave -noupdate /tb_top/sudoku_solver_00/top_fsm/clk
add wave -noupdate /tb_top/sudoku_solver_00/fsm_addr_gen_rstn
add wave -noupdate -color {Violet Red} /tb_top/sudoku_solver_00/addr_gen/i_enable
add wave -noupdate -color {Violet Red} /tb_top/sudoku_solver_00/addr_gen/i_enable_mark
add wave -noupdate -color Coral -radix unsigned /tb_top/sudoku_solver_00/mem/i_addr
add wave -noupdate -color Salmon /tb_top/sudoku_solver_00/mem/o_rddata
add wave -noupdate -color {Violet Red} -radix unsigned /tb_top/sudoku_solver_00/mem/i_addr_mark_row
add wave -noupdate -color {Violet Red} -radix unsigned /tb_top/sudoku_solver_00/mem/i_addr_mark_col
add wave -noupdate -color {Violet Red} -radix unsigned /tb_top/sudoku_solver_00/mem/i_addr_mark_matrix
add wave -noupdate -color Blue /tb_top/sudoku_solver_00/mem/i_we
add wave -noupdate -color {Medium Blue} /tb_top/sudoku_solver_00/mem/i_we_mark
add wave -noupdate -color Maroon /tb_top/sudoku_solver_00/compare/o_cmp
add wave -noupdate -color Maroon /tb_top/sudoku_solver_00/compare/o_cmp_mark
add wave -noupdate -color Khaki /tb_top/sudoku_solver_00/num_gen/i_enable
add wave -noupdate -color Khaki /tb_top/sudoku_solver_00/num_gen/rst_n
add wave -noupdate -color Khaki -radix unsigned /tb_top/sudoku_solver_00/num_gen/o_wrdata
add wave -noupdate /tb_top/sudoku_solver_00/compare/i_rddata_mark_col
add wave -noupdate /tb_top/sudoku_solver_00/compare/i_rddata_mark_matrix
add wave -noupdate /tb_top/sudoku_solver_00/compare/i_rddata_mark_row
add wave -noupdate /tb_top/sudoku_solver_00/num_gen/o_out_of_range
add wave -noupdate /tb_top/done
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_col_decoder/i_addr
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_col_decoder/i_num
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_col_decoder/addr_by_j
add wave -noupdate -radix unsigned /tb_top/sudoku_solver_00/addr_gen/addr_col_decoder/o_addr_col
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_row_decoder/addr_by_i
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_col_decoder/addr_by_j
add wave -noupdate /tb_top/sudoku_solver_00/addr_gen/addr_matrix_decoder/addr_by_ij
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {172319500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {186517275 ps}
