//
//  DJUSpecialLectureToeicScoreViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 25..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUSpecialLectureToeicScoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> 
{
    BOOL isLoading;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) NSString *djuUserCookie;
@property (strong, nonatomic) NSMutableArray *cellContent;
@property (strong, nonatomic) NSMutableArray *carrierLog;
@property (strong, nonatomic) NSMutableArray *toeicLog;
@property (strong, nonatomic) NSMutableArray *englishLog;
@property NSInteger carrierNum;
@property NSInteger toeicNum;
@property NSInteger englishNum;


@end
