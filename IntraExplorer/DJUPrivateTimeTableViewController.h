//
//  DJUPrivateTimeTableViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 26..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUPrivateTimeTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong) NSMutableArray *lectureInfos;
@property (nonatomic, strong) NSMutableArray *lectureDetails;

@end
