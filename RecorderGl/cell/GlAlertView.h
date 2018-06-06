//
//  GlAlertView.h
//  RecorderGl
//
//  Created by dsw on 16/7/27.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    GlHintCancelRecorder,
    GlHintDragTopRecorder,
} GlAlertType;

@interface GlAlertView : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLab;

//提示上滑
+ (void)showRecorderDragTop;

//松开取消录音
+ (void)showRecorderDragCancel;

+ (void)dismissAlertView;
@end
