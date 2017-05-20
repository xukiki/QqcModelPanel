//
//  QqcModelPanel.m
//  QqcWidgetsFramework
//
//  Created by qiuqinchuan on 15/12/4.
//  Copyright © 2015年 Qqc. All rights reserved.
//
//#import <GPUImage/GPUImage.h>
#import "QqcModelPanel.h"
#import "UIView+Qqc.h"
#import "QqcSizeDef.h"

static QqcModelPanel* _instance;

#define xScreenCenter [UIScreen mainScreen].bounds.size.width/2
#define yScreenCenter  [UIScreen mainScreen].bounds.size.height/2

@interface QqcModelPanel()

@property(nonatomic, assign)QqcModelAnimationType animationType;

@property(nonatomic, strong)UIView* view2show;

@property(nonatomic, strong)UIImageView* bgImageView;

@property(nonatomic, assign)CGFloat bgAlpha;

@property(nonatomic, assign)BOOL bIsOnCenter;

@property(nonatomic, strong)UIWindow* myWindow;

@end

@implementation QqcModelPanel

//- (void)dealloc
//{
//    NSLog(@"QqcModelPanel 释放");
//    _view2show = nil;
//}

+ (instancetype)shareQqcModelPanel
{
    if (_instance == nil)
    {
        _instance = [[self alloc] init];
        _instance.frame = [UIScreen mainScreen].bounds;
    }
    return _instance; 
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (UIImageView *)bgImageView
{
    if (nil == _bgImageView)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
    }
    
    return _bgImageView;
}

- (UIWindow *)myWindow
{
    if (nil == _myWindow) {
        _myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _myWindow.windowLevel = UIWindowLevelNormal+1;
        
        NSLog(@"当前类= %@ 创建Window = %@\n",self, _myWindow);
    }
    
    
    return _myWindow;
}

#pragma mark - 外部接口
+ (void)showModelAppendView:(UIView*)view2show animationType:(QqcModelAnimationType)animationType bgAlpha:(CGFloat)alpha isOnCenter:(BOOL)bIsOnCenter
{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    QqcModelPanel* panel = [QqcModelPanel shareQqcModelPanel];
    panel.animationType = animationType;
    panel.view2show = view2show;
    panel.bgAlpha = alpha;
    panel.bIsOnCenter = bIsOnCenter;

    [panel addBgImageView];
    [panel addSubview:view2show];
    [panel adjustPropertyOfViewByAnimationType];
    [panel doShowAnimation];
    [panel doModel];
}

+ (void)closeModelView
{
    QqcModelPanel* panel = [QqcModelPanel shareQqcModelPanel];
    [panel close];
}

#pragma mark - 内部函数
- (void)addBgImageView
{
    [self.bgImageView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:_bgAlpha]];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.bgImageView addGestureRecognizer:tapGesture];
}

-(void)onTap:(UITapGestureRecognizer*)recognizer
{
    if (self.onTapOnBgBlock) {
        self.onTapOnBgBlock();
    }
}  

- (UIImage *)convertViewToImage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}

- (void)adjustPropertyOfViewByAnimationType
{
    if (QqcModelAnimationTypeNone == self.animationType || QqcModelAnimationTypeFade == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter, yScreenCenter);
        }
    }
    else if (QqcModelAnimationTypeScaleBig2Small == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter, yScreenCenter);
        }
        self.view2show.layer.transform = CATransform3DMakeScale(1.66, 1.66, 1);
    }
    else if (QqcModelAnimationTypeScaleSmall2Big == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter, yScreenCenter);
        }
        self.view2show.layer.transform = CATransform3DMakeScale(0.33, 0.33, 1);
    }
    else if (QqcModelAnimationTypeFromUp == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter, -yScreenCenter);
        }else{
            self.view2show.frame = CGRectMake(self.view2show.left, self.view2show.top-height_screen_qqc, self.view2show.width, self.view2show.height);
        }
    }
    else if (QqcModelAnimationTypeFromBottom == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter, yScreenCenter*3);
        }else{
            self.view2show.frame = CGRectMake(self.view2show.left, self.view2show.top+height_screen_qqc, self.view2show.width, self.view2show.height);
        }
    }
    else if (QqcModelAnimationTypeFromLeft == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(-xScreenCenter, yScreenCenter);
        }else{
            self.view2show.frame = CGRectMake(self.view2show.left-width_screen_qqc, self.view2show.top, self.view2show.width, self.view2show.height);
        }
    }
    else if (QqcModelAnimationTypeFromRight == self.animationType)
    {
        if (self.bIsOnCenter) {
            self.view2show.center = CGPointMake(xScreenCenter*3, yScreenCenter);
        }else{
            self.view2show.frame = CGRectMake(self.view2show.left+width_screen_qqc, self.view2show.top, self.view2show.width, self.view2show.height);
        }
    }
    
    if (QqcModelAnimationTypeNone == self.animationType) {
        self.view2show.alpha = 1.0f;
    }else{
        self.view2show.alpha = 0.;
    }
}

