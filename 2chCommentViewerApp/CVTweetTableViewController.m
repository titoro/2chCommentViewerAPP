//
//  CVTweetTableViewController.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/05/24.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetTableViewController.h"

@interface CVTweetTableViewController ()

@end

@implementation CVTweetTableViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    userNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetTextArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadTimeline];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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

- (void)loadTimeline{
    
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error) {
    if (granted) {
                                    
            if (account == nil) {
                    NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
                    account = [accountArray objectAtIndex:0];
            }
                                    
            if (account != nil) {
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=hiro_JL5 "];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
