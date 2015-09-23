//
//  NewsTableViewController.h
//  RLPrice
//
//  Created by Mikola Dyachok on 9/22/15.
//  Copyright © 2015 Mikola Dyachok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *nTableView;
@property (atomic) NSMutableArray *newsArray;

@end
