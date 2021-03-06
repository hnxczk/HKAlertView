//
//  HKAlertView.m
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#define k_MARGE (k_SCREEN_WIDTH > 360 ? 60 : 30 )  // alert 左右边距
#define k_MAX_HEIGHT 400 // 消息或者自定义视图的最大高度
#define k_TOP_HEIGHT 49 // title 的高度
#define k_BUTTON_HEIGHT 49 // 按钮的高度

#define k_MESSAGE_MARGE_VERTICAL 30 // 内容的竖直边距
#define k_MESSAGE_DETAIL_MARGE_VERTICAL 5 // 内容与detail的的竖直间距
#define k_MESSAGE_MARGE_HORIZONTAL 30  // 内容的水平边距
#define k_MESSAGE_FONT_SIZE 18  // 消息的字体大小
#define k_MESSAGE_DETAIL_FONT_SIZE 16  // 消息的字体大小

#define k_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define ALERT_HEXA_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#import "HKAlertView.h"
#import "HKAlertViewController.h"

@interface HKAlertView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSAttributedString *attributedMessage;
@property (nonatomic, copy) NSString *messageDetail;
@property (nonatomic, copy) NSAttributedString *attributedMessageDetail;

@property (nonatomic, copy) NSString *contentImage;

@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) HKAlertViewClickedHandler clickedHandler;
@property (nonatomic, copy) HKAlertViewShouldDismissHandler shouldDismissHandler;
@property (nonatomic, strong) NSArray<NSString *> *otherButtonTitles;

@property (nonatomic, strong) NSMutableArray<UIButton *> *allButtons;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIView *backDarkView;
@property (nonatomic, strong) UIView *centerBackView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *messageDetailLab;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSArray<UIButton *> *otherButtons;

@property (nonatomic, strong) UIWindow *window;

@end

@implementation HKAlertView

+ (instancetype)alertViewWithMessage:(NSString *)message
                       messageDetail:(NSString *)messageDetail
                        contentImage:(NSString *)contentImage
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                             clicked:(HKAlertViewClickedHandler)clickedHandler
{
    NSArray *otherBtnTitles = nil;
    if (otherButtonTitle.length) {
        otherBtnTitles = @[otherButtonTitle];
    }
    
    HKAlertView *alert = [[HKAlertView alloc] initWithTitle:nil contentImage:contentImage customView:nil message:message attributedMessage:nil messageDetail:messageDetail attributedMessageDetail:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherBtnTitles];
    
    alert.clickedHandler = clickedHandler;
    return alert;
}

