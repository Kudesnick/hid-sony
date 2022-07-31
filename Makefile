obj-m += hid-sony.o

KERNELDIR ?= /lib/modules/$(shell uname -r)

all:
	make -C $(KERNELDIR)/build M=$(PWD) modules

clean:
	make -C $(KERNELDIR)/build M=$(PWD) clean

install:
	cp hid-sony.ko $(KERNELDIR)/kernel/drivers/hid/
