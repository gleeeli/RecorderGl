//
//  RecorderModel.m
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "RecorderModel.h"
#import "GlCommMethod.h"

@implementation RecorderModel
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.cellType = GlRecorder;
        self.startTime = 0.0;
        self.durationRecorder = 0.0;
    }
    return self;
}
- (void)setSavePath:(NSString *)savePath
{
    NSRange range = [savePath rangeOfString:@"/Documents/"];
    if (range.location != NSNotFound && range.length > 0)
    {
        NSString *rootPaht = [savePath substringToIndex:range.location + range.length];
        NSString * name = [savePath substringFromIndex:range.location];

        if (![GlCommMethod isExitFileWithPaht:rootPaht])
        {
            NSLog(@"地址已改变");
            NSString * newSavePath = [NSHomeDirectory() stringByAppendingString:name];
            savePath = newSavePath;
        }
    }
    _savePath = savePath;
    
}
//获取开始时间
- (NSString *)getTimeFormatWithTime:(NSInteger) timeDuration
{
    NSInteger minute = timeDuration / 60;
    NSInteger sencond = timeDuration % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,sencond];
}

- (NSString *)getAddTimeDateFormat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.addtime];
    NSString *dateFormat = [GlCommMethod formatterDateWithDate:date format:@"yyyy.MM.dd HH:mm"];
    return dateFormat;
}

- (NSString *)getShowName
{
    NSString *fullName = [_savePath lastPathComponent];
    NSRange range = [fullName rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.length > 0)
    {
        fullName = [fullName substringToIndex:range.location];
    }
    
    return fullName;
}
- (NSString *)getFileFormat
{
    NSString *format = [_savePath lastPathComponent];
    NSRange range = [format rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.length > 0)
    {
        format = [format substringFromIndex:(range.location + range.length)];
        return format;
    }
    else
    {
        return @"";
    }
}
@end
