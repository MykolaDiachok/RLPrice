//
//  NewsTableViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/22/15.
//  Copyright © 2015 Mikola Dyachok. All rights reserved.
//

#import "NewsTableViewController.h"
#import "ItemsViewController.h"
#import <Parse/Parse.h>

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) loadArray {
	self.newsArray = [NSMutableArray new];
	NSDate *now = [NSDate date];
	NSDate *DaysAgo = [now dateByAddingTimeInterval:-3*24*60*60];

	
	PFQuery *newsQuery = [PFQuery queryWithClassName:@"News"];
	[newsQuery whereKey:@"dateInfo" greaterThan:DaysAgo];
	newsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
	[newsQuery orderByDescending:@"dateInfo"];

	[newsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
	//NSArray *objects = [newsQuery findObjects];
		for (PFObject *tObject in objects) {
			NSDictionary *dNews = @{
									@"dateInfo":tObject[@"dateInfo"],
									@"string":tObject[@"info"],
									@"object":tObject,
									@"objectId":tObject.objectId,
									@"stringCell":@"ArrivalProduct"
									};
			
			[self.newsArray addObject:dNews];
//			NSLog(@"%@",tObject[@"info"]);
			
			dispatch_async(dispatch_get_main_queue(), ^{
				NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"dateInfo" ascending:NO];
				NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
				//	NSMutableArray *sortedArray = [[NSMutableArray sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
				
				self.newsArray  = [[self.newsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
				[self.tableView reloadData];
				//[self.searchDisplayController.searchResultsTableView reloadData];
			});
		}
		
		
	}];
	
	
	PFQuery *exQuery = [PFQuery queryWithClassName:@"ExchangeRates"];
	[exQuery setLimit:5];
	[exQuery whereKey:@"dateSet" greaterThan:DaysAgo];
	exQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
	[exQuery orderByDescending:@"dateSet"];
	
	//objects = [exQuery findObjects];
	[exQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		for (PFObject *tObject in objects) {
			NSDictionary *dEx = @{
									@"dateInfo":tObject[@"dateSet"],
									@"string":tObject[@"name"],
									@"object":tObject,
									@"objectId":tObject.objectId,
									@"stringCell":@"Exchange"
									};
			
			[self.newsArray addObject:dEx];
//			NSLog(@"%@",tObject[@"name"]);
			dispatch_async(dispatch_get_main_queue(), ^{
				NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"dateInfo" ascending:NO];
				NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
				//	NSMutableArray *sortedArray = [[NSMutableArray sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
				
				self.newsArray  = [[self.newsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
				[self.tableView reloadData];
				//[self.searchDisplayController.searchResultsTableView reloadData];
			});
		}
		
		
	}];
	

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"SegueArrivalProduct"]) {
		if ([segue.destinationViewController isKindOfClass:[ItemsViewController class]]){
			 NSIndexPath *indexPath = [self.nTableView indexPathForSelectedRow];
			NSDictionary* tdic=(NSDictionary*) [self.newsArray objectAtIndex:indexPath.row];
			ItemsViewController* mvc = [segue destinationViewController];
			mvc.titleInfo = tdic[@"string"];
			PFObject *tNEws = tdic[@"object"];
			mvc.pfrelationItems = [tNEws relationForKey:@"items"];
//			PFRelation *relation = [tNEws relationForKey:@"items"];
//			PFQuery *query = relation.query;
//			[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//				NSLog(@"%@",objects);
//			}];
			
			
			
//			for (NSString *object in tdic[@"object"][@"items"]) {
//				NSLog(@"%@",object);
//			}
			//arrayItems
//			PFObject *curItem = (PFObject*);
//
//			mvc.curItem =curItem;
		}
	}
	
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.newsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *item =[self.newsArray objectAtIndex:[indexPath row]];
	
	UITableViewCell *cell;
	
	if ([item[@"stringCell"] isEqualToString:@"Exchange"]) {
		cell = [self.nTableView dequeueReusableCellWithIdentifier:item[@"stringCell"]];
		
		
		// Configure the cell
		UILabel *info = (UILabel *)[cell viewWithTag:1];
		UILabel* rate = (UILabel *)[cell viewWithTag:2];
		
		
		NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		
		NSString *rateDate = [dateFormatter stringFromDate:item[@"object"][@"dateSet"]];
		
		info.text = [@"Курс " stringByAppendingString:[NSString stringWithFormat:@"%@",rateDate]];
		rate.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f", [item[@"object"][@"rate"] floatValue]]];
	}
	else{
		cell = [self.nTableView dequeueReusableCellWithIdentifier:item[@"stringCell"]];
		UILabel *itemName = (UILabel *)[cell viewWithTag:3];
		itemName.text = [NSString stringWithFormat:@"%@",item[@"string"]];
		itemName.numberOfLines = 0;
	}
	
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
