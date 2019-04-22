//
//  ExampleDistributeView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleDistributeView.h"

@implementation ExampleDistributeView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        [self addSubview:view];
        [arr addObject:view];
    }
    
    unsigned int type = arc4random() % 4;
    switch (type) {
        case 0:
            [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@60);
                make.height.equalTo(@60);
            }];
            break;
        case 1:
            [arr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
        case 2:
            [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:200 tailSpacing:30];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@60);
                make.height.equalTo(@60);
            }];
            break;
        case 3:
            [arr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:30 leadSpacing:20 tailSpacing:200];
            [arr makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
            
        default:
            break;
    }
    
    return self;
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); // 0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
