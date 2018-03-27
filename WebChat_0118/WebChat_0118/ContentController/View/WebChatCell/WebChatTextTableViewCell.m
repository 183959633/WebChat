//
//  WSChatTextTableViewCell.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatTextTableViewCell.h"
#import <Masonry.h>
#define kPadding                     (20)//子控件距离父控件的内边距
#define kLableMaxWidth               (260)//设置文本框最大宽度
#define kButtonMargin                (20)//默认动态创建的Button间距
#define kButtonHeight                (40)//默认动态创建的Button高度
NSString *const  kNotificationtitleLabel = @"kNotificationtitleLabel";
@interface WebChatTextTableViewCell ()
{
    //文本Lable
    UILabel                     *kTextLable;

    //动态添加的VagueListButton
    UIButton                    *kVagueListButton;
    
    //添加的VagueListButton个数
    NSInteger                   t_count;
}
@end
@implementation WebChatTextTableViewCell
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
    
    kTextLable =[[UILabel alloc]init];
    kTextLable.numberOfLines = 0;
    kTextLable.backgroundColor =[UIColor clearColor];
    kTextLable.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:kTextLable];

    [mBubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@(kLableMaxWidth+2*kMargin));
    }];
    
    [kTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mBubbleImageView).insets(UIEdgeInsetsMake(20,24,20,24));
        make.width.lessThanOrEqualTo(@(kLableMaxWidth));
    }];
    
}
-(void)setModel:(WebChatModel *)model{
    
    kTextLable.attributedText =model.AttributedanswerMsg;
    
    if (isSender)//是自己发送的消息
    {
        [kTextLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(mBubbleImageView).insets(UIEdgeInsetsMake(20,24,20,24));
        }];

    } else//是对方发送的消息
    {
        if(model.vagueList){
            t_count               = model.vagueList.count;
            NSArray  *t_vagueList = model.vagueList;

            for (int i=0; i<t_count; i++) {
                UIButton *findBtn = (UIButton *)[self.contentView viewWithTag:100+i];
                [findBtn removeFromSuperview];

                kVagueListButton = [[UIButton alloc]init];
                [self.contentView addSubview:kVagueListButton];
                kVagueListButton.tag =100+i;
                kVagueListButton.backgroundColor = [UIColor clearColor];
                [kVagueListButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                kVagueListButton.titleLabel.font =[UIFont systemFontOfSize:13.0f];
                [kVagueListButton setTitle:[NSString stringWithFormat:@"%i. %@",i+1,t_vagueList[i]] forState:UIControlStateNormal];
                [kVagueListButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                
                if (t_count ==1) {
                    [kVagueListButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(kTextLable.mas_bottom).offset((kButtonMargin+i*kButtonHeight));
                        make.left.equalTo(mBubbleImageView.mas_left).offset(24);
                        make.bottom.mas_equalTo(mBubbleImageView.mas_bottom).offset(-20);
                        make.width.lessThanOrEqualTo(@(kLableMaxWidth-20));
                        make.height.lessThanOrEqualTo(@(kButtonHeight));
                    }];

                    [kTextLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(mBubbleImageView.mas_top).offset(20);
                        make.left.equalTo(mBubbleImageView.mas_left).offset(24);
                        make.right.equalTo(mBubbleImageView.mas_right).offset(-24);
                        make.bottom.mas_equalTo(kVagueListButton.mas_top).offset(-20);
                    }];
                }else{
                    [kTextLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(mBubbleImageView.mas_top).offset(20);
                        make.left.equalTo(mBubbleImageView.mas_left).offset(24);
                        make.right.equalTo(mBubbleImageView.mas_right).offset(-24);
                        //####重置kTextLable底部距离contentView底部距离以约束文本内容####
                        make.bottom.equalTo(@(-(0+(kButtonHeight+kButtonMargin)*t_count)));
                    }];
                    [kVagueListButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(kTextLable.mas_bottom).offset((kButtonMargin+i*kButtonHeight));
                        make.left.equalTo(mBubbleImageView.mas_left).offset(24);
                        make.width.lessThanOrEqualTo(@(kLableMaxWidth-20));
                        make.height.lessThanOrEqualTo(@(kButtonHeight));
                    }];
                }
            }
        }else{
            [kTextLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(mBubbleImageView).insets(UIEdgeInsetsMake(20,24,20,24));
            }];
        }
    }
}
-(void)selected:(UIButton*)sender{
    
    NSString *aString;
    
    for (int i=0; i < t_count; i++) {
        if (sender.tag==100+i) {
            aString = [sender.titleLabel.text substringFromIndex:3];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationtitleLabel object:self userInfo:@{@"titleLabel":aString}];
        }
    }
}
#pragma 计算kTextLable高度
- (CGFloat)aHeightWithNSString:(NSString *)string
{
    NSDictionary *kFontArray = @{NSFontAttributeName : kTextLable.font};
    CGSize kSize = [kTextLable.text boundingRectWithSize:CGSizeMake(kLableMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:kFontArray context:nil].size;
    CGFloat kHeight = kSize.height;
    
    return kHeight;
}

@end
