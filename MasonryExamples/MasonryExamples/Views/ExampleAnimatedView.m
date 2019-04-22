//
//  ExampleAnimatedView.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleAnimatedView.h"

@interface ExampleAnimatedView ()

@property (nonatomic, strong) NSMutableArray *animatableConstraints;
@property (nonatomic, assign) int padding;
@property (nonatomic, assign) BOOL animating;

@end

@implementation ExampleAnimatedView

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
    int padding = self.padding = 10;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);
    
    self.animatableConstraints = NSMutableArray.new;
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
              make.edges.equalTo(superView).insets(paddingInsets).priorityLow(),
              make.bottom.equalTo(blueView.mas_top).offset(-padding),]];
        
        make.size.equalTo(redView);
        make.height.equalTo(blueView.mas_height);
    }];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
              make.edges.equalTo(superView).insets(paddingInsets).priorityLow(),
              make.left.equalTo(greenView.mas_right).offset(padding),
              make.bottom.equalTo(blueView.mas_top).offset(-padding),]];
        
        make.size.equalTo(greenView);
        make.height.equalTo(blueView.mas_height);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
              make.edges.equalTo(superView).insets(paddingInsets).priorityLow(),
                                                          ]];
        
        make.height.equalTo(greenView.mas_height);
        make.height.equalTo(redView.mas_height);
    }];
    
    return self;
}

- (void)didMoveToWindow
{
    [self layoutIfNeeded];
    
    if (self.window) {
        self.animating = YES;
        [self animateWithInvertedInsets:NO];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    self.animating = newWindow != nil;
}

- (void)animateWithInvertedInsets:(BOOL)invertedInsets
{
    if(!self.animating) return;
    
    int padding = invertedInsets ? 100 : self.padding;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    for (MASConstraint *constraint in self.animatableConstraints) {
        constraint.insets = paddingInsets;
    }
    
    [UIView animateWithDuration:1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        // repeat!
        [self animateWithInvertedInsets:!invertedInsets];
    }];
}

@end
