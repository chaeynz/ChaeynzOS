ASM=nasm
QEMU_IMG=qemu-img

SRC_DIR=src
BUILD_DIR=build

all: $(BUILD_DIR)/main_floppy.vmdk

$(BUILD_DIR)/main_floppy.vmdk: $(BUILD_DIR)/main_floppy.img
	$(QEMU_IMG) convert -f raw -O vmdk $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/main_floppy.vmdk

$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/bootloader.asm
	$(ASM) $(SRC_DIR)/bootloader.asm -f bin -o $(BUILD_DIR)/main.bin