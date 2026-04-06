#Directory

SRC	= src
TB	= testbench
SIM	= sim

LUT3 = $(SRC)/Entropy_LUT_3x3.v
LUT5 = $(SRC)/Entropy_LUT_5x5.v


E3:
	iverilog -o $(SIM)/sim_ET_3x3 $(TB)/tb_Entropy_LUT_3x3.v $(LUT3)
	vvp $(SIM)/sim_ET_3x3

E5:
	iverilog -o $(SIM)/sim_ET_5x5 $(TB)/tb_Entropy_LUT_5x5.v $(LUT5)
	vvp $(SIM)/sim_ET_5x5

H0:
	iverilog -o $(SIM)/sim_H0 $(TB)/tb_H0.v $(SRC)/H0.v $(LUT3) $(LUT5)
	vvp $(SIM)/sim_H0
H1:
	iverilog -o $(SIM)/sim_H1 $(TB)/tb_H1.v $(SRC)/H1.v $(LUT3) $(LUT5)
	vvp $(SIM)/sim_H1
Threshold:
	iverilog -o $(SIM)/sim_Thres $(TB)/tb_Threshold_T.v $(SRC)/Threshold_T.v
	vvp $(SIM)/sim_Thres
Histogram:
	iverilog -o $(SIM)/sim_Histogram $(TB)/tb_Histogram.v $(SRC)/Histogram.v 
	vvp $(SIM)/sim_Histogram
	
all: E3 E5 H0 H1 Threshold Histogram

clean:
	rm -rf $(SIM)/*