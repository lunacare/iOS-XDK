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
    return [NSString stringWithFormat:@"%@%@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]];
}

- (UIImage *)avatarImage
{
    return nil;
}

@end
