#import "LYRUISpecDispatcher.h"

@implementation LYRUISpecDispatcher

- (void)dispatchAsyncOnMainQueue:(void(^)(void))block {
    if (block) {
        block();
    }
}

- (void)dispatchAsyncOnGlobalQueue:(dispatch_queue_priority_t)priority block:(void (^)(void))block {
    if (block) {
        block();
    }
}

- (void)dispatchAsyncOnQueue:(dispatch_queue_t)queue block:(void (^)(void))block {
    if (block) {
        block();
    }
}

@end
