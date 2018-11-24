//
//  DJUSubjectProcessViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 6..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUSubjectProcessViewController.h"
#import "DJUSubjectProcessTableViewCell.h"
#import "HTMLParser.h"

@interface DJUSubjectProcessViewController ()

@end

@implementation DJUSubjectProcessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _processInfos = [NSMutableArray array];//배열초기화
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadSubjectProcess];/*
    [_myTable reloadData];//TableView에서 마지막으로 가지고 있는 데이터 개수와 현재 삽입하려는 개수의 +N이 맞아 떨어져야 정상적으로 삽입 Insert전에 reloadData를 실행시켜서 테이블에 현재 리스트의 개수를 인식시키고 추가하려는 개수를 동기화
    [_myTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _processInfos.count)] withRowAnimation:UITableViewRowAnimationBottom];
    
    [super viewDidAppear:animated];*/
    [_myTable reloadData];
    [_myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    
    [super viewDidAppear:animated];
    [_indicatorView stopAnimating];
}
- (void)loadSubjectProcess
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.sud.sud11Svl03?pgm_id=W_SUI800PQ&pass_gbn=&dpt_ck="]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    //NSLog (@"SubjectProcess === %@", bodyContent);
    
    //html 파싱
    error = nil;//NSError *error
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *trNodes = [bodyNode findChildTags:@"tr"];
    int tmpCount = 0;
    int tdCount;
    for (int trCount = 0; trCount < trNodes.count; trCount++)
    {
        NSMutableArray *tmpArr;
        tmpArr = [NSMutableArray array];
        NSArray *tdNodes = [[trNodes objectAtIndex:trCount] findChildTags:@"td"];
        tmpCount++;
        for(tdCount = 0; tdCount < tdNodes.count; tdCount++ ){
            if (trCount <= 12 && tdCount <= 6)
                break;
            
            [tmpArr addObject:[[tdNodes objectAtIndex:tdCount] allContents]];
            NSLog (@"td content : %@ //trCount: %i // tdCount: %i", [[tdNodes objectAtIndex:tdCount] allContents], trCount, tdCount);
            if (tdCount == 6)
                [_processInfos addObject: tmpArr];
        }
        
    }
    
                                        
    NSLog (@"tmpCount: %i", tmpCount);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _processInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SubjectProcess";
    DJUSubjectProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    int row = (int)[indexPath row];
    NSArray *tmpArr = [NSArray array];
    tmpArr = _processInfos[row];
    if (( [tmpArr[1] isEqualToString:@"소계"] || [tmpArr[1] isEqualToString:@"총계"]) && !([tmpArr[0] isEqualToString:@"평생교육사"]))
    {
        NSString *newStr = [tmpArr[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        cell.subType.text = newStr;
        cell.subName.text = tmpArr[1];
        cell.subPoint.text = [[NSString alloc]initWithFormat:@"학점:%@", tmpArr[2]];
        cell.subScore.text = @"";
        cell.subMark.text = @"";
        cell.subYear.text = tmpArr[5];
        cell.subSem.text = tmpArr[6];
        ;
        //cell.backgroundView.window.backgroundColor = [UIColor colorWithRed:240.0f green:181.0f blue:28.0f alpha:1.0f];
        //cell.backgroundColor = [UIColor colorWithRed:240.0f green:181.0f blue:28.0f alpha:1.0f];
        //cell.window.backgroundColor = [[UIColor colorWithRed:240.0f green:181.0f blue:28.0f alpha:1.0f];
        [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:181.0/255.0 blue:28.0/255.0 alpha:1.0]];
        [cell setTintColor:[UIColor redColor]];
        return cell;
    }
    
    
    
    cell.subType.text = [[NSString alloc]initWithFormat:@"이수구분:%@", tmpArr[0]];
    cell.subName.text = [[NSString alloc]initWithFormat:@"과목명:%@", tmpArr[1]];
    cell.subPoint.text = [[NSString alloc]initWithFormat:@"학점:%@", tmpArr[2]];
    cell.subScore.text = [[NSString alloc]initWithFormat:@"등급:%@", tmpArr[3]];
    cell.subMark.text = [[NSString alloc]initWithFormat:@"평점:%@", tmpArr[4]];
    cell.subYear.text = [[NSString alloc]initWithFormat:@"학년도:%@", tmpArr[5]];
    cell.subSem.text = [[NSString alloc]initWithFormat:@"학기:%@", tmpArr[6]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if ([tmpArr[4] isEqualToString:@"&nbsp"])
        cell.subMark.text = @"**";
         
         
    return cell;
    
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
