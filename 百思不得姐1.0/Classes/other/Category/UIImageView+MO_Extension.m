//
//  UIImageView+MO_Extension.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "UIImageView+MO_Extension.h"


@implementation UIImageView (MO_Extension)

/**
 *  裁剪图片为圆形
 *  与UIImage+MOExtension一起用，其中circleImage来自它。
 */

- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
