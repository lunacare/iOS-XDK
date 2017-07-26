#import "LYRUISpecDispatcher.h"

@implementation LYRUISpecDispatcher

- (void)dispatchAsyncOnMainQueue:(void(^)())block {
    if (block) {
        block();
    }
}

@end
