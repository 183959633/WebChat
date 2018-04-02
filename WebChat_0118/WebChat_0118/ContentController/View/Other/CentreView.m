//
//  CentreView.m
//  WebChat
//
//  Created by Jack on 2018/1/9.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "CentreView.h"
#import <Masonry.h>
#pragma 默认边距
#define kDefaultMargin        (20)
#pragma 默认背景色
#define kbackgroundColor      ([UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.5])
@implementation CentreView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }
    return self;
}
-(void)setUI{
    
    self.backgroundColor     = kbackgroundColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 8;
    [self addSubview:self.kShowImageView];
    
    [self.kShowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(34);
        make.height.mas_offset(64);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kDefaultMargin);
    }];
    
    [self addSubview:self.kShowLabel];
    [self.kShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-kDefaultMargin);
        make.left.equalTo(self.mas_left).offset(kDefaultMargin);
        make.right.equalTo(self.mas_right).offset(-kDefaultMargin);
    }];
}
-(UIImageView *)kShowImageView
{
    if (!_mShowImageView) {
        _mShowImageView = [[UIImageView alloc]init];
        _mShowImageView.backgroundColor = [UIColor clearColor];
        _mShowImageView.image = [UIImage imageNamed:@"cancel_audio"];
        _mShowImageView.animationImages = @[[UIImage imageNamed:@"sender_audio_01"],
                                           [UIImage imageNamed:@"sender_audio_02"],
                                           [UIImage imageNamed:@"sender_audio_03"],
                                           [UIImage imageNamed:@"sender_audio_04"],
                                           [UIImage imageNamed:@"sender_audio_05"]];
        // 设置动画的播放次数
        _mShowImageView.animationRepeatCount = 0;
        // 设置播放时长
        _mShowImageView.animationDuration    = 2.0;
    }
    return _mShowImageView;
}
-(UILabel*)kShowLabel{
    
    if (!_mShowLabel) {
         _mShowLabel = [[UILabel alloc]init];
        _mShowLabel.text            = @"手指上滑,取消发送";
        _mShowLabel.textColor       = [UIColor whiteColor];
        _mShowLabel.backgroundColor = [UIColor clearColor];
        _mShowLabel.textAlignment   = NSTextAlignmentCenter;
        _mShowLabel.font            = [UIFont systemFontOfSize:14.0f];
    }
    return _mShowLabel;
}
@end
