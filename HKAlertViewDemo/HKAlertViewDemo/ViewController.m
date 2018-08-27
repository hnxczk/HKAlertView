//
//  ViewController.m
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#import "ViewController.h"
#import "HKAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[HKAlertView alertViewWithTitle:nil message:@"我是很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的消息" cancelButtonTitle:nil clicked:^(NSInteger buttonIndex) {
        NSLog(@"----%ld----", buttonIndex);
    } otherButtonTitles:nil] show];
}

@end
