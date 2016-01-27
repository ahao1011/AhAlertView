//
//  AhAlertView.m
//
//  Created by ah on 15/12/9.
//  Copyright © 2015年 itcast. All rights reserved.
//

#ifdef DEBUG  // 调试阶段
#define AhLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段
#define AhLog(...)
#endif
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define errorColor   Color(226,53,41)
#define sucessColor  Color(37,199,89)
#define waringColor  Color(223,105,10)
#define infoColor    Color(21,148,255)
#define TopShowDelayTime  3
#define cellHeight 50
#define K_marrk  8 //  间隙
#define K_ActionsheetCell  @"ActionsheetCell"
#define K_cornerRadius  10.0f
#define K_apla 0.3

// 2.获得RGB颜色
#define AHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//3. 随机色
#define AHRandomColor AHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//4. 屏幕宽 高
#define K_Screen_Width [UIScreen mainScreen].bounds.size.width
#define K_Screen_Height [UIScreen mainScreen].bounds.size.height

#define Iphone4 ((K_Screen_Width == 320) && (K_Screen_Height == 480))
#define Iphone5 ((K_Screen_Width == 320) && (K_Screen_Height == 568))
#define Iphone6 ((K_Screen_Width == 375) && (K_Screen_Height == 667))
#define Iphone6P ((K_Screen_Width == 414) && (K_Screen_Height == 736))

#import "AhAlertView.h"
#import "UIView+Extension.h"
#import "ActionsheetCell.h"

typedef void(^AhAlertViewBlock)();
typedef void(^AhShtttBlock)(NSInteger index);
typedef void(^AhTextBlock)(NSString *text);

typedef enum {  // 顶部提示信息的类型
    /** Top */
    AhAlertViewTypeTop,
    /** Alert */
    AhAlertViewTypeAlert,
    /** sheet */
    AhAlertViewTypeSheet,
    
}AhAlertViewType;

@interface AhAlertView ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,assign)id target;
/**底板view */
@property (nonatomic,strong)UIView *alertview;
/**左按钮*/
@property (nonatomic,strong)UIButton *leftBtn;
/**右按钮*/
@property (nonatomic,strong)UIButton *rightBtn;
/**抬头*/
@property (nonatomic,strong)UILabel *titleLable;

/**信息Lable*/
@property (nonatomic,strong)UILabel *mesLabel;
/**其他信息Lable*/
@property (nonatomic,strong)UILabel *OtherMesLabel;
/**信息承载的底层View*/
@property (nonatomic,strong)UIView *messageView;
/**抬头承载的底层View*/
@property (nonatomic,strong)UIView *titleView;
/**左饰件*/
@property (nonatomic,strong)UILabel *leftLable;
/**左图片*/
@property (nonatomic,strong)UIImageView *leftImg;
/**中间lable*/
@property (nonatomic,strong)UILabel *midLable;
/**中间UitextView*/
@property (nonatomic,strong)UITextView *textView;
/**操作手柄*/
@property (nonatomic,copy)AhAlertViewBlock leftHandle;
@property (nonatomic,copy)AhAlertViewBlock rightHandle;
@property (nonatomic,copy)AhAlertViewBlock DoHandle;
@property (nonatomic,copy)AhAlertViewBlock CancleHandle;
@property (nonatomic,copy)AhTextBlock textHandle;
/** 底部弹框的句柄 */
@property (nonatomic,copy)AhShtttBlock sheetHandle;
@property (nonatomic,strong)UITextField *Tf;

/** 底部的弹框 */

@property (nonatomic,strong)UIButton *cancleBtn;
@property (nonatomic,strong)UITableView *tableView;
/**底部弹框标题组*/
@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic,assign)AhAlertViewType AHType;





@end

@implementation AhAlertView{
    
    TopViewType _type;
}


/** 展示 */
- (void)show{
    
    if (_AHType==AhAlertViewTypeTop) {
        [self TopShow];
    }else if (_AHType==AhAlertViewTypeAlert){
        [self AlertShow];
    }else if (_AHType==AhAlertViewTypeSheet){
        [self SheetShow];
    }

}
/** 隐藏 */
- (void)hidden{
    
    if (_AHType==AhAlertViewTypeTop) {
        [self Tophide];
    }else if (_AHType==AhAlertViewTypeAlert){
        [self AlertHidden];
    }else if (_AHType==AhAlertViewTypeSheet){
        [self sheetHiden];
    }
}

- (void)AlertHidden{
    
    [self HidAlertView];
}

- (void)AlertShow{
    
    [self creatNoti];  // 键盘通知
    [self addWindow];
    [UIView animateWithDuration:.5f animations:^{
        _backView.alpha = K_apla;
    }];
    [self popAnimation];
}


