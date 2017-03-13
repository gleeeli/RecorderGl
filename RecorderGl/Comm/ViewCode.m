//
//  ViewCode.m
//  CloudMapStroll
//
//  Created by MAC02 on 15/7/4.
//  Copyright (c) 2015年 VK. All rights reserved.
//

#import "ViewCode.h"

@implementation ViewCode


+(float)getTopYToSelf:(UIView *)view{//获取当前元素到vc顶部的高度
    float topY=view.frame.origin.y;
    while (view.superview) {
        view=view.superview;
        topY += view.frame.origin.y;
//        NSLog(@"class===%@",[view class]);
    }
    return topY;
}
//获取当前字符串一行显示需要的宽度
+(CGFloat)getWidthForStr:(NSString *)str Font:(UIFont *)font  {
    CGSize size=[str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
   // NSLog(@"当前字体宽度＝%f,字体高度＝%f",size.width,size.height);
    return size.width;
}
//固定的宽度，计算字符串需要的高度
+(CGFloat)getHeightForText:(NSString *)text width:(CGFloat)width fontSize:(float)fontSize

{
    //设置计算文本时字体的大小,以什么标准来计算
    NSLog(@"当前字的框的宽度=%f",width);
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    return [text boundingRectWithSize:CGSizeMake(width, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
    
}
//根据tag获取view
+(UIView *)getViewWithTag:(NSInteger)tag fromFatherView:(UIView *)faView {
    for (UIView *nowView in faView.subviews) {
        if (nowView.tag==tag) {
            return nowView;
        }
    }
    NSLog(@"错误，没有找到tag＝%d的view",tag);
    return nil;
}
@end
