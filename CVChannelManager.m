//
//  CVChannelManager.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVChannelManager.h"

@implementation CVChannelManager

@synthesize channels = _channels;


-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //channelsを初期化
    _channels = [NSMutableArray array];
    
    return  self;
}

//チャンネルを管理するためのインスタンス
static CVChannelManager* _sharedInstance = nil;

//インスタンスのアクセッサメソッド
+(CVChannelManager *)sharedManager{
    //インスタンスを生成する
    if (!_sharedInstance) {
        _sharedInstance = [[CVChannelManager alloc]init];
    }
    
    return _sharedInstance;
}

-(void)addChannels:(CVChannel *)channel{
    if (!channel) {
        return;
    }
    
    //チャンネルの追加
    [_channels addObject:channel];
}

@end
