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
@synthesize savedSearchTerm;
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)localsearchBar{
    [_objects removeAllObjects];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *fixed_search = [TSMasterViewController encodeURL:savedSearchTerm];
    NSString *urlstr = [[NSString alloc]initWithFormat:@"http://search.twitter.com/search.json?q=%@",fixed_search];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.searchDisplayController setActive:NO animated:YES];
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];    }
	
    [[self searchResults] removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0)
    {
        for (TSTweet *currentTweet in _objects)
        {
            if ([[currentTweet content] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
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
    // NSLog(@"First tweet text %@", [json allKeys]);
    for (NSDictionary *single_tweet in [json objectForKey:@"results"]) {
        TSTweet *new_tweet = [[TSTweet alloc]initWithPosterContentAndProfileURL:[single_tweet objectForKey:@"from_user_name"] Content:[single_tweet objectForKey:@"text"] ProfileURL:[single_tweet objectForKey:@"profile_image_url"]];
        [self insertNewObject:new_tweet];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download could not complete - please make sure you're connected to either 3G/4G or Wi-Fi." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
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
    
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(TSTweet *)tweet
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:tweet atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    NSString *contentForThisRow = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        contentForThisRow = [[[self searchResults] objectAtIndex:row]content];
    else
        contentForThisRow = [[_objects objectAtIndex:row]content];
	
    static NSString *CellIdentifier = @"CellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    [[cell textLabel] setText:contentForThisRow];
	
    return cell;
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
@end
