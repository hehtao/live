//
//  LiveShowViewController.m
//  LiveVideoCoreDemo
//
//  Created by Alex.Shi on 16/3/2.
//  Copyright © 2016年 com.Alex. All rights reserved.
//

#import "LiveShowViewController.h"
#import "XMNShareMenu.h"

@implementation LiveShowViewController
{
    // 背景
    UIView* _AllBackGroudView;
    // 退出直播
    UIButton* _ExitButton;
    // Rtmp  状态
    UILabel*  _RtmpStatusLabel;
    // 滤镜
    UIButton* _FilterButton;
    // 摄像头切换
    UIButton* _CameraChangeButton;
    // 滤镜效果选择
    XMNShareView* _FilterMenu;
    // Mic 音量显示
    ASValueTrackingSlider* _MicSlider;
    // 摄像头前置
    Boolean _bCameraFrontFlag;
    // 聚焦框
    UIView *_focusBox;
}
@synthesize RtmpUrl;


/**
 *  界面 搭建
 */
-(void) UIInit{
    double fScreenW = [UIScreen mainScreen].bounds.size.width;
    double fScreenH = [UIScreen mainScreen].bounds.size.height;
    
    /*
     *  是否横屏
     */
    if (self.IsHorizontal) {
        double fTmp = fScreenH;
        fScreenH = fScreenW;
        fScreenW = fTmp;
    }
    
    /*
     *背景View
     */
    _AllBackGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fScreenW, fScreenH)];
    [self.view addSubview:_AllBackGroudView];

    /*
     *  退出直播按钮
     */
    float fExitButtonW = 40;
    float fExitButtonH = 20;
    float fExitButtonX = fScreenW - fExitButtonW - 10;
    float fExitButtonY = fScreenH - fExitButtonH - 10;
    _ExitButton = [[UIButton alloc] initWithFrame:CGRectMake(fExitButtonX, fExitButtonY, fExitButtonW, fExitButtonH)];
    _ExitButton.backgroundColor = [UIColor blueColor];
    _ExitButton.layer.masksToBounds = YES;
    _ExitButton.layer.cornerRadius  = 5;
    [_ExitButton setTitle:@"退出" forState:UIControlStateNormal];
    [_ExitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ExitButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_ExitButton addTarget:self action:@selector(OnExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ExitButton];
    
    
    /*
     *  Rtmp状态
     */
    float fRtmpStatusLabelW = 120;
    float fRtmpStatusLabelH = 20;
    float fRtmpStatusLabelX = 10;
    float fRtmpStatusLabelY = 30;
    _RtmpStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(fRtmpStatusLabelX, fRtmpStatusLabelY, fRtmpStatusLabelW, fRtmpStatusLabelH)];
    _RtmpStatusLabel.backgroundColor = [UIColor lightGrayColor];
    _RtmpStatusLabel.layer.masksToBounds = YES;
    _RtmpStatusLabel.layer.cornerRadius  = 5;
    // 设置字体 Helvetica-Bold 西文粗体 和 大小10.0
    _RtmpStatusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_RtmpStatusLabel setTextColor:[UIColor whiteColor]];
    _RtmpStatusLabel.text = @"RTMP状态: 未连接";
    [self.view addSubview:_RtmpStatusLabel];
    
    
    /*
     *  滤镜按钮
     */
    float fFilterButtonW = 50;
    float fFilterButtonH = 30;
    float fFilterButtonX = fScreenW/2-fFilterButtonW-5;
    float fFilterButtonY = fScreenH - fFilterButtonH - 10;
    _FilterButton = [[UIButton alloc] initWithFrame:CGRectMake(fFilterButtonX, fFilterButtonY, fFilterButtonW, fFilterButtonH)];
    _FilterButton.backgroundColor = [UIColor blueColor];
    _FilterButton.layer.masksToBounds = YES;
    _FilterButton.layer.cornerRadius  = 5;
    [_FilterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [_FilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _FilterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [_FilterButton addTarget:self action:@selector(OnFilterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_FilterButton];
    
    
    /*
     *  摄像头选择
     */
    float fCameraChangeButtonW = fFilterButtonW;
    float fCameraChangeButtonH = fFilterButtonH;
    float fCameraChangeButtonX = fScreenW/2+5;
    float fCameraChangeButtonY = fFilterButtonY;
    
    _CameraChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(fCameraChangeButtonX, fCameraChangeButtonY, fCameraChangeButtonW, fCameraChangeButtonH)];
    _CameraChangeButton.backgroundColor = [UIColor blueColor];
    _CameraChangeButton.layer.masksToBounds = YES;
    _CameraChangeButton.layer.cornerRadius  = 5;
    [_CameraChangeButton setTitle:@"后置镜头" forState:UIControlStateNormal];
    [_CameraChangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _CameraChangeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [_CameraChangeButton addTarget:self action:@selector(OnCameraChangeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CameraChangeButton];
    
    
    /*
     *  Mic 音量标签
     */
    float fMicSliderX = 20;
    float fMicSliderY = fCameraChangeButtonY - fCameraChangeButtonH - 10;
    float fMicSliderW = fScreenW - fMicSliderX*2;
    float fMicSliderH = 30;
    _MicSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(fMicSliderX, fMicSliderY, fMicSliderW, fMicSliderH)];
    _MicSlider.maximumValue = 10.0;
    _MicSlider.popUpViewCornerRadius = 4;
    [_MicSlider setMaxFractionDigitsDisplayed:0];
    _MicSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _MicSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:18];
    _MicSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    _MicSlider.popUpViewWidthPaddingFactor = 1.7;
    _MicSlider.delegate = self;
    _MicSlider.dataSource = self;
    _MicSlider.value = 5;
    [self.view addSubview:_MicSlider];
    
    /*
     *  直播页面的轻触手势
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    /*
     *  聚焦框
     */
    _focusBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _focusBox.backgroundColor = [UIColor clearColor];
    _focusBox.layer.borderColor = [UIColor greenColor].CGColor;
    _focusBox.layer.borderWidth = 5.0f;
    
    // 默认隐藏聚焦匡,直到点按View 在点按处显示聚焦框
    _focusBox.hidden = YES;
    [self.view addSubview:_focusBox];
}

-(void) RtmpInit{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize videosize;
        // 根据横屏 或是 竖屏 设置对应的分辨率
        if (self.IsHorizontal) {
            videosize = LIVE_VIEDO_SIZE_HORIZONTAL_D1;
        }else{
            videosize = LIVE_VIEDO_SIZE_D1;
        }
        
        // 初始化Live
        [[LiveVideoCoreSDK sharedinstance] LiveInit:RtmpUrl Preview:_AllBackGroudView VideSize:videosize BitRate:LIVE_BITRATE_800Kbps FrameRate:LIVE_FRAMERATE_20];
        [LiveVideoCoreSDK sharedinstance].delegate = self;
        [[LiveVideoCoreSDK sharedinstance] connect];
        NSLog(@"Rtmp[%@] is connecting", self.RtmpUrl);
        
        // 设置 mic 增益
        [LiveVideoCoreSDK sharedinstance].micGain = 5;

        [self.view addSubview:_MicSlider];
        [self.view addSubview:_ExitButton];
        [self.view addSubview:_RtmpStatusLabel];
        [self.view addSubview:_FilterButton];
        [self.view addSubview:_CameraChangeButton];
    });
}


