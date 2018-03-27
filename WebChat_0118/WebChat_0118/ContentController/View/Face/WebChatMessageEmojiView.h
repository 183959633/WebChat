//
//  WebChatMessageEmojiView.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebChatMessageEmojiView;

@protocol WebChatKeyboardDelegate <NSObject>
- (void)stickerKeyboard:(WebChatMessageEmojiView *)stickerKeyboard didClickEmoji:(NSString *)emojiName;
- (void)stickerKeyboardDidClickDeleteButton:(WebChatMessageEmojiView *)stickerKeyboard;
- (void)stickerKeyboardDidClickSendButton:(WebChatMessageEmojiView *)stickerKeyboard;

@end

@interface WebChatMessageEmojiView : UIView
@property(nonatomic,weak) id <WebChatKeyboardDelegate> delegate;
@end
