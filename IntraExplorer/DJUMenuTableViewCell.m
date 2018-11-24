//
//  DJUMenuTableViewCell.m
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 15..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUMenuTableViewCell.h"

@implementation DJUMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[self performSegueWithIdentifier:@"cellTouch" sender: self];
    // Configure the view for the selected state
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
