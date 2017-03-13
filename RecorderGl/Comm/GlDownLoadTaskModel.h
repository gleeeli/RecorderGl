//
//  GlDownLoadTaskModel.h
//  PlayerWebURLDemo
//
//  Created by gleeeli on 16/6/19.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

//下载状态
typedef enum : NSUInteger {
    GlDownLoadWait,
    GlDownLoading,
    GlDownLoadComplete,
} GlDownLoadStatus;

//下载方式
typedef enum : NSUInteger {
    GlDownGET,
    GlDownPOST,
} GlDownLoadMethod;

@interface GlDownLoadTaskModel : NSObject

@property(nonatomic,copy) NSString *taskID;
@property(nonatomic,assign) GlDownLoadStatus curStatus;//任务状态
@property(nonatomic,assign) NSInteger curIndex;//当前下载到第几个链接
@property(nonatomic,copy) NSString *currntRequestURL;
@property(nonatomic,copy) NSString *downLoadPath;
@property(nonatomic,copy) NSArray  *requestArray;//待下载的所有链接
@property(nonatomic,assign) BOOL isAllCompleted;//是否全部完成
@property(nonatomic,assign) GlDownLoadMethod downMethod;//下载方式，get、post

@property(nonatomic,copy) NSString *method;//请求方式
@property(nonatomic,copy) NSDictionary *curParameters;//url参数

@end
