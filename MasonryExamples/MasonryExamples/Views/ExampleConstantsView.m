//
//  ExampleConstantsView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleConstantsView.h"

@implementation ExampleConstantsView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    UIView *purpleView = UIView.new;
    purpleView.backgroundColor = UIColor.purpleColor;
    purpleView.layer.borderColor = UIColor.blackColor.CGColor;
    purpleView.layer.borderWidth = 2;
    [self addSubview:purpleView];
    
    UIView *orangeView = UIView.new;
    orangeView.backgroundColor = UIColor.orangeColor;
    orangeView.layer.borderColor = UIColor.blackColor.CGColor;
    orangeView.layer.borderWidth = 2;
    [self addSubview:orangeView];
    
    // examples of using constants
    [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.bottom.equalTo(@-20);
        make.right.equalTo(@-20);
    }];
    
    
    // auto-boxing macros allow you to simply use scalars and structs, they will be wrapped automatically
    // 注意：使用auto-boxing需要定义 #define MAS_SHORTHAND_GLOBALS （这里是在PCH文件中定义的）
    [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(CGPointMake(0, 50));    // 这里的CGPoint值是距离center的偏移值，例如(0, 50)表示center向下偏移50；(0, -50)表示center向上偏移50；(50, 0)表示center向右偏移50；(-50, 0)表示center向左偏移50
        make.size.equalTo(CGSizeMake(200, 100));
    }];
    
    return self;
}

@end
