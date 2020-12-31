'use strict';

import type { EmitterSubscription } from 'react-native';

import { NumberlyUser } from './NumberlyUser';
import { NumberlyPush } from './NumberlyPush';
import { NumberlyEventEmitter } from './NumberlyEventEmitter';

/**
 * Numberly manages the shared state for all services.
 */
export class Numberly {
  /**
   * The shared User instance.
   */
  static readonly user: NumberlyUser = new NumberlyUser();

  /**
   * The shared Push instance.
   */
  static readonly push: NumberlyPush = new NumberlyPush();

  /**
   * Adds a listener for a Numberly event.
   *
   * @param eventType The event name.
   * @param listener The event listener.
   * @return An emitter subscription.
   */
  static addListener(
    eventType: string,
    listener: (...args: any[]) => any
  ): EmitterSubscription {
    return NumberlyEventEmitter.addListener(eventType, listener);
  }

  /**
   * Removes a listener for a Numberly event.
   *
   * @param eventType The event name.
   * @param listener The event listener. Should be a reference to the function passed into addListener.
   */
  static removeListener(eventType: string, listener: (...args: any[]) => any) {
    NumberlyEventEmitter.removeListener(eventType, listener);
  }

  /**
   * Removes all listeners for Numberly events.
   *
   * @param eventType The event name.
   */
  static removeAllListeners(eventType: string) {
    NumberlyEventEmitter.removeAllListeners(eventType);
  }
}

/**
 * Numberly event types
 */
export enum NumberlyEventType {
  /**
   * Event name when a push token is received
   */
  PushTokenReceived = 'numberly.push.token',

  /**
   * Event name when a notification is received and results in a user interaction.
   */
  PushNotificationResponse = 'numberly.push.notification.response',
}
