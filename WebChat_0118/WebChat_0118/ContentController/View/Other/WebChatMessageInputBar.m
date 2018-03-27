//
//  WebChatMessageInputBar.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatMessageInputBar.h"

#import "JackHttp.h"
#import <Masonry.h>
#import "WebChatMessageEmojiView.h"
//背景颜色
#define kbackgroundColor               ([UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1])
//默认边距
#define kDefaultMargin              (4)
//输入框最小高度
#define kMinHeightTextView          (36)
//输入框最大高度
#define kMaxHeightTextView          (84)
//_inputBar默认高度
#define kDefaultheight              (44)
//faceView 和 moreView 内_inputBar统一高度
#define kFaceViewAndMoreViewDefault_inputBarheight     (220)
@interface WebChatMessageInputBar ()<UITextViewDelegate,WebChatKeyboardDelegate>
@end
@implementation WebChatMessageInputBar
{
    CGFloat contentHeight;  //
}
#pragma mark - Override System Method
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kbackgroundColor;
        /**
         *  @brief  增加录音按钮
         */
        [self addSubview:self.mVoiceBtn];
        [self addSubview:self.mInputTextView];
        [self addSubview:self.mInputButton];
        [self addSubview:self.mFaceBtn];
        [self addSubview:self.mMoreBtn];
        
        [self.mVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.mas_left).offset(0);
        }];
        
        /**
         *  @brief  增加输入框/录音框
         */
        [self.mInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.mVoiceBtn.mas_right).offset(0);
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.height.mas_equalTo(kMinHeightTextView);
        }];
        
        [self.mInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.mVoiceBtn.mas_right).offset(0);
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.height.mas_equalTo(kMinHeightTextView);
        }];
        
        /**
         *  @brief  增加表情按钮
         */
        [self.mFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultMargin);
            if (_mInputTextView) {
                make.left.equalTo(self.mInputTextView.mas_right).offset(0);
            }else
            {
                make.left.equalTo(self.mInputButton.mas_right).offset(0);
            }
        }];
        /**
         *  @brief  增加更多按钮
         */
        [self.mMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultMargin);
            make.left.equalTo(self.mFaceBtn.mas_right).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
        }];
        
        /**
         *  @brief  监听键盘显示、隐藏变化，让自己伴随键盘移动
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 伴随键盘移动
-(void)keyboardChange:(NSNotification *)keyboard
{
    //获取键盘的高度
    NSDictionary *userInfo = keyboard.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    if (keyboard.name == UIKeyboardWillShowNotification)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-height);
        }];
    }
    else
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_X) {
                make.bottom.mas_equalTo(-kTabHeight_IPHONE_X);
            }else{
                make.bottom.mas_equalTo(0);
            }
        }];
    }
}
#pragma mark - 录音点击事件处理
-(void)voiceBtnClick:(UIButton*)sender
{
    if (_mMoreView)
    {//如果当前还在显示更多视图，则隐藏他先
        [self moreBtnClick:_mMoreBtn];
    }
    if (_mFaceView)
    {//如果当前还在显示表情视图，则隐藏他先
        [self faceBtnClick:_mFaceBtn];
    }
    if (sender.selected)
    {
        _mInputButton.hidden=YES;
        _mInputTextView.hidden =NO;
        [_mInputTextView becomeFirstResponder];
        if (contentHeight > kMinHeightTextView)
        {
            //如果当前高度需要调整，就调整，避免多做无用功
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight+2*kDefaultMargin);
            }];
        }else if (contentHeight < kMinHeightTextView){
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMinHeightTextView);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kDefaultheight);
            }];
        }
    }else
    {
        _mInputTextView.hidden =YES;
        _mInputButton.hidden=NO;
        [_mInputTextView resignFirstResponder];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kDefaultheight);
        }];
    }
    sender.selected = !sender.selected;
}
//表情视图
-(void)faceBtnClick:(UIButton*)sender
{
    if (_mVoiceBtn.selected) {
        //修改_mVoiceBtn状态
        _mVoiceBtn.selected=NO;
    }
    if (_mMoreView)
    {
        //如果当前还在显示更多视图，则隐藏他先
        [self moreBtnClick:self.mMoreBtn];
    }
    if (sender.selected)
    {
        //移除_mFaceView，唤起键盘
        [_mFaceView removeFromSuperview];
        _mFaceView = nil;
        [self.mInputTextView becomeFirstResponder];
        //更新_inputBar高度
        if (contentHeight > kMinHeightTextView)
        {
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight+2*kDefaultMargin);
            }];
        }else if (contentHeight < kMinHeightTextView){
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMinHeightTextView);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kDefaultheight);
            }];
        }
    }else
    {
        //隐藏_mInputButton,显示_mInputTextView
        _mInputButton.hidden=YES;
        _mInputTextView.hidden =NO;
        //初始化_mFaceView,收起键盘
        _mFaceView = [[WebChatMessageEmojiView alloc]init];
        _mFaceView.delegate =self;
        [self addSubview:_mFaceView];
        [_mFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultheight);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.mas_equalTo(self.mas_width);
        }];
        //更新_inputBar高度
        if (contentHeight > kMinHeightTextView)
        {
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight+2*kDefaultMargin+(kFaceViewAndMoreViewDefault_inputBarheight-kDefaultheight));
            }];
            [_mFaceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(contentHeight+2*kDefaultMargin);
            }];
        }else if (contentHeight < kMinHeightTextView){
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMinHeightTextView);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kFaceViewAndMoreViewDefault_inputBarheight);
            }];
            [_mFaceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(kDefaultheight);
            }];
        };
        [self.mInputTextView resignFirstResponder];
    }
    sender.selected = !sender.selected;
}
//更多按钮事件
-(void)moreBtnClick:(UIButton*)sender
{
    if (_mFaceView)
    {//如果当前还在显示表情视图，则隐藏他先
        [self faceBtnClick:_mFaceBtn];
        //        [_mFaceView removeFromSuperview];
    }
    if (_mVoiceBtn.selected) {
        //修改_mVoiceBtn状态
        _mVoiceBtn.selected =NO;
    }
    if (_mFaceBtn.selected) {
        //修改_mFaceBtn状态
        _mFaceBtn.selected =NO;
    }
    if (sender.selected) {
        //移除_mMoreView，唤起键盘
        [_mMoreView removeFromSuperview];
        _mMoreView = nil;
        [_mInputTextView becomeFirstResponder];
        //更新_inputBar高度
        if (contentHeight > kMinHeightTextView)
        {
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight+2*kDefaultMargin);
            }];
        }else if (contentHeight < kMinHeightTextView){
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMinHeightTextView);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kDefaultheight);
            }];
        };
    }else{
        //隐藏_mInputButton,显示_mInputTextView
        _mInputButton.hidden=YES;
        _mInputTextView.hidden =NO;
        //初始化_mMoreView,收起键盘
        _mMoreView = [[WebChatMessageMoreView alloc]init];
        [self addSubview:_mMoreView];
        [_mMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultheight);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.mas_equalTo(self.mas_width);
        }];
        //更新_inputBar高度
        if (contentHeight > kMinHeightTextView)
        {
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight+2*kDefaultMargin+(kFaceViewAndMoreViewDefault_inputBarheight-kDefaultheight));
            }];
            [_mMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(contentHeight+2*kDefaultMargin);
            }];
        }else if (contentHeight < kMinHeightTextView){
            [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMinHeightTextView);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kFaceViewAndMoreViewDefault_inputBarheight);
            }];
            [_mMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(kDefaultheight);
            }];
        };
        [self.mInputTextView resignFirstResponder];
    }
    sender.selected = !sender.selected;
}
#pragma mark - Getter Method
-(UIButton *)mVoiceBtn
{
    if (_mVoiceBtn) {
        return _mVoiceBtn;
    }
    _mVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mVoiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _mVoiceBtn.backgroundColor = [UIColor clearColor];
    [_mVoiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [_mVoiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
    [_mVoiceBtn  setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
    
    return _mVoiceBtn;
}
-(UITextView *)mInputTextView
{
    if (_mInputTextView) {
        return _mInputTextView;
    }
    _mInputTextView = [[UITextView alloc]init];
    _mInputTextView.delegate = self;
    _mInputTextView.layer.borderWidth=1;
    _mInputTextView.layer.cornerRadius = 4;
    _mInputTextView.layer.masksToBounds = YES;
    _mInputTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    _mInputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 4.0f);
    _mInputTextView.contentInset = UIEdgeInsetsZero;
    _mInputTextView.scrollEnabled = NO;
    _mInputTextView.scrollsToTop = NO;
    _mInputTextView.userInteractionEnabled = YES;
    _mInputTextView.font = [UIFont systemFontOfSize:14];
    _mInputTextView.textColor = [UIColor blackColor];
    _mInputTextView.backgroundColor = [UIColor whiteColor];
    _mInputTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    _mInputTextView.keyboardType = UIKeyboardTypeDefault;
    _mInputTextView.returnKeyType = UIReturnKeySend;
    _mInputTextView.textAlignment = NSTextAlignmentLeft;
    _mInputTextView.tag =101;
    return _mInputTextView;
    
}
-(UIButton *)mInputButton
{
    if (_mInputButton) {
        return _mInputButton;
    }
    _mInputButton = [[UIButton alloc]init];
    _mInputButton.hidden =YES;
    [_mInputButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    _mInputButton.layer.borderWidth=1;
    _mInputButton.layer.cornerRadius = 4;
    _mInputButton.layer.masksToBounds = YES;
    _mInputButton.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    _mInputButton.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [_mInputButton setTitleColor:[UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1.0f] forState:UIControlStateNormal];
    _mInputButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    _mInputButton.backgroundColor = [UIColor whiteColor];
    
    return _mInputButton;
}
-(UIButton *)mFaceBtn
{
    if (!_mFaceBtn) {
        _mFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mFaceBtn.backgroundColor = [UIColor clearColor];
        [_mFaceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [_mFaceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
        [_mFaceBtn  setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
        [_mFaceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mFaceBtn;
}
-(UIButton *)mMoreBtn
{
    if (!_mMoreBtn) {
        _mMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mMoreBtn.backgroundColor = [UIColor clearColor];
        [_mMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        [_mMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
        [_mMoreBtn  setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
        [_mMoreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mMoreBtn;
}
#pragma mark -TextView Delegate
//输入框获取输入焦点后，隐藏其他视图
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (_mMoreView)
    {//如果当前还在显示更多视图，则隐藏先
        [self moreBtnClick:self.mMoreBtn];
    }
    if (_mFaceView)
    {
        [self faceBtnClick:self.mFaceBtn];
    }
}
#pragma 动态计算inputTextView高度
-(void)reckonInputTextViewHeight{
    
    //计算输入框最小高度
    CGSize size =  [_mInputTextView sizeThatFits:CGSizeMake(_mInputTextView.contentSize.width, 0)];
    
    //输入框的高度不能超过最大高度
    if (size.height > kMaxHeightTextView)
    {
        contentHeight = kMaxHeightTextView;
        _mInputTextView.scrollEnabled = YES;
    }else
    {
        contentHeight = size.height;
        _mInputTextView.scrollEnabled = NO;
    }
    
    if (contentHeight > kMinHeightTextView)
    {
        [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight+2*kDefaultMargin+(kFaceViewAndMoreViewDefault_inputBarheight-kDefaultheight));
        }];
        [_mFaceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(contentHeight+2*kDefaultMargin);
        }];
    }else if (contentHeight < kMinHeightTextView){
        [self.mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kMinHeightTextView);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFaceViewAndMoreViewDefault_inputBarheight);
        }];
        [_mFaceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kDefaultheight);
        }];
    };
    
}
//根据输入文字多少，自动调整输入框的高度
-(void)textViewDidChange:(UITextView *)textView
{
    //计算输入框最小高度
    CGSize size =  [_mInputTextView sizeThatFits:CGSizeMake(_mInputTextView.contentSize.width, 0)];
    
    //输入框的高度不能超过最大高度
    if (size.height > kMaxHeightTextView)
    {
        contentHeight = kMaxHeightTextView;
        _mInputTextView.scrollEnabled = YES;
    }else
    {
        contentHeight = size.height;
        _mInputTextView.scrollEnabled = NO;
    }
    
    if (contentHeight > kMinHeightTextView)
    {
        //如果当前高度需要调整，就调整，避免多做无用功
        [_mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight+2*kDefaultMargin);
        }];
        
    }else if (contentHeight < kMinHeightTextView){
        [_mInputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kMinHeightTextView);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kDefaultheight);
        }];
    }
}
//判断用户是否点击了键盘发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{   //点击了发送按钮
    if ([text isEqualToString:@"\n"])
    {
        if (![textView.text isEqualToString:@""])
        {
            //输入框当前有数据才需要发送
            if (self.delegate &&[self.delegate respondsToSelector:@selector(stickerInputBarDidClickSendButton:)]) {
                [self.delegate stickerInputBarDidClickSendButton:self];
            }
            textView.text =@"";
            [self textViewDidChange:textView];
        }
        return NO;
    }
    return YES;
}
#pragma mark - PPStickerKeyboardDelegate
- (void)stickerKeyboard:(WebChatMessageEmojiView *)stickerKeyboard didClickEmoji:(NSString *)emojiName
{
    if (!emojiName) {
        return;
    }
    UIImage *emojiImage = [UIImage imageNamed:emojiName];
    if (!emojiImage) {
        return;
    }
    //初始化属性字符串对象
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_mInputTextView.attributedText];
    //初始化一个属性字符串附件对象
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = emojiImage;
    textAttachment.bounds = CGRectMake(0, -3, 14, 14);
    //将附件转换成属性字符串
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //index为用户指定要插入图片的位置
    //将转换后的属性字符串插入到目标字符串
    [string insertAttributedString:textAttachmentString atIndex:_mInputTextView.selectedRange.location];
    _mInputTextView.attributedText = string;
    
    [self reckonInputTextViewHeight];
    
}
-(void)stickerKeyboardDidClickDeleteButton:(WebChatMessageEmojiView *)stickerKeyboard{
    
    NSRange selectedRange = _mInputTextView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_mInputTextView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        _mInputTextView.attributedText = attributedText;
        _mInputTextView.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - 1, 1)];
        _mInputTextView.attributedText = attributedText;
        _mInputTextView.selectedRange = NSMakeRange(selectedRange.location - 1, 0);
    }
    
    [self reckonInputTextViewHeight];
    
}
-(void)stickerKeyboardDidClickSendButton:(WebChatMessageEmojiView *)stickerKeyboard{
    //更新表情视图
    [self reckonInputTextViewHeight];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(stickerInputBarDidClickSendButton:)]) {
        if (![_mInputTextView.text isEqualToString:@""]) {
             [self.delegate stickerInputBarDidClickSendButton:self];
        }
       
    }
    _mInputTextView.text =@"";
    
}
@end

