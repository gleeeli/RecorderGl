//
//  ViewCode.h
//  CloudMapStroll
//
//  Created by MAC02 on 15/7/4.
//  Copyright (c) 2015年 VK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewCode : NSObject
//获取当前元素到vc顶部的高度
+(float)getTopYToSelf:(UIView *)view ;
//获取当前字符串一行显示需要的宽度
+(CGFloat)getWidthForStr:(NSString *)str Font:(UIFont *)font ;
//固定的宽度，计算字符串需要的高度
+(CGFloat)getHeightForText:(NSString *)text width:(CGFloat)width fontSize:(float)fontSize ;
//根据tag获取view
+(UIView *)getViewWithTag:(NSInteger)tag fromFatherView:(UIView *)faView ;
@end
