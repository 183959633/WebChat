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
@property(nonatomic,strong)UITextField   *kNumberTextField;
@property(nonatomic,strong)UITextField   *passwordTextField;
@property(nonatomic,strong)UIButton      *loginButton;
@property(nonatomic,copy)resignBlock     resignblock;
@end
