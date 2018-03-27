//
//  WebChatModel.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseModel.h"

@class WebChatBaseTableViewCell;
#define kCellReuseIDWithSenderAndType(isSender,chatCellType)    ([NSString stringWithFormat:@"%@-%@",isSender,chatCellType])

//根据模型得到可重用Cell的 重用ID
#define kCellReuseID(model)      ((model.chatCellType.integerValue == WebChatCellType_Time)?kTimeCellReusedID:(kCellReuseIDWithSenderAndType(model.isSender,model.chatCellType)))


/**
 *  @brief  消息类型
 */
typedef NS_ENUM (NSUInteger, WebChatCellType) {
    /** 文本消息*/
    WebChatCellType_Text  = 1,
    /** 图片消息*/
    WebChatCellType_Image = 2,
    /** 语音消息*/
    WebChatCellType_Audio = 3,
    /** 视频消息*/
    WebChatCellType_Video = 4,
    /** 时间*/
    WebChatCellType_Time  = 5,
    /** 预录音*/
    WebChatCellType_Flicker =6
};
@interface WebChatModel : BaseModel
#pragma 带表情的文本内容
@property(nonatomic,copy)     NSAttributedString *AttributedanswerMsg;
#pragma 发送的图片 imge
@property(nonatomic,strong)   UIImage   *aImage;
#pragma 是否为本人发送的标识,BOOL("YES"为本人,"NO"为他人)
@property(nonatomic,assign)   BOOL      isSender;
#pragma answerTypeId=5
@property(nonatomic,retain)   NSArray   *vagueList;
#pragma 录音时长
@property(nonatomic,copy)     NSString  *aAudiotime;
#pragma 录音文件路径
@property(nonatomic,copy)     NSString  *aAudioPath;
#pragma 消息类型
@property (nonatomic,assign)  WebChatCellType  chatCellType;
@end
