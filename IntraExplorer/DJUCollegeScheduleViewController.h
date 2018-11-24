//
//  DJUCollegeScheduleViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 28..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUCollegeScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong) NSString *isYear;
@property (nonatomic, strong) NSString *isSem;
@property (nonatomic, strong) NSMutableArray *yearArr;
@property (nonatomic, strong) NSMutableArray *semArr;
@property (nonatomic, strong) NSMutableArray *scheduleArr;
@property (strong, nonatomic) UIView *pickerView;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property CGRect screenRect;//스크린 정보
@property CGFloat screenWidth;//스크린 너비
@property CGFloat screenHeight;//스크린 높이
- (IBAction)closePicker;
- (IBAction)searchSem:(id)sender;

@end
