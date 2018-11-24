//
//  DJULectureEvaluateResultViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 7..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJULectureEvaluateResultViewController.h"
#import "DJULectureEvaluateTableViewCell.h"
#import "HTMLParser.h"

@interface DJULectureEvaluateResultViewController ()

@end

@implementation DJULectureEvaluateResultViewController

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
    UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicatorView setFrame:CGRectMake(60, 150, 30, 30)];
    [_indicatorView setBackgroundColor:[UIColor grayColor]];
    [keyView addSubview:_indicatorView];
    [super viewDidLoad];
    
    _yearSmts = [NSMutableArray array];
    _dptCds = [NSMutableArray array];
    _valDivs = [NSMutableArray array];
    
    
    _yearSmtDic = [NSMutableDictionary dictionary];
    _dptCdDic = [NSMutableDictionary dictionary];
    _valDivDic = [NSMutableDictionary dictionary];
    
    _screenRect = [[UIScreen mainScreen] bounds];//화면 좌표
    _screenWidth = _screenRect.size.width;//화면 너비
    _screenHeight = _screenRect.size.height;//화면 높이
    
    _lectureEvaluates = [NSMutableArray array];
    
    _isValDiv = @"10";
    

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [_indicatorView startAnimating];
    
    [self loadOptionData];
    
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
    
    [_indicatorView stopAnimating];
    
    [self searchSem:nil];
    NSArray *arr = [_valDivDic allKeys];
    for (NSString *str in arr)
    {
        NSLog (@"divdic %@", str);
    }
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
    
    [self loadEvaluateResultWithYearSmt:_isYearSmt AndDptCd:_isDptCd AndValDiv:_isValDiv];
    [_myTable reloadData];
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
    
    NSLog(@"reload!!!!!!!!!!!");
}

- (void)loadOptionData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/adm.ars.ars01Svl504?pgm_id=W_ARS505PQ&pass_gbn=&dpt_ck="]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    NSLog (@"EvaluateResult === %@", bodyContent);
    
    //html 파싱
    error = nil;//NSError *error
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    HTMLNode *bodyNode = [parser body];
    NSArray *selectNodes = [bodyNode findChildTags:@"select"];
    
    for (HTMLNode *selectNode in selectNodes){
        if([[selectNode getAttributeNamed:@"name"] isEqualToString:@"year_smt"]){
            NSArray *optionNodes = [selectNode findChildTags:@"option"];
            for (HTMLNode *optionNode in optionNodes){
                NSLog (@"optionNode yearsmt: %@", [optionNode allContents]);
                NSString *resultVal = [optionNode getAttributeNamed:@"value"];
                [_yearSmts addObject:[optionNode allContents]];
                [_yearSmtDic setObject:resultVal forKey:[optionNode allContents]];
            }
        }
        
        if([[selectNode getAttributeNamed:@"name"] isEqualToString:@"dpt_cd"]){
            NSArray *optionNodes = [selectNode findChildTags:@"option"];
            for (HTMLNode *optionNode in optionNodes){
                NSLog (@"optionNode dptcd: %@", [optionNode allContents]);
                NSString *resultVal = [optionNode getAttributeNamed:@"value"];
                [_dptCds addObject:[optionNode allContents]];
                [_dptCdDic setObject:resultVal forKey:[optionNode allContents]];
            }
        }
        
        if([[selectNode getAttributeNamed:@"name"] isEqualToString:@"val_div"]){
            NSArray *optionNodes = [selectNode findChildTags:@"option"];
            for (HTMLNode *optionNode in optionNodes){
                NSLog (@"optionNode val-div : %@", [optionNode allContents]);
                NSString *resultVal = [optionNode getAttributeNamed:@"value"];
                [_valDivs addObject:[optionNode allContents]];
                NSLog (@"addKey %@ and object : %@", [optionNode allContents], resultVal);
                [_valDivDic setObject:resultVal forKey:[optionNode allContents]];
            }
        }
        
    }
}

