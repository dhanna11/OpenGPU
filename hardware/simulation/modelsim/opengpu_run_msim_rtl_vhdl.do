transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/fabricio/OpenGPU/hardware/ogpu_data_record_pkg.vhd}
vcom -93 -work work {/home/fabricio/OpenGPU/hardware/ogpu_setup.vhd}

vcom -93 -work work {/home/fabricio/OpenGPU/hardware/ogpu_setup_testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  ogpu_setup_testbench

add wave *
view structure
view signals
run 500 ns
