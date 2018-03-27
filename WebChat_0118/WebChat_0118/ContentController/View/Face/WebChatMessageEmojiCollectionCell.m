//
//  WebChatMessageEmojiCollectionCell.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//


#import "WebChatMessageEmojiCollectionCell.h"
#import <Masonry.h>

static NSInteger const  kimageSize = 28;
@interface WebChatMessageEmojiCollectionCell ()
{
    UIImageView *mImageView;
    UILabel     *kLabel;
}
@end

@implementation WebChatMessageEmojiCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}
#pragma 初始化UI界面
-(void)setUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    mImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:mImageView];
    mImageView.backgroundColor = [UIColor clearColor];
    
    [mImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kimageSize, kimageSize));
        make.centerX.equalTo(self.contentView);
    }];
}
-(void)setModel:(NSMutableDictionary *)model
{
    mImageView.image = [UIImage imageNamed:model[@"aImage"]];
}
@end
