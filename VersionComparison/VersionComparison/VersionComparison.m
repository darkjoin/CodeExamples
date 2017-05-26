//
//  VersionComparison.m
//  VersionComparison
//
//  Created by darkgm on 11/03/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "VersionComparison.h"

#define LOWER @"v1 < v2"
#define HIGHER @"v1 > v2"
#define SAME @"v1 = v2"

@implementation VersionComparison

// 检查版本号是否有效
- (BOOL)checkVaildVersion:(NSString *)version
{
    // 检查版本号是否以'.'开头
    if (version.length == 0) {
        NSLog(@"请输入版本号");
        return NO;
    }
    
    // 检查版本号是否以'.'结尾
    if ([version hasPrefix:@"."] || [version hasSuffix:@"."]) {
        NSLog(@"请输入正确的版本号");
        return NO;
    }
    
    return YES;
}

// 分离版本号里的字符串
- (NSMutableArray *)separateVersion:(NSString *)version
{
    NSArray *array = [version componentsSeparatedByString:@"."];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    return mutableArray;
}


- (void)version1:(NSString *)version1 compare:(NSString *)version2
{
    // 去除版本号里的空格字符
    NSString *v1 = [version1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *v2 = [version2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 检查版本号是否有效
    BOOL version1Vaild = [self checkVaildVersion:v1];
    BOOL version2Vaild = [self checkVaildVersion:v2];
    
    if ((version1Vaild == NO) || (version2Vaild == NO)) {
        return;
    }
    
    // 判断两个版本是否一样
    if ([v1 isEqualToString:v2]) {
        NSLog(SAME);
    }
    else {
        // 根据'.'分离版本号里的字符串
        NSMutableArray *arr1 = [self separateVersion:v1];
        NSMutableArray *arr2 = [self separateVersion:v2];
        
        NSInteger m, j;
        m = arr1.count - arr2.count;
        // 如果被分离的版本号元素不一致，通过添加0补齐两个版本号元素
        if (m > 0) {
            j = arr1.count;
            for (int i = 0; i < m; ++i) {
                [arr2 addObject:@"0"];
            }
        }
        else if (m < 0) {
            j = arr2.count;
            for (int i = 0; i < -m; ++i) {
                [arr1 addObject:@"0"];
            }
        }
        
        // 通过比较被分离的版本号各字符串的长度区分版本号大小
        for (int i = 0; i < j; ++i) {
            if ([arr1[i] length] < [arr2[i] length]) {
                NSLog(LOWER);
                break;
            }
            else if ([arr1[i] length] > [arr2[i] length]) {
                NSLog(HIGHER);
                break;
            }
            // 如果被分离的字符串长度一致，就比较字符串的大小
            else if ([arr1[i] length] == [arr2[i] length]) {
                if ([arr1[i] compare:arr2[i]] == NSOrderedAscending) {
                    NSLog(LOWER);
                    break;
                }
                else if ([arr1[i] compare:arr2[i]] == NSOrderedDescending) {
                    NSLog(HIGHER);
                    break;
                }
                else if ([arr1[i] compare:arr2[i]] == NSOrderedSame) {
                    if (i == j - 1) {
                        NSLog(SAME);
                    }
                }
            }
        }
    }
}
@end
