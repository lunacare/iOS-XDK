//
//  LYRUIMediaHandler.h
//  Pods
//
//  Created by Klemen Verdnik on 6/4/18.
//

#import <Foundation/Foundation.h>
#import "LYRUIMediaPlaying.h"
#import "LYRUIConfigurable.h"

extern NSString *const LYRUIMediaHandlerErrorDomain;

typedef enum : NSUInteger {
    LYRUIMediaHandlerErrorStatusFailedToOpen = 1,
} LYRUIMediaHandlerErrorStatus;

@interface LYRUIMediaHandler : NSObject <LYRUIMediaPlaying, LYRUIConfigurable>

@end
