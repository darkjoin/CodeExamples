//
//  FirstViewController.m
//  ViewControllerLifecycleDemo
//
//  Created by darkgm on 16/09/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (instancetype)init
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    self = [super init];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    self = [super initWithCoder:aDecoder];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super awakeFromNib];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)loadView
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super loadView];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewDidLoad
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewDidLoad];
    
//    [self setup];   // add Present/Push to Next button
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewWillAppear:animated];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewDidAppear:animated];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewWillDisappear:animated];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewDidDisappear:animated];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewWillLayoutSubviews];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super viewDidLayoutSubviews];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
    [super didReceiveMemoryWarning];
    NSLog(@"%s, %i", __PRETTY_FUNCTION__, __LINE__);
}

- (void)setup
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 200, 70);
    button.center = self.view.center;
    [button setTitle:@"Present to Next" forState:UIControlStateNormal]; // present
//    [button setTitle:@"Push to Next" forState:UIControlStateNormal];    // push
    button.titleLabel.font = [UIFont systemFontOfSize:30.0];
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)next
{
    [self presentViewController:[[SecondViewController alloc] init] animated:YES completion:nil]; // present

//    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES]; // push with animated
    
//    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:NO]; // push without animated
}

@end
