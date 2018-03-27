//
//  LoginView.m
//  WebChat
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "LoginView.h"
#import <Masonry.h>
//168,205,252 Normal
//59,172,245 Selected

#define kclearColor                      ([UIColor clearColor])
#define kButtonBackgroundColor_Selected  ([UIColor colorWithRed:232/255.0f green:244/255.0f blue:251/255.0f alpha:1.0f])
#define kButtonTitleColor_Normal         ([UIColor colorWithRed:178/255.0f green:211/255.0f blue:255/255.0f alpha:1.0f])
#define kButtonTitleColor_Selected       ([UIColor colorWithRed:59/255.0f green:172/255.0f blue:245/255.0f alpha:1.0f])
@implementation LoginView
{
    
    
    UIButton      *phoneNumberButton;         /**手机号phoneNumber**/
    UIButton      *cardNumberButton;          /**账卡号cardNumber**/
    UILabel       *kNumberLabel;
    UILabel       *passwordLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.backgroundColor =kclearColor;
    UIView *topView =[[UIView alloc]init];
    [self addSubview:topView];
    //    80,158,228
    topView.backgroundColor =[UIColor colorWithRed:0/255.0f green:137/255.0f blue:255/255.0f alpha:1.0f];
    topView.layer.cornerRadius =20;
    topView.layer.borderWidth =2;
    //    209,236,242
    topView.layer.borderColor = [[UIColor colorWithRed:209/255.0f green:236/255.0f blue:242/255.0f alpha:1] CGColor];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(60);
        make.right.mas_equalTo(self.mas_right).offset(-60);
        make.height.mas_equalTo(44);
        
    }];
    phoneNumberButton =[[UIButton alloc]init];
    [topView addSubview:phoneNumberButton];
    phoneNumberButton.tag =101;
    //    232,244,251 默认选中
    phoneNumberButton.backgroundColor =kButtonBackgroundColor_Selected;
    //    phoneNumberButton.backgroundColor =[UIColor clearColor];
    phoneNumberButton.layer.cornerRadius =16;
    phoneNumberButton.layer.borderWidth =4;
    phoneNumberButton.layer.borderColor =[[UIColor clearColor] CGColor];
    [phoneNumberButton setTitle:@"手机号" forState:UIControlStateNormal];
    //    168,205,252 Normal
    //    59,172,245  Selected
    [phoneNumberButton setTitleColor:kButtonTitleColor_Selected forState:UIControlStateNormal];
    phoneNumberButton.titleLabel.font =[UIFont systemFontOfSize:18.0f];
    
    [phoneNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(4);
        make.left.mas_equalTo(topView.mas_left).offset(4);
        make.bottom.mas_equalTo(topView.mas_bottom).offset(-4);
        make.width.mas_equalTo(topView.mas_width).multipliedBy(0.5);
    }];
    
    cardNumberButton =[[UIButton alloc]init];
    [topView addSubview:cardNumberButton];
    cardNumberButton.tag =102;
    //232,244,251
    cardNumberButton.backgroundColor =kclearColor;
    cardNumberButton.layer.cornerRadius =16;
    cardNumberButton.layer.borderWidth =4;
    cardNumberButton.layer.borderColor =[[UIColor clearColor] CGColor];
    [cardNumberButton setTitle:@"账卡号" forState:UIControlStateNormal];
    //168,205,252 Normal
    //59,172,245 Selected
    [cardNumberButton setTitleColor:kButtonTitleColor_Normal forState:UIControlStateNormal];
    cardNumberButton.titleLabel.font =[UIFont systemFontOfSize:18.0f];
    [cardNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(4);
        make.right.mas_equalTo(topView.mas_right).offset(-4);
        make.bottom.mas_equalTo(topView.mas_bottom).offset(-4);
        make.width.mas_equalTo(topView.mas_width).multipliedBy(0.5);
    }];
    
    [phoneNumberButton addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];
    [cardNumberButton  addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];

    UIView *bottomView =[[UIView alloc]init];
    bottomView.backgroundColor =[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2];
    bottomView.layer.borderWidth=1.5;
    bottomView.layer.cornerRadius=2;
    bottomView.layer.borderColor=[[UIColor colorWithRed:209/255.0f green:236/255.0f blue:242/255.0f alpha:1] CGColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.mas_equalTo(240);
    }];

    UIView *phoneView =[[UIView alloc]init];
    [bottomView addSubview:phoneView];
    phoneView.backgroundColor =kclearColor;
    phoneView.layer.borderWidth=1.5;
    phoneView.layer.cornerRadius=2;
    phoneView.layer.borderColor=[[UIColor colorWithRed:255/255.0f green:255/255.0f  blue:255/255.0f  alpha:0.88] CGColor];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(30);
        make.left.equalTo(bottomView.mas_left).offset(22);
        make.right.equalTo(bottomView.mas_right).offset(-22);
        make.height.mas_equalTo(40);
    }];
    
    kNumberLabel =[[UILabel alloc]init];
    [phoneView addSubview:kNumberLabel];
    kNumberLabel.text =@"手机号码";
    kNumberLabel.textAlignment =NSTextAlignmentCenter;
    kNumberLabel.textColor =[UIColor whiteColor];
    kNumberLabel.font =[UIFont systemFontOfSize:16.0f];
    kNumberLabel.backgroundColor =kclearColor;
    [kNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_top).offset(0);
        make.left.equalTo(phoneView.mas_left).offset(0);
        make.bottom.equalTo(phoneView.mas_bottom).offset(-0);
        make.width.equalTo(phoneView.mas_width).multipliedBy(0.3);
    }];
    
    _kNumberTextField=[[UITextField alloc]init];
    [phoneView addSubview:_kNumberTextField];
    //225,237,254
    _kNumberTextField.placeholder =@"请输入手机号码";
    [_kNumberTextField setValue:[UIColor colorWithRed:225/255.0f green:237/255.0f blue:254/255.0f alpha:0.7f] forKeyPath:@"_placeholderLabel.textColor"];
    [_kNumberTextField setValue:[UIFont boldSystemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    _kNumberTextField.backgroundColor =kclearColor;
    _kNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    _kNumberTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    [_kNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_top).offset(0);
        make.left.equalTo(kNumberLabel.mas_right).offset(20);
        make.bottom.equalTo(phoneView.mas_bottom).offset(-0);
        make.right.equalTo(phoneView.mas_right).offset(-0);
        //        make.width.equalTo(phoneView.mas_width).multipliedBy(0.7);
    }];
    
    UIView *passwordView =[[UIView alloc]init];
    [bottomView addSubview:passwordView];
    passwordView.backgroundColor =kclearColor;
    passwordView.layer.borderWidth=1.5;
    passwordView.layer.cornerRadius=2;
    passwordView.layer.borderColor=[[UIColor colorWithRed:255/255.0f green:255/255.0f  blue:255/255.0f  alpha:0.88] CGColor];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(30);
        make.left.equalTo(bottomView.mas_left).offset(22);
        make.right.equalTo(bottomView.mas_right).offset(-22);
        make.height.mas_equalTo(40);
    }];
    passwordLabel =[[UILabel alloc]init];
    [passwordView addSubview:passwordLabel];
    passwordLabel.text =@"登录密码";
    passwordLabel.textAlignment =NSTextAlignmentCenter;
    passwordLabel.textColor =[UIColor whiteColor];
    passwordLabel.font =[UIFont systemFontOfSize:16.0f];
    passwordLabel.backgroundColor =kclearColor;
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_top).offset(0);
        make.left.equalTo(passwordView.mas_left).offset(0);
        make.bottom.equalTo(passwordView.mas_bottom).offset(-0);
        make.width.equalTo(passwordView.mas_width).multipliedBy(0.3);
    }];
    
    _passwordTextField=[[UITextField alloc]init];
    [passwordView addSubview:_passwordTextField];
    //225,237,254
    _passwordTextField.placeholder =@"请输入密码";
    [_passwordTextField setValue:[UIColor colorWithRed:225/255.0f green:237/255.0f blue:254/255.0f alpha:0.7f] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIFont boldSystemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    _passwordTextField.backgroundColor =kclearColor;
    _passwordTextField.secureTextEntry =YES;
    _passwordTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_top).offset(0);
        make.left.equalTo(passwordLabel.mas_right).offset(20);
        make.bottom.equalTo(passwordView.mas_bottom).offset(-0);
        make.right.equalTo(passwordView.mas_right).offset(-0);
        //        make.width.equalTo(passwordView.mas_width).multipliedBy(0.7);
    }];
    
    _loginButton = [[UIButton alloc]init];
    [bottomView addSubview:_loginButton];
    [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 4;
    _loginButton.titleLabel.font    = [UIFont systemFontOfSize:22.0f];
    //16,120,234
    _loginButton.backgroundColor    = [UIColor colorWithRed:16/255.0f green:120/255.0f blue:234/255.0f alpha:0.75f];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(30);
        make.left.equalTo(bottomView.mas_left).offset(22);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-30);
        make.right.equalTo(bottomView.mas_right).offset(-22);
        make.height.mas_equalTo(40);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_resignblock) {
        _resignblock();
    }
}
-(void)changeTitle:(UIButton *)sender{
    
    if (sender.tag ==101) {
        phoneNumberButton.backgroundColor = kButtonBackgroundColor_Selected;
        cardNumberButton.backgroundColor  = [UIColor clearColor];
        
        [phoneNumberButton setTitleColor:kButtonTitleColor_Selected forState:UIControlStateNormal];
        [cardNumberButton  setTitleColor:kButtonTitleColor_Normal forState:UIControlStateNormal];
        
        kNumberLabel.text             = @"手机号码";
        _kNumberTextField.placeholder = @"请输入手机号码";
    }else{
        cardNumberButton.backgroundColor  = kButtonBackgroundColor_Selected;
        phoneNumberButton.backgroundColor = [UIColor clearColor];
        
        [cardNumberButton  setTitleColor:kButtonTitleColor_Selected forState:UIControlStateNormal];
        [phoneNumberButton setTitleColor:kButtonTitleColor_Normal forState:UIControlStateNormal];
        
        kNumberLabel.text             = @"账卡号码";
        _kNumberTextField.placeholder = @"请输入账卡号码";
    }
}
@end
