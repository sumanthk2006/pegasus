//
//  PGTranslators.m
//  Pegasus
//
//  Copyright 2012 Jonathan Ellis
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

#import "PGTranslators.h"

@implementation PGTranslators

+ (SEL)translatorForType:(NSString *)type {
    // Primitives:
    if ([type isEqualToString:@"int"]) return @selector(intWithString:);
    if ([type isEqualToString:@"double"]) return @selector(doubleWithString:);
    if ([type isEqualToString:@"float"]) return @selector(floatWithString:);
    if ([type isEqualToString:@"BOOL"]) return @selector(boolWithString:);
    
    // Structs:
    if ([type isEqualToString:@"CGRect"]) return @selector(rectWithString:);
    if ([type isEqualToString:@"CGSize"]) return @selector(sizeWithString:);
    if ([type isEqualToString:@"CGPoint"]) return @selector(pointWithString:);
    if ([type isEqualToString:@"CGAffineTransform"]) return @selector(affineTransformWithString:);
    if ([type isEqualToString:@"UIEdgeInsets"]) return @selector(edgeInsetsWithString:);
    
    // Enums:
    if ([type isEqualToString:@"UITextAlignment"]) return @selector(textAlignmentWithString:);
    if ([type isEqualToString:@"UITextBorderStyle"]) return @selector(textBorderStyleWithString:);
    if ([type isEqualToString:@"UIViewAutoresizing"]) return @selector(viewAutoresizingWithString:);
    if ([type isEqualToString:@"UIViewContentMode"]) return @selector(contentModeWithString:);
    if ([type isEqualToString:@"UILineBreakMode"]) return @selector(lineBreakModeWithString:);
    if ([type isEqualToString:@"UITextFieldViewMode"]) return @selector(textFieldViewModeWithString:);
    if ([type isEqualToString:@"UIScrollViewIndicatorStyle"]) return @selector(scrollViewIndicatorStyleWithString:);
    if ([type isEqualToString:@"UIProgressViewStyle"]) return @selector(progressViewStyleWithString:);
    
    // Objects:
    if ([type isEqualToString:@"NSString"]) return @selector(stringWithString:);
    if ([type isEqualToString:@"UIColor"]) return @selector(colorWithString:);
    if ([type isEqualToString:@"UIImage"]) return @selector(imageWithString:);
    if ([type isEqualToString:@"UIFont"]) return @selector(fontWithString:);
    
    return NULL;
}

#pragma mark - Translators (Primitives)

+ (int)intWithString:(NSString *)string {
    return string.intValue;
}

+ (double)doubleWithString:(NSString *)string {
    return string.doubleValue;
}

+ (float)floatWithString:(NSString *)string {
    return string.floatValue;
}

+ (BOOL)boolWithString:(NSString *)string {
    if ([string isEqualToString:@"yes"] || [string isEqualToString:@"true"]) return YES;
    return NO;
}

#pragma mark - Translators (Structs)

+ (CGRect)rectWithString:(NSString *)string {
    return CGRectFromString(string);
}

+ (CGSize)sizeWithString:(NSString *)string {
    return CGSizeFromString(string);
}

+ (CGPoint)pointWithString:(NSString *)string {
    return CGPointFromString(string);
}

+ (CGAffineTransform)affineTransformWithString:(NSString *)string {
    NSArray *components = [self componentsForTuple:string];
    
    float a = [[components objectAtIndex:0] floatValue];
    float b = [[components objectAtIndex:1] floatValue];
    float c = [[components objectAtIndex:2] floatValue];
    float d = [[components objectAtIndex:3] floatValue];
    float tx = [[components objectAtIndex:4] floatValue];
    float ty = [[components objectAtIndex:5] floatValue];
    
    return CGAffineTransformMake(a, b, c, d, tx, ty);
}

+ (UIEdgeInsets)edgeInsetsWithString:(NSString *)string {
    NSArray *components = [self componentsForTuple:string];
    
    float top = [[components objectAtIndex:0] floatValue];
    float left = [[components objectAtIndex:1] floatValue];
    float bottom = [[components objectAtIndex:2] floatValue];
    float right = [[components objectAtIndex:3] floatValue];    

    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - Translators (Enums)

+ (UITextAlignment)textAlignmentWithString:(NSString *)string {
    if ([string isEqualToString:@"left"]) return UITextAlignmentLeft;
    if ([string isEqualToString:@"right"]) return UITextAlignmentRight;
    if ([string isEqualToString:@"center"]) return UITextAlignmentCenter;
    return 0;
}

+ (UITextBorderStyle)textBorderStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"bezel"]) return UITextBorderStyleBezel;
    if ([string isEqualToString:@"line"]) return UITextBorderStyleLine;
    if ([string isEqualToString:@"none"]) return UITextBorderStyleNone;
    if ([string isEqualToString:@"rounded-rect"]) return UITextBorderStyleRoundedRect;
    return 0;
}

+ (UIViewAutoresizing)autoresizingWithString:(NSString *)string {
    UIViewAutoresizing mask = 0;
    NSArray *chunks = [string componentsSeparatedByString:@" "];
    for (NSString *chunk in chunks) {
        if ([chunk isEqualToString:@"none"]) mask |= UIViewAutoresizingNone;
        if ([chunk isEqualToString:@"margin-left"]) mask |= UIViewAutoresizingFlexibleLeftMargin;
        if ([chunk isEqualToString:@"margin-right"]) mask |= UIViewAutoresizingFlexibleRightMargin;
        if ([chunk isEqualToString:@"margin-top"]) mask |= UIViewAutoresizingFlexibleTopMargin;
        if ([chunk isEqualToString:@"margin-bottom"]) mask |= UIViewAutoresizingFlexibleBottomMargin;
        if ([chunk isEqualToString:@"width"]) mask |= UIViewAutoresizingFlexibleWidth;
        if ([chunk isEqualToString:@"height"]) mask |= UIViewAutoresizingFlexibleHeight;
    }
    
    return mask;
}

