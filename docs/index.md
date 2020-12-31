
Guide and instructions for setting up the Numberly SDK for React Native apps.

???+ info "Requirements"

    * React Native >= 0.60.0
    * Android:
        * `compileSdkVersion` 29
        * `minSdkVersion` 16+

    * iOS:
        * Xcode 12+

## Installation

=== "Yarn"

    ```sh
    yarn add react-native-numberly-sdk
    ```

=== "NPM"

    ```sh
    npm i react-native-numberly-sdk --save
    ```


## Setup

### Android

1. Create the `numberly.properties` file in the application’s `android/app/src/main/assets`.

    ```yaml
    app_key = the app key provided by numberly
    notification_icon_name = your icon name
    notification_icon_color = #00A6B6FF
    ```

2. Add the `google-services.json` file to `/android/app`.

!!! warning ""
    This guide assumes that you've already configured your android application to connect to [Firebase](https://firebase.google.com). If this is not the case, please flow [this instructions](https://firebase.google.com/docs/android/setup#console) to do so.

### iOS

1. Install needed pods

    ```sh
    cd ios
    pod install
    ```

2. Open the project `.xcworkspace` in the `ios` folder and create a `Numberly.plist` file. Make sure that it's included to your application’s target.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>app_key</key>
      <string>the app key provided by numberly</string>
      <key>automatic_notification_registration</key>
      <true/>
    </dict>
    </plist>
    ```

3. Add the `Push Notification` capability to your project by following [this guide](https://developer.apple.com/documentation/xcode/adding_capabilities_to_your_app).
