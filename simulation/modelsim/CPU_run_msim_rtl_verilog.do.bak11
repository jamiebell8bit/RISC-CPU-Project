transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/mul.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/adder32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/register64.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/register.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/mdr.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/mar.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/ir.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/div.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/datapath.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/bus.v}
vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/alu.v}

vlog -vlog01compat -work work +incdir+C:/Users/jimbo/projects/ELEC\ 374\ project/CPU_Project {C:/Users/jimbo/projects/ELEC 374 project/CPU_Project/div_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  datapath_div_tb

add wave *
view structure
view signals
run 500 ns