+ (UIViewContentMode)contentModeWithString:(NSString *)string {
    if ([string isEqualToString:@"scale-to-fill"]) return UIViewContentModeScaleToFill;
    if ([string isEqualToString:@"scale-aspect-fit"]) return UIViewContentModeScaleAspectFit;
    if ([string isEqualToString:@"scale-aspect-fill"]) return UIViewContentModeScaleAspectFill;
    if ([string isEqualToString:@"redraw"]) return UIViewContentModeRedraw;
    if ([string isEqualToString:@"center"]) return UIViewContentModeCenter;
    if ([string isEqualToString:@"top"]) return UIViewContentModeTop;
    if ([string isEqualToString:@"bottom"]) return UIViewContentModeBottom;
    if ([string isEqualToString:@"left"]) return UIViewContentModeLeft;
    if ([string isEqualToString:@"right"]) return UIViewContentModeLeft;
    if ([string isEqualToString:@"top-left"]) return UIViewContentModeTopLeft;
    if ([string isEqualToString:@"top-right"]) return UIViewContentModeTopRight;
    if ([string isEqualToString:@"bottom-left"]) return UIViewContentModeBottomLeft;
    if ([string isEqualToString:@"bottom-right"]) return UIViewContentModeBottomRight;
    
    return 0;
}

+ (UILineBreakMode)lineBreakModeWithString:(NSString *)string {
    if ([string isEqualToString:@"word-wrap"]) return UILineBreakModeWordWrap;
    if ([string isEqualToString:@"character-wrap"]) return UILineBreakModeCharacterWrap;
    if ([string isEqualToString:@"clip"]) return UILineBreakModeClip;
    if ([string isEqualToString:@"head-truncation"]) return UILineBreakModeHeadTruncation;
    if ([string isEqualToString:@"tail-truncation"]) return UILineBreakModeTailTruncation;
    if ([string isEqualToString:@"middle-truncation"]) return UILineBreakModeTailTruncation;
    return 0;
}

+ (UITextFieldViewMode)textFieldViewModeFromString:(NSString *)string {
    if ([string isEqualToString:@"always"]) return UITextFieldViewModeAlways;
    if ([string isEqualToString:@"never"]) return UITextFieldViewModeNever;
    if ([string isEqualToString:@"unless-editing"]) return UITextFieldViewModeUnlessEditing;
    if ([string isEqualToString:@"while-editing"]) return UITextFieldViewModeWhileEditing;

    return 0;
}

+ (UIScrollViewIndicatorStyle)scrollViewIndicatorStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"default"]) return UIScrollViewIndicatorStyleDefault;
    if ([string isEqualToString:@"black"]) return UIScrollViewIndicatorStyleBlack;
    if ([string isEqualToString:@"white"]) return UIScrollViewIndicatorStyleWhite;
    return 0;
}

+ (UIProgressViewStyle)progressViewStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"default"]) return UIProgressViewStyleDefault;
    if ([string isEqualToString:@"bar"]) return UIProgressViewStyleBar;
    return 0;
}

#pragma mark - Translators (Objects)

+ (NSString *)stringWithString:(NSString *)string {
    return string;
}

+ (UIColor *)colorWithString:(NSString *)string {
    // Hex color:
    if ([[string substringToIndex:1] isEqualToString:@"#"]) return [UIColor colorWithHexString:string];
    
    // Preset colors:
    if ([string isEqualToString:@"black"]) return [UIColor blackColor];
    if ([string isEqualToString:@"dark-gray"]) return [UIColor darkGrayColor];
    if ([string isEqualToString:@"light-gray"]) return [UIColor lightGrayColor];
    if ([string isEqualToString:@"white"]) return [UIColor whiteColor];
    if ([string isEqualToString:@"gray"]) return [UIColor grayColor];
    if ([string isEqualToString:@"red"]) return [UIColor redColor];
    if ([string isEqualToString:@"green"]) return [UIColor greenColor];
    if ([string isEqualToString:@"blue"]) return [UIColor blueColor];
    if ([string isEqualToString:@"cyan"]) return [UIColor cyanColor];    
    if ([string isEqualToString:@"yellow"]) return [UIColor yellowColor];
    if ([string isEqualToString:@"magenta"]) return [UIColor magentaColor];
    if ([string isEqualToString:@"orange"]) return [UIColor orangeColor];
    if ([string isEqualToString:@"purple"]) return [UIColor purpleColor];
    if ([string isEqualToString:@"brown"]) return [UIColor brownColor];
    if ([string isEqualToString:@"clear"]) return [UIColor clearColor];
    return nil;
}

+ (UIImage *)imageWithString:(NSString *)string {
    return [UIImage imageNamed:string];
}

+ (UIFont *)fontWithString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@" "];
    NSString *name = [components objectAtIndex:0];
    float size = [[components objectAtIndex:1] floatValue];
    
    if ([name isEqualToString:@"system"]) return [UIFont systemFontOfSize:size];
    if ([name isEqualToString:@"system-bold"]) return [UIFont boldSystemFontOfSize:size];
    if ([name isEqualToString:@"system-italic"]) return [UIFont italicSystemFontOfSize:size];

    return [UIFont fontWithName:name size:size];
}

#pragma mark - Helper methods

+ (NSArray *)componentsForTuple:(NSString *)string {
    NSCharacterSet *curlyBracketsSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    NSString *bracketlessString = [string stringByTrimmingCharactersInSet:curlyBracketsSet];
    return [bracketlessString componentsSeparatedByString:@","];
}

@end