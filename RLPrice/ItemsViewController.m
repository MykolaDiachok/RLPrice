//
//  ItemsViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/13/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

//
#import "ItemsViewController.h"
#import "UIImageView+WebCache.h"

@interface ItemsViewController ()<UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic) UISearchController *searchController;


@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.curGroup[@"name"];
    [self setupSearchBar];
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
    // Dispose of any resources that can be recreated.
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"ParseItems";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segueGroup"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
////        RecipeDetailViewController *destViewController = segue.destinationViewController;
////        destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
//    }
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    self.title=self.curGroup[@"name"];
    [query whereKey:@"Availability" equalTo: @YES];
//    [query whereKey:@"parseGroupId" equalTolf.parentViewController.];
    [query whereKey:@"parseGroupId" equalTo:self.curGroup];
	if (self.searchController.searchBar.text.length) {
		[query whereKey:@"Name" matchesRegex: self.searchController.searchBar.text modifiers:@"mi"];
		query.cachePolicy = kPFCachePolicyIgnoreCache;
	}
	else{
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query.maxCacheAge=60*60;
	}
    [query orderByAscending:@"sortcode"];
    return query;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"itemCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    
//    NSLog(@"%@",object[@"Name"]);
	
    //    UIView *selectionColor = [[UIView alloc] init];
    //    selectionColor.backgroundColor = [UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    //    cell.selectedBackgroundView = selectionColor;
    
    UILabel *itemName = (UILabel *)[cell viewWithTag:1];
    itemName.text = [NSString stringWithFormat:@"%@",object[@"Name"]];
    itemName.numberOfLines = 0;
    //[itemName sizeToFit];
    //itemName.lineBreakMode = NSLineBreakByWordWrapping;

    
    UILabel *labelUSD = (UILabel *)[cell viewWithTag:3];
    labelUSD.text = [NSString stringWithFormat:@"$%.02f", [object[@"Price"] floatValue]];
    
    UILabel *labelUAH = (UILabel *)[cell viewWithTag:4];
    labelUAH.text = [NSString stringWithFormat:@"₴%.02f", [object[@"PriceUAH"] floatValue]];
    
    UILabel *labelQuatity = (UILabel *)[cell viewWithTag:5];
    labelQuatity.text = @""; //[NSString stringWithFormat:@"₴%.02f", [object[@"PriceUAH"] floatValue]];
    
    UIImageView *itemImage = (UIImageView *)[cell viewWithTag:2];

    PFFile *theImage = [object objectForKey:@"image"];
    
    
    [itemImage setShowActivityIndicatorView:YES];
    [itemImage setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [itemImage sd_setImageWithURL:[NSURL URLWithString:theImage.url ]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [itemImage setContentMode:UIViewContentModeScaleAspectFit];

    


   
   
    return cell;
}


-(CGFloat)dynamicLblHeight:(UILabel *)lbl
{
    CGFloat lblWidth = lbl.frame.size.width;
    CGRect lblTextSize = [lbl.text boundingRectWithSize:CGSizeMake(lblWidth, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:lbl.font}
                                                context:nil];
    return lblTextSize.size.height;
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
//        NSLog(@"load more rows");
        [self loadNextPageInTable];
    }
}

-(void) loadNextPageInTable {
    
    [self loadNextPage];
//    NSLog(@"NEW PAGE LOADED");
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
	[self loadObjects];
}

- (IBAction)btnAddItem:(UIButton *)sender {
    NSLog(@"%@",sender);
}

- (IBAction)btnDelItem:(UIButton *)sender {
    NSLog(@"%@",sender);
}


@end
