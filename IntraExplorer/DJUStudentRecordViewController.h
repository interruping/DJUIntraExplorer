//
//  DJUStudentRecordViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 5..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUStudentRecordViewController : UIViewController
@property (nonatomic, strong) NSString *djuUserCookie;
@property (strong, nonatomic) IBOutlet UILabel *stdNum;
@property (strong, nonatomic) IBOutlet UILabel *stdName;
@property (strong, nonatomic) IBOutlet UILabel *idNum;
@property (strong, nonatomic) IBOutlet UILabel *colName;
@property (strong, nonatomic) IBOutlet UILabel *stdStatus;
@property (strong, nonatomic) IBOutlet UILabel *entranceYear;
@property (strong, nonatomic) IBOutlet UILabel *entranceType;
@property (strong, nonatomic) IBOutlet UILabel *chinesName;
@property (strong, nonatomic) IBOutlet UILabel *engName;
@property (strong, nonatomic) IBOutlet UILabel *highSchool;
@property (strong, nonatomic) IBOutlet UILabel *highSchoolGraduateDate;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) IBOutlet UILabel *cellPhoneNum;
@property (strong, nonatomic) IBOutlet UILabel *emailAdr;
@property (strong, nonatomic) IBOutlet UILabel *stdYearInfo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


@end
