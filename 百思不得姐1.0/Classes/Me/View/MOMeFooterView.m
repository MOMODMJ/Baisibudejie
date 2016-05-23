//
//  MOMeFooterView.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOMeFooterView.h"
#import "MOSquare.h"
#import "MOSquareButton.h"
#import "MOTabBarController.h"
#import "MONavigationController.h"
#import "MOWebViewController.h"
#import "MOSquareButton.h"

@implementation MOMeFooterView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self  = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
   
        //发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSArray *squares = [MOSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            MOLog(@"%@",responseObject[@"square_list"]);
            [self createSquares:squares];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            
        }];
  
        
    }
    return self;
}

- (void)createSquares: (NSArray *)squares{
    
    //一行最多4列
    NSInteger maxCols = 4;
    CGFloat buttonW = MAINSCREENWIDTH/maxCols;
    CGFloat buttonH = buttonW;
    
    
    for (int i = 0; i< squares.count; i++) {
        //创建按钮（得“有”）
        MOSquareButton *button = [[MOSquareButton alloc]init];
        
        //传递模型（数据）
        button.square = squares[i];
        
        
        //将控件添加到View中
        [self addSubview:button];
        
        //计算frame（显示出来，x,y,width,height）
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
        //监听点击（作用，方法）
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //如果button不是直接加在一个控制器自带的大view上，需同时计算所在小view的大小，否则不能点击。小view默认大小为0；
    NSInteger rows = (squares.count + maxCols -1) /maxCols;
    self.height = rows * buttonH;

    
    //重绘（必要）
    [self setNeedsDisplay];
    
}

- (void)buttonClick:(MOSquareButton *)button{
    
    if (![button.square.url hasPrefix:@"http"]) return;
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
    
    
    MOWebViewController *webVC = [[MOWebViewController alloc]init];
    webVC.title = button.square.name;
    webVC.url = button.square.url;
    
    [nav pushViewController:webVC animated:YES];
    
    
}

//设置背景图片，因为UIView没有设置背景图片的设置，所以用drawRect
- (void)drawRect:(CGRect)rect{
    
    [[UIImage imageNamed:@"angle-mask"] drawInRect:rect];
}


@end
