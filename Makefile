obj-m += hid-sony.o

KERNELDIR ?= /lib/modules/$(shell uname -r)

all hid-sony.ko:
	make -C $(KERNELDIR)/build M=$(PWD) modules

clean:
	make -C $(KERNELDIR)/build M=$(PWD) clean

install: hid-sony.ko
	xz -c hid-sony.ko > $(KERNELDIR)/kernel/drivers/hid/hid-sony.ko.xz

reload:
	rmmod hid_sony && modprobe hid-sony
