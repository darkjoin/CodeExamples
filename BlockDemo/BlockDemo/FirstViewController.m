//
//  FirstViewController.m
//  BlockDemo
//
//  Created by darkgm on 11/07/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"id"]) {
        SecondViewController *svc = (SecondViewController *)segue.destinationViewController;
        // 定义SecondViewController中的block属性
        svc.showTheColor = ^(UIColor *color){
            self.view.backgroundColor = color;
        };
    }
}


@end
