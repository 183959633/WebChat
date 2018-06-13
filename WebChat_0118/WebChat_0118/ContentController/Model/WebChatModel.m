//
//  WebChatModel.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatModel.h"
@implementation WebChatModel
- (NSString *)getchatCellType:(WebChatCellType)type{
     NSString *t_chatCellType;
    
    switch (type) {
        case WebChatCellType_Image:
            t_chatCellType = @"WebChatCellType_Image";
            break;
        case WebChatCellType_Audio:
            t_chatCellType = @"WebChatCellType_Audio";
            break;
        case WebChatCellType_Video:
            t_chatCellType = @"WebChatCellType_Video";
            break;
        case WebChatCellType_Time:
            t_chatCellType = @"WebChatCellType_Time";
            break;
        case WebChatCellType_Flicker:
            t_chatCellType = @"WebChatCellType_Flicker";
            break;
            
        default:
            t_chatCellType = @"WebChatCellType_Text";
            break;
    }
    
    return t_chatCellType;
}
@end
