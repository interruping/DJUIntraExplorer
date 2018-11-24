//
//  DJULectureEvaluateTableViewCell.h
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 7..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJULectureEvaluateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lecGrade;
@property (strong, nonatomic) IBOutlet UILabel *lecNum;
@property (strong, nonatomic) IBOutlet UILabel *lecName;
@property (strong, nonatomic) IBOutlet UILabel *lecTeacher;
@property (strong, nonatomic) IBOutlet UILabel *lecPeopleNum;
@property (strong, nonatomic) IBOutlet UILabel *lecScore;
@property (strong, nonatomic) IBOutlet UILabel *lecDivNum;

@end
