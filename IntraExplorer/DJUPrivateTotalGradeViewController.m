//
//  DJUPrivateTotalGradeViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 28..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUPrivateTotalGradeViewController.h"
#import "DJUPrivateTotalGradeTableViewCell.h"
#import "HTMLParser.h"


@interface DJUPrivateTotalGradeViewController ()

@end

@implementation DJUPrivateTotalGradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadTotalGrade
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.suh.suh04Svl01?pgm_id=W_SUH080PQ&pass_gbn=001&dpt_ck="]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    //NSLog (@"totalGrade: %@", bodyContent);
    
    error = nil;//NSError *error
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    HTMLNode *bodyNode = [parser body];
    
    
    NSArray *trNodes = [bodyNode findChildTags:@"tr"];
    NSMutableArray *trContents = [NSMutableArray array];
    
    unsigned char SemNum = 0; //학기 갯수
    unsigned int indexCount = 0; //인덱싱을 위한 변수
    
    NSMutableArray *gradesBegin = [NSMutableArray array]; //학기당 성적데이터의 시작
    NSMutableArray *gradesEnd = [NSMutableArray array]; //학기당 성적데이터의 끝
    
    for (HTMLNode *trNode in trNodes){
        //NSLog(@"TotalGrade trNode: %@  indexing: %i", [trNode allContents], indexCount);
        NSRange beginFound = [[trNode allContents] rangeOfString:@"학년도"]; // 시작을 찾아냄
        NSRange endFound = [[trNode allContents] rangeOfString:@"신청학점"]; // 끝을 찾아냄
        
        if (beginFound.location != NSNotFound){
            SemNum++;
            [gradesBegin addObject:[NSNumber numberWithInt:indexCount]];
        }
        
        if (endFound.location != NSNotFound ){
            [gradesEnd addObject:[NSNumber numberWithInt:indexCount]];
        }
        
        indexCount++;
        NSString *str =[trNode allContents];
        NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//공백제거
        str = [newStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];//줄바꿈제거
        [trContents addObject: str];
    }
    
    
    for (NSNumber *tmpNum in gradesBegin)
        NSLog(@"startAt: %i", [tmpNum integerValue]);
    
    for (NSNumber *tmpNum in gradesEnd)
        NSLog(@"endAt: %i", [tmpNum integerValue]);

    _gradesOfSem = [NSMutableArray array];//학기당 성적데이터 배열을 저장한 배열
    _semInfo = [NSMutableArray array]; //학기 데이터를 저장할 배열
    
    for (int count = 0; count < SemNum; count++)//학기 갯수만큼 성적데이터 파싱
    {
        NSMutableArray *tmpGrade = [NSMutableArray array];
        [_semInfo addObject: [trContents objectAtIndex: [[gradesBegin objectAtIndex:count] integerValue]]];
        for (int inCount = ([[gradesBegin objectAtIndex:count]integerValue] + 2); inCount < ([[gradesEnd objectAtIndex:count]integerValue] - 1); inCount++)
        {
            
            [tmpGrade addObject: [trContents objectAtIndex:inCount]];
        }
        [_gradesOfSem addObject:tmpGrade];
    }
    
    for (NSArray *tmpArr in _gradesOfSem)
        for (NSString *tmpStr in tmpArr)
            NSLog (@"result: %@", tmpStr);
    
    NSLog (@"GradesOfSemCount: %i", _gradesOfSem.count);
    for (NSString *tmpStr in _semInfo)
        NSLog (@"gradeInfo: %@", tmpStr);
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self loadTotalGrade];
    [_indicatorView stopAnimating];
    
    [_myTable reloadData];
    [_myTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _myTable.numberOfSections)] withRowAnimation:UITableViewRowAnimationBottom];
    [super viewDidAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_semInfo.count == 0)
        return 1;
    
    return _semInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_semInfo.count == 0)
        return 1;
    
    NSArray *tmpArr = _gradesOfSem[section];
    return tmpArr.count;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_semInfo.count == 0)
        return nil;
    
    return _semInfo[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrivateTotalGradeCell";
    DJUPrivateTotalGradeTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_semInfo.count== 0){
        cell.contentOfGrade.text = @"현재 성적 데이터가 존재하지 않습니다.";
        return cell;
    }
    
    NSMutableArray *resultGrades = _gradesOfSem[indexPath.section];
    
    int row = (int)[indexPath row];
    cell.contentOfGrade.text = resultGrades[row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
