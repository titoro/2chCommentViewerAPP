//
//  CVChannel.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVChannel : NSObject{
    NSString* _identifer;       //識別子
    BOOL _read;                 //読み込みフラグ
    NSString* _channelName;     //チャンネル名
    NSMutableArray* _channels;  //チャンネルを格納
}
@property(nonatomic, retain) NSString* identifer;

@property(nonatomic, retain) NSString* channelName;
@property(nonatomic, readonly) NSMutableArray* channels;
@end
