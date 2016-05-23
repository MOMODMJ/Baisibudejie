//
//  MOMeCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOMeCell.h"

@implementation MOMeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    //这句？？？
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
        //要设一个cell的backgroundView,需先通过UIView包装一个view出来
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor darkGrayColor]; 
        
        
        
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.imageView == nil) return;
//    self.textLabel.font = [UIFont systemFontO
    
    
}

@end