/**
 *  前后摄像头切换
 */
-(void) OnCameraChangeClicked:(id)sender{
    _bCameraFrontFlag = !_bCameraFrontFlag;
    
    // SDK提供的切换方法
    [[LiveVideoCoreSDK sharedinstance] setCameraFront:_bCameraFrontFlag];
    if (_bCameraFrontFlag) {
        [_CameraChangeButton setTitle:@"前置镜头" forState:UIControlStateNormal];
    }else{
        [_CameraChangeButton setTitle:@"后置镜头" forState:UIControlStateNormal];
    }
}


/**
 *  滤镜效果
 *
 *  @param sender 选择按钮
 */
-(void) OnFilterClicked:(id)sender{
    NSArray *shareAry = @[@{kXMNShareImage:@"original_Image",
                            kXMNShareHighlightImage:@"original_Image",
                            kXMNShareTitle:@"原始"},
                          @{kXMNShareImage:@"beauty_Image",
                          kXMNShareHighlightImage:@"beauty_Image",
                          kXMNShareTitle:@"美颜"},
                          @{kXMNShareImage:@"fugu_Image",
                            kXMNShareHighlightImage:@"fugu_Image",
                            kXMNShareTitle:@"复古"},
                          @{kXMNShareImage:@"black_Image",
                            kXMNShareHighlightImage:@"fugu_Image",
                            kXMNShareTitle:@"黑白"},];
    
    //自定义头部   添加label标签 "滤镜:"
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"滤镜:";
    [headerView addSubview:label];
    
    _FilterMenu = [[XMNShareView alloc] init];
    //设置头部View 如果不设置则不显示头部
    _FilterMenu.headerView = headerView;
    [_FilterMenu setSelectedBlock:^(NSUInteger tag, NSString *title) {
        NSLog(@"\ntag :%lu  \ntitle :%@",(unsigned long)tag,title);

        switch(tag) {
            case 0://原图像
                NSLog(@"设置无滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ORIGINAL];
                break;
            case 1://美颜
                NSLog(@"设置美艳滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BEAUTY];
                break;
            case 2://复古
                NSLog(@"设置复古滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_ANTIQUE];
                break;
            case 3://黑白
                NSLog(@"设置黑白滤镜...");
                [[LiveVideoCoreSDK sharedinstance] setFilter:LIVE_FILTER_BLACK];
                break;
            default:
                break;
        }
    }];
    
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    [_FilterMenu setupShareViewWithItems:shareAry];
    
    [_FilterMenu showUseAnimated:YES];
}


/**
 * 退出按钮 点击事件
 */
-(void) OnExitClicked:(id)sender{
    NSLog(@"Rtmp[%@] is ended", self.RtmpUrl);
    // liveSession end
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    //  liveSession nil
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
}

// 支持屏幕左右旋转
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if(self.IsHorizontal){
        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft));
        return bRet;
    }else{
        return false;
    }
}
- (NSUInteger)supportedInterfaceOrientations {
    if(self.IsHorizontal){
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UIInit];
    
    [self RtmpInit];
    
    
    // 默认启用前置摄像头
    _bCameraFrontFlag = false;
}
- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"CameraViewController: viewWillAppear");
    
    // 监听按下Home键,程序进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 监听是否重新进入应用程序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [super viewDidAppear:YES];
}

