# Makefile
# 10 january 2001

include ../make.common

CFLAGS2=$(CFLAGS) -I$(TOPDIR)/include

#all: datagen

datagen: Makefile main.c ../common/common.so \
	../wgen/tpcw.o ../wgen/text.o ../wgen/rnd.o ../wgen/bm_utils.o
	$(CC) $(CFLAGS2) main.c -o datagen ../common/common.so ../wgen/tpcw.o \
		../wgen/text.o ../wgen/rnd.o ../wgen/bm_utils.o -lm

clean:
	rm -f datagen debug.log error.log





