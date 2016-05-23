//
//  MOSquareButton.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/19.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOSquareButton.h"
#import "MOMeFooterView.h"
#import "MOSquare.h"
#import "UIButton+WebCache.h"

@implementation MOSquareButton

/*文字居中设置*/
- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}

//重写模型（大容器）的set方法，设置控件需要显示的对应数据
- (void)setSquare:(MOSquare *)square{
    
    _square = square;
    [self setTitle:square.name forState:UIControlStateNormal];
    
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

/*init方法重写*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


/*xib加载*/
- (void)awakeFromNib
{
    [self setup];
}


/*渲染界面*/
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = self.height * 0.15;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    
    
    
    CGFloat distance = 10;
    self.titleLabel.x = 0;
    //    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.y = self.imageView.height + distance;
    
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    
}

@end