+ (void)hiddenFromWindow{
    
    for (UIView *aView in [UIApplication sharedApplication].keyWindow.subviews) {
        if (aView && [aView isKindOfClass:[AhAlertView class]]) {
            AhAlertView *AlertView = (AhAlertView *)aView;
            
            if (AlertView.AHType==AhAlertViewTypeAlert) {
                [AlertView AlertHidden];
            }else if (AlertView.AHType==AhAlertViewTypeTop){
                [AlertView Tophide];
            }else if (AlertView.AHType==AhAlertViewTypeSheet){
                [AlertView sheetHiden];
            }
        }
    }
}
- (void)setPlaceTFText:(NSString *)text{
   
    if (_Tf!=nil && _Tf!=NULL) {
        
        _Tf.placeholder = text;
    }else{
        AhLog(@"输入框不存在");
    }
    
    
}
#pragma mark -  top隐藏
- (void)Tophide{
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.leftImg.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 animations:^{
            self.y = -self.height;
        } completion:nil];
    }];
}
#pragma mark -  top显示
- (void)TopShow{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.y=2;
        
    } completion:^(BOOL finished) {
        self.leftImg.alpha = 1;
        self.leftImg.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.5 delay:0.1 usingSpringWithDamping:.5 initialSpringVelocity:3 options:UIViewAnimationOptionCurveLinear animations:^{
            self.leftImg.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];
    
    [self performSelector:@selector(Tophide) withObject:nil afterDelay:TopShowDelayTime];
    
}
#pragma mark -  底部弹框显示
/**底部弹框显示*/
- (void)SheetShow{
    
    [self addWindow1];
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:8 options:UIViewAnimationOptionCurveLinear animations:^{
        self.y = K_Screen_Height-self.height;
         _backView.alpha = K_apla;
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:8 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tableView.y-=5;
        } completion:nil];
    } completion:^(BOOL finished) {
        AhLog(@"底部弹框已弹出");
    }];
}
#pragma mark -  底部弹框隐藏
/**底部弹框隐藏*/
- (void)sheetHiden{
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
        self.y-=30;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.y = K_Screen_Height;
            _backView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [_backView removeFromSuperview];
            [self removeFromSuperview];
        }];
        

    }];
    
}
- (void)addWindow1{
    self.backView = [self creatView1];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.backView];
    [window addSubview:self];
}
- (void)addWindow{
    
    self.backView = [self creatView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.backView];
    [window addSubview:self];
}
+ (void)TophiddenFromWindow{
    
    for (UIView *aView in [UIApplication sharedApplication].keyWindow.subviews) {
        if (aView && [aView isKindOfClass:[AhAlertView class]]) {
            AhAlertView *AlertView = (AhAlertView *)aView;
            [AlertView Tophide];
        }
    }
}

#pragma mark -  确认按钮 信息类提示
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    AhAlertView *view= [[AhAlertView alloc]initWithTitle:title message:message];
    [view AlertShow];
}

#pragma mark -  一个按钮
+ (void)alertViewWithwithTitle:(NSString *)title message:(NSString *)message target:(id)target  confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmbuttonAction:(SEL)Action{
    
    AhAlertView *view =  [[self alloc]initWithTitle:title message:message target:target confirmbuttonTitle:confirmbuttonTitle confirmbuttonAction:Action];
   
    [view AlertShow];
}
#pragma mark -  一个按钮Block
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message  confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandle:(void(^)())confirmHandel{
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title message:message confirmButtonTitle:confirmButtonTitle confirmButtonHandle:confirmHandel];
   
    [view AlertShow];
}
/**2个按钮*/
#pragma mark -  二个按钮
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction{
    
    AhAlertView *view = [[self alloc]initWithTitle:title message:message target:target  leftButtonTitle:leftButtonTitle eftButtonAction:leftAction rightButtonTitle:rightButtonTitle rightButtonAction:rightAction];
   
    [view AlertShow];
}
#pragma mark -  二个按钮Block
+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel{
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title message:message leftButtonTitle:leftButtonTitle leftButtonHandle:leftHandel rightButtonTitle:rightButtonTitle rightButtonHandle:rightHandel];
    
    [view AlertShow];
}

/**带输入框*/
#pragma mark -  *带输入框
+ (void)alertViewWithtextFieldAndTitle:(NSString *)title message:(NSString *)message OtherMessage:(NSString*)OtherMessage target:(id)target  confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmbuttonAction:(SEL)Action{
    
    AhAlertView *view = [[AhAlertView alloc]initWithtextFieldAndTitle:title message:message OtherMessage:OtherMessage target:target confirmbuttonTitle:confirmbuttonTitle confirmbuttonAction:Action];
    view.delegate = target;
    
    [view AlertShow];
}
#pragma mark -  带输入框 Block
+ (void)alertViewWithtextFieldAndTitle:(NSString *)title message:(NSString *)message OtherMessage:(NSString*)OtherMessage confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmHandel:(void(^)())confirmHandel textHandel:(void(^)(NSString *text))textHandel{
   
    AhAlertView *view = [[AhAlertView alloc]initWithtextFieldAndTitle:title message:message OtherMessage:OtherMessage confirmbuttonTitle:confirmbuttonTitle confirmHandel:confirmHandel textHandel:textHandel];
    
    [view AlertShow];
}
#pragma mark -  2个按钮传入一个富文本
+ (void)alertViewWithTitle:(NSString *)title AttributedString:(NSMutableAttributedString*)AttributedString target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction{
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title AttributedString:AttributedString target:target leftButtonTitle:leftButtonTitle eftButtonAction:leftAction rightButtonTitle:rightButtonTitle rightButtonAction:rightAction];
    view.delegate = target;
    [view show];
}
#pragma mark -  2个按钮传入一个富文本Block
+ (void)alertViewWithTitle:(NSString *)title AttributedString:(NSMutableAttributedString*)AttributedString leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel doHandle:(void(^)())doHandel {
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title AttributedString:AttributedString leftButtonTitle:leftButtonTitle leftButtonHandle:leftHandel rightButtonTitle:rightButtonTitle rightButtonHandle:rightHandel doHandle:doHandel];
    
    [view show];
}
#pragma mark -  2个按钮 外部传入一个长文本

