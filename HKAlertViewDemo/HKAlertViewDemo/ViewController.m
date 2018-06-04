//
//  ViewController.m
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#import "ViewController.h"
#import "HKAlertView.h"
#import "HKAlertModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HKAlertModel *model = HKObject(HKAlertModel).propertyNameSet(@"");

    [[HKAlertView alertViewWithTitle:@"我是标题" message:@"我是很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的消息" cancelButtonTitle:@"取消" clicked:^(NSInteger buttonIndex) {
        NSLog(@"----%ld----", buttonIndex);
    } otherButtonTitles:@"按钮1", @"按钮2", nil] show];
}

@end
