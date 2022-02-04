CROSS_COPILE ?= arm-linux-gnueabihf-
TARGET 		 ?= ledc_bsp

CC			 := $(CROSS_COPILE)gcc
LD			 := $(CROSS_COPILE)ld
OBJCOPY		 := $(CROSS_COPILE)objcopy
OBJDUMP 	 := $(CROSS_COPILE)objdump

INCUDIRS	:= imx6u \
			   bsp/clk \
			   bsp/delay \
			   bsp/led

SRCDIRS		:= project \
			   bsp/clk \
			   bsp/delay \
			   bsp/led

INCLUDE		:= $(patsubst %, -I %, $(INCUDIRS))

SFILES		:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.s))
CFILES		:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))

SFILENDIR	:= $(notdir $(SFILES))
CFILENDIR	:= $(notdir $(CFILES))

SOBJS		:= $(patsubst %, obj/%, $(SFILENDIR:.s=.o))
COBJS		:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o))

OBJS		:= $(SOBJS)$(COBJS)

VPATH		:= $(SRCDIRS)

.PHONY:clean

$(TARGET).bin : $(OBJS)
	$(LD) -Timx6u.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis

$(SOBJS) : obj/%.o : %.s
	$(CC) -Wall -nostdlib -c -O2 $(INCLUDE) -o $@ $<

$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2 $(INCLUDE) -o $@ $<

clean:
	rm -rf $(TARGET).bin $(TARGET).elf $(TARGET).dis $(OBJS)

print:
	@echo INCLUDE = $(INCLUDE)
	@echo SFILES = $(SFILES)
	@echo CFILES = $(CFILES)
	@echo SFILENDIR = $(SFILENDIR)
	@echo CFILENDIR = $(CFILENDIR)
	@echo SOBJS = $(SOBJS)
	@echo COBJS	= $(COBJS)
	@echo OBJS = $(OBJS)