+ (void)alertViewWithTitle:(NSString *)title
           DescString:(NSString*)DescString
               target:(id)target
      leftButtonTitle:(NSString *)leftButtonTitle
      eftButtonAction:(SEL)leftAction
     rightButtonTitle:(NSString *)rightButtonTitle
    rightButtonAction:(SEL)rightAction{
    
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title DescString:DescString target:target leftButtonTitle:leftButtonTitle eftButtonAction:leftAction rightButtonTitle:rightButtonTitle rightButtonAction:rightAction];
    [view show];
    
}
#pragma mark -  2个按钮 外部传入一个长文本 block
+ (void)alertViewWithTitle:(NSString *)title
           DescString:(NSString*)DescString
      leftButtonTitle:(NSString *)leftButtonTitle
     leftButtonHandle:(void(^)())leftHandel
     rightButtonTitle:(NSString *)rightButtonTitle
    rightButtonHandle:(void(^)())rightHandel{
    
    AhAlertView *view = [[AhAlertView alloc]initWithTitle:title DescString:DescString leftButtonTitle:leftButtonTitle leftButtonHandle:leftHandel rightButtonTitle:rightButtonTitle rightButtonHandle:rightHandel];
    [view show];
}


// ************************************************************************************************************
#pragma mark -  数据处理

//- (void)setViewHeight:(CGFloat)ViewHeight{
//    
//    CGFloat height = ViewHeight;
//    CGFloat left = 30;
//    CGFloat width = K_Screen_Width-2*left;
//    CGFloat y = (K_Screen_Height - height)*.5;
//    self.frame = CGRectMake(left, y, width, height);
//
//    [self setNeedsLayout];
//}

- (void)setOtherMessageColor:(UIColor *)OtherMessageColor{
    
    _OtherMessageColor = OtherMessageColor;
    
    self.OtherMesLabel.textColor = OtherMessageColor;
}
- (void)setAlertViewColor:(UIColor *)alertViewColor{
    
    _alertViewColor = alertViewColor;
    
    self.alertview.backgroundColor = alertViewColor;

}
-(void)setBtnColor:(UIColor *)BtnColor{
    
    _BtnColor = BtnColor;
    [self setBtn:self.leftBtn WithTitleColor:BtnColor];
    [self setBtn:self.rightBtn WithTitleColor:BtnColor];
}

- (void)setBtn:(UIButton *)btn WithTitleColor:(UIColor *)color{
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setLeftBtnColor:(UIColor *)leftBtnColor{
    
    _leftBtnColor = leftBtnColor;
    [self setBtn:self.leftBtn WithTitleColor:leftBtnColor];
}
- (void)setRightBtnColor:(UIColor *)rightBtnColor{
    
    _rightBtnColor = rightBtnColor;
    [self setBtn:self.rightBtn WithTitleColor:rightBtnColor];
}
- (void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    self.titleLable.textColor = titleColor;
}
- (void)setMessageColor:(UIColor *)MessageColor{
    
    _MessageColor = MessageColor;
    self.mesLabel.textColor = MessageColor;
}
- (void)setTitleBackColor:(UIColor *)TitleBackColor{
    
    _TitleBackColor = TitleBackColor;
    
    self.titleLable.backgroundColor = TitleBackColor;
}


- (void)setButtonFontSize:(CGFloat)buttonFontSize{
    
    _buttonFontSize = buttonFontSize;
    
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
}
- (void)setLeftbuttonFontSize:(CGFloat)LeftbuttonFontSize{
    _LeftbuttonFontSize = LeftbuttonFontSize;
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:LeftbuttonFontSize];
}
- (void)setRightbuttonFontSize:(CGFloat)RightbuttonFontSize{
    _RightbuttonFontSize = RightbuttonFontSize;
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:RightbuttonFontSize];
}
- (void)setMessageFontSize:(CGFloat)messageFontSize{
    _messageFontSize = messageFontSize;
    if (self.mesLabel) {
        self.mesLabel.font = [UIFont systemFontOfSize:messageFontSize];
    }
}
-(void)setTitleFontSize:(CGFloat)titleFontSize{
    _titleFontSize = titleFontSize;
    self.titleLable.font = [UIFont systemFontOfSize:titleFontSize];
}

