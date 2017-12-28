//
//  ScanView.m
//  QRCodeReaderDemo
//
//  Created by darkgm on 27/12/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ScanView.h"

@implementation ScanView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self loadScanLine];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制白色边框
    CGContextAddRect(context, self.bounds);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
    
    // 绘制四角：
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 5.0);
    
    // 左上角：
    CGContextMoveToPoint(context, 0, 30);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 30, 0);
    CGContextStrokePath(context);
    
    // 右上角：
    CGContextMoveToPoint(context, self.bounds.size.width - 30, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 30);
    CGContextStrokePath(context);
    
    // 右下角：
    CGContextMoveToPoint(context, self.bounds.size.width, self.bounds.size.height - 30);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width - 30, self.bounds.size.height);
    CGContextStrokePath(context);
    
    // 左下角：
    CGContextMoveToPoint(context, 30, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height - 30);
    CGContextStrokePath(context);
}

- (void)loadScanLine
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1.0)];
        lineView.backgroundColor = [UIColor greenColor];
        [self addSubview:lineView];
        
        [UIView animateWithDuration:3.0 animations:^{
            lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 2.0);
        } completion:^(BOOL finished) {
            [lineView removeFromSuperview];
        }];
    }];
}


@end
