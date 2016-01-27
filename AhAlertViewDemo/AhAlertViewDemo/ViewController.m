//
//  ViewController.m
//  AhAlertViewDemo
//
//  Created by ah on 16/1/18.
//  Copyright © 2016年 ah. All rights reserved.
//

//  这是一个简单弹框展示的Demo  demo中多数用了类方法 你可以尝试下对象方法 有疑问可以发我邮件

//  邮箱地址: zth0218@126.com 

#define AHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "ViewController.h"
#import "AhAlertView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *pwd;

@end

@implementation ViewController{
    
    NSArray *nameArr;
    NSArray *topArr;
    NSArray *AleArr;
    NSArray *sheetArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =@"AhAlertView展示框";
    
    nameArr =@[@"顶部提示框",@"中间提示框",@"底部提示框"];
    
    topArr =@[@"info",@"sus",@"war",@"error"];
    
    AleArr = @[@"提示类",@"1个按钮",@"2个按钮",@"按钮带输入框",@"按钮带富文本",@"按钮带长文本"];
    
    sheetArr = @[@"列表不滑动",@"列表滑动"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return topArr.count;
        }
        case 1:
        {
            return AleArr.count;
        }
        case 2:
        {
            return sheetArr.count;
        }
            break;
            
        default:
            break;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"a"];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = topArr[indexPath.row];
        }
            break;
        case 1:
        {
            cell.textLabel.text = AleArr[indexPath.row];
        }
            break;
        case 2:
        {
            cell.textLabel.text = sheetArr[indexPath.row];
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return @"顶部提示框";
        }
            break;
        case 1:
        {
            return @"中部提示框";
        }
            break;
        case 2:
        {
            return @"底部提示框";
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [AhAlertView alertViewWithTopText:@"TopViewTypeInfo" DoHandle:^{
                        NSLog(@"info被点击");
                    } type:TopViewTypeInfo];
                }
                    break;
                case 1:
                {
                    [AhAlertView alertViewWithTopText:@"TopViewTypeSucess" DoHandle:nil type:TopViewTypeSucess];
                    
                }
                    break;
                case 2:
                {
                    [AhAlertView alertViewWithTopText:@"TopViewTypeWaring" DoHandle:nil type:TopViewTypeWaring];
                    
                }
                    break;
                    
                case 3:
                {
                    [AhAlertView alertViewWithTopText:@"TopViewTypeError" DoHandle:nil type:TopViewTypeError];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            // AleArr = @[@"提示类",@"1个按钮",@"2个按钮",@"按钮带输入框",@"按钮带富文本"];
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [AhAlertView alertViewWithTitle:@"提示" message:@"快速提示框"];
                }
                    break;
                case 1:
                {
                    [AhAlertView alertViewWithTitle:@"提示" message:@"这个也可以使用Target-Action" confirmButtonTitle:@"确认" confirmButtonHandle:^{
                        NSLog(@"确认按钮被点击");
                    }];
                }
                    break;
                case 2:
                {
                    AhAlertView *view = [[AhAlertView alloc]initWithTitle:@"提示" message:@"这是2个按钮的对象方法展示" leftButtonTitle:@"取消" leftButtonHandle:^{
                         NSLog(@"取消按钮被点击");
                    } rightButtonTitle:@"确认" rightButtonHandle:^{
                         NSLog(@"确认按钮被点击");
                    }];
                    [view show];
                }
                    break;
                case 3:
                {
                   [AhAlertView alertViewWithtextFieldAndTitle:@"提示" message:@"¥888" OtherMessage:@"钱包支付" confirmbuttonTitle:@"确认" confirmHandel:^{
                       
                       NSLog(@"===密码===%@",self.pwd);
                   } textHandel:^(NSString *text) {
                       self.pwd=text;
                       NSLog(@"获取的密码===%@",self.pwd);
                   }];
                }
                    break;
                case 4:
                {
                    [AhAlertView alertViewWithTitle:@"提示" AttributedString:[self creatAgreementStr] leftButtonTitle:nil leftButtonHandle:nil rightButtonTitle:@"好的" rightButtonHandle:^{
                        NSLog(@"好的被点击");
                    } doHandle:^{
                        NSLog(@"跳转到协议");
                    }];
                }
                    break;
                case 5:
                {
                    [AhAlertView alertViewWithTitle:@"提示" DescString:@"本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试长文本测试" leftButtonTitle:@"取消'" leftButtonHandle:^{
                        NSLog(@"取消");
                    } rightButtonTitle:@"确认" rightButtonHandle:^{
                        NSLog(@"确认");
                    }];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    AhAlertView *view = [[AhAlertView alloc]initWithSheetViewTitleArr:@[@"照相机",@"相册"] sheetHandle:^(NSInteger index) {
                        switch (index) {
                            case 0:
                            {
                                NSLog(@"照相机被点击");
                            }
                                break;
                            case 1:
                            {
                                NSLog(@"相册被点击");
                            }
                                break;
                                
                            default:
                                break;
                        }
                    } cancleHandle:^{
                        NSLog(@"取消被点击");
                    }];
                    
                    [view show];
                }
                    break;
                case 1:
                {
                    AhAlertView *view = [[AhAlertView alloc]initWithSheetViewTitleArr:@[@"照相机",@"相册",@"电视机",@"投影机",@"照相机",@"相册",@"电视机",@"投影机"] sheetHandle:^(NSInteger index) {
                        
                        NSLog(@"%zd行被点击",index);
                    } cancleHandle:^{
                        NSLog(@"取消被点击");
                    }];
                    
                    [view show];

                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }

}

/**协议文字*/
- (NSMutableAttributedString*)creatAgreementStr{
    
    // 已认购
    NSString *str01 = @"\"投资理财频道\"  将获取您的个人信息,授权后表明您已同意";
    NSString *str02 = @"《*******注册协议》";
    NSMutableAttributedString *str0 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",str01,str02]];
    
    [str0 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str01.length)];
    [str0 addAttribute:NSForegroundColorAttributeName value:AHColor(21, 148, 255) range:NSMakeRange(str01.length, str02.length)];
    [str0 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str01.length)];
    [str0 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(str01.length, str02.length)];
    return str0;
}




@end
