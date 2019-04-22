//
//  ExampleBasicView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleBasicView.h"

@implementation ExampleBasicView

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
    int padding = 10;
    
    // If you want to use Masonry without the mas_ profix, define MAS_SHORTHAND before importing Masonry.h
    [greenView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(superView.top).offset(padding);
        make.left.equalTo(superView.left).offset(padding);
        make.bottom.equalTo(blueView.top).offset(-padding);
        make.right.equalTo(redView.left).offset(-padding);
        make.width.equalTo(redView.width);
        
        make.height.equalTo(redView.height);
        make.height.equalTo(blueView.height);
    }];
    
    // with is semantic and option
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(padding);   // with with
        make.left.equalTo(greenView.mas_right).offset(padding); // without with
        make.bottom.equalTo(blueView.mas_top).offset(-padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.width.equalTo(greenView.mas_width);
        
        make.height.equalTo(@[greenView, blueView]);    // can pass array of views
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greenView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.bottom.equalTo(superView.mas_bottom).offset(-padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        
        make.height.equalTo(@[greenView.mas_height, redView.mas_height]);   // can pass array of attributes
    }];
    
    return self;
}

@end
