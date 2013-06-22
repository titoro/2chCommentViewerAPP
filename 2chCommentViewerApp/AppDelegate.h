//
//  AppDelegate.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVChannelListController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CVChannelListController *cvChannelListController;
@end
