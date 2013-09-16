//
//  CVTweetManager.m
//  2chCommentViewerApp
//
//  Created by hiroki on 13/09/01.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetManager.h"

@implementation CVTweetManager
@synthesize touchedCell = _touchedCell;
@synthesize isFinish = _isFinish;
@synthesize namesArray = _namesArray;

- (id)initWithNone
{
    self = [super init];
    if (self) {
        //ここに初期化
        
    }
    return self;
}

-(void)setTouched:(NSString *)text{
    touched = text;
}

- (void)dealloc
{
    self.namesArray = nil;
    //    [super dealloc];
}
@end
