//
//  ExchangeTableViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/12/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

#import "ExchangeTableViewController.h"


@interface ExchangeTableViewController()

@end

@implementation ExchangeTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"ExchangeRates";
        self.
        
        // The key of the PFObject to display in the label of the default cell style
//        self.textKey = @"nombrePanaderia";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
//        self.objectsPerPage = 3;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit=1;
    [query orderByDescending:@"dateSet"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            
        } else {
            
            self.title=[NSString stringWithFormat:@"$=%.02f", [object[@"rate"] floatValue]];
            
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    

}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    NSDate *now = [NSDate date];
    NSDate *sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    [query setLimit:5];
    [query whereKey:@"dateSet" greaterThan:sevenDaysAgo];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query orderByDescending:@"dateSet"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    UILabel *info = (UILabel *)[cell viewWithTag:1];
    UILabel* rate = (UILabel *)[cell viewWithTag:2];
    NSLog(@"%@:::%@",object[@"dateSet"],object[@"rate"]);
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSString *rateDate = [dateFormatter stringFromDate:object[@"dateSet"]];
    
    info.text = [NSString stringWithFormat:@"%@",rateDate];
    rate.text = [NSString stringWithFormat:@"%.02f", [object[@"rate"] floatValue]];
//    cell.lblNombrePanaderia.text = [object objectForKey:@"nombrePanaderia"];
//    cell.lblDescripcionPanaderia.text = [object objectForKey:@"descripcion"];
    
    
    return cell;
}

@end
