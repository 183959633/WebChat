//
//  RootViewController.m
//  WebChat_0118
//
//  Created by Jack on 2018/1/11.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "RootViewController.h"
#import "WebChatTableViewController.h"
#import <Masonry.h>
#import "LoginView.h"
#import "JackHttp.h"
#import <MBProgressHUD.h>
#import <PPNetworkHelper.h>
@interface RootViewController ()
@end
@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(LoginView*)logview{
    if (!_logview) {
        _logview = [[LoginView alloc]init];
    }
    return _logview;
}
-(void)setUI{
    
    self.view.backgroundColor =[UIColor clearColor];
    self.navigationController.navigationBarHidden =YES;
    
    UIImageView *backgroundImageView =[[UIImageView alloc]init];
    [self.view addSubview:backgroundImageView];
    backgroundImageView.backgroundColor =[UIColor clearColor];
    backgroundImageView.image =[UIImage imageNamed:@"background_img"];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    _logoImageView = [[UIImageView alloc]init];
    [self.view addSubview:_logoImageView];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImageView.backgroundColor =[UIColor clearColor];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (Screen_Height == 568) {
            make.top.lessThanOrEqualTo(@60);
        }else if(Screen_Height == 667){
            make.top.lessThanOrEqualTo(@80);
        }else{
            make.top.lessThanOrEqualTo(@100);
        }
        
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.lessThanOrEqualTo(@80);
    }];

    [self.view addSubview:self.logview];
    //初始化Loginview
    [_logview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(280);
    }];
    [_logview.loginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    _logview.resignblock = ^{
        [weakSelf updataLogview];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (notification.name == UIKeyboardWillShowNotification)
    {
        
        CGPoint accountCenter = CGPointMake(self.view.center.x, -200);
        
        [UIView animateWithDuration:2 animations:^{
            //设置_logoImageView位置到屏幕外-200
            _logoImageView.center = accountCenter;
            [_logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.lessThanOrEqualTo(@(-200));
                
            }];
        }];
        
        [_logview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view.mas_centerY).offset(-80);
        }];
        
    }
}
-(void)keyboardWillHide:(NSNotification*)notification{
    if (notification.name == UIKeyboardWillHideNotification)
    {
        //设置_logoImageView初始位置为屏幕外-200
        CGPoint accountCenter = CGPointMake(self.view.center.x, 200);
        
        [UIView animateWithDuration:2.0 // 动画时长
                              delay:0.0 // 动画延迟
             usingSpringWithDamping:1 // 类似弹簧振动效果 0~1
              initialSpringVelocity:8.0 // 初始速度
                            options:UIViewAnimationOptionCurveLinear // 动画过渡效果
                         animations:^{
                             _logoImageView.center = accountCenter;
                             [_logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 if (Screen_Height == 568) {
                                     make.top.lessThanOrEqualTo(@60);
                                 }else if(Screen_Height == 667){
                                     make.top.lessThanOrEqualTo(@80);
                                 }else{
                                     make.top.lessThanOrEqualTo(@100);
                                 }
                             }];
                         } completion:^(BOOL finished) {
                             // 动画完成后执行
                         }];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)updataLogview{
    
    [_logview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(0);
    }];
    [_logview.kNumberTextField  resignFirstResponder];
    [_logview.passwordTextField resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self updataLogview];
}
-(void)Login{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    WebChatTableViewController *WebChat =[[WebChatTableViewController alloc]init];
    [self.navigationController pushViewController:WebChat animated:NO];

//    NSMutableDictionary *parameterDic =[[NSMutableDictionary alloc]init];
//    [parameterDic setValue:@"jack"    forKey:@"username"];
//    [parameterDic setValue:@"password"forKey:@"password"];
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text     = @"Loading";
//    [PPNetworkHelper POST:CSRBroker_URL parameters:parameterDic responseCache:^(id responseCache) {
//        
//    } success:^(id responseObject) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        WebChatTableViewController *WebChat =[[WebChatTableViewController alloc]init];
//        [self.navigationController pushViewController:WebChat animated:NO];
//
//    } failure:^(NSError *error) {
//        NSLog(@"失败了===%@",error);
//    }];
}
@end
