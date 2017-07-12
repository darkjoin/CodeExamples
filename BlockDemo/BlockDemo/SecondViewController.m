//
//  SecondViewController.m
//  BlockDemo
//
//  Created by darkgm on 11/07/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *red;
@property (weak, nonatomic) IBOutlet UISlider *green;
@property (weak, nonatomic) IBOutlet UISlider *blue;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.showTheColor) {
        // 调用block属性
        self.showTheColor(self.label.backgroundColor);
    }
}

- (IBAction)changeColor:(UISlider *)sender
{
    if (sender == self.red) {
        self.red.value = sender.value;
    }
    else if (sender == self.green) {
        self.green.value = sender.value;
    }
    else if (sender == self.blue) {
        self.blue.value = sender.value;
    }
    
    UIColor *color = [UIColor colorWithRed:self.red.value/255.0 green:self.green.value/255.0 blue:self.blue.value/255.0 alpha:1.0];
    self.label.backgroundColor = color;
}

@end
