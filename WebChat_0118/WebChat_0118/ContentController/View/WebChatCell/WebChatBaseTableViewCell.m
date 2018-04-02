//
//  WSChatBaseTableViewCell.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatBaseTableViewCell.h"
#import <Masonry.h>
@implementation WebChatBaseTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        mHead = [[UIImageView alloc]init];
        mHead.layer.masksToBounds = YES;
        mHead.layer.cornerRadius  = 20;
        mHead.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mHead];
        
        [mHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kHeadTop);
            make.size.mas_equalTo(CGSizeMake(kHeadLength,kHeadLength));
        }];
        
        mBubbleImageView = [[UIImageView alloc]init];
        mBubbleImageView.userInteractionEnabled = YES;
        mBubbleImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mBubbleImageView];
        
        [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kImageViewTopSuperView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-2*kMargin);
        }];
        
        NSArray *IDs = [reuseIdentifier componentsSeparatedByString:kReuseIDSeparate];
        NSAssert(IDs.count >= 2, @"reuseIdentifier should be separate by -");
        isSender = [IDs[0] boolValue];
    
        if (isSender)//是我自己发送的
        {
            // mHead右边👉距离Superview 10
            [mHead mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kMargin);
            }];
            mHead.image = [UIImage imageNamed:@"icon_01"];
            
            mBubbleImageView.image = [[UIImage imageNamed:kImageNameChat_send_nor] stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];
            
            mBubbleImageView.highlightedImage = [[UIImage imageNamed:kImageNameChat_send_press] stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];
                        
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(mHead.mas_left).offset(-kOffsetHHeadToBubble);
            }];
        }else//别人发送的消息
        {
            // mHead左边👉距离Superview 10
            [mHead mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(kMargin);
            }];
            mHead.image = [UIImage imageNamed:@"icon_02"];
            
            mBubbleImageView.image = [[UIImage imageNamed:kImageNameChat_Recieve_nor]stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];
            mBubbleImageView.highlightedImage = [[UIImage imageNamed:kImageNameChat_Recieve_press] stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];
            
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mHead.mas_right).offset(kOffsetHHeadToBubble);
            }];
        }
    }
    return self;
}
@end
