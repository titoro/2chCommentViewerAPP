//
//  CVTweetDelegate.h
//  2chCommentViewerApp
//
//  Created by hiroki on 13/09/08.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVChannelListController.h"
#import "CVTweetTagView.h"

@interface CVTweetDelegate : NSObject<UITableViewDelegate>{
    id touchedCellId;
}
@property (nonatomic, strong) NSString* touchedCellText;
-(void)touchedCellDelegate:(NSString*)cell;
-(void)setTouchedCell:(id)a;
@end

@protocol CVTweet
@end

