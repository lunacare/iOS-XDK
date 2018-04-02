//
//  LYRUIKeyboardAccessoryView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 28.03.2018.
//  Copyright (c) 2017 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LYRUIKeyboardAccessoryView.h"
#import "LYRUIConversationView.h"
#import "LYRUIComposeBar.h"
#import "LYRUIMessageListView.h"

static NSTimeInterval const LYRUIKeyboardAnimationDuration = 0.25;
static UIViewAnimationCurve const LYRUIKeyboardAnimationCurve = 7;

@interface LYRUIKeyboardAccessoryView ()

@property (nonatomic, weak) LYRUIConversationView *conversationView;

@end

@implementation LYRUIKeyboardAccessoryView

- (instancetype)initWithConversationView:(LYRUIConversationView *)conversationView {
    self = [super init];
    if (self) {
        self.conversationView = conversationView;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview) {
        [self.superview removeObserver:self
                            forKeyPath:@"center"];
        
        [self.superview removeObserver:self
                            forKeyPath:@"frame"];
    }
    
    [super willMoveToSuperview:newSuperview];
    
    [newSuperview addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(center))
                      options:0
                      context:nil];
    
    [newSuperview addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(frame))
                      options:0
                      context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    BOOL isObservedKeyPath = ([keyPath isEqualToString:NSStringFromSelector(@selector(center))] ||
                              [keyPath isEqualToString:NSStringFromSelector(@selector(frame))]);
    if (object == self.superview && isObservedKeyPath) {
        CGRect frame = self.superview.frame;
        
        CGRect windowFrame = [[[UIApplication sharedApplication] keyWindow] frame];
        windowFrame = self.superview.window.frame;
        
        CGFloat offset = windowFrame.size.height - frame.origin.y;
        
        CGFloat offsetChange = ABS(self.conversationView.keyboardMaintainedConstraint.constant - offset);
        BOOL shouldAnimate = CGRectGetHeight(frame) == offsetChange || CGRectGetHeight(frame) == 0;
        [self changeOffsetTo:offset animated:shouldAnimate];
    }
}

- (void)changeOffsetTo:(CGFloat)offset animated:(BOOL)animated {
    UICollectionView *collectionView = self.conversationView.messageListView.collectionView;
    CGPoint oldContentOffset = collectionView.contentOffset;
    CGFloat bottomOffset = collectionView.contentSize.height - (oldContentOffset.y + CGRectGetHeight(collectionView.bounds));
    CGFloat offsetChange = offset - self.conversationView.keyboardMaintainedConstraint.constant;
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:LYRUIKeyboardAnimationDuration];
        [UIView setAnimationCurve:LYRUIKeyboardAnimationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    self.conversationView.keyboardMaintainedConstraint.constant = offset;
    if (animated) {
        [self.conversationView layoutIfNeeded];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    if (offsetChange > 0) {
        CGFloat newHeight = CGRectGetHeight(self.conversationView.frame) - CGRectGetHeight(self.conversationView.composeBar.frame) - offset;
        CGFloat newOffset = collectionView.contentSize.height - newHeight - bottomOffset;
        [collectionView setContentOffset:CGPointMake(oldContentOffset.x, newOffset) animated:NO];
    }
}

@end
