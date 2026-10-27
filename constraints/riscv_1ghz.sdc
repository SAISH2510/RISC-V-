```tcl
# ============================================================
# RISC-V 5-Stage Pipeline Processor
# Clock Frequency : 1 GHz
# Clock Period    : 1 ns
# ============================================================

# Create clock
create_clock -name clk -period 1.0 [get_ports clk]

# Clock uncertainty: 5% of clock period
set_clock_uncertainty 0.05 [get_clocks clk]

# Clock transition
set_clock_transition 0.01 [get_clocks clk]

# Input delay: 10% of clock period
set_input_delay 0.1 -clock clk [all_inputs]

# Output delay: 10% of clock period
set_output_delay 0.1 -clock clk [all_outputs]

# Input transition
set_input_transition 0.01 [all_inputs]
```
