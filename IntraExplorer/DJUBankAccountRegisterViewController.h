//
//  DJUBankAccountRegisterViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 29..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUBankAccountRegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong) NSString *stdNum;
@property (strong, nonatomic) IBOutlet UILabel *bank;
@property (strong, nonatomic) IBOutlet UILabel *bankNum;
@property (strong, nonatomic) IBOutlet UILabel *bankOwner;
@property (strong, nonatomic) IBOutlet UILabel *stdNm;
@property (strong, nonatomic) IBOutlet UILabel *modyfiyDt;
@property (strong, nonatomic) IBOutlet UILabel *bankNumYn;

@end
