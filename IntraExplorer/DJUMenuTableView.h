//
//  DJUMenuTableView.h
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 15..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJUMenuTableViewCell.h"

@interface DJUMenuTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
@property NSArray *menuList;
@end
