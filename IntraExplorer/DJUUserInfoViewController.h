//
//  DJUUserInfoViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 9..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DJUUserInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> 

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userStudentNum;
@property (strong, nonatomic) IBOutlet UILabel *userMajor;
@property (strong, nonatomic) IBOutlet UILabel *userGrade;
@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) NSString *DJUUserCookie;

-(void) loadUserData;
-(IBAction)logOut:(id) sender;
@end