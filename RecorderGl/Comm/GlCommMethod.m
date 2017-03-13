//
//  GlCommMethod.m
//  PlayerWebURLDemo
//
//  Created by huangxianchao on 16/6/25.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import "GlCommMethod.h"
#import <CommonCrypto/CommonCrypto.h>
#include <sys/mount.h>
#import <AVFoundation/AVFoundation.h>

@implementation GlCommMethod
//创建文件夹
+(BOOL)createFileDirectories:(NSString *) folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
        
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(!bCreateDir)
        {
            NSLog(@"创建文件夹失败");
        }
        return bCreateDir;
    }
    return YES;
}
+ (BOOL)isExitFileWithPaht:(NSString *)filePath
{
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    return isDirExist;
}
+ (NSString *)getVIdFromUrl:(NSString *)urlStr regex:(NSString *) regex
{
    if (urlStr == nil)
    {
        urlStr = @"";
    }
    NSError *error =NULL;
    NSRegularExpression *regularExp=[NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result=[regularExp firstMatchInString:urlStr options:0 range:NSMakeRange(0, urlStr.length)];
    
    NSString *resultStr=[urlStr substringWithRange:result.range];
    
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    return resultStr;
}
+ (NSArray *)getm3u8Urls:(NSString *)m3u8File regex:(NSString *) regex
{
    if (m3u8File == nil)
    {
        m3u8File = @"";
    }
    
    NSError *error =NULL;
    NSRegularExpression *regularExp=[NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regularExp matchesInString:m3u8File options:0 range:NSMakeRange(0, m3u8File.length)];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    for (NSTextCheckingResult *result in results)
    {
        NSString *resultStr=[m3u8File substringWithRange:result.range];
        [muArray addObject:resultStr];
    }
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    return muArray;
}
#pragma mark MD5 加密
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    if (!srcString) {
        srcString=@"";
    }
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return [result uppercaseString];
}

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result];
    }
    return ret;
}

//判断是否为空
+(BOOL)isNUllObject:(id) sender
{
    
    if ([sender isKindOfClass:[NSString class]]) {//判断字符串是否为空
        if ([sender isEqualToString:@""]||[sender isEqualToString:@"<null>"]||[sender isEqualToString:@"(null)"]) {
            return YES;//为空
        }
    }else if([sender isKindOfClass:[NSData class]]){//判断data是否为空
        NSString *str=[[NSString alloc]initWithData:sender encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"null"]) {
            return YES;
        }
    }else if (!sender||[sender isKindOfClass:NULL]||[sender isKindOfClass:[NSNull class]]) {
        return YES;//为空
    }
    return NO;//非空
}
//获取文件大小
+ (unsigned long long)fileSizeForPath:(NSString *)path
{
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    
    if ([fileManager fileExistsAtPath:path])
    {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict)
        {
            
            fileSize = [fileDict fileSize];
            
        }
        
    }
    
    return fileSize;
    
}
//格式化日期
+(NSString *)formatterDateForService:(NSDate *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setCalendar:[NSCalendar currentCalendar]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *nowFDate=[dateFormatter stringFromDate:date];
    return nowFDate;
}
//格式化日期
+(NSString *)formatterDateWithDate:(NSDate *)date  format:(NSString *)format
{
    date = [GlCommMethod getNowDateFromatAnDate:date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setCalendar:[NSCalendar currentCalendar]];
    [dateFormatter setDateFormat:format];
    
    NSString *nowFDate=[dateFormatter stringFromDate:date];
    return nowFDate;
}
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate//将日期转为本地时间
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    return destinationDateNow;
}
//url编码
+ (NSString *)encodeUrl:(NSString *)unencodeUrl
{
    NSString *charactersToEscape = @"`#%^{}\"[]|\\<> :,";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString * newUrl =[unencodeUrl stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return newUrl;
}

+ (void)combinateMp3AudioWithArray:(NSArray *)array savePath:(NSString *)savePath complete:(void(^)(BOOL isSuccess)) complete
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音频tarck
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    
    //将所有片段加入轨道,注意反序
    for (NSInteger i = ([array count]-1); i >= 0; i--)
    {
        NSString *filePath = array[i];
        AVAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:optDict];
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        NSArray * atracks = [asset tracksWithMediaType:AVMediaTypeAudio];
        [audioTrack insertTimeRange:timeRange ofTrack:([atracks count] > 0? atracks[0]:nil) atTime:kCMTimeZero error:nil];
    }
    
    //如果文件已存在，将造成导出失败
    NSError *error;
    BOOL success = [[NSFileManager defaultManager]removeItemAtPath:savePath error:&error];
    if (!success)
    {
        NSLog(@"删除失败mp3：%@",savePath);
    }
    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    exporterSession.outputFileType = AVAssetExportPresetAppleM4A;
    exporterSession.outputURL = [NSURL fileURLWithPath:savePath];
    exporterSession.shouldOptimizeForNetworkUse = YES; //用于互联网传输
    [exporterSession exportAsynchronouslyWithCompletionHandler:^
     {
         switch (exporterSession.status)
         {
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"exporter Unknow");
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"exporter Canceled");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"exporter Failed");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"exporter Waiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"exporter Exporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"exporter Completed");
                 break;
         }
         
         if (exporterSession.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"合成成功：%@",savePath);
             complete(YES);
         }
         else
         {
             NSLog(@"error:合成失败");
             complete(NO);
         }
     }];
}

