//
//  GlRecorderProgressView.m
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlRecorderProgressView.h"

@interface GlRecorderProgressView ()
@property (nonatomic, strong) UIView *poleView;//标杆
@property (nonatomic, strong) UIView *progressView;

@end
@implementation GlRecorderProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}
- (void)initCustomView
{
    self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, VIEW_HEIGHT)];
    _progressView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:204/255.0 alpha:1];
    //_progressView.backgroundColor = [UIColor redColor];
    [self addSubview:_progressView];
    
    _poleView = [[UIView alloc] initWithFrame:CGRectMake(10, -2, 1, VIEW_HEIGHT + 4)];
    _poleView.backgroundColor = [UIColor colorWithRed:0 green:131/2550 blue:233/255.0 alpha:1];
    [self addSubview:_poleView];
    
}
- (void)setHilightedColor
{
    _progressView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:204/255.0 alpha:1];
    _poleView.backgroundColor = [UIColor colorWithRed:0 green:131/2550 blue:233/255.0 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}
//设置进度
- (void)setProgress:(float)progress
{
    CGFloat width = VIEW_WIDTH * progress;
    
    CGRect frame = _progressView.frame;
    frame.size.width = width;
    _progressView.frame = frame;
    
    CGRect poleframe = _poleView.frame;
    poleframe.origin.x = width;
    _poleView.frame = poleframe;

    
}
- (void)layoutSubviews
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
