//
//  ttCell.m
//  WebChat_0118
//
//  Created by Jack on 2018/2/5.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WebChatFlickerTableViewCell.h"
#import <Masonry.h>
@implementation WebChatFlickerTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUI];
        
    }
    return self;
}
#pragma 初始化UI界面
-(void)setUI{
    
    if (isSender)//是自己发送的消息
    {
        // 设置动画的播放次数
        mBubbleImageView.animationRepeatCount = 0;
        // 设置播放时长
        mBubbleImageView.animationDuration = 2.0;
        
        mBubbleImageView.animationImages =@[[UIImage imageNamed:@"chat_send_flicker03"],
                                            [UIImage imageNamed:@"chat_send_flicker04"],
                                            [UIImage imageNamed:@"chat_send_flicker05"]];
        
        [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
        }];
    }
}
@end
