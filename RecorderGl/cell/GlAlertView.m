//
//  GlAlertView.m
//  RecorderGl
//
//  Created by dsw on 16/7/27.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlAlertView.h"
#import "GlCommHeader.h"
#import "GlCommMethod.h"
#import "ViewCode.h"

#define GlAlertTag 2312

@implementation GlAlertView

static GlAlertView *alertViewGl = nil;

+ (void)initGlAlertView
{
    if (!alertViewGl)
    {
        CGFloat widthAl = 150 * FIT_WIDTH;
        CGFloat heightAl = 150 * FIT_WIDTH;
        CGFloat xAl = GlSCREEN_WIDTH * 0.5 - widthAl * 0.5;
        CGFloat yAl =GlSCREEN_HEIGHT * 0.5 - heightAl * 0.5;
        alertViewGl = [[GlAlertView alloc]initWithFrame:CGRectMake( xAl, yAl, widthAl, heightAl)];
        alertViewGl.tag  = GlAlertTag;
    }
    [GlAlertView clearOtherEffect];
}
//提示上滑
+ (void)showRecorderDragTop
{
    [GlAlertView initGlAlertView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    GlAlertView *alertView =  [window viewWithTag:GlAlertTag];
    if (!alertView)
    {
        [window addSubview:alertViewGl];
    }
    [alertViewGl setImageName:@"GlRecorderDragOutside" title:@"手指上滑，取消录音"];
}
//松开取消录音
+ (void)showRecorderDragCancel
{
    [GlAlertView initGlAlertView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    GlAlertView *alertView =  [window viewWithTag:GlAlertTag];
    if (!alertView)
    {
        [window addSubview:alertViewGl];
    }
    [alertViewGl setImageName:@"GlRecorderDragIn" title:@"松开手指，取消录音"];
    alertViewGl.titleLab.backgroundColor = [UIColor colorWithRed:190/255.0 green:101/255.0 blue:101/255.0 alpha:1];
}
//取消其它特殊效果
+ (void)clearOtherEffect
{
    alertViewGl.titleLab.backgroundColor = [UIColor clearColor];
}

+ (void)dismissAlertView
{
    //UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [alertViewGl removeFromSuperview];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.layer.cornerRadius = 5.0 * FIT_WIDTH;
        [self initImageTitle];
    }
    return self;
}
- (void)initImageTitle
{
    CGFloat yImage = VIEW_HEIGHT * 0.1;
    CGFloat hImage = VIEW_HEIGHT - 15 * FIT_WIDTH - yImage * 2.0;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, yImage, VIEW_WIDTH, hImage)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    
    CGFloat hTitle = 15 * FIT_WIDTH;
    CGFloat yTitle = VIEW_HEIGHT - 10 * FIT_WIDTH - hTitle;//靠底部
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, yTitle, VIEW_WIDTH, hTitle)];
    _titleLab.font = [UIFont systemFontOfSize:14.0 * FIT_WIDTH];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
}
- (void)setImageName:(NSString *)imageName title:(NSString *)title
{
    _titleLab.text = title;
    float hintTextWidth = [ViewCode getWidthForStr:title Font:_titleLab.font] + 5;
    if (hintTextWidth > VIEW_WIDTH)
    {
        hintTextWidth = VIEW_WIDTH;
    }
    CGRect titleRect = _titleLab.frame;
    titleRect.size.width = hintTextWidth;
    titleRect.origin.x = VIEW_WIDTH * 0.5 - hintTextWidth * 0.5;
    _titleLab.frame = titleRect;
    
    _imageView.image = [UIImage imageNamed:imageName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
