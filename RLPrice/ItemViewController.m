//
//  ItemViewController.m
//  RLPrice
//
//  Created by Mikola Dyachok on 9/21/15.
//  Copyright © 2015 Mikola Dyachok. All rights reserved.
//

#import "ItemViewController.h"
#import "UIImageView+WebCache.h"

@interface ItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;

@property (weak, nonatomic) IBOutlet UIImageView *imgItem;

@property (weak, nonatomic) IBOutlet UIWebView *webviewItem;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.curItem[@"Name"];
	self.lblItemName.text = self.curItem[@"Name"];
	
    
    PFFile *theImage = [self.curItem objectForKey:@"image"];
    
    
    [self.imgItem setShowActivityIndicatorView:YES];
    [self.imgItem  setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imgItem  sd_setImageWithURL:[NSURL URLWithString:theImage.url ]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imgItem  setContentMode:UIViewContentModeScaleAspectFit];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
