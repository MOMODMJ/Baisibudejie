//
//  MOAddTagsToolBarView.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/23.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOAddTagsToolBarView.h"
#import "MOTagsViewController.h"

@interface MOAddTagsToolBarView()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
@implementation MOAddTagsToolBarView
+(instancetype)toolbar{
    
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MOAddTagsToolBarView class]) owner:nil options:nil].lastObject;
}


- (void)awakeFromNib{
    UIButton *addbutton = [[UIButton alloc]init];
    [addbutton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addbutton.size =  [UIImage imageNamed:@"tag_add_icon"].size;
    [self.topView addSubview:addbutton];
    [addbutton addTarget:self action:@selector(addtags) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addtags{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addtagsViewController" object:nil];
    MOLog(@"加标签");
 
}

@end
