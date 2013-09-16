//
//  CVTweetDelegate.m
//  2chCommentViewerApp
//
//  Created by hiroki on 13/09/08.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetDelegate.h"

@implementation CVTweetDelegate
@synthesize touchedCellText = _touchedCellText;
-(void)touchedCellDelegate:(NSString*)cell{
    CVChannelListController *sdelegate = [[CVChannelListController alloc] initWithNibName:@"CVChannelListController" bundle:[NSBundle mainBundle]];
    sdelegate.tableView.delegate = self;
    _touchedCellText = cell;
}

//タッチされたセルのidを保存
-(void)setTouchedCell:(id)a{
    touchedCellId = a;
}
@end
