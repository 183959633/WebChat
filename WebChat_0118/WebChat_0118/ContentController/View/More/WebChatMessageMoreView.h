//
//  WebChatMessageMoreView.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebChatModel.h"
//#define kNotificationImage (@"kNotificationImage")
extern NSString *const kNotificationImage;
/**
 *  @brief  更多、图片、段视频、文件等
 */
@interface WebChatMessageMoreView : UIView
/**
 *  @brief  选取图片按钮
 */
@property(nonatomic,strong)UIButton   *kPhotoBtn;
/**
 *  @brief  拍摄照片按钮
 */
@property(nonatomic,strong)UIButton   *kShotBtn;
/**
 *  @brief  视频聊天按钮
 */
@property(nonatomic,strong)UIButton   *kVideoBtn;
//#pragma model
//@property(nonatomic,strong)WebChatModel *model;
//#pragma 数据源
//@property(nonatomic,strong)NSMutableArray *dataArray;
-(void)kPhotoBtnClick;
@end
