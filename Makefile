# Path to stlink folder for uploading code to board
STLINK=~/Tools/stlink-1.7.0

# Put your source files here (*.c)
SRCS= \
Core/Src/main.c \
Core/Src/stm32f4xx_it.c \
Core/Src/gpio.c \
Core/Src/stm32f4xx_hal_msp.c \
Core/Src/system_stm32f4xx.c  \
Core/Src/tim.c  \
Core/Src/usart.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c

#Drivers/STM32F4xx_HAL_Driver/Src

######################################
# target
######################################
TARGET = Air_stats

# Path to stlink folder for uploading code to board


# Libraries source files, add ones that you intent to use
# SRCS += stm32f4xx_rcc.c
# SRCS += stm32f4xx_gpio.c
# SRCS += stm32f4xx_usart.c

# Binaries will be generated with this name (.elf, .bin, .hex)
PROJ_NAME=Air_stats

# Put your STM32F4 library code directory here, change YOURUSERNAME to yours
STM_COMMON=Drivers/
ST_NUCLEO = home/dragos/Tools/ 

# Compiler settings. Only edit CFLAGS to include other header files.
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

# Compiler flags
CFLAGS  = -g -O2 -Wall -Tstm32_flash.ld
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -Wfatal-errors
CFLAGS += -I.

# Include files from STM libraries
CFLAGS += -I $(STM_COMMON)CMSIS/Include
CFLAGS += -I $(STM_COMMON)CMSIS/ST/STM32F4xx/Include
CFLAGS += -I $(STM_COMMON)STM32F4xx_HAL_Driver/Inc
CFLAGS += -I $(STM_COMMON)STM32F4xx_HAL_Driver/Inc/Legacy
CFLAGS += -I $(STM_COMMON)CMSIS/Device/ST/STM32F4xx/Include
CFLAGS += -I Core/Inc


# add startup file to build
#SRCS += $(STM_COMMON)CMSIS/Device/ST/STM32F4xx/Source/Templates/arm/startup_stm32f401xe.s
OBJS = $(SRCS:.c=.o)

vpath %.c $(ST_NUCLEO)STM32_Nucleo_FW_V1.2.1/Libraries/STM32F0xx_StdPeriph_Driver/inc\

.PHONY: proj

# Commands
all: proj

proj: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# Flash the STM32F4
burn: proj
	$(STLINK)/st-flash write $(PROJ_NAME).bin 0x8000000