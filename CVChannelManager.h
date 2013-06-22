//
//  CVChannelManager.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVChannel.h"

@interface CVChannelManager : NSObject{
    NSMutableArray* _channels;
}

@property(nonatomic, retain) NSArray* channels;

+(CVChannelManager *)sharedManager;

//チャンネルの操作
-(void)addChannels:(CVChannel *)channel;

@end
