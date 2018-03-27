//
//  WebChatCustomHorizontalLayout.h
//  WebChat
//
//  Created by Jack on 2018/2/6.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebChatCustomHorizontalLayout : UICollectionViewFlowLayout
//重写初始化方法
-(instancetype)initWithitemCountPerRow:(NSInteger)itemCountPerRow AndrowCount:(NSInteger)rowCount;
@end
