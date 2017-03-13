//
//  GlRecorderProgressView.h
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlCommHeader.h"

@interface GlRecorderProgressView : UIView
@property (nonatomic, assign) float progress;

- (void)initCustomView ;
- (void)setHilightedColor ;
@end
