//
//  GlOperationRecorderSql.h
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecorderModel.h"

@interface GlOperationRecorderSql : NSObject
+ (GlOperationRecorderSql *)shareManger;

//添加录音
- (void)addRecorderWithRecorderModel:(RecorderModel *)model;

//更新
- (void)updateRecorderWithRecorderModel:(RecorderModel *)model;

//获取录音
- (NSMutableArray *)getAllRecorder;

//删除任务
- (void)deleteRecorders:(NSArray *)array;
@end