#pragma mark -  初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark -  确认按钮提示
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    
    return [self initWithTitle:title message:message target:self confirmbuttonTitle:@"确认" confirmbuttonAction:@selector(confirmClick)];
}

#pragma mark -  二个按钮Block
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel{
    
    _leftHandle = leftHandel;
    _rightHandle = rightHandel;
    return [self initWithTitle:title message:message target:self leftButtonTitle:leftButtonTitle eftButtonAction:@selector(leftAction) rightButtonTitle:rightButtonTitle rightButtonAction:@selector(rightAction)];
    
}

- (void)leftAction{
    if (_leftHandle) {
        [self HidAlertView];
        _leftHandle();
    }
}
- (void)rightAction{
    
    if(_rightHandle) {
        [self HidAlertView];
        _rightHandle();
    }
}
/**base_method*/

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction{
    
    _AHType = AhAlertViewTypeAlert;
    CGFloat height = 170;
    CGFloat left = 30;
    CGFloat width = K_Screen_Width-2*left;
    CGFloat y = (K_Screen_Height - height)*.5;
    self = [super initWithFrame:CGRectMake(left, y, width, height)];
    AhLog(@"本身的frame:%@",NSStringFromCGRect(self.frame));
    if (self) {
        // 提示面板
        UIView *alertview = [[UIView alloc]init];
        alertview.layer.cornerRadius = 8.0f;
        alertview.layer.masksToBounds = YES;
        [self addSubview:alertview];
        self.alertview = alertview;
        alertview.frame = CGRectMake(0, 0, width, height);
        AhLog(@"提示面板的的frame:%@",NSStringFromCGRect(alertview.frame));
        alertview.backgroundColor = [UIColor clearColor];  //  提示面板背景色;
        // 左右按钮
        UIColor *btnColor = [UIColor colorWithRed:21/255.0f green:148/255.0f blue:255/255.0f alpha:1];
        
        
        UIButton *leftBtn = [[UIButton alloc]init];
        self.leftBtn = leftBtn;
        leftBtn.backgroundColor = [UIColor whiteColor];
        if (target!=nil && leftAction!=nil) {  //  容错
            
            if ([target respondsToSelector:leftAction]) {
                [leftBtn addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [leftBtn addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitle:leftButtonTitle forState:UIControlStateNormal];
        [leftBtn setTitle:leftButtonTitle forState:UIControlStateHighlighted];
        [leftBtn setTitle:leftButtonTitle forState:UIControlStateSelected];
        [leftBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [leftBtn setTitleColor:btnColor forState:UIControlStateHighlighted];
        [alertview addSubview:leftBtn];
        
        UIButton *rightBtn = [[UIButton alloc]init];
        self.rightBtn = rightBtn;
        rightBtn.backgroundColor = [UIColor whiteColor];
        
        if (target!=nil && rightAction!=nil) {  //  容错
           
            if ([target respondsToSelector:rightAction]) {
                [rightBtn addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];

            }
        }
        [rightBtn setTitle:rightButtonTitle forState:UIControlStateNormal];
        [rightBtn setTitle:rightButtonTitle forState:UIControlStateHighlighted];
        [rightBtn setTitle:rightButtonTitle forState:UIControlStateSelected];
        [rightBtn setTitleColor:btnColor forState:UIControlStateNormal];
        [rightBtn setTitleColor:btnColor forState:UIControlStateHighlighted];
        [alertview addSubview:rightBtn];
        
        // message 信息
        UIView *messageView = [[UIView alloc]init];
        messageView.backgroundColor = [UIColor whiteColor];    //  白色
        self.messageView  = messageView;
        [alertview addSubview:messageView];
        UILabel *mesLabel = [[UILabel alloc]init];
        self.mesLabel = mesLabel;
        mesLabel.numberOfLines = 0;
        mesLabel.text = message;
        mesLabel.textAlignment = NSTextAlignmentCenter;
        [messageView addSubview:mesLabel];
        UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageAction)];
        [mesLabel addGestureRecognizer:Recognizer];
        // title 提示文字
        UIView *titleView = [[UIView alloc]init];
        titleView.backgroundColor = [UIColor clearColor];
        self.titleView = titleView;
        [alertview addSubview:titleView];
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = title;
        CGFloat padd = 0;
        if (title==nil) {
            titleLable.frame =CGRectZero;
            padd=0;
        }else{
            titleLable.frame = CGRectMake(0, 0, alertview.frame.size.width, 40);
            padd=1;
        }
        AhLog(@"抬头的frame:%@",NSStringFromCGRect(titleLable.frame));
        [titleView addSubview:titleLable];
        self.titleLable = titleLable;
        
        
        
        CGFloat leftBtnx = 0;
        CGFloat leftBtnwidth = (alertview.frame.size.width)*0.5 - 0.5;
        CGFloat leftBtnHeight = 40;
        CGFloat leftBtnY = alertview.frame.size.height - leftBtnHeight;
        leftBtn.frame = CGRectMake(leftBtnx, leftBtnY, leftBtnwidth, leftBtnHeight);
        AhLog(@"左按钮的frame:%@",NSStringFromCGRect(leftBtn.frame));
        int mm = 1;
        if ([leftButtonTitle isEqualToString:@""] || leftButtonTitle ==nil) {
            
            leftBtnwidth = 0;
            mm=0;  //  间隙为0
        }
        
        CGFloat rightBtnx = leftBtnwidth + mm;
        CGFloat rightBtnwidth = alertview.frame.size.width-leftBtnwidth-mm;
        CGFloat rightBtnHeight = 40;
        CGFloat rightBtnY = alertview.frame.size.height - leftBtnHeight;
        rightBtn.frame = CGRectMake(rightBtnx, rightBtnY, rightBtnwidth, rightBtnHeight);
        AhLog(@"右按钮的frame:%@",NSStringFromCGRect(leftBtn.frame));
        
        CGFloat mesLabelX = 0;
        CGFloat mesLabelY = CGRectGetMaxY(titleLable.frame)+padd;
        CGFloat mesLabelWidth =alertview.frame.size.width;
        CGFloat mesLabelheight = leftBtn.frame.origin.y - titleLable.frame.origin.y - titleLable.frame.size.height-2;
        
        messageView.frame = CGRectMake(mesLabelX, mesLabelY, mesLabelWidth, mesLabelheight);
        mesLabel.frame = CGRectMake(0, 0, mesLabelWidth, mesLabelheight);
        AhLog(@"信息的frame:%@",NSStringFromCGRect(mesLabel.frame));
        
        // 提示
        if (title.length>0) {
            titleLable.hidden = NO;
            titleLable.text = title;
        }else{
            titleLable.hidden = YES;
        }
        
        // 字号
        titleLable.font = [UIFont boldSystemFontOfSize:16];
        mesLabel.font = [UIFont systemFontOfSize:16];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        //  颜色
        
        mesLabel.backgroundColor = [UIColor whiteColor];
        self.titleLable.backgroundColor = [UIColor whiteColor];
        
        self.backgroundColor = AHColor(231, 231, 231);
        
        
    }
    return self;
}



#pragma mark -  一个按钮
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target  confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmbuttonAction:(SEL)Action{
    
    return [self initWithTitle:title message:message target:target leftButtonTitle:nil eftButtonAction:nil rightButtonTitle:confirmbuttonTitle rightButtonAction:Action];
}
#pragma mark -  一个按钮Block
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandle:(void(^)())confirmHandel{
    
    return [self initWithTitle:title message:message leftButtonTitle:nil leftButtonHandle:nil rightButtonTitle:confirmButtonTitle rightButtonHandle:confirmHandel];
}
#pragma mark -    带1个文本输入框 Block


- (instancetype)initWithtextFieldAndTitle:(NSString *)title message:(NSString *)message OtherMessage:(NSString*)OtherMessage confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmHandel:(void(^)())confirmHandel textHandel:(void(^)(NSString *text))textHandel{
   
   
    self = [[AhAlertView alloc]initWithTitle:title message:message confirmButtonTitle:confirmbuttonTitle confirmButtonHandle:confirmHandel];
    if (self) {
        [self creatTf:OtherMessage];
        _textHandle = textHandel;
    }
    return self;
}

- (void)hrightAction{
    
    [self rightAction];
}

#pragma mark -  带1个文本输入框
- (instancetype)initWithtextFieldAndTitle:(NSString *)title message:(NSString *)message OtherMessage:(NSString*)OtherMessage target:(id)target  confirmbuttonTitle:(NSString *)confirmbuttonTitle confirmbuttonAction:(SEL)Action{
    
    
    self = [[AhAlertView alloc]initWithTitle:title message:message target:target confirmbuttonTitle:confirmbuttonTitle confirmbuttonAction:Action];
    
    AhLog(@"AhAlertView的Frame=====%@",NSStringFromCGRect(self.frame));

    AhLog(@"信息承载的Frame=====%@",NSStringFromCGRect(self.messageView.frame));
    
    if (self) {
        [self creatTf:OtherMessage];
    }
    return self ;
}
#pragma mark 增加输入框
- (void)creatTf:(NSString *)OtherMessage{
    //  其他信息
    UILabel *otherMessageLable = [[UILabel alloc]init];
    otherMessageLable.backgroundColor = [UIColor clearColor];
    otherMessageLable.numberOfLines = 0;
    otherMessageLable.text = OtherMessage;
    otherMessageLable.textColor = [UIColor darkGrayColor];
    otherMessageLable.font = [UIFont systemFontOfSize:10];
    otherMessageLable.textAlignment = NSTextAlignmentCenter;
    self.OtherMesLabel = otherMessageLable;
    [self.messageView addSubview:otherMessageLable];
    
    //  文本输入框
    _Tf = [[UITextField alloc]init];
    _Tf.borderStyle = UITextBorderStyleRoundedRect; //  输入文本框样式
    _Tf.secureTextEntry = YES;  //  强制密文
    _Tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _Tf.delegate = self;
    _Tf.returnKeyType = UIReturnKeyDone;
    _Tf.placeholder = @"请输入您的支付密码";
    _Tf.textAlignment = NSTextAlignmentLeft;
    _Tf.font = [UIFont boldSystemFontOfSize:14];
    
    [self.messageView addSubview:_Tf];
    
    [_Tf becomeFirstResponder];
    
    // frame
    
    CGFloat mesX = 0;
    CGFloat mesY = 1;
    CGFloat mesW = self.width;
    CGFloat mesH = 25;
    
    self.mesLabel.frame = CGRectMake(mesX, mesY, mesW, mesH);
    self.mesLabel.font = [UIFont boldSystemFontOfSize:17];
    AhLog(@"mesLabel.frame=====%@",NSStringFromCGRect(self.mesLabel.frame));
    
    CGFloat hh = 10;  //距左边的间隔
    CGFloat TFX = hh;
    CGFloat TFW = self.messageView.width-2*hh;
    CGFloat TFH = 30;
    CGFloat TFY = self.messageView.height-8-TFH;
    
    _Tf.frame = CGRectMake(TFX, TFY, TFW, TFH);
    AhLog(@"Tf.frame=====%@",NSStringFromCGRect(_Tf.frame));
    
    CGFloat otherMesLabelX = 0;
    CGFloat otherMesLabelWidth = self.messageView.width;
    CGFloat otherMesLabelY = CGRectGetMaxY(self.mesLabel.frame)+5;
    CGFloat otherMesLabelheight = TFY-3-otherMesLabelY;
    otherMessageLable.frame = CGRectMake(otherMesLabelX, otherMesLabelY, otherMesLabelWidth, otherMesLabelheight);
    
    AhLog(@"otherMessageLable.frame=====%@",NSStringFromCGRect(otherMessageLable.frame));
}

#pragma mark -  2个按钮 外部传入1个富文本 Block
- (instancetype)initWithTitle:(NSString *)title AttributedString:(NSMutableAttributedString*)AttributedString leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel doHandle:(void(^)())doHandel{
    
    self = [[AhAlertView alloc]initWithTitle:title message:nil leftButtonTitle:leftButtonTitle leftButtonHandle:leftHandel rightButtonTitle:rightButtonTitle rightButtonHandle:rightHandel];
    if (self) {
        [self creatAttributedString:AttributedString];
        _DoHandle = doHandel;

    }
    return self;
}
#pragma mark -  2个按钮 外部传入1个富文本
- (instancetype)initWithTitle:(NSString *)title AttributedString:(NSMutableAttributedString*)AttributedString target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction{
    
    
    self =[[AhAlertView alloc]initWithTitle:title message:nil target:target leftButtonTitle:leftButtonTitle eftButtonAction:leftAction rightButtonTitle:rightButtonTitle rightButtonAction:rightAction];
    if (self) {
        [self creatAttributedString:AttributedString];
    }
    return self;
}



#pragma mark -  增加富文本
- (void)creatAttributedString:(NSMutableAttributedString*)AttributedString{
    
    self.mesLabel.attributedText = AttributedString;
    self.mesLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageAction)];
    [self.mesLabel addGestureRecognizer:Recognizer];
}

