//
//  DJUSubjectProcessViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 6..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUSubjectProcessViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong) NSMutableArray *processInfos;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


@end
