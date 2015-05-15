//
//  UIResponder+ATLFirstResponder.m
//  Pods
//
//  Created by Kabir Mahal on 5/15/15.
//
//

#import "UIResponder+ATLFirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (ATLFirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
