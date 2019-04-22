//
//  ExampleRemakeView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleRemakeView.h"

@interface ExampleRemakeView ()

@property (nonatomic, strong) UIButton *movingButton;
@property (nonatomic, assign) BOOL topLeft;

- (void)toggleButtonPosition;

@end

@implementation ExampleRemakeView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    self.movingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.movingButton setTitle:@"Move Me!" forState:UIControlStateNormal];
    self.movingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.movingButton.layer.borderWidth = 3;
    
    [self.movingButton addTarget:self action:@selector(toggleButtonPosition) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.movingButton];
    
    self.topLeft = YES;
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updateing constraints
- (void)updateConstraints
{
    [self.movingButton remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        
        if (self.topLeft) {
            make.left.equalTo(self.left).with.offset(10);
            make.top.equalTo(self.top).with.offset(10);
        }
        else {
            make.bottom.equalTo(self.bottom).with.offset(-10);
            make.right.equalTo(self.right).with.offset(-10);
        }
    }];
    
    // according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)toggleButtonPosition
{
    self.topLeft = !self.topLeft;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
