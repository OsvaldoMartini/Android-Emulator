# Android Command Line Tools & Galaxy S23 Ultra Emulator Setup

This guide explains how to install the Android command line tools, set up environment variables, and create an emulator that mimics the Galaxy S23 Ultra.

---

## 📥 Download & Install Android Command Line Tools

1. **Download** the Android command line tools from the [official site](https://developer.android.com/studio#command-tools).
2. **Extract** them to the following directory (mandatory):

   ```
   C:\Android\cmdline-tools\latest
   ```
3. **Set environment variables**:

   * `ANDROID_SDK_ROOT = C:\Android`
   * Add to **PATH**:

     ```
     %ANDROID_SDK_ROOT%\cmdline-tools\latest\bin
     ```
4. **Verify installation** by running:

   ```bash
   sdkmanager --list
   ```

   If it shows available packages → ✅ It worked!
5. Run all commands as **Administrator** (important for Windows users).

---

## 📌 Android Build Tools Setup - **Mandatory**

Android Build-Tools are essential for Appium because they contain the utilities required to verify, sign, align, and optimize APK files. They are mandatory for Appium to start **UiAutomator2** sessions and are not included in platform-tools.

Appium relies on Build-Tools to:

✔ verify the **UiAutomator2** server APKs using tools such as **apksigner.jar** and **zipalign.exe**

✔ sign the **uiautomator2-server** and **uiautomator2-server-debug-androidTest** APKs

✔ install the automation APKs onto the device

✔ ensure that **APK signatures** are valid and consistent

✔ align and optimize APKs when required

Install the Build-Tools version that matches your target Android API level.

---

## ✅ What apksigner.bat Does

**apksigner.bat** runs the Android APK **signing tool**, which is responsible for:

✔ Verifying APK signatures

Example:
```bash
apksigner verify myapp.apk
```

Checks whether the APK is properly signed.

✔ Signing APK files

Example:
```bash
apksigner sign --ks mykey.jks myapp.apk
```

Signs an APK with your keystore.

✔ Aligning + signing test APK used by Appium

Appium uses it internally to sign:

**uiautomator2-server.apk**

**uiautomator2-server-debug-androidTest.apk**

🚩 Without this, Appium cannot install its automation server on your Android device.

## 📌 Why Appium Needs apksigner.bat

Appium must verify the signature of the **UiAutomator2** server before it installs it.

Your error:
```bash
Cannot verify the signature… Could not find apksigner.jar
```

🚩 This happens because Appium calls **apksigner.bat**, and if **Build-Tools** are missing, Appium fails to start the session.

## 📂 Where apksigner.bat Lives

After installing Build-Tools:

```bash
<ANDROID_HOME>\build-tools\<version>\apksigner.bat
```

Example:
```bash
C:\Android\build-tools\34.0.0\apksigner.bat
```

Inside build-tools\34.0.0\lib\ is the real tool:
```bash
apksigner.jar
```

The .bat file simply calls that .jar.

---

## 📌 Installing Build-Tools

### ✅ Build-Tools for Android 15 (Preview) – API 35

```bash
sdkmanager "build-tools;35.0.0"
```

### ✅ Build-Tools for Android 14 – API 34

```bash
sdkmanager "build-tools;34.0.0"
```

### ✅ Build-Tools for Android 13 – API 33

```bash
sdkmanager "build-tools;33.0.2"
```

### 📂 After Installation

The Build Tools will be placed under:

```bash
<ANDROID_HOME>/build-tools/<version>/
```

Inside this folder you will find:

* `apksigner.bat`
* `lib/apksigner.jar`
* `zipalign.exe`
* `d8`, `aapt2`, etc.

These tools must be available for Appium to create Android sessions.

---

### 🔧 Add Build-Tools to PATH

Ensure the following is added to your system PATH:

```bash
%ANDROID_HOME%\build-tools\<version>
```

Example:

```bash
C:\Android\build-tools\34.0.0
```

---

## 📌 API Level Setup

### Android 15 (Preview) – API 35

```bash
sdkmanager "platform-tools" "platforms;android-35" "emulator" "system-images;android-35;google_apis;x86_64"
```

### Android 14 (Current S23 Ultra OS) – API 34

```bash
sdkmanager "platform-tools" "platforms;android-34" "emulator" "system-images;android-34;google_apis;x86_64"
```

### Android 13 (Older S23 Ultra OS) – API 33

```bash
sdkmanager "platform-tools" "platforms;android-33" "emulator" "system-images;android-33;google_apis;x86_64"
```

---

## 📌 Accept All SDK Licenses
Run the following command to accept all licenses:

```bash
sdkmanager --licenses
```


## 📱 Galaxy S23 Ultra Specs

* **Screen size:** 6.8"
* **Resolution:** 3088 × 1440 (QHD+)
* **Density:** ~500+ ppi → `xxxhdpi (560 dpi)`
* **CPU:** ARM64 (Snapdragon / Exynos), but emulator commonly uses `x86_64` system images for performance.

---

## 🚀 Emulator Setup for S23 Ultra

### ✅ Step 1: Install System Image (Android 14 / API 34)

```bash
sdkmanager "platform-tools" "platforms;android-34" "emulator" "system-images;android-34;google_apis;x86_64"
```

### ✅ Step 2: Create the AVD

```bash
avdmanager create avd -n "S23Ultra_API34"  -k "system-images;android-34;google_apis;x86_64" -d "pixel_6_pro" --device "pixel_6_pro"
```

**Why `pixel_6_pro`?**
The Galaxy S23 Ultra is not a predefined device in the SDK. The Pixel 6 Pro (6.7", high DPI, similar resolution) is the closest match.

### ✅ Step 3: Emulator does not belong to Android SDK
```bash
emulator -avd -n "S23Ultra_API34"
```

### ✅ Step 4: Customize Hardware Profile

1. Open **AVD Manager** in Android Studio → Edit the new device.
2. Adjust the following settings:

   * **Resolution** → `3088 x 1440`
   * **Screen size** → `6.8`
   * **DPI** → `560`
   * **RAM** → `4096 MB` (minimum; real device has 8–12 GB)
3. Save changes.
4. Launch your emulator — now it behaves like a Galaxy S23 Ultra.

---
