# Переменные
SV_SOURCES = scr1_pipe_ialu.sv  # Укажите здесь все ваши файлы SystemVerilog
TOP_MODULE = scr1_pipe_ialu
COCOTB_SOURCES = $(shell cocotb-config --makefiles)/simulators/Makefile.inc
SIM_BINARY = makefiletest
COVERAGE = coverege 

# Цель по умолчанию
all: sim
coverage: $(COVERAGE)
sim: $(SIM_BINARY)

	$(SIM_BINARY): $(SV_SOURCES) test.py $(COCOTB_SOURCES)
		verilator --sv --trace -Wno-fatal --top-module $(scr1_pipe_ialu) \
				--Mdir obj_dir -y $(shell cocotb-config --prefix)/cocotb/libs -LDFLAGS "-ldl" \
				$(SV_SOURCES)
	$(COVERAGE): scr1_pipe_ialu.sv cocotb_test/test11.py
    verilator -sv --coverage -I./cocotb/share/ -y./cocotb/share/ --Mdir $(COVERAGE) --cc $< cocotb_test/test11.py --exe sim_main.cpp
    make -C $(COVERAGE) -f Vscr1_pipe_ialu.mk

	make -C obj_dir -f V$(scr1_pipe_ialu).mk
# Запуск тестбенча
run: sim
	PYTHONPATH=$(shell cocotb-config --prefix)/cocotb/libs/ LD_LIBRARY_PATH=$(shell cocotb-config --prefix)/cocotb/libs/ ./obj_dir/V$(scr1_pipe_ialu) -sv

# Очистка временных файлов
clean:
	rm -rf obj_dir *.vcd

.PHONY: all sim run clean
