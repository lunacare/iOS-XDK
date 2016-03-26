//
//  LYRIdentity+ATLParticipant.m
//  Atlas
//
//  Created by Kabir Mahal on 2/17/16.
//
//

#import "LYRIdentity+ATLParticipant.h"

@implementation LYRIdentity (ATLParticipant)

- (NSString *)avatarInitials
{
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@%@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]];
    }
    return [self.displayName substringToIndex:2];
}

- (UIImage *)avatarImage
{
    return nil;
}

@end