+ (instancetype)alertViewWithAttributedMessage:(NSAttributedString *)attributedMessage
                       attributedMessageDetail:(NSAttributedString *)attributedMessageDetail
                                  contentImage:(NSString *)contentImage
                             cancelButtonTitle:(NSString *)cancelButtonTitle
                              otherButtonTitle:(NSString *)otherButtonTitle
                                       clicked:(HKAlertViewClickedHandler)clickedHandler
{
    NSArray *otherBtnTitles = nil;
    if (otherButtonTitle.length) {
        otherBtnTitles = @[otherButtonTitle];
    }
    
    HKAlertView *alert = [[HKAlertView alloc] initWithTitle:nil contentImage:contentImage customView:nil message:nil attributedMessage:attributedMessage messageDetail:nil attributedMessageDetail:attributedMessageDetail cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherBtnTitles];
    
    alert.clickedHandler = clickedHandler;
    return alert;
}

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
    return [self alertViewWithTitle:title message:message customView:customView contentImage:nil attributedMessage:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles clicked:clickedHandler shouldDismiss:shouldDismissHandler];
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                        customView:(UIView *)customView
                      contentImage:(NSString *)contentImage
                 attributedMessage:(NSAttributedString *)attributedMessage
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           clicked:(HKAlertViewClickedHandler)clickedHandler
                     shouldDismiss:(HKAlertViewShouldDismissHandler)shouldDismissHandler
{
    
    HKAlertView *alert = [[HKAlertView alloc] initWithTitle:title contentImage:contentImage customView:customView message:message attributedMessage:attributedMessage messageDetail:nil attributedMessageDetail:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    
    alert.clickedHandler = clickedHandler;
    alert.shouldDismissHandler = shouldDismissHandler;
    
    return alert;
}

- (instancetype)initWithTitle:(NSString *)title
                 contentImage:(NSString *)contentImage
                   customView:(UIView *)customView
                      message:(NSString *)message
            attributedMessage:(NSAttributedString *)attributedMessage
                messageDetail:(NSString *)messageDetail
      attributedMessageDetail:(NSAttributedString *)attributedMessageDetail
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    if (self = [super init]) {
        
        [self addSubview:self.backDarkView];
        [self addSubview:self.centerBackView];
        self.centerBackView.layer.cornerRadius = 10.0f;
        self.centerBackView.layer.masksToBounds = YES;
        
        if (title.length) {
            self.title = title;
            [self.centerBackView addSubview:self.titleLab];
        }
        
        [self.centerBackView addSubview:self.contentScrollView];
        
        if (contentImage) {
            self.contentImage = contentImage;
            [self.contentScrollView addSubview:self.contentImageView];
        }
        
        if (customView) {
            self.customView = customView;
            [self.contentScrollView addSubview:self.customView];
        } else {
            if (attributedMessage) {
                self.attributedMessage = attributedMessage;
            } else {
                self.message = message;
            }
            [self.contentScrollView addSubview:self.messageLab];
            if (attributedMessageDetail) {
                self.attributedMessageDetail = attributedMessageDetail;
            } else {
                self.messageDetail = messageDetail;
            }
            [self.contentScrollView addSubview:self.messageDetailLab];
        }
        
        self.otherButtonTitles = otherButtonTitles;
        for (UIButton *btn in self.otherButtons) {
            [self.bottomView addSubview:btn];
            [self.allButtons addObject:btn];
        }
        if (cancelButtonTitle) {
            [self.bottomView addSubview:self.cancleBtn];
            [self.allButtons addObject:self.cancleBtn];
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (cancelButtonTitle || self.otherButtons.count) {
            [self.centerBackView addSubview:self.bottomView];
        }
        
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
    
    if (self.contentImage) {
        UIImage *image = [UIImage imageNamed:self.contentImage];
        CGFloat w = image.size.width;
        CGFloat h = image.size.height;
        self.contentImageView.image = image;
        self.contentImageView.frame = CGRectMake((centerW - w) / 2 , k_MESSAGE_MARGE_VERTICAL, w, h);
        contentH += (h + k_MESSAGE_MARGE_VERTICAL);
    }
    
    if (self.customView) {
        CGFloat customW = self.customView.frame.size.width;
        CGFloat customH = self.customView.frame.size.height;
        self.customView.frame = CGRectMake((centerW - customW) / 2, k_MESSAGE_MARGE_VERTICAL + contentH, customW, customH);
        contentH += (customH + k_MESSAGE_MARGE_VERTICAL);
    } else {
        CGSize messageSize = [self messageTextSize];
        self.messageLab.frame = CGRectMake(k_MESSAGE_MARGE_HORIZONTAL, k_MESSAGE_MARGE_VERTICAL + contentH, centerW - 2 * k_MESSAGE_MARGE_HORIZONTAL, messageSize.height);
        if (messageSize.height) {
            contentH += (messageSize.height + k_MESSAGE_MARGE_VERTICAL);
        }
        
        CGSize messageDetailSize = [self messageDetailTextSize];
        self.messageDetailLab.frame = CGRectMake(k_MESSAGE_MARGE_HORIZONTAL, k_MESSAGE_DETAIL_MARGE_VERTICAL + contentH, centerW - 2 * k_MESSAGE_MARGE_HORIZONTAL, messageDetailSize.height);
        if (messageDetailSize.height) {
            contentH += (messageDetailSize.height + k_MESSAGE_DETAIL_MARGE_VERTICAL);
        }
    }
    
    self.contentScrollView.frame = CGRectMake(0, titleH, centerW, (contentH > k_MAX_HEIGHT ? k_MAX_HEIGHT : contentH) + k_MESSAGE_MARGE_VERTICAL);
    self.contentScrollView.contentSize = CGSizeMake(centerW, contentH + k_MESSAGE_MARGE_VERTICAL);
    

    switch (self.allButtons.count) {
        case 0:
        {
            break;
        }
        case 1:
        {
            UIButton *btn = [self.allButtons firstObject];
            btn.frame = CGRectMake(0, 0, centerW, k_BUTTON_HEIGHT);
            break;
        }
        case 2:
        {
            UIButton *btnLeft = [self.allButtons firstObject];
            CGFloat btnW = centerW / 2;
            btnLeft.frame = CGRectMake(0, 0, btnW, k_BUTTON_HEIGHT);

            UIButton *btnRight = [self.allButtons lastObject];
            btnRight.frame = CGRectMake(btnW, 0, btnW, k_BUTTON_HEIGHT);
            break;
        }
        default:
        {
            [self.otherButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull otherBtn, NSUInteger idx, BOOL * _Nonnull stop) {
                otherBtn.frame = CGRectMake(0, idx * k_BUTTON_HEIGHT, centerW, k_BUTTON_HEIGHT);
            }];
            break;
        }
    }
    
    CGFloat bottomH = 0;
    if (self.allButtons.count) {
        UIButton *btn = [self.allButtons lastObject];
        bottomH = CGRectGetMaxY(btn.frame);
    }
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
    } completion:^(BOOL finished) {
        if (!(self.cancelButtonTitle.length + self.otherButtonTitles.count)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }
    }];
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
    if (self.attributedMessage) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_SCREEN_WIDTH - 2 * k_MARGE - 2 * k_MESSAGE_MARGE_HORIZONTAL, MAXFLOAT)];
        tempLabel.attributedText = self.attributedMessage;
        tempLabel.numberOfLines = 0;
        [tempLabel sizeToFit];
        return tempLabel.frame.size;
    } else if (self.message) {
        CGSize size = CGSizeMake(k_SCREEN_WIDTH - 2 * k_MARGE - 2 * k_MESSAGE_MARGE_HORIZONTAL, MAXFLOAT);
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:k_MESSAGE_FONT_SIZE]};
        return [self.message boundingRectWithSize:size options:opts attributes:attrs context:nil].size;
    }
    return CGSizeZero;
}

