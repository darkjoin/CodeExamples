//
//  ViewController.m
//  VersionComparison
//
//  Created by darkgm on 11/03/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"

#import "VersionComparison.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VersionComparison *versionComparison = [[VersionComparison alloc] init];
    
    [versionComparison version1:@"1.5.26" compare:@"    "];
    [versionComparison version1:@"1.5.26" compare:@" .1.5"];
    [versionComparison version1:@"1.5.26" compare:@"1.  5.26"];
    [versionComparison version1:@"1.5.26" compare:@"12.5.26"];
    [versionComparison version1:@"1.5.26" compare:@"1.5"];
    [versionComparison version1:@"1.5.26" compare:@"1.5.26.0"];
    [versionComparison version1:@"1.5.26" compare:@"1.5.26.3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
