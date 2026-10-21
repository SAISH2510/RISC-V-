```tcl
#========================================================
# SDC Constraints: 8-bit Binary <-> Gray Code Converter
# Design: converter_top
#========================================================

# 1. Clock definition
create_clock -name clk -period 10.000 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.200 [get_clocks clk]

# Clock transition
set_clock_transition 0.100 [get_clocks clk]


# 2. Input timing constraints
# Assumed external input delay: 2 ns

set_input_delay -clock clk -max 2.000 \
    [get_ports {start convert ext_in[*]}]

set_input_delay -clock clk -min 0.500 \
    [get_ports {start convert ext_in[*]}]


# 3. Input transition constraints

set_input_transition 0.100 \
    [get_ports {start convert ext_in[*]}]


# 4. Output timing constraints
# Assumed external output delay: 2 ns

set_output_delay -clock clk -max 2.000 \
    [get_ports {bus[*] done}]

set_output_delay -clock clk -min 0.500 \
    [get_ports {bus[*] done}]


# 5. Output load constraints
# Assumed load: 5 pF

set_load 5.000 [get_ports {bus[*] done}]


# 6. Reset constraint
# rst is assumed to be an asynchronous, active-high reset.
# Exclude reset from ordinary synchronous input timing.

set_false_path -from [get_ports rst]


