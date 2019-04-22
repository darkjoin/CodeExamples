//
//  ExampleListViewController.m
//  MasonryExamples
//
//  Created by amber on 2018/12/17.
//  Copyright © 2018年 amber. All rights reserved.
//

#import "ExampleListViewController.h"
#import "ExampleViewController.h"
#import "ExampleLayoutGuideViewController.h"
#import "ExampleSafeAreaLayoutGuideViewController.h"

#import "ExampleBasicView.h"
#import "ExampleConstantsView.h"
#import "ExampleSidesView.h"
#import "ExampleAspectFitView.h"
#import "ExampleAnimatedView.h"
#import "ExampleDebuggingView.h"
#import "ExampleLabelView.h"
#import "ExampleUpdateView.h"
#import "ExampleRemakeView.h"
#import "ExampleScrollView.h"
#import "ExampleArrayView.h"
#import "ExampleAttributeChainingView.h"
#import "ExampleMarginView.h"
#import "ExampleDistributeView.h"

static NSString *const kCellReuseIdentifier = @"kCellReuseIdentifier";

@interface ExampleListViewController ()

@property (nonatomic, strong) NSArray *exampleControllers;

@end

@implementation ExampleListViewController

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = @"Examples";
    
    self.exampleControllers = @[
        [[ExampleViewController alloc] initWithTitle:@"Basic" viewClass:ExampleBasicView.class],
        [[ExampleViewController alloc] initWithTitle:@"Update Constraints" viewClass:ExampleUpdateView.class],
        [[ExampleViewController alloc] initWithTitle:@"Remake Constraints" viewClass:ExampleRemakeView.class],
        [[ExampleViewController alloc] initWithTitle:@"Using Constants" viewClass:ExampleConstantsView.class],
        [[ExampleViewController alloc] initWithTitle:@"Composite Edges" viewClass:ExampleSidesView.class],
        [[ExampleViewController alloc] initWithTitle:@"Aspect Fit" viewClass:ExampleAspectFitView.class],
        [[ExampleViewController alloc] initWithTitle:@"Basic Animated" viewClass:ExampleAnimatedView.class],
        [[ExampleViewController alloc] initWithTitle:@"Debugging Helpers" viewClass:ExampleDebuggingView.class],
        [[ExampleViewController alloc] initWithTitle:@"Bacony Labels" viewClass:ExampleLabelView.class],
        [[ExampleViewController alloc] initWithTitle:@"UIScrollView" viewClass:ExampleScrollView.class],
        [[ExampleViewController alloc] initWithTitle:@"Array" viewClass:ExampleArrayView.class],
        [[ExampleViewController alloc] initWithTitle:@"Attribute Chaining" viewClass:ExampleAttributeChainingView.class],
        [[ExampleViewController alloc] initWithTitle:@"Margins" viewClass:ExampleMarginView.class],
        [[ExampleViewController alloc] initWithTitle:@"Views Distribute" viewClass:ExampleDistributeView.class]
        ];
    
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)]) {
        self.exampleControllers = [self.exampleControllers arrayByAddingObject:[[ExampleLayoutGuideViewController alloc] init]];
    }
    
    if ([UIView instancesRespondToSelector:@selector(safeAreaLayoutGuide)]) {
        self.exampleControllers = [self.exampleControllers arrayByAddingObject:[[ExampleSafeAreaLayoutGuideViewController alloc] init]];
    }
    
    return self;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kCellReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exampleControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.exampleControllers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier    forIndexPath:indexPath];
    cell.textLabel.text = viewController.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.exampleControllers[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
