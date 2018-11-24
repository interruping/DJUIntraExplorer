//
//  DJUCollegeScheduleViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 28..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUCollegeScheduleViewController.h"
#import "DJUCollegeScheduleTableViewCell.h"
#import "HTMLParser.h"

@interface DJUCollegeScheduleViewController ()

@end

@implementation DJUCollegeScheduleViewController

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
    _scheduleArr = [NSMutableArray array];//일정 배열 초기화
    _yearArr = [NSMutableArray array];//년도 배열 초기화
    _semArr = (NSMutableArray *)@[@"1학기",@"2학기"]; //학기 배열 초기화
    
    // Do any additional setup after loading the view.
    //[_pickerView reloadInputViews];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadScheduleWithYear:nil AndSem:nil];
    [_myTable reloadData];//TableView에서 마지막으로 가지고 있는 데이터 개수와 현재 삽입하려는 개수의 +N이 맞아 떨어져야 정상적으로 삽입 Insert전에 reloadData를 실행시켜서 테이블에 현재 리스트의 개수를 인식시키고 추가하려는 개수를 동기화
    
    
    
    
    [_myTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _scheduleArr.count)] withRowAnimation:UITableViewRowAnimationBottom];
    
    [super viewDidAppear:animated];
    [_indicatorView stopAnimating];
    
    _screenRect = [[UIScreen mainScreen] bounds];//화면 좌표
    _screenWidth = _screenRect.size.width;//화면 너비
    _screenHeight = _screenRect.size.height;//화면 높이
    
    _pickerView = [[UIView alloc]initWithFrame:CGRectMake(0,_screenHeight, 320, 256)];
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,20, 320, 216)];
    picker.showsSelectionIndicator=YES;
    picker.dataSource = self;
    picker.delegate = self;
    [_pickerView addSubview:picker];
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    tools.barStyle=UIBarStyleDefault;
    [_pickerView addSubview:tools];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"조회" style:UIBarButtonItemStyleBordered target:self action:@selector(closePicker)];
    
    doneButton.imageInsets=UIEdgeInsetsMake(200, 6, 50, 25);
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,doneButton,nil];
    [tools setItems:array];
    
    
    //UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    [self.view addSubview:_pickerView];
}

- (IBAction)searchSem:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _pickerView.frame =CGRectMake(0,_screenHeight-256, 320, 256);
    [UIView commitAnimations];
}

