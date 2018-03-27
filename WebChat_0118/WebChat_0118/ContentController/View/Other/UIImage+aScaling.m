//
//  UIImage+aScaling.m
//  WebChat_0118
//
//  Created by Jack on 2018/1/31.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "UIImage+aScaling.h"

@implementation UIImage (aScaling)
- (UIImage *)scaleWithHeight:(CGFloat)height{
    // 如果传入的高度比当前高度还要大,就直接返回
    if (height > self.size.height){
        return  self;
    }
    // 计算缩放之后的宽度
    CGFloat width = ( height  / self.size.height) * self.size.width;
    
    // 初始化要画的大小
    CGRect kRect= CGRectMake(0, 0, width, height);
    // 1. 开启图形上下文
    UIGraphicsBeginImageContext(kRect.size);
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    [self drawInRect:kRect];
    // 3. 取到图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 5. 返回
    return image;
    
}

@end
