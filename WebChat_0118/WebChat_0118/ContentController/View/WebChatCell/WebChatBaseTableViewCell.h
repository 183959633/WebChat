//
//  WSChatBaseTableViewCell.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebChatModel.h"
#import <Masonry.h>
#define kDefaultCellHeight            (44)//默认Cell高度
#define kHeadLength                   (40)//正方形头像边长
#define kHeadTop                      (10)//头像离父视图顶部距离
#define kImageViewTopSuperView        (15)//背景框距离父视图顶部距离
#define kMargin                       (10)//头像外边距
#define kImageViewMargin              (30)//设置背景框拉伸不变形范围
#define kOffsetHHeadToBubble          (0)//背景框与头像间距

#define kReuseIDSeparate               (@"-") //可重用ID字符串区分符号

#define kImageNameChat_send_nor        (@"chat_send_nor")
#define kImageNameChat_send_press      (@"chat_send_press_pic")


#define kImageNameChat_Recieve_nor     (@"chat_recive_nor")
#define kImageNameChat_Recieve_press   (@"chat_recive_press_pic")


@interface WebChatBaseTableViewCell : UITableViewCell
{
    @public
    
    /**
     *  @brief  头像
     */
    UIImageView *mHead;
    
    /**
     *  @brief  汽包
     */
    UIImageView *mBubbleImageView;

    /**
     *  @brief  本消息是否是本人发送的？
     */
    BOOL isSender;
}
//聊天消息中单条消息模型
@property(nonatomic,strong) WebChatModel *model;
@end
