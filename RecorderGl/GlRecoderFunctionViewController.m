//
//  GlRecoderFunctionViewController.m
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlRecoderFunctionViewController.h"
#import "GlCommHeader.h"

@interface GlRecoderFunctionViewController ()

@end

@implementation GlRecoderFunctionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, VC_HEIGHT, VC_WIDTH, kTabbarHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1];
    [self.view addSubview:bottomView];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"删除",@"分享",@"重命名",@"合成", nil];
    
    CGFloat lBtn = 0;
    CGFloat tBtn = 0;
    CGFloat wBtn = 50 * FIT_WIDTH;
    CGFloat hBtn = kTabbarHeight;
    CGFloat inter= (VC_WIDTH - wBtn*[array count])/([array count]+1);
    for(int i = 0; i < [array count]; i++)
    {
        lBtn = i * (wBtn + inter) + inter;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(lBtn, tBtn, wBtn, hBtn)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
