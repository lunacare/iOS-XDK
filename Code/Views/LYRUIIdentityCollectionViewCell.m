//
//  LYRUIIdentityCollectionViewCell.m
//  Pods
//
//  Created by Łukasz Przytuła on 27.07.2017.
//
//

#import "LYRUIIdentityCollectionViewCell.h"
#import "LYRUIIdentityItemView.h"

@implementation LYRUIIdentityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    LYRUIIdentityItemView *identityView = [[LYRUIIdentityItemView alloc] init];
    identityView.frame = self.contentView.bounds;
    identityView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.contentView addSubview:identityView];
    self.identityView = identityView;
}

@end
