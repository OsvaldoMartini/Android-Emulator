# Custom Galaxy S23 Ultra Emulator (AVD) Config

This guide explains how to create a custom AVD configuration so your Android emulator mimics the **Galaxy S23 Ultra** as closely as possible.

---

## 📌 Where Hardware Configs Live

When you create an AVD with `avdmanager`, it generates a folder inside:

* **Linux/Mac:**

  ```
  ~/.android/avd/
  ```
* **Windows:**

  ```
  %USERPROFILE%\.android\avd\
  ```

Inside each AVD folder (e.g., `S23Ultra_API34.avd`) you’ll find a file called **`config.ini`** (and sometimes a `hardware-qemu.ini`).
That’s where we’ll drop the custom specs.

---

## ✅ Custom `config.ini` for Galaxy S23 Ultra

Paste the following into your `config.ini` file (overwrite existing content):

```ini
avd.ini.encoding=UTF-8
hw.device.name=Galaxy S23 Ultra
hw.device.manufacturer=Samsung
hw.lcd.width=1440
hw.lcd.height=3088
hw.lcd.density=560
hw.screen.size=6.8
hw.gpu.enabled=yes
hw.gpu.mode=auto
hw.ramSize=4096
hw.cpu.arch=x86_64
hw.cpu.ncore=4
hw.keyboard=yes
hw.mainKeys=no
hw.trackBall=no
hw.sensors.orientation=yes
hw.sensors.proximity=yes
hw.sensors.gyroscope=yes
hw.sensors.accelerometer=yes
hw.sensors.magnetic_field=yes
hw.battery=yes
vm.heapSize=256
skin.name=1080x2400
skin.dynamic=yes
disk.dataPartition.size=8G
image.sysdir.1=system-images/android-34/google_apis/x86_64/
tag.id=google_apis
tag.display=Google APIs
abi.type=x86_64
playstore.enabled=false
showDeviceFrame=no
```

---

## 🔹 Steps to Apply

### 1. Create the AVD with `avdmanager`

```bash
avdmanager create avd -n "S23Ultra_API34" -k "system-images;android-34;google_apis;x86_64"
```

### 2. Locate the AVD Folder

* **Linux/Mac:**

  ```
  ~/.android/avd/S23Ultra_API34.avd/
  ```
* **Windows:**

  ```
  %USERPROFILE%\.android\avd\S23Ultra_API34.avd\
  ```

### 3. Replace Config

Replace the existing **`config.ini`** with the custom version provided above.

### 4. Start the Emulator

```bash
emulator -avd S23Ultra_API34
```

---

✅ You now have an emulator configured to mimic the **Galaxy S23 Ultra** screen size, resolution, DPI, and hardware profile.