#pragma mark -  2个按钮 外部传入1个富文本 Block
- (instancetype)initWithTitle:(NSString *)title DescString:(NSString*)DescString leftButtonTitle:(NSString *)leftButtonTitle leftButtonHandle:(void(^)())leftHandel rightButtonTitle:(NSString *)rightButtonTitle rightButtonHandle:(void(^)())rightHandel{
    
    self = [[AhAlertView alloc]initWithTitle:title message:nil leftButtonTitle:leftButtonTitle leftButtonHandle:leftHandel rightButtonTitle:rightButtonTitle rightButtonHandle:rightHandel];
    if (self) {
        [self creatDescString:DescString];
    }
    return self;
    
}
#pragma mark -  2个按钮 外部传入一个长文本
- (instancetype)initWithTitle:(NSString *)title DescString:(NSString*)DescString target:(id)target  leftButtonTitle:(NSString *)leftButtonTitle eftButtonAction:(SEL)leftAction rightButtonTitle:(NSString *)rightButtonTitle rightButtonAction:(SEL)rightAction{
    self =[[AhAlertView alloc]initWithTitle:title message:nil target:target leftButtonTitle:leftButtonTitle eftButtonAction:leftAction rightButtonTitle:rightButtonTitle rightButtonAction:rightAction];
    if (self) {
        [self creatDescString:DescString];
    }
    return self;
}

