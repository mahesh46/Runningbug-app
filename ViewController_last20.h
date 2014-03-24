//
//  ViewController.h
//  jsonexample
//
//  Created by Mahesh Lad on 07/11/2013.
//  Copyright (c) 2013 Mahesh Lad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_lat20 : UIViewController<NSURLConnectionDelegate>{
    IBOutlet UITableView * tableView;
    NSArray *record;
    NSMutableData *data;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
-(void) parseJSONBugMiles ;
@end
