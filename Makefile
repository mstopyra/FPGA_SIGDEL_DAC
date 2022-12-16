# -Wall turns on all warnings
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -g2012 -Wall -y ./hdl -I ./hdl
IVERILOG_SIM_ARGS= -y ./tests -I ./tests
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source


CIC_SRCS=hdl/CIC_comb.sv hdl/CIC_int.sv
FIR_SRCS=hdl/fir.sv hdl/register.sv
DAC_SRC=hdl/sigdel_DAC.sv
MAIN_SRCS=${CIC_SRCS} ${FIR_SRCS} ${DAC_SRC} hdl/main_dac.sv hdl/pulse_generator.sv hdl/triangle_generator.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_main: tests/test_main.sv ${MAIN_SRCS}
	@echo "This might take a while, we're testing a lot of clock cycles!"
	${IVERILOG} $^ -o test_main.bin && ${VVP} test_main.bin ${VVP_POST}

main.bit: $(MAIN_SRCS)
	@echo "########################################"
	@echo "#### Building FPGA bitstream        ####"
	@echo "########################################"
	${VIVADO} build.tcl

program_fpga_vivado: main.bit
	@echo "########################################"
	@echo "#### Programming FPGA (Vivado)      ####"
	@echo "########################################"
	${VIVADO} program.tcl

program_fpga_digilent: main.bit
	@echo "########################################"
	@echo "#### Programming FPGA (Digilent)    ####"
	@echo "########################################"
	djtgcfg enum
	djtgcfg prog -d CmodA7 -i 0 -f main.bit


# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml
	rm -rf .Xil

# Call this to generate your submission zip file.
submission:
	zip submission.zip Makefile hdl/*.sv tests/*.sv README.md docs/* *.tcl *.xdc
