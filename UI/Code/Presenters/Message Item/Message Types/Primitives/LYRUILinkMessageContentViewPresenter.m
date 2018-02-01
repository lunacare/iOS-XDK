//
//  LYRUILinkMessageContentViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 26.09.2017.
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

#import "LYRUILinkMessageContentViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIImageFetcher.h"
#import "LYRUIDispatcher.h"
#import "LYRUILinkMessage.h"
#import "LYRUIReusableViewsQueue.h"
#import "UIView+LYRUIMessageConfiguration.h"
#import "LYRUILinkMessageView.h"

static CGFloat const LYRUIMessageItemViewLinkImageDefaultRatio = 4.0 / 3.0;
static CGSize const LYRUIMessageItemViewLinkImageDefaultSize = { 4.0, 3.0 };
static CGFloat const LYRUIMessageItemViewLinkImageMaxHeight = 450.0;

@interface LYRUILinkMessageContentViewPresenter ()

@property (nonatomic, strong) NSCache *pageImageURLsCache;
@property (nonatomic, strong) LYRUILinkMessageView *sizingLinkView;

@end

@implementation LYRUILinkMessageContentViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingLinkView = [[LYRUILinkMessageView alloc] init];
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.pageImageURLsCache = [layerConfiguration.injector objectOfType:[NSCache class]];
}

- (LYRUILinkMessageView *)viewForMessage:(LYRUILinkMessage *)message {
    if (message.metadata != nil && message.imageURL == nil) {
        return nil;
    }
    
    LYRUILinkMessageView *linkView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUILinkMessageView class]];
    if (linkView == nil) {
        linkView = [[LYRUILinkMessageView alloc] init];
        linkView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    if (message.imageURL) {
        [self setupViewConstraints:linkView forImageSize:message.imageSize];
    } else {
        [self setupViewConstraints:linkView];
    }
    [self setupLinkView:linkView withMessageType:message];
    
    return linkView;
}

- (void)setupLinkView:(__weak LYRUILinkMessageView *)linkView withMessageType:(LYRUILinkMessage *)messageType {
    NSString *contextId = [NSUUID UUID].UUIDString;
    linkView.imageView.lyr_presentationContextId = contextId;
    
    linkView.textView.hidden = (messageType.imageURL != nil);
    linkView.imageView.hidden = (messageType.imageURL == nil);
    if (messageType.imageURL != nil) {
        [self fetchAndPresentImageWithURL:messageType.imageURL inImageView:linkView.imageView contextId:contextId completion:nil];
    } else {
        linkView.textView.text = messageType.URL.absoluteString;
    }
}

- (void)setupViewConstraints:(LYRUILinkMessageView *)view {
    [super setupViewConstraints:view];
    [view.textView.topAnchor constraintEqualToAnchor:view.topAnchor].active = YES;
    [view.textView.rightAnchor constraintEqualToAnchor:view.rightAnchor].active = YES;
    [view.textView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor].active = YES;
    [view.textView.leftAnchor constraintEqualToAnchor:view.leftAnchor].active = YES;
    [view.imageView.topAnchor constraintEqualToAnchor:view.topAnchor].active = YES;
    [view.imageView.rightAnchor constraintEqualToAnchor:view.rightAnchor].active = YES;
    [view.imageView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor].active = YES;
    [view.imageView.leftAnchor constraintEqualToAnchor:view.leftAnchor].active = YES;
}

- (void)setupViewConstraints:(UIView *)view forImageSize:(CGSize)size {
    CGFloat maxHeight = LYRUIMessageItemViewLinkImageMaxHeight;
    CGFloat ratio = (size.height != 0.0) ? (size.width / size.height) : LYRUIMessageItemViewLinkImageDefaultRatio;
    [self setupViewConstraints:view];
    if (size.width != 0.0) {
        CGFloat width = (size.height > maxHeight) ? (maxHeight * ratio) : size.width;
        NSLayoutConstraint *widthConstraint = [view.widthAnchor constraintEqualToConstant:width];
        widthConstraint.priority = 501.0;
        widthConstraint.active = YES;
    }
    NSLayoutConstraint *ratioConstraint = [view.widthAnchor constraintEqualToAnchor:view.heightAnchor multiplier:ratio];
    ratioConstraint.priority = UILayoutPriorityDefaultHigh;
    ratioConstraint.active = YES;
    [view.heightAnchor constraintLessThanOrEqualToConstant:maxHeight].active = YES;
}

- (CGFloat)viewHeightForMessage:(LYRUILinkMessage *)message
                       minWidth:(CGFloat)minWidth
                       maxWidth:(CGFloat)maxWidth {
    if (message.metadata != nil && message.imageURL == nil) {
        return 0.0;
    } else if (message.imageURL == nil) {
        return [self textHeightForMessageType:message minWidth:minWidth maxWidth:maxWidth];
    } else {
        return [self imageHeightForMessageType:message minWidth:minWidth maxWidth:maxWidth];
    }
}

- (CGFloat)textHeightForMessageType:(LYRUILinkMessage *)messageType
                           minWidth:(CGFloat)minWidth
                           maxWidth:(CGFloat)maxWidth {
    LYRUILinkMessageView *linkView = self.sizingLinkView;
    [self setupLinkView:linkView withMessageType:messageType];
    CGFloat textWidth = maxWidth - 28.0;
    CGRect stringRect = [linkView.textView.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                          attributes:linkView.textView.typingAttributes
                                                             context:nil];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat linkViewHeight = ceil(stringRect.size.height * screenScale) / screenScale;
    return linkViewHeight + 14.0;
}

- (CGFloat)imageHeightForMessageType:(LYRUILinkMessage *)messageType
                            minWidth:(CGFloat)minWidth
                            maxWidth:(CGFloat)maxWidth {
    CGSize imageSize = messageType.imageSize;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        UIImage *image = [self.imagesCache objectForKey:messageType.imageURL];
        if (image != nil) {
            imageSize = image.size;
        } else {
            imageSize = LYRUIMessageItemViewLinkImageDefaultSize;
        }
    }
    CGFloat height = [self heightForSize:imageSize withMinWidth:minWidth maxWidth:maxWidth];
    return MIN(height, LYRUIMessageItemViewLinkImageMaxHeight);
}

@end
