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

## 📌 Android Build Tools Setup

Android **Build-Tools** are required by Appium to sign and verify the `uiautomator2-server` APKs (`apksigner.jar`, `zipalign`, etc.).
Install the version that matches your target API level.

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