- (IBAction)closePicker
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _pickerView.frame =CGRectMake(0,_screenHeight, 320, 256);
    [UIView commitAnimations];
    _scheduleArr = [NSMutableArray array];
    
    [self loadScheduleWithYear:_isYear AndSem:_isSem];
    [_myTable reloadData];
    NSLog(@"reload!!!!!!!!!!!");
}
- (void)loadScheduleWithYear:(NSString *)year AndSem:(NSString *)sem
{
    if((year != nil) && (sem != nil)){
        NSLog(@"year is %@, sem is %@", _isYear, _isSem);
        NSString *newSem = [_isSem stringByReplacingOccurrencesOfString:@"학기" withString:@"0" ];
        _isSem = [NSString stringWithString:newSem];
        
        NSString *tempContent = @"";
        NSString *scheduleRequestUrl = @"http://intra.dju.kr/servlet/sys.syc.syc01Svl15";
        
        NSMutableString *content = [NSMutableString stringWithString:tempContent];
        [content insertString:[[NSString alloc]initWithFormat:@"year=%@",_isYear ] atIndex:[content length]];//년도 정보
        [content insertString:[[NSString alloc]initWithFormat:@"&smt=%@",_isSem ] atIndex:[content length]];//학기 정보
        [content insertString:@"&select=%EC%A1%B0%ED%9A%8C" atIndex:[content length]];
        NSLog (@"request-content: %@", content);
        
        NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlenght = [NSString stringWithFormat:@"%d",[data length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:scheduleRequestUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postlenght forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
        
        NSError *error=nil;
        NSURLResponse *response=nil;
        NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
        
        
        NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
        //NSLog (@"ScheduleContent === %@", bodyContent);
        
        error = nil;//NSError *error
        HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *trNodes = [bodyNode findChildTags:@"tr"];
        NSRange start;
        BOOL isBegin = NO;
        
        for (HTMLNode *trNode in trNodes){
            
            start = [[trNode allContents] rangeOfString:@"시작"];
            if (start.location != NSNotFound){
                isBegin = YES;
                continue;
            }
            
            if (isBegin){
                NSString *tmpStr = [trNode allContents];
                NSString *newStr = [tmpStr stringByReplacingOccurrencesOfString:@"학사서비스팀" withString:@""];
                tmpStr = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                //newStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                NSMutableArray *eachSchedule = [[NSMutableArray alloc] initWithArray:[tmpStr componentsSeparatedByString:@"\r\n"] copyItems: YES];
                [_scheduleArr addObject:eachSchedule];
                //NSLog(@"trNode is %@", tmpStr);
            }
            
            
            
            
        }
        
    }
    else{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/sys.syc.syc01Svl15?pgm_id=W_SYS032PQ&pass_gbn=&dpt_ck="]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
        
        [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
        
        NSError *error=nil;
        NSURLResponse *response=nil;
        NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
        
        
        NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
        
        //html 파싱
        error = nil;//NSError *error
        HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
        
        
        HTMLNode *bodyNode = [parser body];
        NSArray *selectNodes = [bodyNode findChildTags:@"select"];
        
        for(HTMLNode *selectNode in selectNodes)//년도 정보
        {
            if(![[selectNode getAttributeNamed:@"name"]isEqualToString:@"year"])
                break;//년도만 골라서 파싱
            
            NSArray *yearNodes = [selectNode findChildTags:@"option"];
            
            
            for(HTMLNode *yearNode in yearNodes)
            {
                if([yearNode getAttributeNamed:@"selected"]){//현재 년도 골라서 파싱
                    
                    //NSLog(@"selected year is %@", [yearNode allContents]);
                    _isYear = [yearNode allContents];
                    [_yearArr addObject:[yearNode allContents]];
                }
                else{
                    //NSLog(@"year is %@", [yearNode allContents]);
                    [_yearArr addObject:[yearNode allContents]];
                }
            }//for
            
        }//for
        
        for(HTMLNode *selectNode in selectNodes){//학기 정보
            if(![[selectNode getAttributeNamed:@"name"]isEqualToString:@"smt"])
                continue;//학기 골라서 파싱
            
            NSArray *semNodes = [selectNode findChildTags:@"option"];
            
            
            for(HTMLNode *semNode in semNodes){
            
                if([semNode getAttributeNamed:@"selected"]){//현재 학기 골라서 파싱
                    
                    //NSLog(@"selected year is %@", [semNode allContents]);
                    _isSem = [semNode allContents];
                    
                }
                else{
                    //NSLog(@"sem is %@", [semNode allContents]);
                    
                }
            }//for
            
        }//for
        [self loadScheduleWithYear:_isYear AndSem:_isSem];
    }//else
        
    
    //NSArray *tdNodes = [bodyNode findChildTags:@"td"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return _yearArr.count;
    else
        return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return _yearArr[row];
    else
        return _semArr[row];
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component)
    {
        case 0:
            _isYear = _yearArr[row];
            break;
        case 1:
            _isSem = _semArr[row];
    }
}

#pragma mark - scheduleTable

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _scheduleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CollegeScheduleCell";
    DJUCollegeScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        
    NSMutableArray *tmpArr = _scheduleArr[indexPath.section];
    
    
    cell.beginDate.text = [[NSString alloc]initWithFormat:@"시작 :%@", tmpArr[2]];
    cell.endDate.text =[[NSString alloc]initWithFormat:@"종료 :%@", tmpArr[4]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *tmp = _scheduleArr[section];
    
    return tmp[1];
    
    
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
