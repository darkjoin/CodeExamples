//
//  TableViewController.m
//  MemoryManagementDemo
//
//  Created by darkgm on 26/07/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

//@synthesize titles = _titles;
//@synthesize lastTitleSelected = _lastTitleSelected;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *string = [_titles objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"Title: %@", string];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建消息
    NSString *string = [_titles objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"Title: %@", string];
    NSString *message = [NSString stringWithFormat:@"Last title: %@. Current title: %@", _lastTitleSelected, title];
    
    // 创建警报视图以显示弹出的消息
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hint" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    // 设置实例变量
    self.lastTitleSelected = title;
}


@end
