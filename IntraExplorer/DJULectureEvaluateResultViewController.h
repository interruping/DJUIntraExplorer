//
//  DJULectureEvaluateResultViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 7..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJULectureEvaluateResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString *djuUserCookie;
@property (strong, nonatomic) UIView *pickerView;
@property (nonatomic, strong) NSString *isYearSmt;
@property (nonatomic, strong) NSString *isDptCd;
@property (nonatomic, strong) NSString *isValDiv;
@property (strong, nonatomic) NSMutableArray *yearSmts;
@property (strong, nonatomic) NSMutableArray *dptCds;
@property (strong, nonatomic) NSMutableArray *valDivs ;
@property (strong, nonatomic) NSMutableDictionary *yearSmtDic;
@property (strong, nonatomic) NSMutableDictionary *dptCdDic;
@property (strong, nonatomic) NSMutableDictionary *valDivDic;
@property (strong, nonatomic) NSMutableArray *lectureEvaluates;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property CGRect screenRect;//스크린 정보
@property CGFloat screenWidth;//스크린 너비
@property CGFloat screenHeight;//스크린 높이
@property (strong, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)searchSem:(id)sender;
@end
