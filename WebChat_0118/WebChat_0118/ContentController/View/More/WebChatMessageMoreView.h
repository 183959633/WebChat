//
//  WebChatMessageMoreView.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebChatModel.h"
extern NSString *const kNotificationImage;
/**
 *  @brief  更多、图片、段视频、文件等
 */
@interface WebChatMessageMoreView : UIView
/**
 *  @brief  选取图片按钮
 */
@property(nonatomic,strong)UIButton   *mPhotoBtn;
/**
 *  @brief  拍摄照片按钮
 */
@property(nonatomic,strong)UIButton   *mShotBtn;
/**
 *  @brief  视频聊天按钮
 */
@property(nonatomic,strong)UIButton   *mVideoBtn;
@end
