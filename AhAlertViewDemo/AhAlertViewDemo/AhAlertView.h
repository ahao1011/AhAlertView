//
//  AhAlertView.h
//
//  Created by ah on 15/12/9.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AhAlertView;
//   建议使用Block  使用代理记得要指明其delegate 是谁 (类方法已内置) 注意实现代理方法
@protocol AhAlertViewDelegate <NSObject>

@optional  //

/**文本输入框输入完成*/
- (void)AhAlertView:(AhAlertView*)AhAlertView DidEndEditing:(UITextField *)textField;
/** 信息内容被点击 */
- (void)AhAlertViewmessageAction:(AhAlertView*)AhAlertView;
/** 底部弹窗的取消按钮被点击 */
- (void)AhAlertViewActionSheetCancleButtonclicked:(AhAlertView *)CustomActionSheet;
//@required
/**  底部弹窗列表被点击 */
- (void)AhAlertViewActionSheet:(AhAlertView *)CustomActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
typedef enum {  // 顶部提示信息的类型
    /** 信息 */
    TopViewTypeInfo,
    /** 成功 */
    TopViewTypeSucess,
    /** 警告 */
    TopViewTypeWaring,
    /**错误*/
    TopViewTypeError,
    
}TopViewType;
@interface AhAlertView : UIView
@property (nonatomic,weak)id<AhAlertViewDelegate> delegate;


/** 提示框中的富文本lable */
@property (nonatomic,strong)UILabel *AdsLable;
/** alertView的背景色 */
@property (nonatomic,strong)UIColor *alertViewColor;
/** 按钮字体颜色 */
@property (nonatomic,strong)UIColor *BtnColor;
/** 左按钮字体颜色 */
@property (nonatomic,strong)UIColor *leftBtnColor;
/** 右按钮字体颜色 */
@property (nonatomic,strong)UIColor *rightBtnColor;
/** 提示字体颜色 */
@property (nonatomic,strong)UIColor *titleColor;
/** 信息字体颜色 */
@property (nonatomic,strong)UIColor *MessageColor;
/** 其他信息字体颜色 */
@property (nonatomic,strong)UIColor *OtherMessageColor;
/** 提示框背景颜色 */
@property (nonatomic,strong)UIColor *TitleBackColor;
/** 按钮文字大小 */
@property (nonatomic,assign)CGFloat buttonFontSize;
/** 左按钮文字大小 */
@property (nonatomic,assign)CGFloat LeftbuttonFontSize;
/** 右按钮文字大小 */
@property (nonatomic,assign)CGFloat RightbuttonFontSize;
/** 正文文字大小 */
@property (nonatomic,assign)CGFloat messageFontSize;
/** 抬头文字大小 */
@property (nonatomic,assign)CGFloat titleFontSize;


/** 展示 */
- (void)show;
/** 隐藏 */
- (void)hidden;
/**类方法隐藏*/
+ (void)hiddenFromWindow;
/**设置输入框提示文字,要设置则不能使用类方法创建弹框且在show 方法前*/
- (void)setPlaceTFText:(NSString *)text;

#pragma mark -   ======快速创建 类方法

#pragma mark -  顶部弹出的一个信息类提示框
/**
 *  顶部弹出的一个信息类提示框
 *  备注:  考虑到这只是一个提示类的框,一般DoHandel为nil,显示 隐藏 以及对象方法都未暴露
 *  @param text     提示信息
 *  @param DoHandel 点击信息框句柄
 *  @param type     提示信息类型
 */
+ (void)alertViewWithTopText:(NSString *)text
                    DoHandle:(void(^)())DoHandel
                        type:(TopViewType)type;

#pragma mark - 确认按钮提示类方法
/** 确认按钮提示类方法 */
+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message;

#pragma mark -  2个按钮 外部传入1个富文本
/**
 *  2个按钮 外部传入1个富文本
 *
 *  @param title            抬头
 *  @param AttributedString 富文本
 *  @param target           target
 *  @param leftButtonTitle  左按钮标题
 *  @param leftAction       左Action
 *  @param rightButtonTitle 右按钮标题
 *  @param rightAction      右Action */
+ (void)alertViewWithTitle:(NSString *)title
          AttributedString:(NSMutableAttributedString*)AttributedString
                    target:(id)target
           leftButtonTitle:(NSString *)leftButtonTitle
           eftButtonAction:(SEL)leftAction
          rightButtonTitle:(NSString *)rightButtonTitle
         rightButtonAction:(SEL)rightAction;

