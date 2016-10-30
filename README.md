# Setup
1: First download this file: https://drive.google.com/file/d/0B1BaegXXFI73UUZNS1R5OFVfT0k/view?usp=sharing <br />
2: Place that file in the ```files/debian``` folder(if the folder doesn't exist create it) <br />
3: Go to the root from the project <br />
# Prepare the build
1: Connect your device to your computer. (make sure you are on Cyanogenmod) <br />
2: Type: ```make prepare -f MakeFile``` <br />
# Building
1: Type: ```make build -f MakeFile``` <br />
2: If everything was successful then your new boot.img should be in ```out/(DEVICE_CODENAME)/compiled/boot.img```
# Installing
1: Connect your phone it's sdcard to your computer
2: Create an second partition with```ext4``` on your sdcard(Make sure to backup any data otherwise it will all be lost)  <br />
3: Go to ```devices/(DEVICE_CODENAME)/sdcard``` and type: ```cp -Rav ./* /mnt/(SDCARD)``` (where (SDCARD) is your sdcard it's mount name)  <br />
4: Install the compiled boot.img in ```out/(DEVICE_CODENAME)/compiled/boot.img``` <br />
5: Put your phone it's sdcard in your phone again. <br />
6: Done..now wait until it boots(If it doesn't boot then open an issue with your last_ksmg) <br />

