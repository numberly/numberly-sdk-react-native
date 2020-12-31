//
//  NumberlyPlugin.h
//  NumberlyPlugin
//
//  Copyright © 2020-present Numberly. All rights reserved.
//

@import React;

#if __has_include("Numberly.h")
#import "Numberly.h"
#else
@import Numberly;
#endif

@interface NumberlyPlugin : RCTEventEmitter

@end
