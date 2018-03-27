//
//  JackHttp.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma 智能机器人ip地址
extern       NSString *const CSRBroker_URL;
#pragma IP地址
extern const NSString *IP_URL;
#pragma 登陆接口
extern const NSString *Login_URL;
#pragma 转人工接口
extern const NSString *Agent_URL;
#pragma 开启轮询
extern const NSString *MsgOpen_URL;
#pragma 轮询消息
extern const NSString *MsgPull_URL;
#pragma 与客服互动接口
extern const NSString *MsgTxt_URL;
#pragma 图片上传
extern const NSString *UpLoad_URL;

#pragma --------屏幕宽高宏定义
#define Screen_Width  ([[UIScreen mainScreen] bounds].size.width)
#define Screen_Height ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPHONE_X (Screen_Height == 812.0f) ? YES : NO
#define kTabHeight_IPHONE_X              (34)
@interface JackHttp : NSObject

@end
