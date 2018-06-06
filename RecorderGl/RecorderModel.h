//
//  RecorderModel.h
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GlRecorder,
    GlRecordering,
} GlRecorderCell;

@interface RecorderModel : NSObject

@property (nonatomic, copy) NSString *recorderID;
@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, assign) NSTimeInterval addtime;
@property (nonatomic, assign) NSTimeInterval durationRecorder;//时长
@property (nonatomic, assign) NSTimeInterval startTime;//当前播放时间

@property (nonatomic, assign) GlRecorderCell cellType;

//获取时间00：00格式
- (NSString *)getTimeFormatWithTime:(NSInteger) timeDuration ;

- (NSString *)getAddTimeDateFormat;

- (NSString *)getShowName;

- (NSString *)getFileFormat;

@end
