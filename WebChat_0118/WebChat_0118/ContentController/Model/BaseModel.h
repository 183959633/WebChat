//
//  BaseModel.h
//  WebChat
//
//  Created by Jack on 2018/1/8.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
#pragma 基类BaseModel初始化
- (instancetype)initWithDic:(NSDictionary*)dic;
#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
#pragma mark po或者打印时打出内部信息
-(NSString *)description;
#pragma mark 获取一个类的属性列表
- (NSArray *)filterPropertys;
#pragma mark 模型中的字符串类型的属性转化为字典
-(NSDictionary*)modelStringPropertiesToDictionary;
@end
