//
//  SecondViewController.h
//  BlockDemo
//
//  Created by darkgm on 11/07/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

// 声明一个block属性
@property (nonatomic, copy) void(^showTheColor)(UIColor *);

@end
