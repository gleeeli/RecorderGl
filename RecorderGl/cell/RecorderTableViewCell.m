//
//  RecorderTableViewCell.m
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "RecorderTableViewCell.h"
@interface RecorderTableViewCell()

@end

@implementation RecorderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [_progressView layoutIfNeeded];
    [_progressView initCustomView];
    
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.playBtn setImage:[UIImage imageNamed:@"GlPlayerRecorder.png"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"GlPauseRecorder.png"] forState:UIControlStateSelected];
    self.playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)toPlayClick:(id)sender
{
    UIButton *btn = sender;
    btn.selected = btn.selected ? NO:YES;
    if (self.playerClick)
    {
        self.playerClick(btn.selected);
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [_progressView setHilightedColor];
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [_progressView setHilightedColor];
    self.lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}
@end
