all:
	sh tools/scripts/build
prepare:
	sh tools/scripts/prepare
kernel:
	sh tools/scripts/kernel
clean:
	sudo rm -rf out/
	

