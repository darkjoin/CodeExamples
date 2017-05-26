//
//  ViewController.m
//  UIBezierPathDemo
//
//  Created by darkgm on 23/05/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;      // 背景
@property (nonatomic, strong) UIImageView *fgImageView;      // 前景

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建背景imageView并添加到视图中
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 150, 300, 300)];
    [self.view addSubview:self.bgImageView];
    
    // 为背景imageView设置图片
    UIImage *bgImage = [UIImage imageNamed:@"bgImage"];
    self.bgImageView.image = [self clipImage:bgImage];
    
    // 创建前景imageView并添加到视图中
    self.fgImageView = [[UIImageView alloc] initWithFrame:self.bgImageView.frame];
    [self.view addSubview:self.fgImageView];
    
    // 为前景imageView设置图片
    UIImage *fgImage = [UIImage imageNamed:@"fgImage"];
    self.fgImageView.image = [self clipImage:fgImage];
}


// 裁剪图片
- (UIImage *)clipImage:(UIImage *)image
{
    // 开启一个与图像大小一致的图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 创建一个圆形的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 剪切圆形路径
    [path addClip];
    
    // 将图片绘制到图形上下文中
    [image drawAtPoint:CGPointZero];
    
    // 从当前图形上下文中获取被裁剪的图片
    UIImage *clippedImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 返回被裁剪的图片
    return clippedImage;
}

// 实现刮开涂层的效果
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    // 创建一个UITouch对象
    UITouch *touch = touches.anyObject;
    // 设置触摸位置在前景图片上的坐标
    CGPoint touchPoint = [touch locationInView:self.fgImageView];
    // 设置触摸时清除点的大小
    CGRect touchRect = CGRectMake(touchPoint.x, touchPoint.y, 20, 20);
    
    // 开启一个与前景图像大小一致的图形上下文
    UIGraphicsBeginImageContextWithOptions(self.fgImageView.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 将前景图像视图的图层渲染到当前上下文中
    [self.fgImageView.layer renderInContext:context];
    
    // 清除触摸过的区域
    CGContextClearRect(context, touchRect);
    
    // 从当前图形上下文中获取图片（即刮开的图片）
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 设置前景imageView的图片为刮开的图片
    self.fgImageView.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