#pragma mark -  增加UitextView

- (void)creatDescString:(NSString *)DescString{
    
    [self.mesLabel removeFromSuperview];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:self.messageView.bounds];
    textView.scrollEnabled = YES;
    [textView resignFirstResponder];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor blackColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.text = DescString;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textAlignment = NSTextAlignmentCenter;
    [self.messageView addSubview:textView];
    self.textView = textView;
    
}


#pragma mark -  隐藏

- (void)HidAlertView{
    
    if (_Tf) { [_Tf resignFirstResponder]; }
    [self HideAnimation];
    [UIView animateWithDuration:.2f animations:^{
        _backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self Ahdealloc];  //  移除通知 
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)cancleAction{
    
    [self HidAlertView];
}

- (void)confirmClick{
    
    [self HidAlertView];
}
- (UIView *)creatView{
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    AhLog(@"蒙板========%@",NSStringFromCGRect(_backView.frame));
    backView.alpha = 0;
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HidAlertView)];
    [backView addGestureRecognizer:recongnizer];
    return backView;
}
- (UIView *)creatView1{
    
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    AhLog(@"蒙板========%@",NSStringFromCGRect(_backView.frame));
    backView.alpha = 0;
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sheetHiden)];
    [backView addGestureRecognizer:recongnizer];
    return backView;

}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_textHandle) {
        _textHandle(textField.text);
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(AhAlertView:DidEndEditing:)]) {
        [self.delegate AhAlertView:self DidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)messageAction{
    
    if (_DoHandle) {
        _DoHandle();
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(AhAlertViewmessageAction:)]) {
     
        [self.delegate AhAlertViewmessageAction:self];
    }
    
}
#pragma mark -  键盘通知 
- (void)creatNoti{
    
    //获取通知中心
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //让self监听键盘弹出的通知,注册通知
    //Observer：接收通知的对象
    //selector：接收到通知之后调用的方法
    //name:通知的名字
    [nc addObserver:self selector:@selector(keybardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [nc addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -  键盘显示
-(void)keybardWillShow:(NSNotification *)notify
{
    NSTimeInterval time = [[notify.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:time animations:^{
       
        if (self!=nil) {
            CGFloat Magin;
            if (Iphone5) {
                Magin=50;
            }else if (Iphone6){
                Magin = 10;
            }else if (Iphone6P){
                Magin=0;
            }else{
                Magin = 95;
            }
            self.y-=Magin;
        }
    }];
//    AhLog(@"%@",notify);
}

#pragma mark -键盘隐藏
-(void)keyboardWillHidden
{
    [UIView animateWithDuration:0.25 animations:^{
        if (self!=nil) {
            CGFloat Magin;
            if (Iphone5) {
                Magin=80;
            }else if (Iphone6){
                Magin = 10;
            }else if (Iphone6P){
                Magin=0;
            }else{
                Magin = 95;
            }
            self.y+=Magin;
        }

    }];
}

#pragma mark -  显示动画

- (void)popAnimation{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f,@0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];

}
#pragma mark -  隐藏动画
- (void)HideAnimation{
    
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    hideAnimation.delegate = self;
    [self.layer addAnimation:hideAnimation forKey:nil];

}

#pragma mark -  =======TopView

+ (void)alertViewWithTopText:(NSString *)text DoHandle:(void(^)())DoHandel type:(TopViewType)type{
   
    AhAlertView *view = [[AhAlertView alloc]initWithTopViewText:text DoHandle:DoHandel type:type];
    [view TopShow];
}
#pragma mark -  点击手势
- (void)TapTop{
    
    if (_DoHandle) {
        _DoHandle();
    }
    [self Tophide];
}
/**
 *  TopView提示框
 */
- (instancetype)initWithTopViewText:(NSString *)text DoHandle:(void(^)())DoHandel type:(TopViewType)type{
    
    _AHType = AhAlertViewTypeTop;
    _DoHandle = DoHandel;
    _type = type;
    CGFloat x = 30;
    CGFloat h = 40;
    CGFloat y = -h;
    CGFloat w = K_Screen_Width - 2*x;
    
    self = [super initWithFrame:CGRectMake(x, y, w, h)];
    if (self) {
        
        self.layer.cornerRadius = 2.0f;
        self.clipsToBounds = YES;
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        UILabel *leftLable = [UILabel new];
        [self addSubview:leftLable];
        UILabel *mid = [[UILabel alloc]init];
        mid.userInteractionEnabled = YES;
        mid.text = text;
        mid.font = [UIFont systemFontOfSize:14];
        mid.textColor = [UIColor whiteColor];
        UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTop)];
        [mid addGestureRecognizer:Recognizer];
        mid.textAlignment =  NSTextAlignmentCenter;
        [self addSubview:mid];
        _leftImg = [[UIImageView alloc]init];
        _leftImg.alpha = 0;
        _leftImg.backgroundColor = [UIColor clearColor];
        _leftImg.userInteractionEnabled = YES;
        _leftImg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_leftImg];
        
        switch (type) {
            case TopViewTypeInfo:{
                leftLable.backgroundColor = infoColor;
                mid.backgroundColor = infoColor;
                _leftImg.image = [UIImage imageNamed:@"Resoure.bundle/icon/info"];
            }
                break;
            case TopViewTypeSucess:{
                leftLable.backgroundColor = sucessColor;
                mid.backgroundColor = sucessColor;
                _leftImg.image = [UIImage imageNamed:@"Resoure.bundle/icon/sus"];
            }
                break;
            case TopViewTypeError:{
                leftLable.backgroundColor = errorColor;
                mid.backgroundColor = errorColor;
                _leftImg.image = [UIImage imageNamed:@"Resoure.bundle/icon/er"];
            }
                break;
            case TopViewTypeWaring:{
                leftLable.backgroundColor = waringColor;
                mid.backgroundColor = waringColor;
                _leftImg.image = [UIImage imageNamed:@"Resoure.bundle/icon/wa"];
            }
                break;
                
            default:
                break;
        }
        
        //frame
        
        CGFloat leftX = 0;
        CGFloat leftY = 0;
        CGFloat leftW = 4;
        CGFloat leftH = self.height;
        
        leftLable.frame = CGRectMake(leftX, leftY, leftW, leftH);
        
        CGFloat MidX = CGRectGetMaxX(leftLable.frame) + 2;
        CGFloat MidY = 0;
        CGFloat MidW = self.width-5-MidX;
        CGFloat MidH = self.height;
        
        mid.frame = CGRectMake(MidX, MidY, MidW, MidH);
        
        CGFloat LeftIconX = MidX+4;
        CGFloat LeftIconH = 20;
         CGFloat LeftIconW = 20;
        CGFloat LeftIconY = (self.height-LeftIconH)*0.5 ;
        _leftImg.layer.cornerRadius = LeftIconW * 0.5;
        _leftImg.frame = CGRectMake(LeftIconX, LeftIconY, LeftIconW, LeftIconH);
       
    }
    return self;
}

-(void)Ahdealloc
{
    //获取通知中心
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //移除键盘出现的监听
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //移除键盘消失的监听
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    _leftHandle = nil;
    _rightHandle = nil;
    
    
    
}
- (void)dealloc{
    
    [self Ahdealloc];
}

#pragma mark - ============= 底部弹框

- (instancetype)initWithDeafaultFrame{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(10, K_Screen_Height, K_Screen_Width-20, 163);
    }
    return self;
}

