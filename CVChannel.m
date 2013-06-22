//
//  CVChannel.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVChannel.h"

@implementation CVChannel

@synthesize identifer = _identifer;
@synthesize channelName = _channelName;
@synthesize channels = _channels;

-(id)init{
    self  = [super init];
    if (!self) {
        return nil;
    }
    
    //識別子を作成する
    CFUUIDRef uuid;
    uuid = CFUUIDCreate(NULL);
    _identifer = (__bridge NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    //チャンネルを取得
    [self getChannels];
    
    return self;
}

-(BOOL)getChannels{
    BOOL getflag;
    
    //チャンネルをテスト用に指定
    _channels = [[NSMutableArray alloc]initWithObjects:@"NHK教育",@"TBS",@"テレビ朝日",
                            @"日本テレビ",@"フジテレビ",@"テレビ東京", nil];
    
    //チャンネルを取得したかどうかの判定
    if(!_channels){
        getflag = NO;
    }else {
        getflag = YES;
    }
    return getflag;
}

-(void)dealloc{
    
}

@end
