//
//  ExampleUpdateView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleUpdateView.h"

@interface ExampleUpdateView ()

@property (nonatomic, strong) UIButton *growingButton;
@property (nonatomic, assign) CGSize buttonSize;

@end

@implementation ExampleUpdateView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    self.growingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.growingButton setTitle:@"Grow Me!" forState:UIControlStateNormal];
    self.growingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.growingButton.layer.borderWidth = 3;
    
    [self.growingButton addTarget:self action:@selector(didTapGrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.growingButton];
    
    self.buttonSize = CGSizeMake(100, 100);
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// This is Apple's recommended place for adding/updating constraints
- (void)updateConstraints
{
    [self.growingButton updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//        make.width.equalTo(@(self.buttonSize.width)).priorityLow();
//        make.height.equalTo(@(self.buttonSize.height)).priorityLow();
        make.width.equalTo(@(self.buttonSize.width));
        make.height.equalTo(@(self.buttonSize.height));
        make.width.lessThanOrEqualTo(self);
        make.height.lessThanOrEqualTo(self);
    }];
    
    // according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)didTapGrowButton:(UIButton *)button
{
    self.buttonSize = CGSizeMake(self.buttonSize.width * 1.3, self.buttonSize.height * 1.3);
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
