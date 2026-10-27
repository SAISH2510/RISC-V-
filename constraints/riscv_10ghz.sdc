# ============================================================
# RISC-V 5-Stage Pipeline Processor
# Clock Frequency : 10 GHz
# Clock Period    : 0.1 ns (100 ps)
# ============================================================

# Create clock
create_clock -name clk -period 0.1 [get_ports clk]

# Clock uncertainty: 5% of clock period
set_clock_uncertainty 0.005 [get_clocks clk]

# Clock transition
set_clock_transition 0.001 [get_clocks clk]

# Input delay: 10% of clock period
set_input_delay 0.01 -clock clk [all_inputs]

# Output delay: 10% of clock period
set_output_delay 0.01 -clock clk [all_outputs]

# Input transition
set_input_transition 0.001 [all_inputs]