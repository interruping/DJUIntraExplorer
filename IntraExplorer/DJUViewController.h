//
//  DJUViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 9..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJUUserInfoViewController.h"
#import "DJUUserModel.h"

@interface DJUViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *djuUserId;
@property (strong, nonatomic) IBOutlet UITextField *djuUserPassword;
@property (strong, nonatomic) IBOutlet UIImageView *djuLogo;
@property (strong, nonatomic) IBOutlet UISwitch *djuUserInfoStoreSwitch;
@property (strong, nonatomic) IBOutlet UILabel *djuUserInfoStoreStatus;
@property (strong, nonatomic) NSString *djuCookie;
@end
