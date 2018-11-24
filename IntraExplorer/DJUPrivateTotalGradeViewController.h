//
//  DJUPrivateTotalGradeViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 28..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUPrivateTotalGradeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong)NSMutableArray *gradesOfSem;
@property (nonatomic, strong)NSMutableArray *semInfo;
@end
