'use strict';

import {
  NativeEventEmitter,
  NativeModules,
  Platform,
  EmitterSubscription,
} from 'react-native';

/**
 * @hidden
 */
const NumberlyModule = NativeModules.NumberlyModule;

/**
 * @hidden
 */
class NumberlyEventEmitter extends NativeEventEmitter {
  constructor() {
    super(NumberlyModule);
  }

  addListener(
    eventType: string,
    listener: (...args: any[]) => any,
    context?: Object
  ): EmitterSubscription {
    if (Platform.OS === 'android') {
      NumberlyModule.addListener(eventType);
    }
    return super.addListener(eventType, listener, context);
  }

  removeAllListeners(eventType: string) {
    if (Platform.OS === 'android') {
      NumberlyModule.removeListeners(this.listeners(eventType).length);
    }
    super.removeAllListeners(eventType);
  }

  removeSubscription(subscription: EmitterSubscription) {
    if (Platform.OS === 'android') {
      NumberlyModule.removeListeners(1);
    }
    super.removeSubscription(subscription);
  }
}

const NumberlyEventEmitterInstance = new NumberlyEventEmitter()
export { NumberlyEventEmitterInstance as NumberlyEventEmitter }