- (void)doShowAnimation
{
    __weak typeof(self)weakSelf = self;
    void (^doShow)(void) = ^(void){};
    
    if ( QqcModelAnimationTypeNone == self.animationType ){
        doShow = ^(void){
        };
    }else if ( QqcModelAnimationTypeFade == self.animationType ){
        doShow = ^(void){
        };
    }else if (self.animationType == QqcModelAnimationTypeScaleBig2Small){
        doShow = ^(void){
            weakSelf.view2show.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        };
    }else if (self.animationType == QqcModelAnimationTypeScaleSmall2Big){
        doShow = ^(void){
            weakSelf.view2show.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        };
    }else{
        
        if (self.bIsOnCenter) {
            doShow = ^(void){
                weakSelf.view2show.center = CGPointMake(xScreenCenter, yScreenCenter);
            };
        }else{
            
            CGRect rcView = CGRectZero;
            if (self.animationType == QqcModelAnimationTypeFromUp) {
                rcView = CGRectMake(self.view2show.left, self.view2show.top+height_screen_qqc, self.view2show.width, self.view2show.height);
            }else if (self.animationType == QqcModelAnimationTypeFromBottom){
                rcView = CGRectMake(self.view2show.left, self.view2show.top-height_screen_qqc, self.view2show.width, self.view2show.height);
            }else if (self.animationType == QqcModelAnimationTypeFromLeft){
                rcView = CGRectMake(self.view2show.left+width_screen_qqc, self.view2show.top, self.view2show.width, self.view2show.height);
            }else if (self.animationType == QqcModelAnimationTypeFromRight){
                rcView = CGRectMake(self.view2show.left-width_screen_qqc, self.view2show.top, self.view2show.width, self.view2show.height);
            }
            
            doShow = ^(void){
                weakSelf.view2show.frame = rcView;
            };
        }
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        
        doShow();
        weakSelf.bgImageView.alpha = 1.0f;
        weakSelf.view2show.alpha = 1.0f;
    }];
}

