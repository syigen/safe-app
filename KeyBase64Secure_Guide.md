
# KeyStore Generation and Base64 Conversion Guide

This guide provides step-by-step instructions on generating KeyStore files for Android app signing and converting them to a Base64-encoded format, on both **iOS (Mac)** and **Windows**.

---

## **Process Name**
**KeyBase64Secure**

---

## **1. Generating KeyStore on macOS/iOS**

### Prerequisites
Ensure you have Java installed. Run the following to confirm:
```bash
java -version
```

### Steps
1. Open the Terminal.
2. Run the following command to generate a KeyStore file:
   ```bash
   keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 3650 -alias key
   ```
3. Enter the required details when prompted:
   - **KeyStore Password**: Protects the KeyStore file.
   - **Key Password**: Protects the specific key (can match KeyStore Password).
   - **Distinguished Name**: Provide your personal or organization details.
4. After successful completion, `key.jks` will be created in the current directory.

---

## **2. Generating KeyStore on Windows**

### Prerequisites
- Install the Java Development Kit (JDK) from [Oracle's website](https://www.oracle.com/java/technologies/javase-downloads.html).
- Add `keytool` to the PATH environment variable:
  1. Search for **Environment Variables** in Windows.
  2. Under **System Variables**, locate `Path` and click **Edit**.
  3. Add the path to the `bin` folder in your JDK installation (e.g., `C:\Program Files\Java\jdk-XX\bin`).

### Steps
1. Open **Command Prompt**.
2. Run the same `keytool` command as in macOS:
   ```bash
   keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 3650 -alias key
   ```
3. Enter the required details when prompted, similar to the macOS steps.

---

## **3. Converting KeyStore File to Base64**

### On macOS/iOS:
1. Open Terminal.
2. Run the following command:
   ```bash
   base64 key.jks > key.jks.base64
   ```

### On Windows:
1. Open Command Prompt.
2. Run the following command:
   ```bash
   certutil -encode key.jks key.jks.base64
   ```

3. The Base64 content will be saved in the `key.jks.base64` file.

---

## **4. Decoding Base64 Back to KeyStore**

If needed, you can convert the Base64 string back into a KeyStore file:

### macOS/iOS:
```bash
echo "<BASE64_STRING>" | base64 -d > key.jks
```

### Windows:
```cmd
certutil -decode key.jks.base64 key.jks
```

Replace `<BASE64_STRING>` with your actual Base64 string.

---

## **5. Adding Secrets to GitHub Actions**

To securely use the KeyStore in CI/CD workflows, add the following as **GitHub Secrets**:

- **`AndroidSigningKeyBase64`**: Base64-encoded KeyStore content.
- **`AndroidStorePassword`**: Password for the KeyStore.
- **`AndroidKeyPassword`**: Password for the specific key.

### Adding Secrets:
1. Go to your GitHub repository.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Add the secrets with the respective names.

