//
//  GlCommHeader.h
//  PlayerWebURLDemo
//
//  Created by gleeeli on 16/6/19.
//  Copyright © 2016年 liguanglei. All rights reserved.
//
#import "UIInitMethod.h"
#import "Common_define.h"
//#import "SVProgressHUD.h"

#ifndef GlCommHeader_h
#define GlCommHeader_h

#define TASK_STATUS_CHANGE @"Gl_task_status_change"
#define Gl_TASK_DOWN_RESUME @"Gl_task_load_resume"
#define Gl_TASK_DOWN_STOP @"Gl_task_load_stop"
/*---------------------------  适配屏幕☟  ---------------------------*/
#define ORIGINAL_WIDTH 320.0      //当前原型图基准iOS设备的逻辑分辨率的宽
#define ORIGINAL_HEIGHT 568.0     //当前原型图基准iOS设备的逻辑分辨率的高
#define VC_WIDTH self.view.frame.size.width
#define VC_HEIGHT self.view.frame.size.height
#define kTabbarHeight       49
#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height
#define GlSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define GlSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

///水平方向适配系数
#define FIT_WIDTH (([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)/ORIGINAL_WIDTH)
///竖直方向适配系数
#define FIT_HEIGHT (([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)/ORIGINAL_HEIGHT)

///非图标控件frame的适配
#define FitCGRectMake(X,Y,W,H) CGRectMake((X)*FIT_WIDTH,(Y)*FIT_HEIGHT,(W)*FIT_WIDTH,(H)*FIT_HEIGHT)

///图标控件frame的适配
#define PitCGRectMake(X,Y,W,H) CGRectMake((X)*FIT_WIDTH,(Y)*FIT_HEIGHT,(W)*FIT_WIDTH,(H)*FIT_WIDTH)

///图标控件frame的适配(仅宽度)
#define IitCGRectMake(X,Y,W,H) CGRectMake((X)*FIT_WIDTH,(Y)*FIT_WIDTH,(W)*FIT_WIDTH,(H)*FIT_WIDTH)

///字体的适配
#define FitFontSize(S) [UIFont systemFontOfSize:(S)*FIT_WIDTH]

///Point的适配
#define FitCGPointMake(X,Y) CGPointMake((X)*FIT_WIDTH,(Y)*FIT_HEIGHT)

///Size的适配
#define FitCGSizeMake(W,H) CGSizeMake((W)*FIT_WIDTH,(H)*FIT_HEIGHT)


#endif /* GlCommHeader_h */
