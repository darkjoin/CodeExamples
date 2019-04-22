//
//  ExampleSafeAreaLayoutGuideViewController.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleSafeAreaLayoutGuideViewController.h"

@interface ExampleSafeAreaLayoutGuideViewController ()

@end

@implementation ExampleSafeAreaLayoutGuideViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Safe Area Layout Guides";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = UIView.new;
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIView *view2 = UIView.new;
    view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view2];
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view3];
    
    UIView *leftView = [self viewWithName:@"LY"];
    UIView *rightView = [self viewWithName:@"RY"];
    UIView *topView = [self viewWithName:@"TX"];
    UIView *bottomView = [self viewWithName:@"BX"];

    UIView *leftTopView = [self viewWithName:@"LT"];
    UIView *rightTopView = [self viewWithName:@"RT"];
    UIView *leftBottomView = [self viewWithName:@"LB"];
    UIView *rightBottomView = [self viewWithName:@"RB"];

    UIView *centerView = [self viewWithName:@"XY"];
    
    MASAttachKeys(self.view, view1, view2, view3, centerView, leftView, rightView, topView, bottomView, leftTopView, rightTopView, leftBottomView, rightBottomView);

    const CGFloat size = 50.0;
    
    // 下面的布局中如果使用mas_safeAreaLayoutGuide会崩溃
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide).inset(10);  // this will crash
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(10);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(-10);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).inset(10);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).inset(-10);
    }];

    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view.mas_safeAreaLayoutGuide);
//        make.width.height.equalTo(self.view.mas_safeAreaLayoutGuide).sizeOffset(CGSizeMake(-40.0, -40.0));
        make.centerX.equalTo(self.view.mas_safeAreaLayoutGuideCenterX);
        make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideCenterY);
        make.width.equalTo(self.view.mas_safeAreaLayoutGuideWidth).offset(-40.0);
        make.height.equalTo(self.view.mas_safeAreaLayoutGuideHeight).offset(-40);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view.mas_safeAreaLayoutGuide);
//        make.width.equalTo(self.view.mas_safeAreaLayoutGuide).sizeOffset(CGSizeMake(-60.0, -60.0));
//        make.height.equalTo(self.view.mas_safeAreaLayoutGuide).sizeOffset(CGSizeMake(-60, -60));
        make.centerX.equalTo(self.view.mas_safeAreaLayoutGuideCenterX);
        make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideCenterY);
        make.width.equalTo(self.view.mas_safeAreaLayoutGuideWidth).offset(-60.0);
        make.height.equalTo(self.view.mas_safeAreaLayoutGuideHeight).offset(-60.0);
    }];
    
    [leftTopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.width.height.equalTo(@(size));
    }];
    
    [rightTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.width.height.equalTo(@(size));
    }];
    
    [leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.height.equalTo(@(size));
    }];
    
    [rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.height.equalTo(@(size));
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.centerY.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideCenterY);
        make.width.height.equalTo(@(size));
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideCenterY);
//        make.right.centerY.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.width.height.equalTo(@(size));
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.centerX.equalTo(self.view.mas_safeAreaLayoutGuideCenterX);
//        make.top.centerX.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.width.height.equalTo(@(size));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.centerX.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.centerX.equalTo(self.view.mas_safeAreaLayoutGuideCenterX);
        make.width.height.equalTo(@(size));
    }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.centerX.equalTo(self.view.mas_safeAreaLayoutGuideCenterX);
        make.centerY.equalTo(self.view.mas_safeAreaLayoutGuideCenterY);
        make.width.height.equalTo(@(size));
    }];
}

- (UIView *)viewWithName:(NSString *)name
{
    UILabel *label = [UILabel new];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:label];
    
    return label;
}

@end
