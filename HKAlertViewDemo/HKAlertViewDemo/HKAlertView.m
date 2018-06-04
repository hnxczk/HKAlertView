//
//  HKAlertView.m
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#define k_MARGE 50  // alert 左右边距
#define k_MAX_HEIGHT 400 // 消息或者自定义视图的最大高度
#define k_TOP_HEIGHT 49 // title 的高度
#define k_BUTTON_HEIGHT 49 // 按钮的高度

#define k_MESSAGE_MARGE_VERTICAL 20 // 内容的竖直边距
#define k_MESSAGE_MARGE_HORIZONTAL 10  // 内容的水平边距
#define k_MESSAGE_FONT_SIZE 16  // 消息的字体大小

#define k_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define ALERT_HEXA_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#import "HKAlertView.h"
#import "HKAlertViewController.h"

@interface HKAlertView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) HKAlertViewClickedHandler clickedHandler;
@property (nonatomic, copy) HKAlertViewShouldDismissHandler shouldDismissHandler;
@property (nonatomic, strong) NSArray<NSString *> *otherButtonTitles;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIView *backDarkView;
@property (nonatomic, strong) UIView *centerBackView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *messageLab;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSArray<UIButton *> *otherButtons;

@property (nonatomic, strong) UIWindow *window;

@end

