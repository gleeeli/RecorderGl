//
//  RecoderIngTableViewCell.m
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "RecoderIngTableViewCell.h"

@implementation RecoderIngTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}
@end
