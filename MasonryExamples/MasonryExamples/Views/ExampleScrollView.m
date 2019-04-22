//
//  ExampleScrollView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleScrollView.h"

@interface ExampleScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ExampleScrollView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor grayColor];
    [self addSubview:scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self generateContent];
    
    return self;
}

- (void)generateContent
{
    UIView *contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    UIView *lastView;
    CGFloat height = 25;
    
    for (int i = 0; i < 10; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        [contentView addSubview:view];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [view addGestureRecognizer:singleTap];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView ? lastView.bottom : @0);
            make.left.equalTo(@0);
            make.width.equalTo(contentView.width);
            make.height.equalTo(@(height));
        }];
        
        height += 25;
        lastView = view;
    }
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.bottom);
    }];
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); // 0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;    // 0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    [sender.view setAlpha:sender.view.alpha / 1.20];
    
    [self.scrollView scrollRectToVisible:sender.view.frame animated:YES];
};

@end
