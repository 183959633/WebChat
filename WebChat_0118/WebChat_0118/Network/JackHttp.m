//
//  JackHttp.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "JackHttp.h"
#pragma 智能机器人接口
NSString *const CSRBroker_URL  = @"http://172.17.6.66:8080/CSRBroker/queryAction";
#pragma 小查 IP
//const NSString *IP_URL       = @"http://172.17.3.89:2017/";
#pragma 内网 IP 地址
NSString *const IP_URL         = @"http://172.17.6.33:2017/";
#pragma 登陆接口
NSString *const Login_URL      = @"webchat/user/login";
#pragma 转人工接口
NSString *const Agent_URL      = @"webchat/customer/agent";
#pragma 开启轮询
NSString *const MsgOpen_URL    = @"webchat/customer/msg/open";
#pragma 轮询消息
NSString *const MsgPull_URL    = @"webchat/customer/msg/pull" ;
#pragma 与客服互动接口
NSString *const MsgTxt_URL     = @"webchat/customer/msg/txt/send";
#pragma 图片上传
NSString *const UpLoad_URL     = @"webchat/customer/upload";
@implementation JackHttp
 
@end
