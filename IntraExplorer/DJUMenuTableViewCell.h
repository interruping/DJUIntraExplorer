//
//  DJUMenuTableViewCell.h
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 15..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUMenuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *menuTitle;
@property NSString *menuConnectUrl;

@end
