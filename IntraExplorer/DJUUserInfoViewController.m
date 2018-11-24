//
//  DJUUserInfoViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 9..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUUserInfoViewController.h"
#import "DJUSpecialLectureToeicScoreViewController.h"
#import "DJUPrivateTimeTableViewController.h"
#import "DJUPrivateTotalGradeViewController.h"
#import "DJUCollegeScheduleViewController.h"
#import "DJUBankAccountRegisterViewController.h"
#import "DJUStudentRecordViewController.h"
#import "DJUSubjectProcessViewController.h"
#import "DJULectureEvaluateResultViewController.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "DJUViewController.h"
#import "DJUMenuTableViewCell.h"

@interface DJUUserInfoViewController ()

@end

@implementation DJUUserInfoViewController

-(void)loadUserData
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/jsp/su/sud/sud11Jsp13.jsp?pgm_id=W_SUD007PQ&pass_gbn=&dpt_ck=01"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_DJUUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;

    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    //NSLog (@"bodyContent: %@", bodyContent);
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    /**********사용자 사진불러오기**********/
    HTMLNode *bodyNode = [parser body];
    
    NSArray *inputUserPictureNodes = [bodyNode findChildTags:@"img"];
    NSString *pictureURL;
    for (HTMLNode *inputNode in inputUserPictureNodes) {
        
        pictureURL = [inputNode getAttributeNamed:@"src"];
        NSRange substr;
        substr = [pictureURL rangeOfString:@"was84"];
        
        if(substr.location != NSNotFound)
            break;
    
    }
    
    NSURL  *url = [NSURL URLWithString:pictureURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    _userPicture.image = [UIImage imageWithData:urlData];
    urlData = nil;
    /**********사용자 기본 정보불러오기**********/
    
    NSArray *inputUserInfoNodes = [bodyNode findChildTags:@"td"];
    NSString *tempUserInfo;
    unsigned char isStudentNum = 0 , isUserName = 0, isMajor= 0, isGrade= 0;
    NSLog (@"td :");
    for (HTMLNode *inputNode in inputUserInfoNodes)
    {
        tempUserInfo = [inputNode allContents];
        NSRange contentOfStudentNum, contentOfUserName, contentOfMajor, contentOfGrade;
        
        
        contentOfStudentNum = [tempUserInfo rangeOfString:@"학    번"];
        if ( contentOfStudentNum.location != NSNotFound && tempUserInfo != nil){
            isStudentNum++;
            //NSLog (@"i found it! %@", tempUserInfo);
            //NSLog (@"isSudentNum = %i", isStudentNum);
            continue;
        }
        
        
        if ( isStudentNum ==2 ){
            isStudentNum = 0;
            
            _userStudentNum.text = [[NSString alloc] initWithFormat:@"학번: %@", tempUserInfo];
        }
        
        contentOfUserName = [tempUserInfo rangeOfString:@"성    명"];
        if ( contentOfUserName.location != NSNotFound && tempUserInfo != nil){
            isUserName++;
           // NSLog (@"i found it! %@", tempUserInfo);
            //NSLog (@"isUserName = %i", isUserName);
            continue;
        }
        
        if ( isUserName == 1){
            isUserName = 7;
            //NSLog(@"isUserNameis %i and tempInfo:%@", isUserName, tempUserInfo);
            _userName.text = [[NSString alloc] initWithFormat:@"성명: %@", tempUserInfo];
        }
        
        contentOfMajor = [tempUserInfo rangeOfString: @"학부(과)"];
        if ( contentOfMajor.location != NSNotFound && tempUserInfo != nil){
            isMajor++;
            //NSLog (@"i found it! %@", tempUserInfo);
            //NSLog (@"isMajor = %i", isMajor);
            continue;
        }
        
        if ( isMajor == 1 ){
            isMajor = 7;
            _userMajor.text = [[NSString alloc] initWithFormat:@"학부(과):%@", tempUserInfo];
            
        }
        
        contentOfGrade = [tempUserInfo rangeOfString:@"학    년"];
        if ( contentOfGrade.location !=NSNotFound && tempUserInfo != nil) {
            isGrade++;
            //NSLog (@"i fount Grade!");
            //NSLog (@"isGrade = %i and tempUserInfo: %@", isGrade, tempUserInfo);

            continue;
        }
        
        if (isGrade == 1) {
            isGrade = 7;
            _userGrade.text = [[NSString alloc] initWithFormat:@"학년: %@", tempUserInfo];
            
        }
        
        
       // NSLog (@"td is --------------------");
        //NSLog (@"%@", tempUserInfo);
    
    
    }
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; //상태바 네트워크 인디케이터
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadUserData];
    [_indicatorView stopAnimating];
    _loadingView.hidden = YES;
}

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
    //DJUSpecialLectureToeicScoreViewController *preLoad = [[DJUSpecialLectureToeicScoreViewController alloc]init];
    //[preLoad viewDidLoad];
    //_resultLabel.text = [NSString stringWithFormat:@"cookie:%@", _DJUUserCookie];
    
    [super viewDidLoad];
    _menuList = @[@"학생기록카드",
                  @"특강/모의토익 결과조회",
                  @"학사일정조회",
                  @"장학금수령계좌등록",
                  @"개인시간표",
                  @"교과과정이수상황표",
                  @"강의평가 결과 조회",
                  @"수강신청내역정보",
                  @"개인별전체성적조회"];
    
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _menuList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menuListCell";
    DJUMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = (int)[indexPath row];
    cell.menuTitle.text = _menuList[row];
    
    // Configure the cell...
    NSLog (@"cell return !!!!!!");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[indexPath row];
    NSString *menuTitle = _menuList[row];
    
    if ([menuTitle isEqualToString:@"특강/모의토익 결과조회"])
    {
        [self performSegueWithIdentifier:@"SpecialLectureToeicScore" sender:self];
    }
        
    if ([menuTitle isEqualToString:@"개인시간표"])
    {
        [self performSegueWithIdentifier:@"PrivateTimeTable" sender:self];
    }
    
    if ([menuTitle isEqualToString:@"학사일정조회"])
    {
        [self performSegueWithIdentifier:@"CollegeSchedule" sender:self];
    }
    
    if ([menuTitle isEqualToString:@"개인별전체성적조회"])
    {
        [self performSegueWithIdentifier:@"PrivateTotalGrade" sender:self];
    }
    if ([menuTitle isEqualToString:@"장학금수령계좌등록"])
    {
        [self performSegueWithIdentifier:@"BankAccountRegister" sender:self];
    }
    
    if ([menuTitle isEqualToString:@"학생기록카드"])
    {
        [self performSegueWithIdentifier:@"StudentRecord" sender:self];
    }
    
    if ([menuTitle isEqualToString:@"교과과정이수상황표"])
    {
        [self performSegueWithIdentifier:@"SubjectProcess" sender:self];
    }
    
    if ([menuTitle isEqualToString:@"강의평가 결과 조회"])
    {
        [self performSegueWithIdentifier:@"LectureEvaluateResult" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"SpecialLectureToeicScore"]){
        DJUSpecialLectureToeicScoreViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"PrivateTimeTable"]){
        DJUPrivateTimeTableViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"PrivateTotalGrade"]){
        DJUPrivateTotalGradeViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"CollegeSchedule"]){
        DJUCollegeScheduleViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"BankAccountRegister"]){
        DJUBankAccountRegisterViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
        destination.stdNum = _userStudentNum.text;
    }
    
    if( [segue.identifier isEqualToString:@"StudentRecord"]){
        DJUStudentRecordViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"SubjectProcess"]){
        DJUSubjectProcessViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    
    if( [segue.identifier isEqualToString:@"LectureEvaluateResult"]){
        DJULectureEvaluateResultViewController *destination = [segue destinationViewController];
        destination.djuUserCookie = _DJUUserCookie;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
