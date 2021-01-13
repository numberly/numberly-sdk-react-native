//
//  RNNumberlyEventEmitter.h
//  NumberlyPlugin
//
//  Copyright © 2020-present Numberly. All rights reserved.
//

@import Foundation;

#import <React/RCTEventEmitter.h>

#if __has_include("Numberly.h")
#import "Numberly.h"
#else
@import Numberly;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNNumberlyEventEmitter : NSObject <NBLPushDelegate >

@property (class, readonly) RNNumberlyEventEmitter* shared;

@property (nonatomic, readonly) NSArray<NSString *>* supportedEvents;

@property (nonatomic, weak, nullable) RCTEventEmitter* emitter;

- (void)addListener:(NSString *)eventName;

- (void)removeListeners:(double)count;

@end

NS_ASSUME_NONNULL_END