- (void)loadEvaluateResultWithYearSmt: (NSString *) yearSmt AndDptCd: (NSString *) dptCd AndValDiv: (NSString *)valDiv
{
    NSString *tempContent = @"";
    NSString *scheduleRequestUrl = @"http://intra.dju.kr/servlet/adm.ars.ars01Svl504";
    
    NSMutableString *content = [NSMutableString stringWithString:tempContent];
    
    [content insertString:[[NSString alloc] initWithFormat:@"year_smt=%@",yearSmt] atIndex:content.length];
    [content insertString:[[NSString alloc] initWithFormat:@"&dpt_cd=%@",dptCd] atIndex:content.length];
    [content insertString:[[NSString alloc] initWithFormat:@"&val_div=%@",valDiv] atIndex:content.length];
    [content insertString:@"&select=%EC%A1%B0%ED%9A%8C" atIndex:[content length]];
    NSLog (@"request-content:%@", content);
    
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
    NSLog (@"EvaluateResult=== %@", bodyContent);
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    HTMLNode *bodyNode = [parser body];
    
    NSArray *trNodes = [bodyNode findChildTags:@"tr"];
    
    NSMutableArray *tmpArr;
    for (int trCount = 2; trCount < trNodes.count; trCount++)
    {
        tmpArr = [NSMutableArray array];
        NSArray *tdNodes = [[trNodes objectAtIndex:trCount] findChildTags:@"td"];
        for(int tdCount = 0; tdCount < tdNodes.count; tdCount++ ){
            NSLog (@"tdNode == %@  //trCount: %i //tdCount: %i", [[tdNodes objectAtIndex:tdCount] allContents], trCount, tdCount);
            [tmpArr addObject:[[tdNodes objectAtIndex:tdCount] allContents]];
            if(tdCount == 6)
                [_lectureEvaluates addObject:tmpArr];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_lectureEvaluates.count == 0)
        return 1;
    return _lectureEvaluates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LectureEvaluate";
    DJULectureEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_lectureEvaluates.count == 0){
        cell.lecGrade.text = @"";
        cell.lecNum.text = @"";
        cell.lecDivNum.text = @"";
        cell.lecName.text = @"0개의 데이터";
        cell.lecTeacher.text = @"";
        cell.lecPeopleNum.text = @"";
        cell.lecScore.text = @"";
        
        return cell;
    }
    
    int row = (int)[indexPath row];
    
    NSArray *tmpArr = _lectureEvaluates[row];
    cell.lecGrade.text = [[NSString alloc] initWithFormat:@"학년:%@",tmpArr[0]];
    cell.lecNum.text = [[NSString alloc] initWithFormat:@"학수번호:%@",tmpArr[1]];
    cell.lecDivNum.text = [[NSString alloc] initWithFormat:@"분반:%@", tmpArr[2]];
    cell.lecName.text = [[NSString alloc] initWithFormat:@"과목명:%@", tmpArr[3]];
    cell.lecTeacher.text = [[NSString alloc] initWithFormat:@"담당교수:%@", tmpArr[4]];
    cell.lecPeopleNum.text = [[NSString alloc] initWithFormat:@"수강인원:%@", tmpArr[5]];
    cell.lecScore.text = [[NSString alloc] initWithFormat:@"수강인원:%@", tmpArr[6]];
    return cell;
    
}
#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return _yearSmts.count;
            break;
        case 1:
            return _dptCds.count;
            break;
        case 2:
            return _valDivs.count;
            break;
    }
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSLog (@"!!!! component %i row %i", component, row);
    switch (component)
    {
        case 0:{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, (pickerView.frame.size.width/3)-10, 216)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            label.text = _yearSmts[row];
            return label;
        }
            break;
        case 1:{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.width/3, pickerView.frame.size.width/3, 216)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            label.text = _dptCds[row];
            NSLog (@"dpt row %i, component: %i", row, component);
            return label;
        }
            break;
        case 2:{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (pickerView.frame.size.width/3)*2, pickerView.frame.size.width/3, 216)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            
            label.text = _valDivs[row];
            return label;
        }
            break;
            
    }
    return nil;
}
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return _yearSmts[row];
            break;
        case 1:
            return _dptCds[row];
            break;
        case 2:
            return _valDivs[row];
            break;
            
    }
    return nil;
    
}
*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            _isYearSmt = [_yearSmtDic objectForKey:_yearSmts[row]];
            break;
        case 1:
            _isDptCd = [_dptCdDic objectForKey:_dptCds[row]];
            break;
        case 2:
            _isValDiv = [_valDivDic objectForKey:_valDivs[row]];
            break;
            
    }
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