#pragma mark -  2个按钮 外部传入1个富文本 Block
/**
 *  2个按钮 外部传入1个富文本 Block
 *
 *  @param title            抬头
 *  @param AttributedString 富文本
 *  @param leftButtonTitle  左标题
 *  @param leftHandel       左句柄
 *  @param rightButtonTitle 右标题
 *  @param rightHandel      右句柄
 */
+ (void)alertViewWithTitle:(NSString *)title
          AttributedString:(NSMutableAttributedString*)AttributedString
           leftButtonTitle:(NSString *)leftButtonTitle
          leftButtonHandle:(void(^)())leftHandel
          rightButtonTitle:(NSString *)rightButtonTitle
         rightButtonHandle:(void(^)())rightHandel
                  doHandle:(void(^)())doHandel;

#pragma mark -  1个按钮的提示框
/**
 *  一个按钮的提示框
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
 *  @param target             taget
 *  @param confirmbuttonTitle 按钮文字
 *  @param Action             点击事件
 *
 *  @return 提示框
 */
+ (void)alertViewWithwithTitle:(NSString *)title
                       message:(NSString *)message
                        target:(id)target
            confirmbuttonTitle:(NSString *)confirmbuttonTitle
           confirmbuttonAction:(SEL)Action;

#pragma mark -  1个按钮的提示框Block
/**
 *  一个按钮的提示框Block
 *
 *  @param title              抬头
 *  @param message            信息
 *  @param confirmButtonTitle 按钮文字
 *  @param confirmHandel      按钮句柄
 */
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message  confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandle:(void(^)())confirmHandel;

#pragma mark -  2个按钮的提示框
/**
*  2个按钮的提示框
*
*  @param title            抬头提示文字
*  @param message          提示的具体信息
*  @param target           target
*  @param leftButtonTitle  左边按钮文字
*  @param leftAction       左边按钮点击事件
*  @param rightButtonTitle 右边按钮文字
*  @param rightAction      右边按钮点击事件
*/

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction;
#pragma mark -  2个按钮的提示框Block
/**
 *  二个按钮Block
 *
 *  @param title            抬头
 *  @param message          信息
 *  @param leftButtonTitle  左标题
 *  @param leftHandel       左句柄
 *  @param rightButtonTitle 右标题
 *  @param rightHandel      右句柄
 */
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel;
#pragma mark -  带1个文本输入框
/**
 *  带1个文本输入框
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
 * @param OtherMessage       其他提示的具体信息
 *  @param target             target
 *  @param confirmbuttonTitle 按钮文字
 *  @param Action             按钮点击事件
 */
+ (void)alertViewWithtextFieldAndTitle:(NSString *)title message:(NSString *)message OtherMessage:(NSString*)OtherMessage target:(id)target  confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmbuttonAction:(SEL)Action;
#pragma mark -  带1个文本输入框 Block
/**
 *   带输入框 Block
 *
 *  @param title              抬头
 *  @param message            信息
 *  @param OtherMessage       副信息
 *  @param confirmbuttonTitle 按钮文字
 *  @param confirmHandel      按钮句柄
 *  @param textHandel         输入框句柄
 */
+ (void)alertViewWithtextFieldAndTitle:(NSString *)title
                               message:(NSString *)message
                          OtherMessage:(NSString*)OtherMessage
                    confirmbuttonTitle:(NSString *)confirmbuttonTitle
                         confirmHandel:(void(^)())confirmHandel
                            textHandel:(void(^)(NSString *text))textHandel;

#pragma mark - ======= 对象方法

#pragma mark -  2个按钮 外部传入1个富文本
/**
 *  2个按钮 外部传入1个富文本
 *
 *  @param title            抬头
 *  @param AttributedString 富文本
 *  @param target           target
 *  @param leftButtonTitle  左按钮标题
 *  @param leftAction       左Action
 *  @param rightButtonTitle 右按钮标题
 *  @param rightAction      右Action */
- (instancetype)initWithTitle:(NSString *)title AttributedString:(NSMutableAttributedString*)AttributedString target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction;
#pragma mark -  2个按钮 外部传入1个富文本 Block
/**
 *  2个按钮 外部传入1个富文本 Block
 *
 *  @param title            抬头
 *  @param AttributedString 富文本
 *  @param leftButtonTitle  左标题
 *  @param leftHandel       左句柄
 *  @param rightButtonTitle 右标题
 *  @param rightHandel      右句柄
 */
