//
//  DJUSubjectProcessTableViewCell.h
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 6..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJUSubjectProcessTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *subType;
@property (strong, nonatomic) IBOutlet UILabel *subName;
@property (strong, nonatomic) IBOutlet UILabel *subPoint;
@property (strong, nonatomic) IBOutlet UILabel *subScore;
@property (strong, nonatomic) IBOutlet UILabel *subMark;
@property (strong, nonatomic) IBOutlet UILabel *subYear;
@property (strong, nonatomic) IBOutlet UILabel *subSem;
@end
