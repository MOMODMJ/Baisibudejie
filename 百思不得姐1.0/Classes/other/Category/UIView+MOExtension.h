//
//  UIView+UIView_MOExtention.h
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_MOExtention)

@property (nonatomic, assign) CGSize   size;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, assign) CGFloat  height;
@property (nonatomic, assign) CGFloat  x;
@property (nonatomic, assign) CGFloat  y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
- (BOOL)isShowingOnKeyWindow;
#pragma 这句话怎么理解？？
//  在分类中声明@property，只会生成方法的声明，不会生成方法的实现和带下划线的成员变量
@end
