# or.do - COMPACT demo waves for datapath_or_tb
# Purpose: show only the signals TAs care about (registers + bus + Y/Z + opcode/state)
# Transcript: do or.do

proc addw {path radix} {
    catch { add wave -radix $radix $path }
}

quietly WaveActivateNextPane {} 0
catch { wave delete * }

# ===== TB (controls) =====
addw sim:/datapath_or_tb/Clock hexadecimal
addw sim:/datapath_or_tb/Present_state unsigned
addw sim:/datapath_or_tb/Rin hexadecimal
addw sim:/datapath_or_tb/Rout hexadecimal
addw sim:/datapath_or_tb/opcode hexadecimal
addw sim:/datapath_or_tb/Mdatain hexadecimal

# ===== Datapath internals =====
addw sim:/datapath_or_tb/DUT/BusMuxOut hexadecimal
addw sim:/datapath_or_tb/DUT/Y_q hexadecimal
addw sim:/datapath_or_tb/DUT/Zhigh_q hexadecimal
addw sim:/datapath_or_tb/DUT/Zlow_q hexadecimal
addw sim:/datapath_or_tb/DUT/PC_q hexadecimal
addw sim:/datapath_or_tb/DUT/IR_q hexadecimal
addw sim:/datapath_or_tb/DUT/MDR_q hexadecimal
addw sim:/datapath_or_tb/DUT/MAR_q hexadecimal

# ===== Registers relevant to this operation =====
addw sim:/datapath_or_tb/DUT/R5_q hexadecimal
addw sim:/datapath_or_tb/DUT/R6_q hexadecimal
addw sim:/datapath_or_tb/DUT/R2_q hexadecimal

# Run
restart -f
run 500ns
wave zoomfull
