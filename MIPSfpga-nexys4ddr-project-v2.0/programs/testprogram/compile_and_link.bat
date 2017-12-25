set FLAGS=-O0 -g -EL -msoft-float -march=m14kc -Wl,-Map=FPGA_Ram_map.txt -Wl,--defsym,__flash_start=0xbfc00000 -Wl,--defsym,__flash_app_start=0x80000000 -Wl,--defsym,__app_start=0x80000000 -Wl,--defsym,__stack=0x80040000 -Wl,--defsym,__memory_size=0x1f800 -Wl,-e,0xbfc00000

set ASOURCES=
set CSOURCES=
set LDSCRIPT=

set LDSCRIPT=%LDSCRIPT% system_src/boot-uhi32.ld
set ASOURCES=%ASOURCES% system_src/boot.S

set CSOURCES=%CSOURCES% src/main.c
set CSOURCES=%CSOURCES% src/mips_printf.c

set TARGET_NAME=FPGA_Ram

mips-mti-elf-gcc %FLAGS% %ASOURCES% %CSOURCES% -T %LDSCRIPT% -o %TARGET_NAME%.elf
mips-mti-elf-size %TARGET_NAME%.elf
mips-mti-elf-objcopy %TARGET_NAME%.elf -O srec %TARGET_NAME%.rec
