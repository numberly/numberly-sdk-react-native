# Push notifications

Push notifications allow an app that isn’t running in the foreground to notify the user when it has information for them. Push notifications originate from a notification server and are pushed to your app on a user’s device.

## Enabling Push Notifications

By default, on iOS the Numberly SDK will register for push notifications each time your app launches. You can disable this auto integration by setting the `automatic_notification_registration` value to `false` in your `Numberly.plist`.
If you do so, you will be in charge of enabling push notifications in an other suitable moment in the user journey.

```js
// Import
import { Numberly } from 'react-native-numberly-sdk';

// Enable push notifications
Numberly.push.registerForRemoteNotifications()
```

!!! tip
    Make sure to enable push notifications each time your app launches to keep the token up to date.

## Listening to push related events

The Numberly SDK provides an `addListener` method which sets up a function that will be called whenever the specified event is fired.

???+ info "Push Token Received"

    Event fired when push notifications are enabled successfully and the device token is received.

    ```js
    import { NumberlyEventType } from 'react-native-numberly-sdk';

    Numberly.addListener(NumberlyEventType.PushTokenReceived, (event) => {
      console.log(`Push token: ${event.token}`)
    })
    ```

???+ info "Push Notification Response"

    Event fired when a push notification is received and results in a user interaction.

    ```js
    import { NumberlyEventType } from 'react-native-numberly-sdk';

    Numberly.addListener(NumberlyEventType.PushNotificationResponse, (notification) => {
      console.log(JSON.stringify(notification));

      // Get custom data from the payload
      console.log(JSON.stringify(notification.content.data));
    })
    ```