- (void)doHideAnimationAndClose
{
    __weak typeof(self)weakSelf = self;
    void(^doHide)(void) = ^(void){
    };
    
    switch (self.animationType)
    {
        case QqcModelAnimationTypeNone:
        case QqcModelAnimationTypeFade:
        {
            ;
        }
            break;
        case QqcModelAnimationTypeScaleBig2Small:
        {
            doHide = ^(void){
                weakSelf.view2show.layer.transform = CATransform3DMakeScale(1.66, 1.66, 1.0);
            };
        }
            break;
        case QqcModelAnimationTypeScaleSmall2Big:
        {
            doHide = ^(void){
                weakSelf.view2show.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0);
            };
        }
            break;
        case QqcModelAnimationTypeFromUp:
        {
            doHide = ^(void){
                
                if (self.bIsOnCenter) {
                    weakSelf.view2show.center = CGPointMake(xScreenCenter, -yScreenCenter);
                }else{
                    weakSelf.view2show.frame = CGRectMake(weakSelf.view2show.left, weakSelf.view2show.top-height_screen_qqc, weakSelf.view2show.width, weakSelf.view2show.height);
                }
            };
        }
            break;
        case QqcModelAnimationTypeFromBottom:
        {
            doHide = ^(void){
                if (self.bIsOnCenter) {
                    weakSelf.view2show.center = CGPointMake(xScreenCenter, yScreenCenter*3);
                }else{
                    weakSelf.view2show.frame = CGRectMake(weakSelf.view2show.left, weakSelf.view2show.top+height_screen_qqc, weakSelf.view2show.width, weakSelf.view2show.height);
                }
            };
        }
            break;
        case QqcModelAnimationTypeFromLeft:
        {
            doHide = ^(void){
                if (self.bIsOnCenter) {
                    weakSelf.view2show.center = CGPointMake(-xScreenCenter, yScreenCenter);
                }else{
                    weakSelf.view2show.frame = CGRectMake(weakSelf.view2show.left-width_screen_qqc, weakSelf.view2show.top, weakSelf.view2show.width, weakSelf.view2show.height);
                }
            };
        }
            break;
        case QqcModelAnimationTypeFromRight:
        {
            doHide = ^(void){
                if (self.bIsOnCenter) {
                    weakSelf.view2show.center = CGPointMake(xScreenCenter*3, yScreenCenter);
                }else{
                    weakSelf.view2show.frame = CGRectMake(weakSelf.view2show.left+width_screen_qqc, weakSelf.view2show.top, weakSelf.view2show.width, weakSelf.view2show.height);
                }
            };
        }
            break;
        default:
            
            break;
    }
    
    doHide();
    self.bgImageView.alpha = 0.05f;
    self.view2show.alpha = 0.05f;
}

- (void)doModel
{
//    [[QqcBaseUtilityUI getSafeKeyWindow] addSubview:self];
//    if (self.view2show.nextResponder && [self.view2show.nextResponder isKindOfClass:[UIViewController class]]) {
//        
//        [[QqcBaseUtilityUI getSafeKeyWindow].rootViewController addChildViewController:(UIViewController *)self.view2show.nextResponder];
//    }
    
    [self.myWindow addSubview:self];
    if (self.view2show.nextResponder && [self.view2show.nextResponder isKindOfClass:[UIViewController class]]) {
        
        self.myWindow.rootViewController = (UIViewController *)self.view2show.nextResponder;
    }
    
    [self.myWindow makeKeyAndVisible];
}

- (void)close
{
    
    __weak typeof(self)weakSelf = self;
    void(^animationHide)(void) = ^{
        
        [weakSelf doHideAnimationAndClose];
    };
    
    [UIView animateWithDuration:0.22 animations:animationHide completion:^(BOOL finished) {
        
        if (weakSelf.view2show.nextResponder && [weakSelf.view2show.nextResponder isKindOfClass:[UIViewController class]]) {
            
            [((UIViewController *)weakSelf.view2show.nextResponder) removeFromParentViewController];
        }
        [weakSelf removeFromSuperview];
        [weakSelf.view2show removeFromSuperview];
        weakSelf.myWindow.hidden = YES;
        [weakSelf.myWindow resignKeyWindow];
        
        //NSLog(@"当前类= %@ 销毁Window = %@\n",self, weakSelf.myWindow);
        weakSelf.view2show = nil;
        weakSelf.myWindow = nil;
    }];
    
//    __weak typeof(self)weakSelf = self;
//    void(^animationHide)(void) = ^{
//        
//        [weakSelf doHideAnimationAndClose];
//    };
//    
//    [UIView animateWithDuration:0.22 animations:animationHide completion:^(BOOL finished) {
//        [weakSelf.view2show removeFromSuperview];
//        [weakSelf removeFromSuperview];
//        if (weakSelf.view2show.nextResponder && [weakSelf.view2show.nextResponder isKindOfClass:[UIViewController class]]) {
//            
//            [((UIViewController *)weakSelf.view2show.nextResponder) removeFromParentViewController];
//            weakSelf.view2show = nil;
//        }
//    }];
    //_instance = nil;   这里让实例一直存在
}

@end
