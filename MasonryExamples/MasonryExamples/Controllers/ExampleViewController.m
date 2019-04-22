//
//  ExampleViewController.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleViewController.h"
#import "ExampleBasicView.h"

@interface ExampleViewController ()

@property (nonatomic, strong) Class viewClass;

@end

@implementation ExampleViewController

- (instancetype)initWithTitle:(NSString *)title viewClass:(Class)viewClass
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = title;
    self.viewClass = viewClass;
    
    return self;
}

- (void)loadView
{
    self.view = self.viewClass.new;
    self.view.backgroundColor = [UIColor whiteColor];
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
