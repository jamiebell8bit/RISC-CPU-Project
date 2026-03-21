# rol.do - COMPACT demo waves for datapath_rol_tb
# Purpose: show only the signals TAs care about (registers + bus + Y/Z + opcode/state)
# Transcript: do rol.do

proc addw {path radix} {
    catch { add wave -radix $radix $path }
}

quietly WaveActivateNextPane {} 0
catch { wave delete * }

# ===== TB (controls) =====
addw sim:/datapath_rol_tb/Clock hexadecimal
addw sim:/datapath_rol_tb/Present_state unsigned
addw sim:/datapath_rol_tb/Rin hexadecimal
addw sim:/datapath_rol_tb/Rout hexadecimal
addw sim:/datapath_rol_tb/opcode hexadecimal
addw sim:/datapath_rol_tb/Mdatain hexadecimal

# ===== Datapath internals =====
addw sim:/datapath_rol_tb/DUT/BusMuxOut hexadecimal
addw sim:/datapath_rol_tb/DUT/Y_q hexadecimal
addw sim:/datapath_rol_tb/DUT/Zhigh_q hexadecimal
addw sim:/datapath_rol_tb/DUT/Zlow_q hexadecimal
addw sim:/datapath_rol_tb/DUT/PC_q hexadecimal
addw sim:/datapath_rol_tb/DUT/IR_q hexadecimal
addw sim:/datapath_rol_tb/DUT/MDR_q hexadecimal
addw sim:/datapath_rol_tb/DUT/MAR_q hexadecimal

# ===== Registers relevant to this operation =====
addw sim:/datapath_rol_tb/DUT/R0_q hexadecimal
addw sim:/datapath_rol_tb/DUT/R4_q hexadecimal
addw sim:/datapath_rol_tb/DUT/R7_q hexadecimal

# Run
restart -f
run 500ns
wave zoomfull
