#import "LYRUISpecDispatcher.h"

@implementation LYRUISpecDispatcher

- (void)dispatchAsyncOnMainQueue:(void(^)(void))block {
    if (block) {
        block();
    }
}

@end
