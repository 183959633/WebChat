//
//  WSChatImageTableViewCell.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatImageTableViewCell.h"
#import <Masonry.h>
#define kImageViewPadding            (5)//图片距离背景框内间距
#define kImageViewMaxHeight          (200)//展示图片最大高度

@interface WebChatImageTableViewCell ()
{
    //展示图片kImageView
    UIImageView * kImageView;
}
@end

@implementation WebChatImageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    
    kImageView = [[UIImageView alloc]init];
    kImageView.backgroundColor = [UIColor clearColor];
    kImageView.userInteractionEnabled = NO;
    [self.contentView insertSubview:kImageView atIndex:0];
    
    [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.lessThanOrEqualTo(@(kImageViewMaxHeight+kMargin));
    }];
    
    [kImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mBubbleImageView.mas_top).offset(kImageViewPadding);
        make.left.equalTo(mBubbleImageView.mas_left).offset(kImageViewPadding);
        make.bottom.equalTo(mBubbleImageView.mas_bottom).offset(-kImageViewPadding);
        make.right.equalTo(mBubbleImageView.mas_right).offset(-kImageViewPadding);
        make.height.lessThanOrEqualTo(@(kImageViewMaxHeight));
    }];
    
    if (isSender)//是自己发送的消息
    {
        mBubbleImageView.image = [[UIImage imageNamed:@"chat_send_imagemask"] stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];
        
        [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(@(5*kMargin));
        }];
        
    }else//是对方发送的消息
    {
        mBubbleImageView.image = [[UIImage imageNamed:@"chat_recive_imagemask"]stretchableImageWithLeftCapWidth:kImageViewMargin topCapHeight:kImageViewMargin];

        [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.greaterThanOrEqualTo(@(-5*kMargin));
        }];
        
    }
}
-(void)setModel:(WebChatModel *)model
{
    kImageView.image = model.aImage;
}
@end
