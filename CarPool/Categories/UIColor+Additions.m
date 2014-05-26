//
//  UIColor+Additions.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)randomColor
{
    CGFloat redLevel = rand() / (float) RAND_MAX;
    CGFloat greenLevel = rand() / (float) RAND_MAX;
    CGFloat blueLevel = rand() / (float) RAND_MAX;
    
    return [UIColor colorWithRed:redLevel
                           green:greenLevel
                            blue:blueLevel
                           alpha:1.0];
}

+ (UIColor *)blueChatBubbleColor
{
    return [UIColor colorWithRed:37.0/255.0 green:160.0/255.0 blue:254.0/255.0 alpha:1];
}

+ (UIColor *)greenChatBubbleColor
{
    return [UIColor colorWithRed:94.0/255.0 green:228.0/255.0 blue:67.0/255.0 alpha:1];
}

+ (UIColor *)grayChatBubbleColor
{
    return [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:234.0/255.0 alpha:1];
}

+ (UIColor *)redChatBubbleColor
{
    return [UIColor colorWithRed:255.0/255.0 green:53.0/255.0 blue:36.0/255.0 alpha:1];;
}

@end
