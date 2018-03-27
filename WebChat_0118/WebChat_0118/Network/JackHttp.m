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
const NSString *IP_URL         = @"http://172.17.6.33:2017/";
#pragma 登陆接口
const NSString *Login_URL      = @"webchat/user/login";
#pragma 转人工接口
const NSString *Agent_URL      = @"webchat/customer/agent";
#pragma 开启轮询
const NSString *MsgOpen_URL    = @"webchat/customer/msg/open";
#pragma 轮询消息
const NSString *MsgPull_URL    = @"webchat/customer/msg/pull" ;
#pragma 与客服互动接口
const NSString *MsgTxt_URL     = @"webchat/customer/msg/txt/send";
#pragma 图片上传
const NSString *UpLoad_URL     = @"webchat/customer/upload";
@implementation JackHttp
 
@end
