//
//  WSChatVoiceTableViewCell.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatVoiceTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#define kHMinOffsetSecondLable_supView            (40)  //水平方向上，秒数Lable和父控件之间最小间隙
#define kHOffsetSecondLable_voiceImageView        (10)  //水平方向上，秒数Lable和喇叭ImageVIew之间的间隙
#define kHOffsetSecondLable_BubbleView            (20)  //水平方向上，秒数Lable和气泡之间的间隙
#define kHOffsetVoiceImage_BubbleView             (25)  //水平方向上，喇叭和气泡之间的间隔
#define kVOffsetSecondLable_BubbleView            (20)   //垂直方向上，秒数Lable和气泡顶部间隔

//对方秒数Lable 字体颜色
#define kTextColorSecondLable_Receive             ([UIColor blackColor])
#define kTextColorSecondLable_Sender              ([UIColor whiteColor])


@interface WebChatVoiceTableViewCell ()
{
    //声音秒数
    UILabel             *kSecondLable;
    //喇叭
    UIImageView         *kVoiceImageView;
    //全局定时器对象
    NSTimer             *timer;
    //数据模型
    WebChatModel        *t_model;
    //音频播放对象
    AVAudioPlayer       *t_player;
}
@end

@implementation WebChatVoiceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTape)];
        mBubbleImageView.userInteractionEnabled = YES;
        [mBubbleImageView addGestureRecognizer:tap];
        
        kSecondLable = [[UILabel alloc]init];
        kSecondLable.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:kSecondLable];
        
        
        [kSecondLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mBubbleImageView.mas_top).offset(20);
            make.bottom.equalTo(mBubbleImageView.mas_bottom).offset(-24);
            make.width.mas_equalTo(30);
        }];
        
        kVoiceImageView = [[UIImageView  alloc]init];
        kVoiceImageView.backgroundColor= [UIColor clearColor];
        [self.contentView addSubview:kVoiceImageView];
        
        CGFloat scale = 0.6;
        [kVoiceImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(29 *scale, 33*scale));
            make.top.equalTo(mBubbleImageView.mas_top).offset(20);
            make.bottom.equalTo(mBubbleImageView.mas_bottom).offset(-20);
        }];
        kVoiceImageView.animationDuration = 1;
        kVoiceImageView.animationRepeatCount = 0;
        
        if (isSender)
        {
            kSecondLable.textColor = kTextColorSecondLable_Sender;
            kVoiceImageView.image = [UIImage imageNamed:@"chat_voice_sender3"];
            kVoiceImageView.animationImages = @[[UIImage imageNamed:@"chat_voice_sender1"],
                                                [UIImage imageNamed:@"chat_voice_sender2"],
                                                [UIImage imageNamed:@"chat_voice_sender3"]];
            [kVoiceImageView  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(mBubbleImageView.mas_right).offset(-24);
            }];
            [kSecondLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mBubbleImageView.mas_left).offset(24);
            }];
            
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
            }];
        }
        
    }
    return self;
}

-(void)setModel:(WebChatModel *)model
{
    t_model = model;
    if (model.aAudiotime)
    {
        NSInteger kLength = [model.aAudiotime integerValue];
        if (kLength > 20) {
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(240);
            }];
        }else if (10 <= kLength && kLength <= 20) {
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(180);
            }];
        }else if(5 <= kLength && kLength <= 10){
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(140);
            }];
        }else{
            [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
            }];
        }
        kSecondLable.text =[NSString stringWithFormat:@"%@\"",model.aAudiotime];
        
    }
}
#pragma 开启播放录音
-(void)startTape{
    
    if (t_player.playing) {
        [self stopTape];
    }else{
        //播放录音动画
        [kVoiceImageView startAnimating];
        
        AVAudioSession *session =[AVAudioSession sharedInstance];
        NSURL *recordFileUrl = [NSURL fileURLWithPath:t_model.aAudioPath];
        t_player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordFileUrl error:nil];
        //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        //播放录音
        [t_player play];
        //添加定时器
        [self addTimer];
    }
    
}
#pragma 停止播放录音
-(void)stopTape{
    //停止录音动画
    [kVoiceImageView stopAnimating];
    //停止播放录音
    [t_player stop];
    //移除定时器
    [self removeTimer];

}
#pragma 添加定时器
- (void)addTimer
{
    double TimeInterval = [kSecondLable.text doubleValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(stopTape) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma 移除定时器
- (void)removeTimer
{
    [timer invalidate];
    timer = nil;
}
@end
