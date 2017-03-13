//
//  RecorderTableViewCell.h
//  RecorderGl
//
//  Created by dsw on 16/7/25.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlRecorderProgressView.h"

typedef void(^PlayerClick)(BOOL isPlayer);

@interface RecorderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet GlRecorderProgressView *progressView;

@property (nonatomic, copy) PlayerClick playerClick;

@end
