//
//  WebChatMessageInputBar.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebChatModel.h"
#import "WebChatMessageMoreView.h"
#import "WebChatMessageEmojiView.h"
@class WebChatMessageInputBar;
typedef void (^dataBlock)(void);
@protocol WebChatMessageInputBarDelegate <NSObject>

@optional
- (void)stickerInputBarDidClickSendButton:(WebChatMessageInputBar *)inputView;
@end
@interface WebChatMessageInputBar : UIView
/**
 *  @brief  输入TextView/mInputButton
 */
@property(nonatomic,strong)UITextView *mInputTextView;
@property(nonatomic,strong)UIButton    *mInputButton;
/**
 *  @brief  录制语音按钮
 */
@property(nonatomic,strong)UIButton   *mVoiceBtn;
/**
 *  @brief  表情按钮
 */
@property(nonatomic,strong)UIButton   *mFaceBtn;
/**
 *  @brief  更多按钮
 */
@property(nonatomic,strong)UIButton   *mMoreBtn;
/**
 *  @brief  更多视图
 */
@property(nonatomic,strong)WebChatMessageMoreView  *mMoreView;
/**
 *  @brief  表情视图
 */
@property(nonatomic,strong)WebChatMessageEmojiView  *mFaceView;
@property(nonatomic,copy)dataBlock datablock;
@property(nonatomic,weak) id <WebChatMessageInputBarDelegate> delegate;
@end

