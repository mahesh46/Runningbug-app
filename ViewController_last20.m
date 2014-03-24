//
//  ViewController.m
//  jsonexample
//
//  Created by Mahesh Lad on 07/11/2013.
//  Copyright (c) 2013 Mahesh Lad. All rights reserved.
//
//----------------------------------------------------------------------------------------
//                    // we'll receive raw data so we'll create an NSData Object with it
//                    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
//
//                    // now we'll parse our data using NSJSONSerialization
//                    id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];
//
//                    // typecast an array and list its contents
//                    NSArray *jsonArray = (NSArray *)myJSON;
//
//                    // take a look at all elements in the array
//                    for (id element in jsonArray) {
//                        NSLog(@"Element: %@", [element description]);
//                    }
//----------------------------------------------------------------------------------------


#import "ViewController_last20.h"
#import "NSString_stripHtml.h"
#import "SWRevealViewController.h"

@interface ViewController_lat20()

@end

@implementation ViewController_lat20
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = @"Last 20 bugmiles";
   
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //load json and refresh table to see the latest
    [self parseJSONBugMiles];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    data = [[NSMutableData alloc] init];
    }


-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)theData
{
     NSLog(@"didReceiveData");
    [data appendData:theData];
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSLog(@"connectionDidFinishLoading");
    //close spinning wheel
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error
{
    NSLog(@"conn didFailWithError");
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download could not complete -please connect through wifi or 3g" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    
    //close spinning wheel
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    NSLog(@"numberOfsectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    NSLog(@" number of records %lu",(unsigned long)[record count]);
    
   return [record count];
    
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* bugmilerecord = [record objectAtIndex:indexPath.row];
// 2) Get user id
//    NSNumber* userid = [bugmilerecord objectForKey:@"UserId"];
//     NSLog(@" user id: %@", userid);
    
  
    cell.textLabel.text =    [NSString stringWithFormat:@"%@ in %@", [bugmilerecord objectForKey:@"DistanceMilesString"],[bugmilerecord objectForKey:@"DurationString"]];
   NSString * comment = [NSString stringWithFormat:@"%@",[bugmilerecord objectForKey:@"Comment"]];
    //strip tags from comment field
    NSString* stripped = [comment stripHtml];

     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", stripped];
    
    cell.imageView.image = [UIImage imageNamed:@"runningbug1.png"];
   
// NSString* mystring = @"<b>Hello</b> World!!";
// NSString* stripped = [mystring stripHtml];
    
    NSLog(@"%@",stripped);
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{    //set row width
//    //return [indexPath row] * 1.5; // your dynamic height...
//    return 100;
//    
//}

-(void) parseJSONBugMiles
{
    //spinning wheel
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    NSLog(@"record json parse");
    //json parse
    
    NSURL *myURL = [[NSURL alloc]initWithString:@"http://therunningbug-staging.co.uk/api.ashx/v2/bugmiles.json?PageIndex=1&PageSize=20&Hydrated=True"];
    //  NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[myURL standardizedURL]];
    
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"bjFyd3hicGdld3FoOk1vYmlsZVRlc3RVc2Vy" forHTTPHeaderField:@"Rest-User-Token"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *retrievedJTransD = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    record = retrievedJTransD[@"Bugmiles"];
    
    
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response //1
                          
                          options:kNilOptions
                          error:&error];
    
    
    record = [json objectForKey:@"Bugmiles"];
    
    NSLog(@"Bugmiles: %@", record);
    
    NSLog(@"tbl reloadData");
    [_tableView reloadData];
    
    //close spinning wheel
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
-(void) viewDidUnload{
    //release
    //e.g. self.myoutlet = nil
    self.tableView = nil;
    
}
@end
