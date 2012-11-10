//
//  TSMasterViewController.m
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import "TSMasterViewController.h"

@interface TSMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation TSMasterViewController
@synthesize searchResults;
@synthesize data;

+(NSString*)encodeURL:(NSString *)string{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)localSearchBar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        localSearchBar.text = [defaults objectForKey:@"last_search"];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)localsearchBar{
    [_objects removeAllObjects];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [db destroyTweets];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fixed_search = [TSMasterViewController encodeURL:[defaults objectForKey:@"last_search"]];
    NSString *urlstr = [[NSString alloc]initWithFormat:@"http://search.twitter.com/search.json?q=%@",fixed_search];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.searchDisplayController setActive:NO animated:YES];
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:searchTerm forKey:@"last_search"];
	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];    }
	
    [[self searchResults] removeAllObjects];
	
    if ([searchTerm length] != 0)
    {
        for (Tweet *currentTweet in _objects)
        {
            if ([[currentTweet tweetText] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [[self searchResults] addObject:currentTweet];
            }
        }
    }
}
// NETWORKING CODE BEGINS HERE #####################################

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    NSString *next_page = [[NSString alloc] initWithFormat:@"http://search.twitter.com/search.json%@",[json objectForKey:@"next_page"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:next_page forKey:@"next_page"];
    [defaults synchronize];
    for (NSDictionary *single_tweet in [json objectForKey:@"results"]) {
      Tweet *new_tweet = [[Tweet alloc]initWithPosterContentAndProfileURL:[single_tweet objectForKey:@"from_user"] Content:[single_tweet objectForKey:@"text"] ProfileURL:[single_tweet objectForKey:@"profile_image_url"]];
        [self insertNewObject:new_tweet];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request to Twitter could not complete - please make sure you're connected to either 3G/4G or Wi-Fi." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;


}


// END OF NETWORKING CODE###########################################
- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    _objects = [db getTweets];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Load More Tweets"];
    [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.refreshControl addTarget:self
                        action:@selector(refreshView:)
                        forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _objects = nil;
}

- (void)insertNewObject:(Tweet *)tweet
{
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [_objects insertObject:tweet atIndex:0];
    [db insertTweet:tweet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        rows = [[self searchResults] count];
    else
        rows = [_objects count];
	
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *tweetText = nil;
    NSString *tweetAuthor = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView]){
        tweetText = [[[self searchResults] objectAtIndex:row]tweetText];
        tweetAuthor = [[[self searchResults] objectAtIndex:row]tweetPoster];
    }
    else{
        tweetText = [[_objects objectAtIndex:row]tweetText];
        tweetAuthor = [[_objects objectAtIndex:row]tweetPoster];
    }
	
    static NSString *CellIdentifier = @"CustomCell";
	
    TSCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
	cell.textLabel.text = tweetText;
    cell.detailTextLabel.text = tweetAuthor;
	
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
//##### INFINITE SCROLL
 -(void)refreshView:(UIRefreshControl *)refresh {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

         NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"next_page"]];
     if(url){
         NSURLRequest *request = [NSURLRequest requestWithURL:url];
         NSURLConnection *res = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     if(res.originalRequest.HTTPBody){
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"MMM d, h:mm a"];
          NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
          [formatter stringFromDate:[NSDate date]]];
          refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
          
         [self.tableView reloadData];
     }
     refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];

         }
     [refresh endRefreshing];
}
//######################
@end
