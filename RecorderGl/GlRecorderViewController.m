//
//  GlRecorderViewController.m
//  RecorderGl
//
//  Created by dsw on 16/7/26.
//  Copyright © 2016年 dsw. All rights reserved.
//

#import "GlRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "GlCommHeader.h"
#import "GlCommMethod.h"
#import "GlOperationRecorderSql.h"
#import "RecorderTableViewCell.h"
#import "RecoderIngTableViewCell.h"
#import "GlRecoderFunctionViewController.h"
#import "GlTitleBottmButton.h"
#import "GlAlertView.h"

@interface GlRecorderViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSString *tmpSavePath;//临时存放路径

@property (weak, nonatomic) UIButton *recorderBtn;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) NSTimer *avTimer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recordeFiles;

@property (weak, nonatomic) IBOutlet UILabel *recordLab;//
@property (nonatomic, assign) NSTimeInterval recorderTime;//录音时长

@property (nonatomic, strong) NSMutableArray *selArray;//当前选中数组

@property (nonatomic, weak) UIView *bottomFuncView;//底部功能view
@property (nonatomic, weak) UIView *bottomRecorderView;//底部录音view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@end

@implementation GlRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"选择" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editTableView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    UIButton *lbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [lbtn setTitle:@"合成录音" forState:UIControlStateNormal];
    [lbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(combinateMp3:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:lbtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //self.tmpSavePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpRecord"];
    NSString *rootPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"tmpRecord"];
    self.tmpSavePath = [rootPath stringByAppendingPathComponent:@"record"];
    
    [GlCommMethod createFileDirectories:rootPath];
    
    self.recordeFiles = [[GlOperationRecorderSql shareManger] getAllRecorder];
    
    //NSString *str = [GlCommMethod encodeUrl:@"vimeo:li,guang,"];
    //NSLog(@"str:%@",str);
    _tableHeightConstraint.constant = VC_HEIGHT - kTabbarHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tintColor = [UIColor redColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showBottomRecorderView];
    [self getDurationWithVideo:nil];
}
- (NSUInteger)getDurationWithVideo:(NSString *)path
{
    path = [[NSBundle mainBundle] pathForResource:@"xiatian" ofType:@"mp3"];
    
    // path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *videoUrl = [NSURL URLWithString:path];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    NSLog(@"second:%lu",(unsigned long)second);
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSLog(@"audioDurationSeconds:%lu",(unsigned long)audioDurationSeconds);
    
    NSError *error = nil;
    AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:videoUrl error:&error];
    
    double duration = avAudioPlayer.duration;
    NSLog(@"duration:%lu",(unsigned long)duration);
    avAudioPlayer = nil;
    
    return audioDurationSeconds;
}
- (void)showBottomFuncView
{
    if (!_bottomFuncView)
    {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, VC_HEIGHT - kTabbarHeight, VC_WIDTH, kTabbarHeight)];
        bottomView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        [self.view addSubview:bottomView];
        _bottomFuncView = bottomView;
        
        NSArray *array = [[NSArray alloc]initWithObjects:@"删除",@"分享",@"重命名",@"合成", nil];
        NSArray *imageNormalarray = [[NSArray alloc]initWithObjects:@"GlDelete",@"GlShare",@"GlRename",@"GlCombinationMp3", nil];
        NSArray *imageSelarray = [[NSArray alloc]initWithObjects:@"GlNDelete",@"GlNShare",@"GlNRename",@"GlNCombinationMp3", nil];
        
        CGFloat lBtn = 0;
        CGFloat tBtn = 0;
        CGFloat wBtn = 40 * FIT_WIDTH;
        CGFloat hBtn = kTabbarHeight;
        CGFloat inter= (VC_WIDTH - wBtn*[array count])/([array count]+1);
        for(int i = 0; i < [array count]; i++)
        {
            lBtn = i * (wBtn + inter) + inter;
            GlTitleBottmButton *btn = [[GlTitleBottmButton alloc]initWithFrame:CGRectMake(lBtn, tBtn, wBtn, hBtn)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
            [btn setImage:[UIImage imageNamed:imageNormalarray[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageSelarray[i]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 200 + i ;
            [bottomView addSubview:btn];
        }
    }
    _bottomFuncView.hidden = NO;
    //_tableHeightConstraint.constant = VC_HEIGHT - kTabbarHeight;
}

- (void)showBottomRecorderView
{
    if (!_bottomRecorderView)
    {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, VC_HEIGHT-kTabbarHeight, VC_WIDTH, kTabbarHeight)];
        bottomView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        [self.view addSubview:bottomView];
        _bottomRecorderView = bottomView;
        
        
        CGFloat tBtn = 5;
        CGFloat hBtn = kTabbarHeight - 10;
        CGFloat wBtn = hBtn/72.0 *507;//507：72
        
        CGFloat lBtn = (VC_WIDTH - wBtn) * 0.5;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(lBtn, tBtn, wBtn, hBtn)];
        //[btn setTitle:@"开始录音" forState:UIControlStateNormal];
        //[btn setTitle:@"正在录音..." forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"GlStartRecorder"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"GlRecordering"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"GlRecordering"] forState:UIControlStateHighlighted];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[btn setBackgroundColor:[UIColor colorWithRed:203/255.0 green:62/255.0 blue:62/255.0 alpha:1]];
        //[btn addTarget:self action:@selector(toRecorder:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(startRecordgl:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(drageEnter:) forControlEvents:UIControlEventTouchDragInside];
        [btn addTarget:self action:@selector(drageOutSide:) forControlEvents:UIControlEventTouchDragOutside];
        [btn addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [btn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 3.0 ;
        [bottomView addSubview:btn];
        
        _recorderBtn =btn;
    }

    //_tableHeightConstraint.constant = 181 * FIT_WIDTH;
    _bottomRecorderView.hidden = NO;
}
- (void)toRecorder:(UIButton *)sender
{
    sender.selected = sender.selected ? NO:YES;
    if (!sender.selected)
    {
        NSLog(@"停止录音");
        [_audioRecorder stop];
        return;
    }
    
    AVAudioSession *_audioSession = [AVAudioSession sharedInstance];//得到AVAudioSession单例对象
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
    [_audioSession setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
    [self setAudioRecorder];
    
}
- (void)startRecordgl:(id)sender
{
    NSLog(@"开始录音");
    [GlAlertView showRecorderDragTop];
    
    AVAudioSession *_audioSession = [AVAudioSession sharedInstance];//得到AVAudioSession单例对象
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
    [_audioSession setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
    [self setAudioRecorder];
}
- (void)drageOutSide:(id)sender
{
    NSLog(@"拖出");
    [GlAlertView showRecorderDragCancel];
}
- (void)stopRecord:(id)sender
{
    NSLog(@"停止录音");
    [GlAlertView dismissAlertView];
    [_audioRecorder stop];
}
- (void)drageEnter:(id)sender
{
    NSLog(@"拖入");
}
- (void)cancelRecord:(id)sender
{
    NSLog(@"取消录音");
    [_audioRecorder stop];
    [GlAlertView dismissAlertView];
    RecorderModel *model = [_recordeFiles count] > 0 ? _recordeFiles[0]:nil;
    if (model.cellType == GlRecordering)
    {
        [_recordeFiles removeObjectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)editTableView:(id) sender
{
    UIButton * btn = sender;
    btn.selected = btn.selected? NO:YES;
    self.tableView.editing = btn.selected;
    
    self.selArray = [[NSMutableArray alloc]init];
    
    if (btn.selected)
    {
        _bottomRecorderView.hidden = YES;
        [self showBottomFuncView];
    }
    else
    {
        _bottomFuncView.hidden = YES;
        [self showBottomRecorderView];
    }
    
//    GlRecoderFunctionViewController *funcVc = [[GlRecoderFunctionViewController alloc]init];
//    [self.navigationController pushViewController:funcVc animated:YES];
}
//获取选中的model
- (NSMutableArray *)getSelModelsFromRecordeFiles
{
    NSMutableArray *selModels = [[NSMutableArray alloc]init];
    for (int i =0; i < [_selArray count]; i++)
    {
        NSInteger index = [_selArray[i] integerValue];
        if ([_recordeFiles count] > index)
        {
            RecorderModel *model =  _recordeFiles[index];
            [selModels addObject:model];
        }
        else
        {
            NSLog(@"error：选择的行出错");
        }
    }
    return selModels;
}
- (void)combinateMp3:(UIButton *)btn
{
    if ([_selArray count] == 0)
    {
        NSLog(@"没有需要合成的文件");
        return;
    }
    
    NSMutableArray *paths = [[NSMutableArray alloc]init];
    
    NSTimeInterval allTimeDuration = 0;
    for (int i =0; i < [_selArray count]; i++)
    {
        NSInteger index = [_selArray[i] integerValue];
        if ([_recordeFiles count] > index)
        {
            RecorderModel *model =  _recordeFiles[index];
            NSString *path = model.savePath;
            //path = [self updateSavePath:path];
            allTimeDuration += model.durationRecorder;
            
            [paths addObject:path];
        }
        else
        {
            NSLog(@"error：选择的行出错");
        }
    }
    
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString *rootPath = self.tmpSavePath.stringByDeletingLastPathComponent;
    NSString *exportFile = [rootPath stringByAppendingFormat: @"/%ld.m4a", time];
    
    //合成
    [GlCommMethod exportAudioWithArray:paths savePath:exportFile  complete:^(BOOL isSuccess) {
        
        if (isSuccess)
        {
            NSLog(@"合成音频成功");
            NSInteger time = [[NSDate date] timeIntervalSince1970];
            RecorderModel *model = [[RecorderModel alloc] init];
            model.savePath = exportFile;
            model.durationRecorder = allTimeDuration;
            model.recorderID = [NSString stringWithFormat:@"%ld",time];
            
            [_recordeFiles insertObject:model atIndex:0];
            [[GlOperationRecorderSql shareManger] addRecorderWithRecorderModel:model];
            
            NSLog(@"当前数：%ld",[_recordeFiles count]);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.tableView reloadData];
        }
    }];
}
//-(NSString *)updateSavePath:(NSString *)savePath
//{
//    if (![GlCommMethod createFileDirectories:savePath])
//    {
//        NSRange range = [savePath rangeOfString:@"/Documents/"];
//        NSString * name = [savePath substringFromIndex:range.location];
//        NSString * newSavePath = [NSHomeDirectory() stringByAppendingString:name];
//        NSLog(@"地址已发生改变");
//        savePath = newSavePath;
//    }
//    return savePath;
//}


- (void)playerTime:(id)sender
{
    CGFloat progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
    NSLog(@"播放进度：%f",progress);//objectForKey:@"userInfo"
    NSDictionary *dict = [sender valueForKey:@"userInfo"];
    RecorderModel *model = [dict objectForKey:@"NowPlayerModel"];
    model.startTime = self.audioPlayer.currentTime;
    
    NSInteger index = [self getIndexFromRecorderFilesWithModel:model];
    if (index >= 0)
    {
        NSLog(@"刷新行：%ld",index);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        RecorderTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.progressView.progress = progress;
        cell.startTimeLab.text = [model getTimeFormatWithTime:model.startTime];
    }
}
- (NSInteger)getIndexFromRecorderFilesWithModel:(RecorderModel *)model
{
    for (NSInteger i = 0; i < [_recordeFiles count]; i++)
    {
        RecorderModel *nmodel = _recordeFiles[i];
        ;
        if ([nmodel.recorderID isEqualToString:model.recorderID])
        {
            return i;
        }
    }
    
    return -1;
}
//录音设置
- (void)setAudioRecorder
{
    if (!_audioRecorder)
    {
        //录音设置
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];//kAudioFormatMPEGLayer3
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        //存储录音文件
        NSURL * recordUrl = [NSURL URLWithString:_tmpSavePath];
        //NSURL *recordUrl = [NSURL URLWithString:[NSHomeDirectory() stringByAppendingString:@"selfRecord.caf"]];
        //            recordUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.caf",presentTime]]];
        
        NSLog(@"recordUrl:%@",recordUrl);
        //初始化
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordUrl settings:recordSetting error:nil];
        //开启音量检测
        _audioRecorder.meteringEnabled = YES;
        _audioRecorder.delegate = self;
        
        
        //[_audioRecorder addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    if ([_audioRecorder prepareToRecord] == YES)
    {
        NSLog(@"开始录音");
        [_audioRecorder record];
        
        NSInteger time = [[NSDate date] timeIntervalSince1970];
        RecorderModel *model = [[RecorderModel alloc]init];
        model.cellType = GlRecordering;
        model.recorderID = [NSString stringWithFormat:@"%ld",time];
        
        NSString * mp3FileName = [NSString stringWithFormat:@"%@.mp3",model.recorderID];
        NSString *rootPath = _tmpSavePath.stringByDeletingLastPathComponent;
        NSString *savePath = [rootPath stringByAppendingPathComponent:mp3FileName];
        model.savePath = savePath;
        
        [_recordeFiles insertObject:model atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[_tableView reloadData];
    }
    else
    {
        NSLog(@"未准备");
    }
    
    if (!_avTimer)
    {
        self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recorderIng:) userInfo:nil repeats:YES];
    }
    
}

//正在录音
- (void)recorderIng:(id)sender
{
    if (_audioRecorder.currentTime > 0.0)
    {
        _recorderTime = _audioRecorder.currentTime;
    }
    
    NSString *recorderTxt = [NSString stringWithFormat:@"%f",_recorderTime];
    NSLog(@"当前录音时长：%f",_recorderTime);
    self.recordLab.text = recorderTxt;
    
    RecorderModel *model = [_recordeFiles firstObject];
    if (model.cellType == GlRecordering)
    {
        model.durationRecorder = _audioRecorder.currentTime;
        
        NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:0 inSection:0];
        RecoderIngTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPaht];
        cell.recorderDurationLab.text = [model getTimeFormatWithTime:model.durationRecorder];
    }
    
    
}

//- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
//{
//    NSLog(@"keyPath:%@",keyPath);
//    NSLog(@"change:%@",change);
//}
- (IBAction)toPlayer:(id)sender
{
    
    
    //[self transformCAFToMP3_2WithSavePath:savePath];
    
    NSLog(@"开始播放playRecording");
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器
    //
    //    [audioSession setActive:YES error:nil];
    //    //NSURL *recordUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    //
    //    [self toPlayMp3WithPath:@""];
    
    NSLog(@"测试：%f",_audioRecorder.deviceCurrentTime);
    NSLog(@"测试currentTime：%f",_audioRecorder.currentTime);
    // [self combinateMp3];
}
-(void)combinateMp3
{
    NSString *mp31 = [[NSBundle mainBundle] pathForResource:@"xiatian" ofType:@"mp3"];
    NSString *mp32 = [[NSBundle mainBundle] pathForResource:@"duhongcheng1" ofType:@"mp3"];
    NSString *mp33 = [[NSBundle mainBundle] pathForResource:@"tmpRecord" ofType:@"mp3"];
    
    //    NSURL *url1 = [NSURL fileURLWithPath:mp31];
    //    NSURL *url2 = [NSURL fileURLWithPath:mp32];
    //    NSURL *url3 = [NSURL fileURLWithPath:mp33];
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:mp33,mp31,mp32, nil];
    //NSString *savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"combine.m4a"];
    
    //    [GlCommMethod combinateMp3AudioWithArray:array savePath:savePath complete:^(BOOL isSuccess) {
    //        NSLog(@"完成----");
    //    }];
    
    //合成
    //[GlCommMethod exportAudioWithArray:array];
    
}
#define mark 播放相关
- (void)stopPlayer
{
    NSLog(@"停止播放");
    if (_avTimer)
    {
        [self.audioPlayer stop];
        
        [_avTimer invalidate];
        _avTimer = nil;
    }
}
- (void)toPlayMp3WithModel:(RecorderModel *)model
{
    NSString *mp3Path = model.savePath;
    //mp3Path = [self updateSavePath:mp3Path];
    
    NSLog(@"播放音频：%@",[mp3Path lastPathComponent]);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器
    [audioSession setActive:YES error:nil];
    
    NSURL *playerUrl = [NSURL URLWithString:mp3Path];
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playerUrl error:&error];
    self.audioPlayer = audioPlayer;
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1.0;
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    
    if (!_avTimer)
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:model,@"NowPlayerModel", nil];
        self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playerTime:) userInfo:dict repeats:YES];
    }
}
#pragma mark 底部功能按钮
- (void)tabBarBtnClick:(UIButton *)btn
{
    
    switch (btn.tag) {
        case 200://删除
        {
            [self deleteSelFiles];
        }
            break;
        case 201://分享
        {
            
        }
            break;
        case 202://重命名
        {
            [self reNameSelFile];
        }
            break;
        case 203://合成
        {
            [self combinateMp3:nil];
        }
            break;
            
        default:
            break;
    }
}
//重命名
- (void)reNameSelFile
{
    if ([_selArray count] == 1)
    {
        NSInteger index = [[_selArray firstObject] integerValue];
        RecorderModel *model = [_recordeFiles count] > index? _recordeFiles[index]:nil;
        NSString *originName = [model getShowName];
        UIAlertController *alertVc = [UIAlertController  alertControllerWithTitle:@"文件重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
           UITextField *filed = [alertVc.view viewWithTag:230];
            NSString *newName = filed.text;
            NSLog(@"确定filed:%@",newName);
            
            if (![originName isEqualToString:newName])
            {
                //model.savePath = [self updateSavePath:model.savePath];
                NSString *rootPaht = model.savePath.stringByDeletingLastPathComponent;
                NSString *fullPath = [NSString stringWithFormat:@"%@/%@.%@",rootPaht,newName,[model getFileFormat]];
                
                NSError *error = nil;
                BOOL success = [[NSFileManager defaultManager] moveItemAtPath:model.savePath toPath:fullPath error:&error];
                if (success)
                {
                    NSLog(@"改名成功:%@",fullPath);
                    model.savePath = fullPath;
                    [[GlOperationRecorderSql shareManger]updateRecorderWithRecorderModel:model];
                    NSInteger index = [self getIndexFromRecorderFilesWithModel:model];
                    if (index >= 0)
                    {
                        NSLog(@"更新行：%ld",index);
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        RecorderTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                        cell.nameLab.text = [model getShowName];
                        //[_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                }
                else
                {
                    NSLog(@"error:%@",error);
                }
            }
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }]];
        
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = [model getShowName];
            textField.tag = 230;
        }];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else
    {
        NSLog(@"error:选择出错");
    }
    
    
    
}
//删除文件
- (void)deleteSelFiles
{
    NSLog(@"删除选中的文件");
    if ([_selArray count] > 0)
    {
        NSMutableArray *models = [self getSelModelsFromRecordeFiles];
        [[GlOperationRecorderSql shareManger] deleteRecorders:models];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        for (NSNumber *selNum in _selArray)
        {
            NSInteger index = [selNum integerValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [indexPaths addObject:indexPath];
            
            RecorderModel *model = index < [_recordeFiles count]? _recordeFiles[index]:nil;
            
            NSError *error = nil;
            BOOL deleterResult = [[NSFileManager defaultManager]removeItemAtPath:model.savePath error:&error];
            if (!deleterResult)
            {
                NSLog(@"删除文件，error:%@",error);
                return;
            }
        }
        
        for (NSNumber *selNum in _selArray)
        {
            NSInteger index = [selNum integerValue];
            if (index < [_recordeFiles count])
            {
                [_recordeFiles removeObjectAtIndex:index];
            }
        }
        [_selArray removeAllObjects];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*FIT_WIDTH;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"将要选择某行：%ld",indexPath.row);
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择某行：%ld",indexPath.row);
    BOOL isExist = NO;
    for (NSNumber *num in _selArray)
    {
        NSInteger index = [num integerValue];
        if (index == indexPath.row)
        {
            isExist = YES;
        }
    }
    if (!isExist)
    {
        [self.selArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"取消选择某行：%ld",indexPath.row);
    [_selArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger nowObj = [obj integerValue];
        if (nowObj == indexPath.row)
        {
            [_selArray removeObject:obj];
            *stop = YES;
            return ;
        }
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recordeFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdentifier = @"RecoderTableViewCell";
    static NSString * const recodingIdentifier = @"RecoderingTableViewCell";
    
    RecorderModel *model = _recordeFiles[indexPath.row];
    //NSString *recoderPath = model.savePath;
    
    switch (model.cellType) {
        case GlRecorder:
        {
        RecorderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
            
            cell.dateLab.text = [model getAddTimeDateFormat];
            //cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
            cell.multipleSelectionBackgroundView.backgroundColor = [UIColor redColor];
            //[cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            
            cell.nameLab.text = [model getShowName];
            
            //cell.nameLab.text = [NSString stringWithFormat:@"录音%ld",[_recordeFiles count] -indexPath.row];
            cell.startTimeLab.text = [model getTimeFormatWithTime:model.startTime];
            NSString *sTime = [NSString stringWithFormat:@"-%@",[model getTimeFormatWithTime:(model.durationRecorder - model.startTime)]];
            cell.timeLab.text = sTime;
            cell.playerClick = ^(BOOL isPlayer){
                if (isPlayer)
                {
                    [self toPlayMp3WithModel:model];
                }
                else
                {
                    [self stopPlayer];
                }
            };
            
            return cell;
        }
            
            break;
        case GlRecordering:
        {
            RecoderIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recodingIdentifier forIndexPath:indexPath];
            cell.nameLab.text = [NSString stringWithFormat:@"录音%ld",([_recordeFiles count] -1)];
            cell.recorderDurationLab.text = [model getTimeFormatWithTime:model.durationRecorder];
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    
    /*
     if (!cell)
     {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
     }*/
    
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //cell.textLabel.text = [recoderPath lastPathComponent];//kIntToString(indexPath.row)
    
    
    
    
    
}

#pragma mark 转码
- (void)audio_PCMtoMP3WithSavePath:(NSString *)saveMp3Path complete:(void (^)(BOOL success))complete
{
    //NSString *mp3FilePath = [saveMp3Path stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([_tmpSavePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([saveMp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",[exception description]);
        complete(NO);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",saveMp3Path);
        complete(YES);
    }
    
}
////lame 转化为mp3格式
//- (void)transformCAFToMP3_2WithSavePath:(NSString *)saveMp3Path
//{
//    
//    @try {
//        int read, write;
//        
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 11025.0);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//        FILE *mp3 = fopen([saveMp3Path cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置;
//        for (int i = 0; i<3; i++) {
//            FILE *pcm = fopen([_tmpSavePath cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
//            fseek(pcm, 4*1024, SEEK_CUR);
//            
//            do {
//                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//                if (read == 0)
//                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//                else
//                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//                
//                fwrite(mp3_buffer, write, 1, mp3);
//                
//            } while (read != 0);
//            fclose(pcm);
//        }
//        
//        lame_close(lame);
//        fclose(mp3);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",[exception description]);
//    }
//    @finally {
//        
//        NSLog(@"MP3生成成功: %@",saveMp3Path);
//    }
//}

#pragma mark <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"结束播放");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur：%@",error);
}
#pragma mark 录音代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"******结束录音,准备转码MP3******");
    if (_avTimer)
    {
        [_avTimer invalidate];
        _avTimer = nil;
    }
    
    //NSString *mp3FileName = [_tmpSavePath lastPathComponent];
    //NSRange range = [mp3FileName rangeOfString:@"." options:NSBackwardsSearch];
    /*
     if (range.location != NSNotFound)
     {
     mp3FileName = [mp3FileName substringToIndex:range.location];
     }
     
     mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
     */
    
    //NSInteger time = [[NSDate date] timeIntervalSince1970];

    RecorderModel *model = [_recordeFiles count] > 0? [_recordeFiles firstObject]:nil;
    if (model.cellType == GlRecordering)//如果当前正在录音，未取消录音
    {
        model.cellType = GlRecorder;
        
        
        model.addtime = [[NSDate date] timeIntervalSince1970];
        model.durationRecorder = self.recorderTime;
        
        NSLog(@"mp3存放路径：%@",model.savePath);
        [self audio_PCMtoMP3WithSavePath:model.savePath complete:^(BOOL success) {
            
            if ([_recordeFiles count] > 0 && success)
            {
                NSLog(@"PCM转mp3成功");
                [[GlOperationRecorderSql shareManger] addRecorderWithRecorderModel:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];

    }
    
    
    
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    NSLog(@"录音出错：%@",error);
}

#if TARGET_OS_IPHONE

/* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 8_0)
{
    NSLog(@"录音被打断");
}

/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0)
{
    NSLog(@"录音被打断，audioRecorderEndInterruption1");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0)
{
    
}

/* audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 6_0)
{
    NSLog(@"录音被打断，audioRecorderEndInterruption2");
}
#endif // TARGET_OS_IPHONE

- (void)didReceiveMemoryWarning {
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