+ (instancetype)DeafaultActionSheet{
    
    return [[self alloc]initWithDeafaultFrame];
}

- (instancetype)initWithSheetViewTitleArr:(NSArray *)TitleArr sheetHandle:(void (^)(NSInteger index))sheetHandle cancleHandle:(void(^)())cancleHandle{
    
    _AHType = AhAlertViewTypeSheet;
    _CancleHandle = cancleHandle;
    _sheetHandle = sheetHandle;
    self.titleArr = TitleArr;
    CGFloat x = 15;
    NSInteger m = TitleArr.count;
    if (TitleArr.count>4) {
        m=4;
    }
    CGFloat h = 2*K_marrk + cellHeight * (m+1);  //  50 是1个cell的高度  6微调
    CGFloat w = K_Screen_Width - 2* x;
    CGFloat y = K_Screen_Height;
    
    self = [super initWithFrame:CGRectMake(x, y, w, h)];
    AhLog(@"sheetFrame================%@",NSStringFromCGRect(self.frame));
    if (self) {
        
        [self crearAView];
    }
    return self;
}
/**建立内部控件*/
- (void)crearAView{
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat cancleX =0;
    CGFloat cancleH = cellHeight;
    CGFloat cancleW = self.width - 2*cancleX;
    CGFloat cancleY = self.height-K_marrk-cancleH;
    _cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(cancleX, cancleY, cancleW, cancleH)];
    _cancleBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cancleBtn];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [_cancleBtn setTitleColor:Color(84, 157, 249) forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:Color(84, 157, 249) forState:UIControlStateHighlighted];

    [_cancleBtn addTarget:self action:@selector(cancleActio) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.layer.cornerRadius = K_cornerRadius;
    CGFloat sheetX = 0;
    CGFloat sheetY = 0;
    CGFloat sheetW = self.width- 2*sheetX;
    CGFloat sheetH = self.height-sheetY-cancleH-2*K_marrk;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(sheetX, sheetY, sheetW, sheetH) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.layer.cornerRadius = K_cornerRadius;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = cellHeight;
    [self.tableView registerNib:[UINib nibWithNibName:K_ActionsheetCell bundle:nil] forCellReuseIdentifier:K_ActionsheetCell];
    [self addSubview:_tableView];
    [self.tableView reloadData];
}

- (void)cancleActio{
    if (_CancleHandle) {
        _CancleHandle();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(AhAlertViewActionSheetCancleButtonclicked:)]) {
        [self.delegate AhAlertViewActionSheetCancleButtonclicked:self];
    }
    [self sheetHiden];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActionsheetCell *cell = [tableView dequeueReusableCellWithIdentifier:K_ActionsheetCell];
    cell.nameLable.text = _titleArr[indexPath.row];
    cell.nameLable.textColor = Color(84, 157, 249);
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_sheetHandle) {
        _sheetHandle(indexPath.row);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AhAlertViewActionSheet:clickedButtonAtIndex:)]) {
        
        [self.delegate AhAlertViewActionSheet:self clickedButtonAtIndex:indexPath.row];
    }
}






@end
