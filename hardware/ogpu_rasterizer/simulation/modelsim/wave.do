onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/clock
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/reset
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/quad_mask
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/quad
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/depth_quad
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/buffer_ack
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/addr
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/quad_buffer_length
add wave -noupdate -radix hexadecimal /ogpu_quad_store_testbench/buffer_address
add wave -noupdate -radix hexadecimal /ogpu_quad_store_testbench/buffer_byte_enable
add wave -noupdate -radix hexadecimal /ogpu_quad_store_testbench/buffer_write
add wave -noupdate -radix hexadecimal /ogpu_quad_store_testbench/buffer_write_data
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/start_raster
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/store_quad
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/quad_stored
add wave -noupdate -radix unsigned /ogpu_quad_store_testbench/run_proc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {261619 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 440
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {352964 ps}
