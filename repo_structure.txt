Citizen_Squad
│
├── .gitHub
│   ├── ISSUE_TEMPLATE
│   │   └── bug-report.yml
│   ├── scripts
│   │   └── update_structure.py
│   └── workflows
│       ├── build_apk.yml
│       ├── issue-open-close.yml
│       └── pr-merge.yml
│
├── .vscode
│   └── launch.json           
│
├── android
│   ├── .gitignore
│   ├── .gradle
│   │   ├── 8.3
│   │   ├── checksums
│   │   ├── checksums.lock
│   │   ├── fileChanges
│   │   ├── last-build.bin
│   │   ├── fileHashes
│   │   ├── fileHashes.lock
│   │   ├── gc.properties
│   │   ├── vcsMetadata
│   │   └── vcs-1
│   ├── app
│   │   ├── build.gradle
│   │   ├── google-services.json
│   │   └── src
│   │       ├── debug
│   │       │   └── AndroidManifest.xml
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── kotlin
│   │       │   └── com
│   │       │       └── open_innov
│   │       │           └── hackingly_new
│   │       │               └── MainActivity.kt
│   │       └── res
│   │           ├── drawable
│   │           │   └── launch_background.xml
│   │           ├── drawable-v21
│   │           │   └── launch_background.xml
│   │           ├── mipmap-hdpi
│   │           │   └── ic_launcher.png
│   │           ├── mipmap-mdpi
│   │           │   └── ic_launcher.png
│   │           ├── mipmap-xhdpi
│   │           │   └── ic_launcher.png
│   │           ├── mipmap-xxhdpi
│   │           │   └── ic_launcher.png
│   │           ├── mipmap-xxxhdpi
│   │           │   └── ic_launcher.png
│   │           ├── values
│   │           │   └── styles.xml
│   │           ├── values-night
│   │           │   └── styles.xml
│   │           └── profile
│   │               └── AndroidManifest.xml
│   ├── build.gradle
│   ├── gradle
│   │   └── wrapper
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   └── settings.gradle
│
├── assets
│   ├── images
│   │   ├── abnCar.png
│   │   ├── auth.png
│   │   ├── car.jpeg
│   │   ├── garbage.jpeg
│   │   ├── garbage2.png
│   │   ├── potHoles.jpeg
│   │   └── road.png
│   └── lottie
│       ├── auth1.json
│       ├── auth2.json
│       ├── authentication.json
│       ├── loading.json
│       ├── otp.json
│       └── plane.json
│
├── ios
│   ├── .gitignore
│   ├── Flutter
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   └── Release.xcconfig
│   ├── Podfile
│   ├── Podfile.lock
│   ├── Runner
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │       └── AppIcon.appiconset
│   │           ├── Contents.json
│   │           ├── Icon-App-1024x1024@1x.png
│   │           ├── Icon-App-20x20@1x.png
│   │           ├── Icon-App-20x20@2x.png
│   │           ├── Icon-App-20x20@3x.png
│   │           ├── Icon-App-29x29@1x.png
│   │           ├── Icon-App-29x29@2x.png
│   │           ├── Icon-App-29x29@3x.png
│   │           ├── Icon-App-40x40@1x.png
│   │           ├── Icon-App-40x40@2x.png
│   │           ├── Icon-App-40x40@3x.png
│   │           ├── Icon-App-60x60@2x.png
│   │           ├── Icon-App-60x60@3x.png
│   │           ├── Icon-App-76x76@1x.png
│   │           ├── Icon-App-76x76@2x.png
│   │           └── Icon-App-83.5x83.5@2x.png
│   │   ├── LaunchImage.imageset
│   │       ├── Contents.json
│   │       ├── LaunchImage.png
│   │       ├── LaunchImage@2x.png
│   │       ├── LaunchImage@3x.png
│   │       └── README.md
│   │   ├── Base.lproj
│   │       ├── LaunchScreen.storyboard
│   │       └── Main.storyboard
│   │   ├── Info.plist
│   │   └── Runner-Bridging-Header.h
│   ├── Runner.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │       ├── contents.xcworkspacedata
│   │       └── xcshareddata
│   │           ├── IDEWorkspaceChecks.plist
│   │           └── WorkspaceSettings.xcsettings
│   ├── Runner.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   └── xcshareddata
│           ├── IDEWorkspaceChecks.plist
│           └── WorkspaceSettings.xcsettings
│   └── RunnerTests
│       └── RunnerTests.swift
│
├── lib
│   ├── admin_dashboard
│   │   └── admin_dashboard.dart
│   ├── controllers
│   │   └── navigation_bar_controller.dart
│   ├── firebase_options.dart
│   ├── main.dart
│   ├── models
│   │   ├── report.dart
│   │   ├── reports_model.dart
│   │   └── user_model.dart
│   ├── pages
│   │   ├── authentication
│   │       ├── otp_delivery.dart
│   │       └── phone_auth.dart
│   │   ├── components
│   │       └── index.dart
│   │   ├── screens
│   │       ├── admin
│   │           └── rto_admin.dart
│   │       ├── user
│   │           ├── home_screen.dart
│   │           ├── profile.dart
│   │           └── reports_screen.dart
│   │       ├── utilities
│   │           ├── abandoned_cars.dart
│   │           ├── garbage.dart
│   │           ├── potholes_report.dart
│   │           └── tracking.dart
│   │       └── welcome_screen
│   │           └── splash_screen.dart
│   ├── providers
│   │   ├── abandoned_cars_provider.dart
│   │   ├── admin_dashboard.dart
│   │   ├── garbage_report_provider.dart
│   │   ├── mongo_provider.dart
│   │   └── user_provider.dart
│   ├── services
│   │   ├── address_service.dart
│   │   ├── firebase_storage_service.dart
│   │   ├── image_picker_service.dart
│   │   ├── report_submission_service.dart
│   │   └── text_recognition_service.dart
│   ├── utils
│   │   └── constants.dart
│   └── widgets
│       └── CustomWidgets.dart
│
├── linux
│   ├── .gitignore
│   ├── CMakeLists.txt
│   ├── flutter
│   │   ├── CMakeLists.txt