- (CGSize)messageDetailTextSize
{
    if (self.attributedMessageDetail) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_SCREEN_WIDTH - 2 * k_MARGE - 2 * k_MESSAGE_MARGE_HORIZONTAL, MAXFLOAT)];
        tempLabel.attributedText = self.attributedMessageDetail;
        tempLabel.numberOfLines = 0;
        [tempLabel sizeToFit];
        return tempLabel.frame.size;
    } else if (self.messageDetail) {
        CGSize size = CGSizeMake(k_SCREEN_WIDTH - 2 * k_MARGE - 2 * k_MESSAGE_MARGE_HORIZONTAL, MAXFLOAT);
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:k_MESSAGE_DETAIL_FONT_SIZE]};
        return [self.messageDetail boundingRectWithSize:size options:opts attributes:attrs context:nil].size;
    }
    return CGSizeZero;
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

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage
{
    _attributedMessage = attributedMessage;
    self.messageLab.attributedText = attributedMessage;
}

- (void)setMessageDetail:(NSString *)messageDetail
{
    _messageDetail = messageDetail;
    self.messageDetailLab.text = messageDetail;
}

- (void)setAttributedMessageDetail:(NSAttributedString *)attributedMessageDetail
{
    _attributedMessageDetail = attributedMessageDetail;
    self.messageDetailLab.attributedText = attributedMessageDetail;
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

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
    }
    return _contentImageView;
}

- (UILabel *)messageLab
{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.font = [UIFont systemFontOfSize:k_MESSAGE_FONT_SIZE];
        _messageLab.textColor = ALERT_HEXA_COLOR(0x333333);
        _messageLab.numberOfLines = 0;
    }
    return _messageLab;
}

- (UILabel *)messageDetailLab
{
    if (!_messageDetailLab) {
        _messageDetailLab = [[UILabel alloc] init];
        _messageDetailLab.textAlignment = NSTextAlignmentCenter;
        _messageDetailLab.font = [UIFont systemFontOfSize:k_MESSAGE_DETAIL_FONT_SIZE];
        _messageDetailLab.textColor = ALERT_HEXA_COLOR(0x999999);
        _messageDetailLab.numberOfLines = 0;
    }
    return _messageDetailLab;
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
        _cancleBtn.layer.borderColor = ALERT_HEXA_COLOR(0xF2F4F5).CGColor;
        _cancleBtn.layer.borderWidth = 0.5f;
        [_cancleBtn setTitleColor:ALERT_HEXA_COLOR(0x2AA9FF) forState:UIControlStateNormal];
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
            btn.layer.borderColor = ALERT_HEXA_COLOR(0xF2F4F5).CGColor;
            btn.layer.borderWidth = 0.5f;
            [btn setTitleColor:ALERT_HEXA_COLOR(0x999999) forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(otherBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [array addObject:btn];
        }];
        _otherButtons = array;
    }
    return _otherButtons;
}

- (NSMutableArray<UIButton *> *)allButtons
{
    if (!_allButtons) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}

@end

