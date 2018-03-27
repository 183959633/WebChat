//
//  UIImage+aScaling.h
//  WebChat_0118
//
//  Created by Jack on 2018/1/31.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (aScaling)
#pragma 按比例缩放图片,传入指定高度,图形上下文自动计算宽度
- (UIImage *)scaleWithHeight:(CGFloat)height;
@end
