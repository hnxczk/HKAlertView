//
//  HKAlertContentView.m
//  HKAlertViewDemo
//
//  Created by zhouke on 2018/8/27.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#import "HKAlertContentView.h"

@interface HKAlertContentView()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end

@implementation HKAlertContentView

- (void)reloadFrameWithImage:(NSString *)image contentAttributeString:(NSAttributedString *)contentAttributeString
{
    UIImage *img = [UIImage imageNamed:image];
    self.imageW.constant = img.size.width;
    self.imageH.constant = img.size.height;
    self.contentImageView.image = img;
    
    self.contentLable.attributedText = contentAttributeString;
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentLable.frame.size.width, CGFLOAT_MAX)];
    tempLabel.attributedText = contentAttributeString;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.imageH.constant + size.height + 20 + 20 + 20);
}

@end
