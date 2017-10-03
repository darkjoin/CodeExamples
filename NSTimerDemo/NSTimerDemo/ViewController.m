//
//  ViewController.m
//  NSTimerDemo
//
//  Created by darkgm on 02/10/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) NSInteger score;

// outlets
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *tapButton;

// actions
- (IBAction)tap:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)restart:(id)sender;

@end

@implementation ViewController

#pragma mark - Accessor Methods
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(subtractTime) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

- (CGFloat)time
{
    if (!_time) {
        _time = 10.0;
    }
    
    return _time;
}

- (NSInteger)score
{
    if (!_score) {
        _score = 0;
    }
    
    return _score;
}

#pragma mark - Help Method
- (void)subtractTime
{
    // 开始倒计时
    self.time = self.time - 0.1;
    self.timeLabel.text = [NSString stringWithFormat:@"TIME  %.1f", self.time];
    
    if (self.time < 0.1) {
        // 停止定时器
        [self.timer invalidate];
        self.timer = nil;
        
        // 创建警报器
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Time is up!" message:[NSString stringWithFormat:@"Your socre %li points", (long)self.score] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Play Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 重置标签文本
            self.time = 10.0;
            self.timeLabel.text = [NSString stringWithFormat:@"TIME  %.1f", self.time];
            
            self.score = 0;
            self.scoreLabel.text = [NSString stringWithFormat:@"SCORE  %li", (long)self.score];
            
            // 禁用点击按钮
            self.tapButton.enabled = NO;
        }];
        [alertController addAction:alertAction];
        
        // 显示警报视图
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

# pragma mark - Lifecycles
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标签的文本内容
    self.timeLabel.text = [NSString stringWithFormat:@"TIME  %.1f", self.time];
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE  %li", (long)self.score];
    
    // 禁用点击按钮
    self.tapButton.enabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)tap:(id)sender
{
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE  %li", (long)self.score];
}

- (IBAction)start:(id)sender
{
    // 启动定时器
    [self.timer fire];
    
    // 启用点击按钮
    self.tapButton.enabled = YES;
}

- (IBAction)stop:(id)sender
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
    
    // 点击按钮被禁用
    self.tapButton.enabled = NO;
}

- (IBAction)restart:(id)sender
{
    // 重置标签文本内容
    self.time = 10.0;
    self.timeLabel.text = [NSString stringWithFormat:@"TIME  %.1f", self.time];
    
    self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE  %li", (long)self.score];
    
    // 启动定时器
    [self.timer fire];
    
    // 启用点击按钮
    self.tapButton.enabled = YES;
}

@end
