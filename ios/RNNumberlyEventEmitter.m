//
//  RNNumberlyEventEmitter.m
//  NumberlyPlugin
//
//  Copyright © 2020-present Numberly. All rights reserved.
//

#import "RNNumberlyEventEmitter.h"

NSString *const RNNumberlyPushReceivedNotification = @"numberly.push.notification.received";
NSString *const RNNumberlyPushNotificationResponse = @"numberly.push.notification.response";
NSString *const RNNumberlyPushToken = @"numberly.push.token";


NSString *const RNNumberlyEventNameKey = @"name";
NSString *const RNNumberlyEventParamsKey = @"params";

@interface RNNumberlyEventEmitter()
@property (nonatomic, strong) NSMutableArray *pendingEvents;
@property(nonatomic, strong) NSMutableSet *knownEvents;
@property(atomic, assign) NSInteger observersCount;
@property(readonly) BOOL hasObservers;
@end

@implementation RNNumberlyEventEmitter

+ (RNNumberlyEventEmitter *)shared {
    static RNNumberlyEventEmitter *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [RNNumberlyEventEmitter new];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pendingEvents = @[].mutableCopy;
        self.knownEvents = [NSMutableSet set];
    }
    return self;
}

- (BOOL)hasObservers {
    return self.observersCount > 0;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[RNNumberlyPushToken,
             RNNumberlyPushNotificationResponse,
             RNNumberlyPushReceivedNotification];
}

#pragma mark Event Methods

- (void)sendPendingEvents:(NSString *)eventName {
    for (id event in self.pendingEvents.copy) {
        if ([event[RNNumberlyEventNameKey] isEqualToString:eventName]) {
            [self.pendingEvents removeObject:event];
            [self sendEvent:event[RNNumberlyEventNameKey] params:event[RNNumberlyEventParamsKey]];
        }
    }
}

- (void)addListener:(NSString *)eventName {
    @synchronized(self.knownEvents) {
        self.observersCount++;
        [self.knownEvents addObject:eventName];
        [self sendPendingEvents: eventName];
    }
}

- (void)removeListeners:(double)count {
    @synchronized(self.knownEvents) {
        self.observersCount = MAX(self.observersCount - count, 0);
        if (self.observersCount == 0) {
            [self.knownEvents removeAllObjects];
        }
    }
}

- (void)sendEvent:(NSString *)name params:(NSDictionary *)params {
    @synchronized(self.knownEvents) {
        if (self.emitter && self.hasObservers && [self.knownEvents containsObject:name]) {
            [self.emitter sendEventWithName:name body:params];
        } else {
            @synchronized(self.pendingEvents) {
                [self.pendingEvents addObject:@{ RNNumberlyEventNameKey: name, RNNumberlyEventParamsKey: params}];
            }
        }
    }
}

#pragma mark Push delegate

- (void)receivedNotification:(NBLPushNotification *)notification {
    [self sendEvent:RNNumberlyPushReceivedNotification params:[self wrappedNotification: notification]];
}

- (void)registrationSucceededWithDeviceToken:(NSString *)deviceToken {
    [self sendEvent:RNNumberlyPushToken params:@{@"token": deviceToken}];
}

- (void)receivedNotificationResponse:(NBLPushNotification *)notification {
    [self sendEvent:RNNumberlyPushNotificationResponse params:[self wrappedNotification: notification]];
}

- (NSDictionary *)wrappedNotification:(NBLPushNotification *)notification {
    NSMutableDictionary *wrapped = @{}.mutableCopy;

    wrapped[@"id"] = notification.identifier;
    // wrapped[@"date"] = @([notification.date timeIntervalSince1970]);

    NSMutableDictionary *content = @{}.mutableCopy;

    if (notification.content.title) {
        content[@"title"] = notification.content.title;
    }

    if (notification.content.body) {
        content[@"body"] = notification.content.body;
    }

    if (notification.content.subtitle) {
        content[@"subtitle"] = notification.content.subtitle;
    }

    if (notification.content.badge) {
        content[@"badge"] = notification.content.badge;
    }

    if (notification.content.sound) {
        content[@"sound"] = notification.content.sound;
    }

    content[@"data"] = notification.content.userInfo ?: @{};

    if (notification.content.category) {
        content[@"category"] = notification.content.category;
    }

    wrapped[@"content"] = content.copy;
    return wrapped.copy;
}

@end
