//
//  UIView+Extension.h
//  特付宝
//
//  Created by DeveKing7 on 15/12/28.
//  Copyright (c) 2015年 瀚迪科技. All rights reserved.
//
/** 设置自身x */
#define AHSetX(value) self.x = value
/** 设置自身y */
#define AHSetY(value) self.y = value
/** 设置自身centerX */
#define AHSetCenterX(value) self.centerX = value
/** 设置自身centerY */
#define AHSetCenterY(value) self.centerY = value
/** 设置自身center */
#define AHSetCenter(x, y) AHSetCenterX(x); \
SetCenterY(y)
/** 设置自身宽度 */
#define AHSetWidth(value) self.width = value
/** 设置自身高度 */
#define AHSetHeight(value) self.height = value
/** 设置自身尺寸 */
#define AHSetSize(width, height) self.size = CGSizeMake(width, height)

/** 设置控件x */
#define AHSetXForView(view, value) view.x = value
/** 设置控件y */
#define AHSetYForView(view, value) view.y = value
/** 设置控件centerX */
#define AHSetCenterXForView(view, value) view.centerX = value
/** 设置控件centerY */
#define AHSetCenterYForView(view, value) view.centerY = value
/** 设置控件center */
#define AHSetCenterForView(view, x, y) AHSetCenterXForView(view, x); \
SetCenterYForView(view, y);
/** 设置控件水平居中 */
#define AlignHorizontal(view) [view alignHorizontal]
/** 设置控件垂直居中 */
#define AlignVertical(view) [view alignVertical]
/** 设置控件宽度 */
#define AHSetWidthForView(view, value) view.width = value
/** 设置控件高度 */
#define AHSetHeightForView(view, value) view.height = value
/** 设置控件尺寸 */
#define AHSetSizeForView(view, width, height) view.size = CGSizeMake(width, height)

/** 快速添加子控件的宏定义 */
#define AddView(Class, property) [self addSubview:[Class class] propertyName:property]
#define AddViewForView(view, Class, property) [view addSubview:[Class class] propertyName:property]

// 屏幕bounds
#define AHScreenBounds [UIScreen mainScreen].bounds
// 屏幕的size
#define AHScreenSize [UIScreen mainScreen].bounds.size
// 屏幕的宽度
#define AHScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕的高度
#define AHScreenHeight [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;

/** 水平居中 */
- (void)alignHorizontal;
/** 垂直居中 */
- (void)alignVertical;
/** 加载该View的控制器 */
- (UIViewController *)viewCtroller;

@end
