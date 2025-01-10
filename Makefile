test.net: main.py alu.py utils.py selector.py registers.py
	carotte/carotte.py -o $@ main.py

testass:
	python3 turnep_as/assemble.py turnep_as/quicksort.as
	./netlist_simulator.byte -n 4 test.net

testw: test.net
	./netlist_simulator.byte -n 6 test.net

testwexe: test.net
	./netlist_simulator.exe -n 10300 test.net

test: test.net
	./netlist_simulator.byte  -n 1 test.net
	gcc simulator.c -o test
	
run: test
	./test

.PHONY: run testw test.net testass testwexe
