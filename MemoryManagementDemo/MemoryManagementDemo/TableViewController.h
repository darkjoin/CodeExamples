//
//  TableViewController.h
//  MemoryManagementDemo
//
//  Created by darkgm on 26/07/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *lastTitleSelected;

@end
