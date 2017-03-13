//
//  GlCommMethod.h
//  PlayerWebURLDemo
//
//  Created by huangxianchao on 16/6/25.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlCommMethod : NSObject
//创建文件夹
+(BOOL)createFileDirectories:(NSString *) folderPath ;

//md5加密
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString ;

+ (NSString *)getVIdFromUrl:(NSString *)urlStr regex:(NSString *) regex ;

+ (NSString *)md5HexDigest:(NSString*)input ;

//判断是否为空
+(BOOL)isNUllObject:(id) sender ;

//获取文件大小
+ (unsigned long long)fileSizeForPath:(NSString *)path ;

//格式化日期
+(NSString *)formatterDateForService:(NSDate *)date ;

//url编码
+ (NSString *)encodeUrl:(NSString *)unencodeUrl;
+ (void)combinateMp3AudioWithArray:(NSArray *)array savePath:(NSString *)savePath complete:(void(^)(BOOL isSuccess)) complete ;
+ (void) exportAudioWithArray:(NSArray *)array savePath:(NSString *)savePath complete:(void(^)(BOOL isSuccess)) complete ;

+(NSString *)formatterDateWithDate:(NSDate *)date  format:(NSString *)format;

+ (BOOL)isExitFileWithPaht:(NSString *)filePath;
@end
