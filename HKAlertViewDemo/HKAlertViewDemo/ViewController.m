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
   
    [[HKAlertView alertViewWithMessage:@"考试即将开始" messageDetail:@"距离【机考大赛名称】开考不足10分钟，请做好准备，进入考场。" contentImage:@"start" cancelButtonTitle:@"进入考场" otherButtonTitle:@"稍后再进" clicked:^(NSInteger buttonIndex) {
        
    }] show];
    
}

@end
