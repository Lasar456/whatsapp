# GreenLeaf Clean Campaigns — Flutter Android test project

This source project is based on your **GreenLeaf_Clean_Campaigns.html** file. The **entire supplied HTML/CSS/JavaScript is preserved byte-for-byte** as `assets/index.html`. It includes Home, Campaigns, Inbox, Leads, More and Billing, with the styling, glass-effect cards, charts, filters, demo conversation, and sample billing UI in your file.

## Exactly what this project is

- A real **Flutter Android** application built around Android WebView, using `webview_flutter` to show your supplied screens offline.
- It preserves the design more accurately than rebuilding each screen from scratch.
- It is **not a native Flutter widget rewrite** of the HTML screens.
- This is a **UI testing preview**, not a connection to your live GreenLeaf PHP/MySQL software, WhatsApp API, Meta Ads, payments, or real users. Buttons for live services are demonstration-only.
- This ZIP contains the **source**, not a precompiled APK. GitHub Actions generates `app-debug.apk`.
- App code sets Android Back to close dialogs or chats, then return to More/Home.

## GitHub repository upload (your `Lasar456/greenleaf` repository)

1. Download this ZIP and **Extract All** on Windows.
2. Open `https://github.com/Lasar456/greenleaf` -> **Code** -> **Add file** -> **Upload files**.
3. Upload the *contents* of this ZIP, not the ZIP itself and not a surrounding folder. Make sure `assets/index.html`, `lib/main.dart`, and `pubspec.yaml` end up at the repository root in their respective paths.
4. If you are updating the existing project, replace `assets/index.html`, `lib/main.dart`, and `pubspec.yaml`. You may also upload `branding` for the app icon.
5. The hidden `.github` folder contains `workflows/main.yml`. On Windows, if hidden folders aren't visible or can't be uploaded, create/edit that file directly using GitHub's website. If your existing `main.yml` already builds correctly, **you can leave it unchanged** and only upload the three updated app source files.
6. **Commit changes** directly to branch `main`.
7. Open **Actions** -> **Build GreenLeaf Android APK** -> the new run (or click **Run workflow** if needed).
8. Once the run is green, open it, scroll to **Artifacts**, download `GreenLeaf-Android-APK` and extract it to get **`app-debug.apk`**.
9. Copy the APK to the Samsung Galaxy S25 and install it. If an older test version conflicts due to a different signature, uninstall the older preview first.

## Working from an empty repository

Make sure `.github/workflows/main.yml` is present. GitHub only runs the workflow if it is located under `.github/workflows/`.

## Project layout

```text
.github/workflows/main.yml     Automatic GitHub debug APK builder
assets/index.html              Your exact Clean Campaigns HTML
lib/main.dart                  Flutter host and Android Back handling
pubspec.yaml                  Flutter dependencies and asset registration
branding/android/            GreenLeaf test launcher icon for Android
README.md                    Build instructions
```

## Build locally (optional)

With Flutter and Android SDK already installed, run:

```bash
flutter create . --platforms=android --org in.greenleaf --project-name greenleaf_mobile_preview
flutter pub get
flutter analyze lib
flutter build apk --debug
```

APK path: `build/app/outputs/flutter-apk/app-debug.apk`.

*The Flutter/Android SDK is not available in the current workspace, so this exact revision cannot be compiled or validated on a physical Samsung Galaxy S25 here. GitHub will perform the actual compilation.*
