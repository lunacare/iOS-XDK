//
//  LYRUIFileMessageContentViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 21.09.2017.
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

#import "LYRUIFileMessageContentViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIImageFactory.h"
#import "LYRUIFileMessage.h"
#import "LYRUIReusableViewsQueue.h"

static CGFloat const LYRUIFileMessageContentViewHeight = 104.0;

static NSString *const LYRUIFileMessageZipIcon = @"FileIconZIP";
static NSString *const LYRUIFileMessageAudioIcon = @"FileIconAudio";
static NSString *const LYRUIFileMessageImageIcon = @"FileIconImage";
static NSString *const LYRUIFileMessagePDFIcon = @"FileIconPDF";
static NSString *const LYRUIFileMessageTextIcon = @"FileIconText";
static NSString *const LYRUIFileMessageGenericIcon = @"FileIconGeneric";

static NSString *const LYRUIFileMIMETypeRAR = @"application/x-rar";
static NSString *const LYRUIFileMIMETypeZIP = @"application/zip";
static NSString *const LYRUIFileMIMETypeAudio = @"audio/";
static NSString *const LYRUIFileMIMETypeImage = @"image/";
static NSString *const LYRUIFileMIMETypePDF = @"application/pdf";
static NSString *const LYRUIFileMIMETypeText = @"text/";
static NSString *const LYRUIFileMIMETypeMS = @"application/ms";
static NSString *const LYRUIFileMIMETypeVND = @"application/vnd.openxmlformats";
static NSString *const LYRUIFileMIMETypeRTF = @"application/rtf";
static NSString *const LYRUIFileMIMETypeXRTF = @"application/x-rtf";
static NSString *const LYRUIFileMIMETypeExcel = @"application/excel";
static NSString *const LYRUIFileMIMETypeXExcel = @"application/x-excel";
static NSString *const LYRUIFileMIMETypePowerpoint = @"application/powerpoint";
static NSString *const LYRUIFileMIMETypeIWork = @"application/x-iwork";

@interface LYRUIFileMessageContentViewPresenter ()

@property (nonatomic, strong) LYRUIImageFactory *imageFactory;

@end

@implementation LYRUIFileMessageContentViewPresenter

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                   forClass:[self class]];
}

- (UIImageView *)viewForMessage:(LYRUIFileMessage *)message {
    UIImageView *imageView = [self.reusableViewsQueue dequeueReusableViewOfType:[UIImageView class]];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self setupViewConstraints:imageView];
    [self setupImageView:imageView withMessage:message];
    
    return imageView;
}

- (void)setupImageView:(__weak UIImageView *)imageView withMessage:(LYRUIFileMessage *)message {
    imageView.contentMode = UIViewContentModeCenter;
    NSString *MIMEType = message.fileMIMEType;
    NSString *iconFileName;
    if ([MIMEType containsString:LYRUIFileMIMETypeRAR] ||
        [MIMEType containsString:LYRUIFileMIMETypeZIP]) {
        iconFileName = LYRUIFileMessageZipIcon;
    } else if ([MIMEType containsString:LYRUIFileMIMETypeAudio]) {
        iconFileName = LYRUIFileMessageAudioIcon;
    } else if ([MIMEType containsString:LYRUIFileMIMETypeImage]) {
        iconFileName = LYRUIFileMessageImageIcon;
    } else if ([MIMEType containsString:LYRUIFileMIMETypePDF]) {
        iconFileName = LYRUIFileMessagePDFIcon;
    } else if ([MIMEType containsString:LYRUIFileMIMETypeText] ||
               [MIMEType containsString:LYRUIFileMIMETypeMS] ||
               [MIMEType containsString:LYRUIFileMIMETypeVND] ||
               [MIMEType containsString:LYRUIFileMIMETypeRTF] ||
               [MIMEType containsString:LYRUIFileMIMETypeXRTF] ||
               [MIMEType containsString:LYRUIFileMIMETypeExcel] ||
               [MIMEType containsString:LYRUIFileMIMETypeXExcel] ||
               [MIMEType containsString:LYRUIFileMIMETypePowerpoint] ||
               [MIMEType containsString:LYRUIFileMIMETypeIWork]) {
        iconFileName = LYRUIFileMessageTextIcon;
    } else {
        iconFileName = LYRUIFileMessageGenericIcon;
    }
    imageView.image = [self.imageFactory imageNamed:iconFileName];
}

- (void)setupViewConstraints:(UIView *)view {
    [super setupViewConstraints:view];
    [view.heightAnchor constraintGreaterThanOrEqualToConstant:LYRUIFileMessageContentViewHeight].active = YES;
}

- (CGFloat)viewHeightForMessage:(LYRUIMessageType *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    return LYRUIFileMessageContentViewHeight;
}

@end