+ (void) exportAudioWithArray:(NSArray *)array savePath:(NSString *)savePath complete:(void(^)(BOOL isSuccess)) complete
{
    AVMutableComposition *composition = [AVMutableComposition composition];

    NSMutableArray *audioMixParams = [[NSMutableArray alloc] init];
    
    
    CMTime stratTime = kCMTimeZero;
    //将所有片段加入轨道,注意反序
    for (NSInteger i = ([array count]-1); i >= 0; i--)
    {
        NSString *filePath = array[i];
//        AVAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:optDict];
//        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
//        
//        NSArray * atracks = [asset tracksWithMediaType:AVMediaTypeAudio];
//        [audioTrack insertTimeRange:timeRange ofTrack:([atracks count] > 0? atracks[0]:nil) atTime:kCMTimeZero error:nil];
        
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        
        AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *sourceAudioTrack = nil;
        if ([songAsset tracksWithMediaType:AVMediaTypeAudio] > 0)
        {
            sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        }
        else
        {
            NSLog(@"error:音频文件获取音轨出错");
            continue;
        }
    
        
        NSError *error = nil;
        BOOL ok = NO;
        
        CMTimeRange tRange = CMTimeRangeMake(kCMTimeZero, songAsset.duration);
        
        //Set Volume
        AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        [trackMix setVolume:0.9f atTime:kCMTimeZero];
        [audioMixParams addObject:trackMix];
        
        //Insert audio into track  //offset CMTimeMake(0, 44100)
        ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:stratTime error:&error];
        stratTime = CMTimeAdd(stratTime, songAsset.duration);
    }
    
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    //audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    
    //If you need to query what formats you can export to, here's a way to find out
    NSLog (@"compatible presets for songAsset: %@",
           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName: AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSLog(@"savePath:%@",savePath);
    // set up export
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:savePath];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted)
            {
                complete(YES);
            }
            else
            {
                complete(NO);
            }
        });
        
        
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                NSError *exportError = exporter.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
                
            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted"); break;
            case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
            case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
            case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
            case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
            default:  NSLog (@"didn't get export status"); break;
        }
        
    }];
    
}
- (void) setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    BOOL ok = NO;
    
    CMTime startTime = start;
    CMTime trackDuration = dura;
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:0.8f atTime:startTime];
    //[audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:offset error:&error];
}
@end
