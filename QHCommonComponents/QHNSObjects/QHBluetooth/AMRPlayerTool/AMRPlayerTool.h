//
//  DDPlayerTool.h
//  duoduo
//
//  Created by lockezhang on 16/3/28.
//  Copyright © 2016年 Locke. All rights reserved.
//  播放器

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


/** 播放状态监听代理 ****/
@protocol AMRPlayerToolDelegate <NSObject>

@optional
/** 停止播放 */
- (void)stopPlayVoice;
@end

@interface AMRPlayerTool : NSObject

@property (nonatomic,strong)AVAudioPlayer *player;
/** 停止播放时的回调Block */
@property (nonatomic,copy)void(^stopPlayingBlock)(void);
/** 播放时－的回调Block */
@property (nonatomic,copy)void(^playTimeBlock)(float time);
@property (nonatomic,copy)void(^playVolumeBlock)(double volume);
/** 播放状态监听代理对象 ****/
@property (nonatomic,assign)id<AMRPlayerToolDelegate> delegate;
/** 播放完成的回调Block */
@property (nonatomic,copy)void(^finishBlock)(void);
/**
 * 创建和初始化播放工具类
 **/
+ (AMRPlayerTool *)share;
/** 播放本地音乐 */
- (void)playAudioWithName:(NSString *)audioName
                     type:(NSString *)type;
///** 播放音乐--从指定目录中 */
//- (void)playAudioWithName:(NSString *)audioName inFolderPath:(NSString *)inFolderPath;
///**
// *  播放音乐
// *
// *  @param filename 音乐的文件名
// */
//- (void)playMusic:(NSString *)filename;
///**
// *  播放本地音乐文件
// *
// *  @param fileName 音乐的文件名
// *  @param catalog  本地目录
// */
//- (void)playMusic:(NSString *)fileName catalog:(NSString *)catalog;
///**
// *  播放绝对路径
// */
//- (void)playPath:(NSString *)path;
/**
 *  停止播放
 */
- (void)stopMusic;
/**
 *  暂停播放
 */
- (void)pauseMusic;
/**
 *  继续播放
 */
- (void)goOnMusic;
@end
