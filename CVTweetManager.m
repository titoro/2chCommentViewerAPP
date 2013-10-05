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

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

- (id)initWithStyle:(UITableViewStyle)style {
    //self = [super initWithStyle:style];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addPullToRefreshHeader];
}

- (void)setupStrings{
    textPull = @"Pull down to refresh...";
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

@end
