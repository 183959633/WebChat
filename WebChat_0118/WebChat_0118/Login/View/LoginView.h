//
//  LoginView.h
//  WebChat
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^resignBlock)(void);
@interface LoginView : UIView
//暴露出去,隐藏键盘
@property(nonatomic,strong)UITextField   *kNumberTextField;
@property(nonatomic,strong)UITextField   *passwordTextField;
@property(nonatomic,strong)UIButton      *loginButton;/**登陆按钮loginButton**/
@property(nonatomic,copy)resignBlock     resignblock;
@end
