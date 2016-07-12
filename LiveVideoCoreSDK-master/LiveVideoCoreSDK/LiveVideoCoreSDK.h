//
//  LiveVideoCoreSDK.h
//  LiveVideoCoreSDK
//
//  Created by Alex.Shi on 16/3/2.
//  Copyright © 2016年 com.Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "../RtmpLivePushSDK/VideoCore/api/IOS/VCSimpleSession.h"

#define LIVE_VIDEO_DEF_WIDTH  360
#define LIVE_VIDEO_DEF_HEIGHT 640
#define LIVE_VIDEO_DEF_FRAMERATE 25
#define LIVE_VIDEO_DEF_BITRATE   500000

#define LIVE_VIEDO_SIZE_HORIZONTAL_CIF  (CGSizeMake(640, 360))
#define LIVE_VIEDO_SIZE_HORIZONTAL_D1   (CGSizeMake(960, 540))
#define LIVE_VIEDO_SIZE_HORIZONTAL_720P (CGSizeMake(1280, 720))

#define LIVE_VIEDO_SIZE_CIF  (CGSizeMake(360, 640))
#define LIVE_VIEDO_SIZE_D1   (CGSizeMake(540, 960))
#define LIVE_VIEDO_SIZE_720P (CGSizeMake(720, 1280))

typedef NS_ENUM(NSUInteger, LIVE_BITRATE) {
    LIVE_BITRATE_1Mbps=1500000,
    LIVE_BITRATE_800Kbps=800000,
    LIVE_BITRATE_500Kbps=500000
};

typedef NS_ENUM(NSUInteger, LIVE_FRAMERATE) {
    LIVE_FRAMERATE_30=30,
    LIVE_FRAMERATE_25=25,
    LIVE_FRAMERATE_20=20,
    LIVE_FRAMERATE_15=15
};

typedef NS_ENUM(NSInteger, LIVE_VCSessionState)
{
    LIVE_VCSessionStateNone,
    LIVE_VCSessionStatePreviewStarted,
    LIVE_VCSessionStateStarting,
    LIVE_VCSessionStateStarted,
    LIVE_VCSessionStateEnded,
    LIVE_VCSessionStateError
};

typedef NS_ENUM(NSUInteger, LIVE_FILTER_TYPE) {
    LIVE_FILTER_ORIGINAL,
    LIVE_FILTER_BEAUTY,
    LIVE_FILTER_ANTIQUE,
    LIVE_FILTER_BLACK
};

@protocol LIVEVCSessionDelegate <NSObject>
@required
- (void) LiveConnectionStatusChanged: (LIVE_VCSessionState) sessionState;
@end

@interface LiveVideoCoreSDK : NSObject<VCSessionDelegate>

+ (instancetype)sharedinstance;

@property (atomic, weak)   id<LIVEVCSessionDelegate> delegate;
@property (atomic, assign) float micGain;//0~1.0

- (void)LiveInit:(NSURL*)rtmpUrl Preview:(UIView*)previewView;

/**
 *  直播初始化
 *
 *  @param rtmpUrl     rtmp 地址
 *  @param previewView 预加载背景图
 *  @param videSize    分辨率
 *  @param iBitRate    码率
 *  @param iFrameRate  帧率
 */
- (void)LiveInit:(NSURL*)rtmpUrl Preview:(UIView*)previewView VideSize:(CGSize)videSize BitRate:(LIVE_BITRATE)iBitRate FrameRate:(LIVE_FRAMERATE)iFrameRate;

/**
 *  释放直播任务
 */
- (void)LiveRelease;

/**
 *  连接 rtmp
 */
- (void)connect;


/**
 *  断开与 rtmp 的连接
 */
- (void)disconnect;

/**
 *  切换前后摄像头
 *
 *  @param bCameraFrontFlag false -> backCamera, true -> frontCamera
 */
- (void)setCameraFront:(Boolean)bCameraFrontFlag;


/*
 *  滤镜效果选择
 *
 *  @param type  LIVE_FILTER_ORIGINAL:原始;
                LIVE_FILTER_BEAUTY:美颜;
                LIVE_FILTER_ANTIQUE:复古;
                LIVE_FILTER_BLACK:黑白
 */
- (void)setFilter:(LIVE_FILTER_TYPE) type;


/**
 *  聚焦位置设定
 *
 *  @param point 聚焦到 point 点
 */
- (void)focuxAtPoint:(CGPoint)point;


//VCSessionDelegate protocal

/**
 *  rtmp 连接 状态
 *
 *  @param sessionState 连接状态
 */
- (void) connectionStatusChanged: (VCSessionState) sessionState;

@end
