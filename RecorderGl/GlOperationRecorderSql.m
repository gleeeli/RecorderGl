//
//  GlOperationRecorderSql.m
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlOperationRecorderSql.h"
#import "FMDatabase.h"

#define UserName @"defaultName"
static GlOperationRecorderSql *_manger=nil;
@implementation GlOperationRecorderSql
{
    FMDatabase *_dataBase;
}
+ (GlOperationRecorderSql *)shareManger
{
    if(_manger == nil)
    {
        _manger = [[GlOperationRecorderSql alloc] init];
    }
    return _manger;
}
-(id)init
{
    if (self = [super init]) {
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/recorder.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        
        NSLog(@"数据库路径：%@",path);
        BOOL isSueecss = [_dataBase open];
        
        if(isSueecss) {
            
            [self createRecorderTable];
            
        } else {
            NSLog(@"数据库打开失败");
        }
        //关闭数据库
        [_dataBase close];
        
    }
    return self;
}
//创建录音表
- (void)createRecorderTable
{
    NSString *createSql=@"create table if not exists recorderTable(save_id integer not null primary key autoincrement,recorderID varchar(255),savePath text ,addTime real,durationRecorder real,account varchar(255));";
    
    BOOL ret = [_dataBase executeUpdate:createSql];
    if(ret) {
        //        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建录音表失败");
        NSLog(@"error %@",_dataBase.lastErrorMessage);
    }
}
- (void)addRecorderWithRecorderModel:(RecorderModel *)model
{
    NSLog(@"添加一条录音记录");
    //数据库打开
    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess)
    {
        NSLog(@"数据库打开失败");
    }
    /*
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:sortArray];
    NSData *otherData=[NSKeyedArchiver archivedDataWithRootObject:dict];
     */
    //double time= [[NSDate date] timeIntervalSince1970];

    //修改语句
    NSString *insertSql=[NSString stringWithFormat:@"insert into recorderTable(recorderID,savePath,addTime,durationRecorder,account) values(?,?,?,?,?)"];
    
    BOOL ret = [_dataBase executeUpdate:insertSql,model.recorderID,model.savePath,[NSNumber numberWithDouble:model.addtime],[NSNumber numberWithDouble:model.durationRecorder],UserName];
    
    if(!ret)
    {
        NSLog(@"inert error %@",_dataBase.lastErrorMessage);
    }

    [_dataBase close];
}
- (void)updateRecorderWithRecorderModel:(RecorderModel *)model
{
    NSLog(@"更新一条录音记录");
    //数据库打开
    BOOL isSuccess = [_dataBase open];
    
    if(!isSuccess)
    {
        NSLog(@"数据库打开失败");
    }
    
    //修改语句
    NSString *updateSql=[NSString stringWithFormat:@"update recorderTable set savePath = ?, addTime = ?, durationRecorder = ? where recorderID = ?"];
    
    BOOL ret = [_dataBase executeUpdate:updateSql,model.savePath,[NSNumber numberWithDouble:model.addtime],[NSNumber numberWithDouble:model.durationRecorder],model.recorderID];
    
    if(!ret)
    {
        NSLog(@"update error %@",_dataBase.lastErrorMessage);
        [_dataBase close];
    }
    
    [_dataBase close];
}
//获取所有录音
- (NSMutableArray *)getAllRecorder
{
    BOOL isSuccess = [_dataBase open];
    if(!isSuccess)
    {
        NSLog(@"打开失败");
    }
    
    NSMutableArray *recorders = [[NSMutableArray alloc]init];
    
    NSString *selectSql = @"select * from recorderTable where account = ? order by addTime desc" ;
    FMResultSet *ret = [_dataBase executeQuery:selectSql,UserName];
    
    while ([ret next])
    {
        NSString *recorderID=[ret stringForColumn:@"recorderID"];
        NSString *savePath=[ret stringForColumn:@"savePath"];
        double addTime=[ret doubleForColumn:@"addTime"];
        double durationRecorder=[ret doubleForColumn:@"durationRecorder"];
        
        RecorderModel *model = [[RecorderModel alloc]init];
        model.recorderID = recorderID;
        model.savePath = savePath;
        model.addtime = addTime;
        model.durationRecorder = durationRecorder;
        [recorders addObject:model];
    }
    
    [ret close];
    [_dataBase close];
    
    return recorders;
}

//删除任务
- (void)deleteRecorders:(NSArray *)array
{
    BOOL isSuccess = [_dataBase open];
    if(!isSuccess)
    {
        NSLog(@"打开失败");
    }
    
    for (RecorderModel *model in array)
    {
        //删除语句
        NSString *updateSql=[NSString stringWithFormat:@"delete from recorderTable where recorderID = ? "];
        
        BOOL ret = [_dataBase executeUpdate:updateSql,model.recorderID ];
        if(!ret)
        {
            NSLog(@"delete error %@",_dataBase.lastErrorMessage);
        }
    }
    
    
    
    [_dataBase close];
}
@end
