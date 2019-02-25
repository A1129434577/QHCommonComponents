//
//  DDPlayerTool.m
//  duoduo
//
//  Created by lockezhang on 16/3/28.
//  Copyright © 2016年 Locke. All rights reserved.
//

#import "AMRPlayerTool.h"

@interface AMRPlayerTool ()
<AVAudioPlayerDelegate>
@property (copy, nonatomic)NSString *recordFileName;
@property (copy, nonatomic)NSString *recordFilePath;


@property (nonatomic,strong)NSTimer *timer;
@end

static AMRPlayerTool  *_toolsManager;
@implementation AMRPlayerTool

+ (AMRPlayerTool *)share {
    if (!_toolsManager) {
        _toolsManager = [[AMRPlayerTool alloc] init];
    }
    return _toolsManager;
}

/** 播放本地音乐 */
- (void)playAudioWithName:(NSString *)audioName
                     type:(NSString *)type {
    if (!audioName.length) return;
    
    NSString *voicePath = [[NSBundle mainBundle] pathForResource:audioName ofType:type];
    [self playPath:voicePath];
}

-(void)playPath:(NSString *)path{
    //把定时器添加到当前runloop中,用于解决在定时器启动时，其他的手势操作对定时器的影响
    if (!path.length) return;
    
    // 1 切换到播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    if (self.player.isPlaying){
        [self stopMusic];
    }
    // 2.播放器没有创建，进行初始化
    if (!self.player) {
        // 音频文件的URL
        NSURL *url = [NSURL URLWithString:path];
        if (!url) return;
        
        // 创建播放器(一个AVAudioPlayer只能播放一个URL)
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player.delegate = self;
        self.player.meteringEnabled = YES; // 音量检测必须(要想实时获取音量值，必须设置这个属性为yes)
        // 缓冲
        if (![self.player prepareToPlay]) return;
    }
    // 3.播放
    if (!self.player.isPlaying) {
        [self.player play];
        return;
    }
    // 正在播放就停止
    [self stopMusic];
}

/**
 *  停止播放
 */
- (void)stopMusic {
    [self.player stop];
    [self.timer invalidate];
    self.timer = nil;
    self.player = nil;
    // 通知外部代理对象停止播放了
    [self sendDelegateStopPlay];
    
    // 通知外部的block对象停止播放了
    if (self.stopPlayingBlock) {
        self.stopPlayingBlock();
    }
}

/**
 * 通知代理对象停止播放
 **/
- (void)sendDelegateStopPlay {
    if ([self.delegate respondsToSelector:@selector(stopPlayVoice)]) {
        [self.delegate stopPlayVoice];
    }
}

#pragma mark - AVAudioPlayerDelegate
/** 播放完成 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.finishBlock) {
        [self fishMusic];
        return;
    }
    [self stopMusic];
}

/** 播放发生错误 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [self stopMusic];
}

-(void)pauseMusic{
    [self.player pause];
}

-(void)goOnMusic{
    [self.player play];
}

/**
 *  完成播放
 */
- (void)fishMusic {
    [self.player stop];
    [self.timer invalidate];
    self.timer = nil;
    self.player = nil;
    // 通知外部的block对象停止播放了
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
