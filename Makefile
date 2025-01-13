test.net: main.py alu.py utils.py selector.py registers.py
	carotte/carotte.py -o $@ main.py

testass:
	python3 turnep_as/assemble.py turnep_as/divby100.as
	./netlist_simulator.byte -n 4 test.net

testw: test.net
	./netlist_simulator.byte -n 6 test.net

testwexe: test.net
	./netlist_simulator.exe -n 10300 test.net

test: test.net
	./netlist_simulator.byte  -n 40 test.net
	gcc simulator.c -o test
	
testoptiexe: test.net
	./netlist_simulator_opti.exe -n 5 test.net
	gcc simulator.c -o test

run: test
	./test

simul:
	cd simul_opti && dune build

build-clock: simul test.net
	cp -f simul_opti/_build/default/netlist_simulator.exe demo-clock/netlist_simulator.exe
	cp -f test.net demo-clock/test.net
	cd demo-clock; ./netlist_simulator.exe -n 100000000000 test.net; \
	python3 ../turnep_as/assemble.py turnepClock.as; \
	g++ simulator.c -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops -o main
	
run-clock:
	cd demo-clock;\
	gcc -Ofast -march=native -mtune=native -flto -ffast-math -funroll-loops simulator.c -o main;\
	time ./main

build-quicksort: simul test.net
	cp -f simul_opti/_build/default/netlist_simulator.exe demo-quicksort/netlist_simulator.exe
	cp -f test.net demo-quicksort/test.net
	cd demo-quicksort; ./netlist_simulator.exe -n 100000000000 test.net; \
	python3 ../turnep_as/assemble.py quicksort.as; \
	g++ simulator.c -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops -o main
	
run-quicksort:
	cd demo-quicksort;\
	gcc -Ofast -march=native -mtune=native -flto -ffast-math -funroll-loops simulator.c -o main;\
	time ./main

build-fibo: simul test.net
	cp -f simul_opti/_build/default/netlist_simulator.exe demo-fibo/netlist_simulator.exe
	cp -f test.net demo-fibo/test.net
	cd demo-fibo; ./netlist_simulator.exe -n 100000000000 test.net; \
	python3 ../turnep_as/assemble.py fibo.as; \
	g++ simulator.c -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops -o main
	
run-fibo:
	cd demo-fibo;\
	gcc -Ofast -march=native -mtune=native -flto -ffast-math -funroll-loops simulator.c -o main;\
	time ./main



.PHONY: run testw test.net testass testwexe simul build-clock run-clock