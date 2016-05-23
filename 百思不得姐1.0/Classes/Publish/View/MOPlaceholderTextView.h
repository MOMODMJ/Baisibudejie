//
//  MOPlaceholderTextView.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/22.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOPlaceholderTextView : UITextView

/*占位文字*/
@property (nonatomic,copy) NSString *placeholdertext;

/*占位文字颜色*/
@property (nonatomic,strong) UIColor *placeholderColor;


@end
