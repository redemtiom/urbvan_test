# urbvan_test

Flutter test to urbvan.

## Technologies

- [Flutter](https://flutter.dev/docs/get-started/install) v2.0.6.
- [Jdk](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html) v1.0.8.
- [Cocoapods](https://cocoapods.org).


For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Install Depencies

In the terminal go to the directory where you downloaded the project and position yourself inside, then write the following command:

```
flutter pub get
```

## Run the Project
Before running the project, you need to paste the google maps key in the following places:

- android > app > src > main > AndroidManifest.xml
- ios > Runner > AppDelegate.swift
- lib > global_environments.dart
```
Replace this string 'ENTER_YOUR_API_KEY_HERE' with your key
```

In the terminal go to the directory where you downloaded the project and position yourself inside, then write the following command:
```
flutter run
```
and hit enter.

(You need a [AVD](https://developer.android.com/studio/run/managing-avds) or a physical device to run the project).

## Build an Apk to Android

In the terminal go to the directory where you downloaded the project and position yourself inside, then write the following command:
```
flutter build apk --split-per-abi
```

## Icons and Images

The icons use it in this project was picked from:
- [Flaticon](https://www.flaticon.com).
- Home icon made by [Freepik](https://www.flaticon.com/free-icon/map_854878).
- Marker satellite icon made by [wanicon](https://www.flaticon.com/free-icon/satellite_4698849).
