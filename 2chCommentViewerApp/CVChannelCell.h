//
//  CVChannelCell.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVChannelCell : UITableViewCell{
    //サブビュー
    UILabel* channelName;   //チャンネル名
    UILabel* title;         //放送中の番組名
    UILabel* movement;      //勢い
}

@end
