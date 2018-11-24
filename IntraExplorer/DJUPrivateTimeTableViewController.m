//
//  DJUPrivateTimeTableViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 26..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUPrivateTimeTableViewController.h"
#import "DJUPrivateTimeTableTableViewCell.h"
#import "HTMLParser.h"

@interface DJUPrivateTimeTableViewController ()

@end

@implementation DJUPrivateTimeTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)privateTimeTableLoad
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.sug.sug02Svl02?pgm_id=W_SUG010PQ&pass_gbn=001&dpt_ck=03"]];
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
    
    
    NSArray *trNodes = [bodyNode findChildTags:@"tr"];
    NSMutableArray *trContents = [NSMutableArray array];
    
    for ( HTMLNode *trNode in trNodes )
    {
        //NSLog (@"trNode: %@", [trNode allContents]);
        [trContents addObject:[trNode allContents]];
    }
    
    int count;
    int beginNum = 0;
    int endNum = 0;
    NSRange isBegin;
    NSRange isEnd;
    
    for (count = 0; count < [trContents count]; count++){
        isBegin = [trContents[count] rangeOfString:@"교과목명"];
        isEnd = [trContents[count] rangeOfString:@"위의 내용은 학생이"];
        NSLog (@"trContent: %@ count: %i", trContents[count], count);
        if((isBegin.location != NSNotFound) && !beginNum )
        {
            beginNum = count + 1;
        }
        
        if((isEnd.location != NSNotFound) && !endNum )
        {
            endNum = count-1;
        }
        
    }
    NSLog (@"beginNum: %i , endNum: %i", beginNum, endNum );
    
    NSMutableArray *tmpLectureInfo = [NSMutableArray array];
    NSMutableArray *tmpLectureDetail = [NSMutableArray array];
    
    for (count = beginNum; count <= (endNum - 1); count = count + 2)
    {
        [tmpLectureInfo addObject: trContents[count+1] ];
        [tmpLectureDetail addObject: trContents[count] ];
    }
    
    /*
    for (NSString *tmpStr in tmpLectureInfo){
        NSString *resultStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog (@"lectureInfo : %@", resultStr);
    }
    for (NSString *tmpStr in tmpLectureDetail){
        NSString *resultStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog (@"lectureDetail : %@", resultStr);
    }*/
    _lectureInfos = [NSMutableArray array];
    _lectureDetails = [NSMutableArray array];
    
    count = 0;
    for (NSString *tmpStr in tmpLectureInfo)
    {
        NSMutableArray *fileLines = [[NSMutableArray alloc] initWithArray:[tmpStr componentsSeparatedByString:@"\r\n"] copyItems: YES];
        [_lectureInfos addObject:fileLines];
        count++;
    }
    
    for (NSString *tmpStr in tmpLectureDetail)
    {
        NSMutableArray *fileLines = [[NSMutableArray alloc] initWithArray:[tmpStr componentsSeparatedByString:@"\r\n"] copyItems: YES];
        [_lectureDetails addObject:fileLines];
        count++;
    }
    
    for (NSArray *tmpArr in _lectureInfos)
    {
        NSLog (@"Infos---\n");
        for (NSString *tmpStr in tmpArr)
            NSLog(@"isLine: %@\n", tmpStr);
    }
    
    for (NSArray *tmpArr in _lectureDetails)
    {
        NSLog (@"Details---\n");
        for (NSString *tmpStr in tmpArr)
            NSLog(@"isLine: %@\n", tmpStr);
    }
    
    
    
    //NSMutableArray * fileLines = [[NSMutableArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\r\n"] copyItems: YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self privateTimeTableLoad];
    [_indicatorView stopAnimating];
    
    
    NSLog (@"lectureInfos: %i", (int)_lectureInfos.count);
    [_myTable reloadData];//TableView에서 마지막으로 가지고 있는 데이터 개수와 현재 삽입하려는 개수의 +N이 맞아 떨어져야 정상적으로 삽입 Insert전에 reloadData를 실행시켜서 테이블에 현재 리스트의 개수를 인식시키고 추가하려는 개수를 동기화
    
    
    
  
    [_myTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _lectureInfos.count)] withRowAnimation:UITableViewRowAnimationBottom];
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog (@"lectureInfos.count: %i", (int)_lectureInfos.count);
    return _lectureInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *tmpArr = _lectureInfos[section];
    if (tmpArr.count == 8)
        return 2;
    else
        return 1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"LectureTime";
    DJUPrivateTimeTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *tmpArr = _lectureInfos[indexPath.section];
    
    
    
    int row = (int)[indexPath row];
    cell.isTimeInfo.text = tmpArr[row+3];
   
        
    
   
    
   
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSArray *tmpArr = _lectureInfos[section];
    
    NSLog (@"sectonTitle: %@", tmpArr[1]);
    
    return tmpArr[1];
    
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
