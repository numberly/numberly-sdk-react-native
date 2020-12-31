//
//  RNNumberlyAutoStarter.m
//  NumberlyPlugin
//
//  Copyright © 2020-present Numberly. All rights reserved.
//

#import "RNNumberlyAutoStarter.h"
#import "RNNumberlyEventEmitter.h"

@implementation RNNumberlyAutoStarter

+ (void)load {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:RNNumberlyAutoStarter.class
               selector:@selector(performStart:)
                   name:UIApplicationDidFinishLaunchingNotification object:nil];
}


+ (void)performStart:(NSNotification *)notification {
    [Numberly start];
    Numberly.push.delegate = RNNumberlyEventEmitter.shared;
}

@end
