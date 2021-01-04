//
//  NumberlyPlugin.m
//  NumberlyPlugin
//
//  Copyright © 2020-present Numberly. All rights reserved.
//

#import "NumberlyPlugin.h"
#import "RNNumberlyEventEmitter.h"

@implementation NumberlyPlugin {
    BOOL hasListeners;
}

RCT_EXPORT_MODULE(NumberlyModule)

#pragma mark - Setup

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        RNNumberlyEventEmitter.shared.emitter = self;
    }
    return self;
}

- (void)startObserving {
    hasListeners = true;
}

- (void)stopObserving {
    hasListeners = false;
}

- (NSArray<NSString *> *)supportedEvents {
    return RNNumberlyEventEmitter.shared.supportedEvents;
}

- (void)addListener:(NSString *)eventName {
    [super addListener:eventName];
    [RNNumberlyEventEmitter.shared addListener:eventName];
}

- (void)removeListeners:(double)count {
    [super removeListeners:count];
    [RNNumberlyEventEmitter.shared removeListeners:count];
}

#pragma mark - Methods

#pragma mark User module

RCT_REMAP_METHOD(userInstallationID,
                 installationID_resolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  resolve(Numberly.user.installationID);
}

#pragma mark Push module

RCT_REMAP_METHOD(pushDeviceToken,
                 pushDeviceToken_resolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  resolve(Numberly.push.deviceToken);
}

RCT_EXPORT_METHOD(pushRegisterForRemoteNotifications)
{
  [Numberly.push registerForRemoteNotifications:@[@(NBLPushAuthorizationOptionAlert),
                                                  @(NBLPushAuthorizationOptionSound),
                                                  @(NBLPushAuthorizationOptionBadge)]
                              completionHandler:nil];
}

RCT_EXPORT_METHOD(clearBadge) {
    [Numberly.push clearBadge];
}

RCT_REMAP_METHOD(pushAreNotificationsEnabled,
                 pushAreNotificationsEnabled_resolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    [Numberly.push areNotificationsEnabledWithCompletionHandler:^(enum NBLPushAuthorizationStatus result) {
        switch (result) {
            case NBLPushAuthorizationStatusDenied:
                resolve(@NO);
                break;
            case NBLPushAuthorizationStatusNotDetermined:
                resolve(nil);
                break;
            default:
                resolve(@YES);
                break;
        }
    }];
}

@end
