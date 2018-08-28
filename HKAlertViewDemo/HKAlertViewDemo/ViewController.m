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
    NSString *string = @"考试即将开始\n距离【机考大赛名称名称】开考 不足10分钟，请做好准备，进入考场。";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, string.length)];
    
    NSRange range = [string rangeOfString:@"考试即将开始"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];

    [[HKAlertView alertViewWithTitle:nil message:@"考试即将开始" customView:nil contentImage:@"start" attributedMessage:str cancelButtonTitle:@"进入考场" otherButtonTitles:@[@"稍后进入"] clicked:^(NSInteger buttonIndex) {
        
    } shouldDismiss:nil] show];
}

@end
