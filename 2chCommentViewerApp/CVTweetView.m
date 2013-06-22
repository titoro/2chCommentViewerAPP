//
//  CVTweetView.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/05/22.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetView.h"

extern NSString *touchedTable;
@interface CVTweetView ()

@end
@implementation CVTweetView

@synthesize accountId = _accountId;
@synthesize detailView = _detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    UIViewController *viewController = [[CVTweetTableViewController alloc] init];
//	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    
//    [self.view addSubview:[navigationController view]];
    
    // サイズを指定した生成例
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    
    //アプリケーションデリゲートから値を取り出す
    /*
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    label.text = appDelegate.touchedTableTweet;
    */
    
    /**** test code  ****/
//    label.text = touchedTable;
//    [self.view addSubview:label];
    /***             ***/
    
    //twitterのタイムラインの情報の取得
    //accountStore = [[ACAccountStore alloc] init];
    //accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //test
    //[self tweet:@"2ch"];
    
    userNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetTextArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    accountStore = [[ACAccountStore alloc]init];
	accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
		if(granted)
		{
			NSArray *accounts = [accountStore accountsWithAccountType:accountType];
			if([accounts count] > 0)
			{
				account = [accounts objectAtIndex:0];
				self.accountId = account.identifier;
                NSLog(@"%@",account);
			}
		}
	}];
    
    //タイムラインを表示
    [self loadTimeline];
    
}

//twitter OAuth Request
-(void)tweet:(NSString *)message{
    NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/update.json"];
    
    // サービスからアプリ用に割り当てられたKeyとSecret
    NSString* consumerKey = @"aovoz75XqdBMGxj3F1dfg";
    NSString* consumerSecret = @"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY";
    
    // API問い合わせにつかうクライアント単位のKeyとSecret
    NSString* tokenKey = nil;
    NSString* tokenSecret = nil;
    
    OAConsumer *consumer = [[OAConsumer alloc]
                             initWithKey:consumerKey secret:consumerSecret];
    OAToken* token = tokenKey ? [[OAToken alloc]
                                  initWithKey:tokenKey secret:tokenSecret]  : nil;
    
    // リクエストを生成する
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                     initWithURL:url consumer:consumer
                                     token:token realm:nil signatureProvider:nil];
    
    // リクエストを実行する
    OADataFetcher* fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    
//    OAConsumer *consumer =
//    [[OAConsumer alloc] initWithKey:@"aovoz75XqdBMGxj3F1dfg"
//                              secret:@"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY"];
//    OAToken *accessToken =
//    [[OAToken alloc] initWithKey:@"215992182-56ELH2oBtBmYqltZHIwEk31ieF70e2YDii5RpHIX"
//                           secret:@"oGxMWDDJ0mtE0uzpukeb15pHP6W8iJjijmSUKUAYecI"];
    
    
//    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
//                                                                    consumer:consumer
//                                                                       token:accessToken
//                                                                       realm:nil
//                                                           signatureProvider:nil];

    [request setHTTPMethod:@"POST"];
    NSString *bodyString = [NSString stringWithFormat:@"status=%@",
                            (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(  
                                                                                kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)message,
                                                                                NULL,
                                                                                NULL,
                                                                                kCFStringEncodingUTF8)];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",request);
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(ticket:didFinishWithData:)
//                  didFailSelector:@selector(ticket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
         didFinishWithData:(NSData *)data {
    NSString *response = [[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", response);
}
- (void)requestTokenTicket:(OAServiceTicket *)ticket
          didFailWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
}

- (void)ticket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@", dataString);
}

- (void)ticket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

//twitteAccountの取得
//- (NSArray *)fetchAccounts
//{
////    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
////    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
////        
////    NSArray *accounts = [NSArray array];
////    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:
////     ^(BOOL granted, NSError *error) {
////         if (granted) {
////             account = [accountStore accountsWithAccountType:accountType];
////         }
////     }];
////    NSLog(@"%@",account);
////    return account;
//}

- (void)loadTimeline{
	
    //未認可のリクエストトークンをtwitterから取得
    OAConsumer *consumer =
    [[OAConsumer alloc] initWithKey:@"aovoz75XqdBMGxj3F1dfg"
                            secret:@"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY"];
    OAToken *accessToken =
        [[OAToken alloc] initWithKey:@"215992182-56ELH2oBtBmYqltZHIwEk31ieF70e2YDii5RpHIX"
                        secret:@"oGxMWDDJ0mtE0uzpukeb15pHP6W8iJjijmSUKUAYecI"];

    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/firehose"];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:consumer
                                                                    token:accessToken
                                                                    realm:nil
                                                        signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];

    
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
		if(granted)
		{
			NSArray *accountstores = [accountStore accountsWithAccountType:accountType];
			if([accountstores count] > 0)
			{
				account = [accountstores objectAtIndex:0];
				self.accountId = account.identifier;
			}
		}
	}];
    
    
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error) {
                                if (granted) {
                                    
                                    if (account == nil) {
                                        NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
//                                        NSArray *accountArray = [self fetchAccounts];
                                        account = [accountArray objectAtIndex:0];
                                        NSLog(@"%@",account);
                                    }
                                    
                                    if (account != nil) {
//                                        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/firehose"];
                                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                        [params setObject:@"20" forKey:@"count"];
                                        [params setObject:@"1" forKey:@"include_entities"];
                                        [params setObject:@"1" forKey:@"include_rts"];
                                        
                                        TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                                                 parameters:params
                                                                              requestMethod:TWRequestMethodGET];
                                        [request setAccount:account];
                                        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                            
                                            if (responseData) {
                                                NSError *jsonError;
                                                NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                    options:NSJSONReadingMutableLeaves error:&jsonError];
                                                NSLog(@"%@", timeline);
                                            }
                                            
                                        }];
                                    }
                                }
                            }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end