//
//  ItemsViewController.h
//  RLPrice
//
//  Created by Mikola Dyachok on 9/13/15.
//  Copyright (c) 2015 Mikola Dyachok. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface ItemsViewController : PFQueryTableViewController<UISearchBarDelegate>
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@property (nonatomic) PFObject *curGroup;
@property (nonatomic) PFRelation *pfrelationItems;
@property (nonatomic) NSString *titleInfo;

@end
