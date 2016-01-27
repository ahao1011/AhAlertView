# AhAlertView
一. 这是一款简单的弹框集合,集合了顶部弹框,AlertView和sheetView, 其中顶部弹框照片在Resoure.bundle内,可以根据自己的需求进行更换;AlertView模仿的原生弹框,通过Block的实现
让代码块显得紧凑,宜读. 底部的sheetView弹框加了一些动画进去,不需要的可以取消掉,目前该弹框是应用到我们公司自己的项目,你可以根据自己的需求进行更改,
或者@我, 邮箱zth0218@126.com  QQ:656205255 

同一效果使用了Action-Target和Block实现,具体的实现方法还是参看Demo吧,确实没什么难的技术点.

可利用类方法快速创建一个简洁弹窗 ,例如:
[AhAlertView alertViewWithTitle:@"提示" message:@"这个也可以使用Target-Action" confirmButtonTitle:@"确认" confirmButtonHandle:^{
           NSLog(@"确认按钮被点击");
  }];
使用类方法时,因为弹框是加载到window上的,  在何时的地方要进行隐藏,隐藏时,弹框会从Window移除.


/**类方法隐藏*/
+ (void)hiddenFromWindow;

也可以使用对象方法创建,
AhAlertView *view = [[AhAlertView alloc]initWithTitle:@"提示" message:@"这是2个按钮的对象方法展示" leftButtonTitle:@"取消" leftButtonHandle:^{
    NSLog(@"取消按钮被点击");
 } rightButtonTitle:@"确认" rightButtonHandle:^{
    NSLog(@"确认按钮被点击");
 }];
 
 使用对象方法时要使用
 

[view show]进行弹框展示, 
在合适的地方用[view hidden] 来实现弹框的隐藏.

注意: Action_target中实现Action方法时要记得手动隐藏 
隐藏方法如下:

   - (void)hidden;

   + (void)hiddenFromWindow;

.h里暴露的对象属性可以针对弹框做一些文字颜色,大小,和弹框各部分的背景色的设置.

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