@implementation HKAlertView

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitle:(NSString *)otherButtonTitle
                           clicked:(HKAlertViewClickedHandler)clickedHandler
{
    NSArray *otherBtnTitles = nil;
    if (otherButtonTitle.length) {
        otherBtnTitles = @[otherButtonTitle];
    }
    return [self alertViewWithTitle:title message:message customView:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherBtnTitles clicked:clickedHandler shouldDismiss:nil ];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                           clicked:(HKAlertViewClickedHandler)clickedHandler
                 otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    
    return [self alertViewWithTitle:title message:message customView:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:tempOtherButtonTitles clicked:clickedHandler shouldDismiss:nil];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                        customView:(UIView *)customView
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           clicked:(HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(HKAlertViewShouldDismissHandler)shouldDismissHandler
{
    return [self alertViewWithTitle:title message:nil customView:customView cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles clicked:clickedHandler shouldDismiss:shouldDismissHandler];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           clicked:(HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(HKAlertViewShouldDismissHandler)shouldDismissHandler
{
    return [self alertViewWithTitle:title message:message customView:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles clicked:clickedHandler shouldDismiss:shouldDismissHandler];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                        customView:(UIView *)customView
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           clicked:(HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(HKAlertViewShouldDismissHandler)shouldDismissHandler
{
    
    HKAlertView *alert = [[HKAlertView alloc] initWithTitle:title message:message customView:customView otherButtonTitles:otherButtonTitles];
    
    alert.cancelButtonTitle = cancelButtonTitle;
    alert.clickedHandler = clickedHandler;
    alert.shouldDismissHandler = shouldDismissHandler;
    
    return alert;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message customView:(UIView *)customView otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    if (self = [super init]) {
        
        [self addSubview:self.backDarkView];
        [self addSubview:self.centerBackView];
        self.centerBackView.layer.cornerRadius = 5.0f;
        self.centerBackView.layer.masksToBounds = YES;
        
        if (title.length) {
            self.title = title;
            [self.centerBackView addSubview:self.titleLab];
        }
        
        [self.centerBackView addSubview:self.contentScrollView];
        if (customView) {
            self.customView = customView;
            [self.contentScrollView addSubview:self.customView];
        } else {
            self.message = message;
            [self.contentScrollView addSubview:self.messageLab];
        }
        
        [self.centerBackView addSubview:self.bottomView];
        self.otherButtonTitles = otherButtonTitles;
        for (UIButton *btn in self.otherButtons) {
            [self.bottomView addSubview:btn];
        }
        [self.bottomView addSubview:self.cancleBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backDarkView.frame = self.bounds;
    
    CGFloat centerW = k_SCREEN_WIDTH - 2 * k_MARGE;
    CGFloat titleH = 10;
    if (self.title.length) {
        self.titleLab.frame = CGRectMake(0, 0, centerW, k_TOP_HEIGHT);
        titleH = k_TOP_HEIGHT;
    }
    
    CGFloat contentH = 0;
    if (self.customView) {
        CGFloat customW = self.customView.frame.size.width;
        CGFloat customH = self.customView.frame.size.height;
        self.customView.frame = CGRectMake((centerW - customW) / 2, k_MESSAGE_MARGE_VERTICAL, customW, customH);
        contentH = customH;
    } else {
        CGSize messageSize = [self messageTextSize];
        contentH = messageSize.height;
        self.messageLab.frame = CGRectMake(k_MESSAGE_MARGE_HORIZONTAL, k_MESSAGE_MARGE_VERTICAL, centerW - 2 * k_MESSAGE_MARGE_HORIZONTAL, messageSize.height);
    }
    self.contentScrollView.frame = CGRectMake(0, titleH, centerW, (contentH > k_MAX_HEIGHT ? k_MAX_HEIGHT : contentH) + 2 * k_MESSAGE_MARGE_VERTICAL);
    self.contentScrollView.contentSize = CGSizeMake(centerW, contentH + 2 * k_MESSAGE_MARGE_VERTICAL);
    
    NSInteger otherBtnCount = self.otherButtonTitles.count;
    // 只有一个取消按钮
    if (otherBtnCount == 0) {
        self.cancleBtn.frame = CGRectMake(0, 0, centerW, k_BUTTON_HEIGHT);
    } else if (otherBtnCount == 1) { // 有一个其他按钮
        CGFloat btnW = centerW / 2;
        UIButton *otherBtn = [self.otherButtons firstObject];
        otherBtn.frame = CGRectMake(0, 0, btnW, k_BUTTON_HEIGHT);
        self.cancleBtn.frame = CGRectMake(btnW, 0, btnW, k_BUTTON_HEIGHT);
    } else { // 有大于两个的其他按钮
        [self.otherButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull otherBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            otherBtn.frame = CGRectMake(0, idx * k_BUTTON_HEIGHT, centerW, k_BUTTON_HEIGHT);
        }];
        self.cancleBtn.frame = CGRectMake(0, otherBtnCount * k_BUTTON_HEIGHT, centerW, k_BUTTON_HEIGHT);
    }
    CGFloat bottomH = CGRectGetMaxY(self.cancleBtn.frame);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentScrollView.frame), centerW, bottomH);
    
    self.centerBackView.frame = CGRectMake(0, 0, centerW, CGRectGetMaxY(self.bottomView.frame));
    self.centerBackView.center = self.center;
}

- (void)show
{
    HKAlertViewController *viewController = [[HKAlertViewController alloc] init];
    viewController.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    viewController.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([UIDevice currentDevice].systemVersion.intValue == 9) { // Fix bug for keyboard in iOS 9
        window.windowLevel = CGFLOAT_MAX;
    } else {
        window.windowLevel = UIWindowLevelAlert;
    }
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    self.window = window;
    
    [viewController.view addSubview:self];
    self.frame = window.bounds;
    
    [self.window layoutIfNeeded];
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backDarkView.alpha = 0.3f;
    } completion:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backDarkView.alpha = 0;
        self.centerBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        self.window = nil;
        if (self.clickedHandler) {
            self.clickedHandler(self.selectedIndex);
        }
    }];
}

- (void)cancleBtnClickAction
{
    [self dealBtnClickWithIndex:0];
}

- (void)otherBtnClickAction:(UIButton *)btn
{
    [self dealBtnClickWithIndex:btn.tag];
}

- (void)dealBtnClickWithIndex:(NSInteger)index
{
    BOOL shouldDismiss = YES;
    if (self.shouldDismissHandler) {
        shouldDismiss = self.shouldDismissHandler(index);
    }
    if (shouldDismiss) {
        [self dismiss];
    }
    self.selectedIndex = index;
}

- (CGSize)messageTextSize
{
    CGSize size = CGSizeMake(k_SCREEN_WIDTH - 2 * k_MARGE - 2 * k_MESSAGE_MARGE_HORIZONTAL, MAXFLOAT);
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:k_MESSAGE_FONT_SIZE]};
    
    CGSize textSize =
    [self.message boundingRectWithSize:size
                               options:opts
                            attributes:attrs
                               context:nil].size;
    if (self.messageLab.numberOfLines != 0) {
        textSize.height = MIN(textSize.height, [UIFont systemFontOfSize:k_MESSAGE_FONT_SIZE].lineHeight * self.messageLab.numberOfLines);
    }
    return textSize;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle
{
    _cancelButtonTitle = cancelButtonTitle;
    [self.cancleBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.messageLab.text = message;
}

#pragma mark - getter
- (UIView *)backDarkView
{
    if (!_backDarkView) {
        _backDarkView = [[UIView alloc] init];
        _backDarkView.alpha = 0;
        _backDarkView.backgroundColor = ALERT_HEXA_COLOR(0x464950);
        _backDarkView.userInteractionEnabled = NO;
    }
    return _backDarkView;
}

- (UIView *)centerBackView
{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] init];
        _centerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _centerBackView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.backgroundColor = ALERT_HEXA_COLOR(0x3b78f4);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (UILabel *)messageLab
{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.font = [UIFont systemFontOfSize:k_MESSAGE_FONT_SIZE];
        _messageLab.textColor = ALERT_HEXA_COLOR(0x354156);
        _messageLab.numberOfLines = 0;
    }
    return _messageLab;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _cancleBtn.layer.borderColor = ALERT_HEXA_COLOR(0xeeeeee).CGColor;
        _cancleBtn.layer.borderWidth = 0.5f;
        [_cancleBtn setTitleColor:ALERT_HEXA_COLOR(0x3b78f4) forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (NSArray<UIButton *> *)otherButtons
{
    if (!_otherButtons) {
        NSMutableArray *array = [NSMutableArray array];
        [self.otherButtonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = idx + 1;
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            btn.layer.borderColor = ALERT_HEXA_COLOR(0xeeeeee).CGColor;
            btn.layer.borderWidth = 0.5f;
            [btn setTitleColor:ALERT_HEXA_COLOR(0x666666) forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(otherBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [array addObject:btn];
        }];
        _otherButtons = array;
    }
    return _otherButtons;
}

@end

