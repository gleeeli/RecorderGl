//
//  GlTitleBottmButton.m
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlTitleBottmButton.h"
#import "ViewCode.h"

@implementation GlTitleBottmButton
{
    float width;
    float height;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.titleLabel.numberOfLines=0;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.backgroundColor = [UIColor redColor];
        width = frame.size.width;
        height = frame.size.height;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = self.imageView.frame;
    imageRect.origin.x = 5;
    imageRect.origin.y = 2;
    imageRect.size.height = 25 ;
    //imageRect.size.width = 30;

    self.imageView.frame = imageRect ;
    self.imageView.center = CGPointMake(width *0.5, imageRect.size.height * 0.5 +2);
    
    float titleWidth = [ViewCode  getWidthForStr:self.titleLabel.text Font:self.titleLabel.font];
    float titleX = (width - titleWidth) * 0.5;
    self.titleLabel.frame = CGRectMake(titleX , imageRect.size.height, width, height- imageRect.size.height-2);
    //self.titleLabel.center = CGPointMake(0, imageRect.size.height + titleRect.size.height * 0.5);
//
//    NSLog(@" 跟改的值width:%f",imageRect.size.width);
//    NSLog(@" 跟改的值height:%f",imageRect.size.height);
//    NSLog(@" 跟改的值x:%f",imageRect.origin.x);
//    NSLog(@" 跟改的值y:%f",imageRect.origin.y);
//    
//    NSLog(@" width:%f",self.imageView.frame.size.width);
//    NSLog(@" height:%f",self.imageView.frame.size.height);
}



@end
