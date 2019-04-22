//
//  ExampleAttributeChainingView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleAttributeChainingView.h"

@implementation ExampleAttributeChainingView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    UIView *greenView = UIView.new;
    greenView.backgroundColor = UIColor.greenColor;
    greenView.layer.borderColor = UIColor.blackColor.CGColor;
    greenView.layer.borderWidth = 2;
    [self addSubview:greenView];
    
    UIView *redView = UIView.new;
    redView.backgroundColor = UIColor.redColor;
    redView.layer.borderColor = UIColor.blackColor.CGColor;
    redView.layer.borderWidth = 2;
    [self addSubview:redView];
    
    UIView *blueView = UIView.new;
    blueView.backgroundColor = UIColor.blueColor;
    blueView.layer.borderColor = UIColor.blackColor.CGColor;
    blueView.layer.borderWidth = 2;
    [self addSubview:blueView];
    
    UIView *superView = self;
    UIEdgeInsets padding = UIEdgeInsetsMake(15, 10, 15, 10);
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        // chain attributes
        make.top.and.left.equalTo(superView).insets(padding);
        
        // which is equivalent of
//        make.top.greaterThanOrEqualTo(superView).insets(padding);
//        make.left.greaterThanOrEqualTo(superView).insets(padding);
        
        make.bottom.equalTo(blueView.mas_top).insets(padding);
        make.right.equalTo(redView.mas_left).insets(padding);
        make.width.equalTo(redView.mas_width);
        
        make.height.equalTo(@[redView, blueView]);
    }];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        // chain attributes
        make.top.and.right.equalTo(superView).insets(padding);
        
        make.left.equalTo(greenView.mas_right).insets(padding);
        make.bottom.equalTo(blueView.mas_top).insets(padding);
        make.width.equalTo(greenView.mas_width);
        
        make.height.equalTo(@[greenView, blueView]);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greenView.mas_bottom).insets(padding);
        
        // chain attributes
        make.left.right.and.bottom.equalTo(superView).insets(padding);
        
        make.height.equalTo(@[greenView, redView]);
    }];
    
    return self;
}

@end
