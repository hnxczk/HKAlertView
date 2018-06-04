//
//  HKAlertView.h
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HKAlertViewClickedHandler)(NSInteger buttonIndex);
typedef BOOL(^HKAlertViewShouldDismissHandler)(NSInteger buttonIndex);

@interface HKAlertView : UIView

/**
 便捷构造一个或者没有其他按钮的方法
 
 @param title 标题
 @param message 提示文字
 @param cancelButtonTitle 取消按钮标题
 @param clickedHandler 按钮点击的回调，index == 0 代表取消按钮，其他按钮依次顺延
 @param otherButtonTitle 其他按钮标题
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                  otherButtonTitle:(nullable NSString *)otherButtonTitle
                           clicked:(nullable HKAlertViewClickedHandler)clickedHandler;

/**
 便捷构造多个其他按钮的方法
 
 @param title 标题
 @param message 提示文字
 @param cancelButtonTitle 取消按钮标题
 @param clickedHandler 按钮点击的回调，index == 0 代表取消按钮，其他按钮依次顺延
 @param otherButtonTitles 其他按钮标题，以逗号分隔，以nil结尾
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           clicked:(nullable HKAlertViewClickedHandler)clickedHandler
                 otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 根据 message 构造 alert
 
 @param title 标题
 @param message 提示文字
 @param cancelButtonTitle 取消按钮标题
 @param clickedHandler 按钮点击的回调，index == 0 代表取消按钮，其他按钮依次顺延
 @param shouldDismissHandler 判断点击按钮是否自动 dismiss 的回调
 @param otherButtonTitles 其他按钮标题数组
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                           clicked:(nullable HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(nullable HKAlertViewShouldDismissHandler)shouldDismissHandler;

/**
 根据 custonView 构造 alert
 
 @param title 标题
 @param customView 容器视图，需要设置其尺寸
 @param cancelButtonTitle 取消按钮标题
 @param clickedHandler 按钮点击的回调，index == 0 代表取消按钮，其他按钮依次顺延
 @param shouldDismissHandler 判断点击按钮是否自动 dismiss 的回调
 @param otherButtonTitles 其他按钮标题数组
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                        customView:(nullable UIView *)customView
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                           clicked:(nullable HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(nullable HKAlertViewShouldDismissHandler)shouldDismissHandler;


/**
 构造方法，message 和 customView 二选一
 
 @param title 标题
 @param message 提示文字
 @param customView 容器视图，需要设置其尺寸
 @param cancelButtonTitle 取消按钮标题
 @param clickedHandler 按钮点击的回调，index == 0 代表取消按钮，其他按钮依次顺延
 @param shouldDismissHandler 判断点击按钮是否自动 dismiss 的回调
 @param otherButtonTitles 其他按钮标题数组
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                        customView:(nullable UIView *)customView
                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                           clicked:(nullable HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(nullable HKAlertViewShouldDismissHandler)shouldDismissHandler;

- (void)show;
- (void)dismiss;

@end

