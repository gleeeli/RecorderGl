//
//  GlDownLoadTaskModel.m
//  PlayerWebURLDemo
//
//  Created by gleeeli on 16/6/19.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import "GlDownLoadTaskModel.h"

@implementation GlDownLoadTaskModel
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.curParameters =nil;
        self.isAllCompleted = NO;
    }
    return self;
}
@end
