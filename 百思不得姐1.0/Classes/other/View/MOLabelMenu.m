//
//  MOLabelMenu.m
//  MOLabelMenu
//
//  Created by Andy_Lin on 16/5/17.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOLabelMenu.h"

@implementation MOLabelMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableClick)]];
    
}

- (void)lableClick{
    
    //label要成为第一响应者，告诉UIMenuController支持哪些操作，这些操作如何处理
    [self becomeFirstResponder];
    
    //显示menuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    /*************************************************
     *  /targetRect : MenuController需指向的矩形框
     targetView : targetRect会以targetView的左上角为坐标原点
     ************************************************/
    [menu setTargetRect:self.frame inView:self.superview];
//        [menu setTargetRect: self.bounds inView:self];
    
    [menu setMenuVisible:YES animated:YES];
    
}

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
//    if (action == @selector(copy:) || action == @selector(cut:) || action == @selector(paste:))
//    return YES;
//    return NO;
  
    
    return YES;
}

- (void)cut:(UIMenuController *)menu{
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text;
    
    self.text = nil;
    
}

- (void)copy:(UIMenuController *)menu{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text;
    
}

- (void)paste:(UIMenuController *)menu{
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    self.text = board.string; //将粘贴板上的文字复制到自己身上
}


@end
