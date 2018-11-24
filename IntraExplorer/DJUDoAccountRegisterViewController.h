//
//  DJUDoAccountRegisterViewController.h
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 30..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUDoAccountRegisterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString *djuUserCookie;
@property (nonatomic, strong) NSString *stdNum;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSMutableDictionary *djuBanks;
@property (nonatomic, strong) NSMutableArray *bankNames;
@property (strong, nonatomic) IBOutlet UITextField *bankNum;
@property (strong, nonatomic) IBOutlet UITextField *ownerNm;

@end
