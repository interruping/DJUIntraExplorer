//
//  DJUSpecialLectureToeicScoreViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 25..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUSpecialLectureToeicScoreViewController.h"
#import "DJUSpecialLectureToeicScoreTableViewCell.h"
#import "HTMLParser.h"

@interface DJUSpecialLectureToeicScoreViewController ()

@end

@implementation DJUSpecialLectureToeicScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewDidLoad
{
    isLoading = YES;
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
    [self loadScoreInfo];
    isLoading = NO;
    [_indicatorView stopAnimating];
    
    [_myTable reloadData];
    [_myTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _myTable.numberOfSections)] withRowAnimation:UITableViewRowAnimationBottom];
    [super viewDidAppear:YES];
}


- (void)loadScoreInfo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.sul.sul01Svl30?pgm_id=W_SUL350PR&pass_gbn=&dpt_ck="]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    //NSLog (@"ScoreContent === %@", bodyContent);
    
    //html 파싱
    error = nil;//NSError *error
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *tdNodes = [bodyNode findChildTags:@"td"];
    
    char count = 0;
    char carrier = 0;
    char toeic = 0;
    char english = 0;
    for ( HTMLNode *tdContent in tdNodes)
    {
        
        
        //NSLog (@"tdContent :%@", [tdContent allContents]);
        NSString *tdString = [tdContent allContents];
        NSRange isSeNum = [tdString rangeOfString:@"연번"];
        //NSLog (@"count: %i, content: %@", count, tdString);
        if(isSeNum.location != NSNotFound){
            NSLog (@"Found 연번");
            if(!carrier)
                carrier = count;
            else if(!toeic)
                toeic = count;
            else if(!english){
                english = count;
                NSLog (@"carrier:%i // toeic: %i /// english: %i",carrier, toeic, english);
            }
            
        }
        
    
    
    
    
    
        
        count++;
        
    }
   
    
    NSMutableArray *tdContents = [NSMutableArray array];
    for ( HTMLNode *tdContent in tdNodes)
    {
        NSString *str =[tdContent allContents];
        NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//공백제거
        str = [newStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];//줄바꿈제거
        [tdContents addObject: str];
        
    }
    
    
    _carrierNum = ((toeic - carrier) - 6)/6;
    _toeicNum = ((english - toeic)- 7)/7;
    _englishNum = (((count+1)-english) - 6)/6;
    
    
    NSLog (@" _carrier: %i _toeic: %i _english: %i", (int)_carrierNum, (int)_toeicNum, (int)_englishNum);
    _cellContent = [NSMutableArray array];
    _carrierLog = [NSMutableArray array];
    _toeicLog = [NSMutableArray array];
    _englishLog = [NSMutableArray array];
    

    
    int toeicCount = 0;
    int carrierCount = 0;
    int englishCount = 0;
    
    for (int i = 0; i < ++count; i++)
    {
        if( i>= carrier && i < toeic && _carrierNum != carrierCount )
        {
            carrierCount++;
            
            [_carrierLog addObject:[[NSString alloc]initWithFormat: @"%@:%@",tdContents[i+6],tdContents[i+11]]];
            i = i + 5;// 6 - 1 = 5
            
        }
        if( i >= toeic && i < english &&  _toeicNum != toeicCount )
        {
            toeicCount++;
            
            [_toeicLog addObject:[[NSString alloc]initWithFormat: @"%@:%@:%@:%@",tdContents[i+7], tdContents[i+10], tdContents[i+12],tdContents[i+13]]];
            i = i + 6;// 7 - 1 = 6
        }
        if( i >= english && i < count && _englishNum != englishCount )
        {
            englishCount++;
            [_englishLog addObject:[[NSString alloc]initWithFormat: @"%@:%@:%@:%@",tdContents[i+6], tdContents[i+9], tdContents[i+10],tdContents[i+11]]];
            i = i + 6;
        }
    }
    
    if ( _carrierNum == 0 )
    {
        _carrierNum = 1;
        [_carrierLog addObject:@"해당 없음"];
        
    }
    
    if ( _toeicNum == 0 )
    {
        _toeicNum = 1;
        [_toeicLog addObject:@"해당 없음"];
        
    }
    
    if ( _englishNum == 0 )
    {
        _englishNum = 1;
        [_englishLog addObject:@"해당 없음"];
        
    }
    [_cellContent addObject: _carrierLog];
    [_cellContent addObject: _toeicLog];
    [_cellContent addObject: _englishLog];
    
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoading)
        return 0;
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (section)
    {
        case 0:
            return _carrierNum;
            break;
        case 1:
            return _toeicNum;
            break;
        case 2:
            return _englishNum;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LectureScoreCell";
    DJUSpecialLectureToeicScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
        
    int row = (int)[indexPath row];
    NSMutableArray *result = _cellContent[indexPath.section];
    cell.infoContent.text = result[row];
    NSLog (@"cellreturn!!");
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    
    NSString *sectionTitle;
    
    switch (section)
    {
        case 0:
            sectionTitle = @"취업특강";
            break;
        case 1:
            sectionTitle = @"모의토익";
            break;
        case 2:
            sectionTitle = @"정규영어시험";
            break;
        default:
            sectionTitle = @"Error";
            break;
    }
 
    return sectionTitle;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
