//
//  QqcModelPanel.h
//  QqcWidgetsFramework
//
//  Created by qiuqinchuan on 15/12/4.
//  Copyright © 2015年 Qqc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QqcModelAnimationTypeNone,
    QqcModelAnimationTypeFade,
    QqcModelAnimationTypeScaleBig2Small,
    QqcModelAnimationTypeScaleSmall2Big,
    QqcModelAnimationTypeFromUp,
    QqcModelAnimationTypeFromBottom,
    QqcModelAnimationTypeFromLeft,
    QqcModelAnimationTypeFromRight,
} QqcModelAnimationType;

@interface QqcModelPanel : UIView

+ (instancetype)shareQqcModelPanel;


#pragma mark - 外部接口
+ (void)showModelAppendView:(UIView*)view2show animationType:(QqcModelAnimationType)animationType bgAlpha:(CGFloat)alpha isOnCenter:(BOOL)bIsOnCenter;

+ (void)closeModelView;

@property(nonatomic, copy) void (^onTapOnBgBlock)(void);

@end
