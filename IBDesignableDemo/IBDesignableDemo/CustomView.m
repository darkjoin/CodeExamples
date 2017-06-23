//
//  CustomView.m
//  IBDesignableDemo
//
//  Created by darkgm on 23/06/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "CustomView.h"

IB_DESIGNABLE

@interface CustomView ()

@property (nonatomic) IBInspectable UIColor *innerColor;
@property (nonatomic) IBInspectable UIColor *outterColor;

@property (nonatomic) IBInspectable CGFloat innerRadius;
@property (nonatomic) IBInspectable CGFloat outterRadius;

@property (nonatomic) IBInspectable CGFloat innerWidth;
@property (nonatomic) IBInspectable CGFloat outterWidth;

@end

@implementation CustomView

- (void)drawRect:(CGRect)rect
{
    // 绘制最里面的圆
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.innerRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [innerPath setLineWidth:self.innerWidth];
    [self.innerColor setStroke];
    [innerPath stroke];
    
    // 绘制最外面的圆
    UIBezierPath *outterPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.outterRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [outterPath setLineWidth:self.outterWidth];
    [self.outterColor setStroke];
    [outterPath stroke];
}

@end
