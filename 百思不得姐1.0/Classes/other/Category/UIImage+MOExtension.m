//
//  UIImage+MOExtension.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "UIImage+MOExtension.h"

@implementation UIImage (MOExtension)


//图形上下文来将图片裁剪成所需的形状。
- (UIImage *)circleImage
{
 
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪ctx,也就是获取到的当前图形上下文
    CGContextClip(ctx);
    
    // 将图片画上去，将自定的rect形状放上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图形上下文。必须
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
