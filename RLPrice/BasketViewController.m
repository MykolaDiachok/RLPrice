//
//  BasketViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/21/15.
//  Copyright © 2015 Mikola Dyachok. All rights reserved.
//

#import "BasketViewController.h"
#import "UIImageView+WebCache.h"

@interface BasketViewController ()<UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic) UISearchController *searchController;

@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupSearchBar];
    // Do any additional setup after loading the view.
}


- (void)setupSearchBar{
	if (!self.tableView.allowsMultipleSelection) {
		//------------search bar------------------------//
		self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
		self.searchController.searchResultsUpdater = self;
		self.searchController.dimsBackgroundDuringPresentation = NO;
		self.searchController.searchBar.delegate = self;
		self.tableView.tableHeaderView = self.searchController.searchBar;
		self.definesPresentationContext = YES;
		[self.searchController.searchBar sizeToFit];
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
	self = [super initWithCoder:aCoder];
	if (self) {
		// Custom the table
		
		// The className to query on
		self.parseClassName = @"Basket";
		
		// The key of the PFObject to display in the label of the default cell style
		//        self.textKey = @"nombrePanaderia";
		
		// Whether the built-in pull-to-refresh is enabled
		self.pullToRefreshEnabled = YES;
		
		// Whether the built-in pagination is enabled
		self.paginationEnabled = YES;
		
		// The number of objects to show per page
		self.objectsPerPage = 25;
		
	}
	return self;
}

- (PFQuery *)queryForTable
{
	PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
	
	[query whereKey:@"sent" equalTo: @NO];
	[query includeKey:@"ParseItems"];
	[query includeKey:@"ParseItems.image"];
	[query whereKey:@"user" equalTo:[PFUser currentUser]];
	if (self.searchController.searchBar.text.length) {
		[query whereKey:@"name" matchesRegex:self.searchController.searchBar.text modifiers:@"mi"];
		query.cachePolicy = kPFCachePolicyIgnoreCache;
	}
	else{
		
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
		query.maxCacheAge=60*60;
		
	}
	//NSLog(@"%@", self.searchController.searchBar.text);
	[query orderByAscending:@"sortcode"];
	
	return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
	
	static NSString *CellIdentifier = @"cell";

	UITableViewCell *cell;
	
		cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}


	
	UILabel *itemName = (UILabel *)[cell viewWithTag:1];
	itemName.text = [NSString stringWithFormat:@"%@",object[@"name"]];
	itemName.numberOfLines = 0;
	
	
	UILabel *labelUSD = (UILabel *)[cell viewWithTag:3];
	labelUSD.text = [NSString stringWithFormat:@"$%.02f", [object[@"requiredpriceUSD"] floatValue]];
	
	UILabel *labelUAH = (UILabel *)[cell viewWithTag:4];
	labelUAH.text = [NSString stringWithFormat:@"₴%.02f", [object[@"requiredpriceUAH"] floatValue]];
	
	UILabel *labelQuatity = (UILabel *)[cell viewWithTag:5];
	labelQuatity.text = [NSString stringWithFormat:@"%0li", [object[@"quantity"] longValue]];
	
	
	UIImageView *itemImage = (UIImageView *)[cell viewWithTag:2];
	
	
	
	PFObject *item = [object objectForKey:@"parseItem"];
	
	
	PFQuery *query = [PFQuery queryWithClassName:@"ParseItems"];
	[query getObjectInBackgroundWithId:item.objectId block:^(PFObject *object, NSError *error) {
		
		PFFile *theImage = [object objectForKey:@"image"];
		
		
		[itemImage setShowActivityIndicatorView:YES];
		[itemImage setIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[itemImage sd_setImageWithURL:[NSURL URLWithString:theImage.url ]
					 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
		[itemImage setContentMode:UIViewContentModeScaleAspectFit];
		
	}];
	
	
	
	return cell;
}


//http://stackoverflow.com/questions/27253685/paging-pfquerytableviewcontroller-automatically

- (IBAction)nextPage:(id)sender
{
	[self loadNextPageInTable];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
	
	
	
	CGPoint offset = aScrollView.contentOffset;
	CGRect bounds = aScrollView.bounds;
	CGSize size = aScrollView.contentSize;
	UIEdgeInsets inset = aScrollView.contentInset;
	float y = offset.y + bounds.size.height - inset.bottom;
	float h = size.height;
	float reload_distance = 15;
	if(y > h + reload_distance) {
		//NSLog(@"load more rows");
		[self loadNextPageInTable];
	}
}

-(void) loadNextPageInTable {
	
	[self loadNextPage];
	//NSLog(@"NEW PAGE LOADED");
}




- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
	[self loadObjects];
}

- (IBAction)btnAdd:(UIButton *)sender {
	
}


- (IBAction)btnDel:(UIButton *)sender {
	
}



@end
