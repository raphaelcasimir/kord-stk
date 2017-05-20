include rtl.mk

samplecontroller.o: lpt_intrpt.o
	ld -r $^ -o $@

clean:
	rm -f *.o *~ core
