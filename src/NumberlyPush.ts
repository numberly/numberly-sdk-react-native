'use strict';

import { NativeModules, Platform } from 'react-native';

/**
 * @hidden
 */
const NumberlyModule = NativeModules.NumberlyModule;

/**
 * Numberly's Push Module
 * @Warning You must always use the {@linkcode Numberly.push} instead of a new instance.
 */
export class NumberlyPush {
  /**
   * Returns whether notifications are enabled the current application.
   *
   * @return A promise with the result.
   */
  public areNotificationsEnabled(): Promise<boolean | null | undefined> {
    return NumberlyModule.pushAreNotificationsEnabled();
  }

  /**
   * Gets the last received remote notification token.
   *
   * @return A promise with the result.
   *
   * @remarks The returned value might be outdated or invalid.
   * Make sure that your application registers for remote notifications
   * once per launch, in order to keep this value up to date.
   */
  public deviceToken(): Promise<string | null | undefined> {
    return NumberlyModule.pushDeviceToken();
  }

  /**
   * iOS Only
   * Register to receive remote notifications.
   * Make sure that your application calls this function once per launch,
   * in order to keep the token value up to date.
   *
   * @remarks You will need to call this method by your self only if you've set
   * `automatic_notification_registration` to `false` in Numberly.plist
   */
  public registerForRemoteNotifications() {
    if (Platform.OS === 'ios') {
      NumberlyModule.pushRegisterForRemoteNotifications();
    }
  }

  /**
   * iOS Only
   * Clear the application’s badge.
   */
  public clearBadge() {
    if (Platform.OS === 'ios') {
      NumberlyModule.clearBadge();
    }
  }
}
