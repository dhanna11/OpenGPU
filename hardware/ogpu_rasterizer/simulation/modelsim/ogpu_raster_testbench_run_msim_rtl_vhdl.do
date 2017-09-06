transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_data_record_pkg.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_triangle_edge_test.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_setup.vhd}

vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_raster_control.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_quad_store.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_quad_generator.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_edge_test.vhd}
vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_depth_test.vhd}

vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_raster_unit.vhd}

vcom -2008 -work work {/home/fabricio/OpenGPU/hardware/ogpu_rasterizer/ogpu_raster_unit_testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  ogpu_raster_unit_testbench

add wave *
view structure
view signals
