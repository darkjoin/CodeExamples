//
//  ExampleMarginView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleMarginView.h"

@implementation ExampleMarginView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    UIView *lastView = self;
    for (int i = 0; i < 10; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        view.layoutMargins = UIEdgeInsetsMake(5, 10, 15, 20);   // it's no need to set the value
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.topMargin);
            make.bottom.equalTo(lastView.bottomMargin);
            make.left.equalTo(lastView.leftMargin);
            make.right.equalTo(lastView.rightMargin);
        }];
        
        lastView = view;
    }
    
    return self;
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); // 0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

@end
