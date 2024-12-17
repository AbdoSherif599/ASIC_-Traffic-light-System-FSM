# Steps followed
1 - Edited syn_script file to synthesize the verilog design.
2 - Used const.tcl file to apply constraints (clock timing, input delay, output load) on the design.
3 - Used the synthesis tool to produce an output netlist that contains gates used from the standard library along with delays for the gates.
4 - Reviewed the power, area and STA reports output from the synthesis tool.
5 - Confirmed no setup or hold violations are found and the slack time is enough.
6 - Confirmed Power consumption and Chip Area meet the design requirements.
7 - Used Synopsis Formality Equivalence Checking tool to compare the output netlist to the input RTL code.

# Schematic
<img src="img/Screenshot 2024-12-15 231946.png" alt="alt text" style="max-width: 600px;">
<img src="img/Screenshot 2024-12-15 232044.png" alt="alt text" style="max-width: 600px;">

# Synthesis Log
<img src="img/err_log.png" alt="alt text" style="max-width: 600px;">

# Constraints Report
<img src="img/const_rpt.png" alt="alt text" style="max-width: 600px;">

# Synthesis Script
<img src="img/syn_script.png" alt="alt text" style="max-width: 600px;">

# Output Netlist
<img src="img/netlist.png" alt="alt text" style="max-width: 600px;">

# Formal Verification Reports
<img src="img/fm_rep2.png" alt="alt text" style="max-width: 600px;">
<img src="img/fm_rep1.png" alt="alt text" style="max-width: 600px;">
<img src="img/fm_rep2.png" alt="alt text" style="max-width: 600px;">
<img src="img/fm_rep3.png" alt="alt text" style="max-width: 600px;">

# RTL vs Netlist
<img src="img/rtl_vs_netlist.png" alt="alt text" style="max-width: 600px;">