- (instancetype)initWithTitle:(NSString *)title
             AttributedString:(NSMutableAttributedString*)AttributedString
              leftButtonTitle:(NSString *)leftButtonTitle
             leftButtonHandle:(void(^)())leftHandel
             rightButtonTitle:(NSString *)rightButtonTitle
            rightButtonHandle:(void(^)())rightHandel
                     doHandle:(void(^)())doHandel;

#pragma mark -  信息展示
/**
 *  信息展示 点击确认隐藏弹框
 *
 *  @param title   提示标题
 *  @param message 信息
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

#pragma mark -   一个按钮的提示框
/**
 *  一个按钮的提示框
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
 *  @param target             taget
 *  @param confirmbuttonTitle 按钮文字
 *  @param Action             点击事件
 *
 *  @return 提示框
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                       target:(id)target
           confirmbuttonTitle:(NSString *)confirmbuttonTitle
          confirmbuttonAction:(SEL)Action;

#pragma mark -  一个按钮的提示框 Block
/**
 *  一个按钮的提示框 Block
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
 *  @param confirmbuttonTitle 按钮文字
 *  @param Action             Block事件
 *
 *  @return 提示框
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
           confirmButtonTitle:(NSString *)confirmButtonTitle
          confirmButtonHandle:(void(^)())confirmHandel;
#pragma mark -   2个按钮的提示框
/**
 *  2个按钮的提示框
 *
 *  @param title            抬头提示文字
 *  @param message          提示的具体信息
 *  @param target           target
 *  @param leftButtonTitle  左边按钮文字
 *  @param leftAction       左边按钮点击事件
 *  @param rightButtonTitle 右边按钮文字
 *  @param rightAction      右边按钮点击事件
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                       target:(id)target
              leftButtonTitle:(NSString *)leftButtonTitle
              eftButtonAction:(SEL)leftAction
             rightButtonTitle:(NSString *)rightButtonTitle
            rightButtonAction:(SEL)rightAction;

#pragma mark -  2个按钮的提示框 Block
/**
 *  2个按钮的提示框 Block
 *
 *  @param title            抬头提示文字
 *  @param message          提示的具体信息
 *  @param leftButtonTitle  左边按钮文字
 *  @param leftAction       左边按钮Block事件
 *  @param rightButtonTitle 右边按钮文字
 *  @param rightAction      右边按钮Block事件
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             leftButtonHandle:(void(^)())leftHandel
             rightButtonTitle:(NSString *)rightButtonTitle
            rightButtonHandle:(void(^)())rightHandel;

#pragma mark -  带1个文本输入框
/**
 *  带1个文本输入框
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
  * @param OtherMessage       其他提示的具体信息
 *  @param target             target
 *  @param confirmbuttonTitle 按钮文字
 *  @param Action             按钮点击事件
 */
- (instancetype)initWithtextFieldAndTitle:(NSString *)title
                                  message:(NSString *)message
                             OtherMessage:(NSString*)OtherMessage
                                   target:(id)target
                       confirmbuttonTitle:(NSString *)confirmbuttonTitle
                      confirmbuttonAction:(SEL)Action;

#pragma mark -    带1个文本输入框 Block
/**
 *  带1个文本输入框 Block
 *
 *  @param title              抬头提示文字
 *  @param message            提示的具体信息
 * @param OtherMessage       其他提示的具体信息
 *  @param confirmbuttonTitle 按钮文字
 *  @param confirmHandel             按钮Block
 */
- (instancetype)initWithtextFieldAndTitle:(NSString *)title
                                  message:(NSString *)message
                             OtherMessage:(NSString*)OtherMessage
                       confirmbuttonTitle:(NSString *)confirmbuttonTitle
                            confirmHandel:(void(^)())confirmHandel
                               textHandel:(void(^)(NSString *text))textHandel;
#pragma mark -  底部弹出框
/**
 *  底部弹出框
 *
 *  @param TitleArr     列表标题数组
 *  @param sheetHandle  列表点击句柄
 *  @param cancleHandle 取消按钮点击句柄
 */
- (instancetype)initWithSheetViewTitleArr:(NSArray *)TitleArr
                              sheetHandle:(void (^)(NSInteger index))sheetHandle
                             cancleHandle:(void(^)())cancleHandle;


@end
