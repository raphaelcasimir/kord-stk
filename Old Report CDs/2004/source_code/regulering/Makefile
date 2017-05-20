include rtl.mk

regulator.o: dt2811.o card.o
	ld -r $^ -o $@

clean:
	rm -f *.o *~ core
