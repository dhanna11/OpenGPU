transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vcom -93 -work work {ogpu_raster_testbench.vho}

vcom -93 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_quad_generator_testbench.vhd}

vsim -t 1ps +transport_int_delays +transport_path_delays -sdftyp /NA=ogpu_raster_testbench_vhd.sdo -L altera -L altera_lnsim -L cyclonev -L gate_work -L work -voptargs="+acc"  ogpu_quad_generator_testbench

add wave *
view structure
view signals
run 2 us
