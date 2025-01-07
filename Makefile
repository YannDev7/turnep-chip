test.net: main.py alu.py utils.py
	carotte/carotte.py -o $@ main.py

test: test.net
	./netlist_simulator.byte -n 1 test.net
	gcc simulator.c -o test
	
run: test
	./test

.PHONY: run
