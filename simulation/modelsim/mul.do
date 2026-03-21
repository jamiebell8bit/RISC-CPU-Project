# mul.do - COMPACT demo waves for datapath_mul_tb
# Purpose: show only the signals TAs care about (registers + bus + Y/Z + opcode/state)
# Transcript: do mul.do

proc addw {path radix} {
    catch { add wave -radix $radix $path }
}

quietly WaveActivateNextPane {} 0
catch { wave delete * }

# ===== TB (controls) =====
addw sim:/datapath_mul_tb/Clock hexadecimal
addw sim:/datapath_mul_tb/Present_state unsigned
addw sim:/datapath_mul_tb/Rin hexadecimal
addw sim:/datapath_mul_tb/Rout hexadecimal
addw sim:/datapath_mul_tb/opcode hexadecimal
addw sim:/datapath_mul_tb/Mdatain hexadecimal

# ===== Datapath internals =====
addw sim:/datapath_mul_tb/DUT/BusMuxOut hexadecimal
addw sim:/datapath_mul_tb/DUT/Y_q hexadecimal
addw sim:/datapath_mul_tb/DUT/Zhigh_q hexadecimal
addw sim:/datapath_mul_tb/DUT/Zlow_q hexadecimal
addw sim:/datapath_mul_tb/DUT/HI_q hexadecimal
addw sim:/datapath_mul_tb/DUT/LO_q hexadecimal
addw sim:/datapath_mul_tb/DUT/PC_q hexadecimal
addw sim:/datapath_mul_tb/DUT/IR_q hexadecimal
addw sim:/datapath_mul_tb/DUT/MDR_q hexadecimal
addw sim:/datapath_mul_tb/DUT/MAR_q hexadecimal

# ===== Registers relevant to this operation =====
addw sim:/datapath_mul_tb/DUT/R3_q hexadecimal
addw sim:/datapath_mul_tb/DUT/R1_q hexadecimal

# Run
restart -f
run 500ns
wave zoomfull
