//
//  TaskCellStatusDelegate.h
//  PlayerWebURLDemo
//
//  Created by huangxianchao on 16/6/24.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskCellStatusDelegate <NSObject>

@optional

- (void)clickStartBtn:(BOOL) selected taskModel:(id ) taskModel;
- (void)statusChangeNotification:(id) taskModel;
@end
