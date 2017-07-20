//
//  LYRUIImageWithLettersViewConfigurator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

#import "LYRUIImageWithLettersViewConfigurator.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageFetcher.h"

@interface LYRUIImageWithLettersViewConfigurator ()

@property (nonatomic, strong) LYRUIImageFetcher *imageFetcher;

@end

@implementation LYRUIImageWithLettersViewConfigurator

- (void)setupImageWithLettersView:(LYRUIImageWithLettersView *)view withIdentity:(LYRIdentity *)identity {
    if (identity.avatarImageURL) {
        view.letters = nil;
        __weak __typeof(view) weakView = view;
        view.imageFetchCallback = ^(UIImage * _Nonnull image) {
            weakView.image = image;
        };
        [self.imageFetcher fetchImageWithURL:identity.avatarImageURL andCallback:view.imageFetchCallback];
    } else {
        view.image = nil;
        view.letters = [self initialsForIdentity:identity];
    }
}

- (NSString *)initialsForIdentity:(LYRIdentity *)identity { // TODO: extract to separate class
    NSString * initials = @"";
    if (identity.firstName && identity.firstName.length > 0 && identity.lastName && identity.lastName.length > 0) {
        initials = [NSString stringWithFormat:@"%@%@", [identity.firstName substringToIndex:1], [identity.lastName substringToIndex:1]];
    }
    else if (identity.displayName && identity.displayName.length > 1) {
        initials = [identity.displayName substringToIndex:2]; // TODO: split by whitespace and take first letters
    }
    return initials;
}

- (void)setupImageWithLettersViewWithMultipleParticipantsIcon:(LYRUIImageWithLettersView *)view {
    // TODO: set asset
}
@end