- (void) appWillEnterForegroundNotification{
    NSLog(@"trigger event when will enter foreground.");
    if (![self hasPermissionOfCamera]) {
        return;
    }
    [self RtmpInit];

}
- (void)WillDidBecomeActiveNotification{
    NSLog(@"CameraViewController: WillDidBecomeActiveNotification");

}


/**
 *  程序进入后台,(一般应用进入后台几秒钟之后,主线程就会被挂起,处于休眠状态),如果在程序休眠之前需要处理任务,则需要额外向系统
 *  申请时间
 */
- (void)WillResignActiveNotification{
    NSLog(@"LiveShowViewController: WillResignActiveNotification");
    
    if (![self hasPermissionOfCamera]) {
        return;
    }
    

    
    //得到当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    //一个后台任务标识符
    UIBackgroundTaskIdentifier taskID;
    //  告诉系统,我们需要更多的时间来处理任务
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        //如果处理超时(10min) ，将执行这个程序块，并停止运行应用程序(挂起应用主线程和子线程,是应用彻底进入后台休眠)
        [app endBackgroundTask:taskID];
    }];
    //UIBackgroundTaskInvalid表示系统没有为我们提供额外的时候
    if (taskID == UIBackgroundTaskInvalid) {
        NSLog(@"Failed to start background task!");
        return;
    }

    // 手动结束任务,退出程序
    //[[SCCaptureManager sharedManager] disconnect];
    [[LiveVideoCoreSDK sharedinstance] disconnect];
    [[LiveVideoCoreSDK sharedinstance] LiveRelease];
    
    //告诉系统我们完成了
    [app endBackgroundTask:taskID];
}


/**
 *  是否授权 使用摄像头
 */
- (BOOL)hasPermissionOfCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus != AVAuthorizationStatusAuthorized){
        
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}






-(void) viewDidDisappear:(BOOL)animated{
    NSLog(@"CameraViewController: viewDidDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];//删除去激活界面的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];//删除激活界面的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//rtmp status delegate:  
- (void) LiveConnectionStatusChanged: (LIVE_VCSessionState) sessionState{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (sessionState) {
            case LIVE_VCSessionStatePreviewStarted:
                _RtmpStatusLabel.text = @"RTMP状态: 预览未连接";
                break;
            case LIVE_VCSessionStateStarting:
                _RtmpStatusLabel.text = @"RTMP状态: 连接中...";
                break;
            case LIVE_VCSessionStateStarted:
                _RtmpStatusLabel.text = @"RTMP状态: 已连接";
                break;
            case LIVE_VCSessionStateEnded:
                _RtmpStatusLabel.text = @"RTMP状态: 未连接";
                break;
            case LIVE_VCSessionStateError:
                _RtmpStatusLabel.text = @"RTMP状态: 错误";
                break;
            default:
                break;
        }
    });
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    if (slider == _MicSlider) {
        float fMicGain = value/10.0;
        NSLog(@"mic slider:%0.2f, %0.2f", value, fMicGain);
        
        // 调整 Mic 音量
        [LiveVideoCoreSDK sharedinstance].micGain = fMicGain;
    }
    
    return nil;
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    NSLog(@"sliderWillDisplayPopUpView...");
    return;
}

- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider{
    NSLog(@"sliderWillHidePopUpView...");
}

- (void)dealSingleTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    
    // 聚 焦 到手指点按处
    [[LiveVideoCoreSDK sharedinstance] focuxAtPoint:point];
    // 移动聚焦框
    [self runBoxAnimationOnView:_focusBox point:point];
}
//对焦的动画效果
- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
                     }
                     completion:^(BOOL complete) {
                         double delayInSeconds = 0.5f;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             view.hidden = YES;
                             view.transform = CGAffineTransformIdentity;
                         });
                     }];
}
@end
