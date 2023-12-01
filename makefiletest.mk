# Переменные
SV_SOURCES = scr1_pipe_ialu.sv  # Укажите здесь все ваши файлы SystemVerilog
TOP_MODULE = scr1_pipe_ialu
COCOTB_SOURCES = $(shell cocotb-config --makefiles)/simulators/Makefile.inc
SIM_BINARY = makefiletest

# Цель по умолчанию
all: sim

# Компиляция SystemVerilog и тестбенча
sim: $(SIM_BINARY)

$(SIM_BINARY): $(SV_SOURCES) test.py $(COCOTB_SOURCES)
	verilator --sv --trace -Wno-fatal --top-module $(TOP_MODULE) \
			--Mdir obj_dir -y $(shell cocotb-config --prefix)/cocotb/libs -LDFLAGS "-ldl" \
			$(SV_SOURCES)

	make -C obj_dir -f V$(TOP_MODULE).mk
# Запуск тестбенча
run: sim
	PYTHONPATH=$(shell cocotb-config --prefix)/cocotb/libs/ LD_LIBRARY_PATH=$(shell cocotb-config --prefix)/cocotb/libs/ ./obj_dir/V$(TOP_MODULE) -sv

# Очистка временных файлов
clean:
	rm -rf obj_dir *.vcd

.PHONY: all sim run clean
