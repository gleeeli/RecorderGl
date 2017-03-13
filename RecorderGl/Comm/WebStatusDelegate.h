//
//  WebStatusDelegate.h
//  PlayerWebURLDemo
//
//  Created by huangxianchao on 16/6/23.
//  Copyright © 2016年 liguanglei. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WebStatusDelegate <NSObject>

@optional
- (void)jsHandleCompleteWithTaskArray:(NSMutableArray *) taskArray;
- (void)receiveDataNotification:(id) sender;
@end
