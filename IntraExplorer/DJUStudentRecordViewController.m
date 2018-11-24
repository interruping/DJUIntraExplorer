//
//  DJUStudentRecordViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 6. 5..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUStudentRecordViewController.h"
#import "HTMLParser.h"

@interface DJUStudentRecordViewController ()

@end

@implementation DJUStudentRecordViewController

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
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadStudentRecord];
    [_indicatorView stopAnimating];
}

- (void)loadStudentRecord
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/jsp/su/sud/sud11Jsp13.jsp?pgm_id=W_SUD007PQ&pass_gbn=&dpt_ck=01"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    NSLog (@"StudentRecord body :%@", bodyContent);
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:bodyContent error:&error];
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *trNodes = [bodyNode findChildTags:@"tr"];
    
    for (int trCount = 0; trCount < trNodes.count; trCount++)
    {
        NSArray *tdNodes = [[trNodes objectAtIndex:trCount] findChildTags:@"td"];
        for(int tdCount = 0; tdCount < tdNodes.count; tdCount++ ){
            NSLog (@"trNodes: %@  // trCount: %i // tdCount: %i", [[tdNodes objectAtIndex:tdCount] allContents], trCount,tdCount);
            /*=============================기본신상*/
            // trCount: 10 // tdCount: 3 학번
            // trCount: 10 // tdCount: 5 이름
            // trCount: 10 // tdCount: 7 주민등록번호
            // trCount: 10 // tdCount: 9 학적상태
            // trCount: 10 // tdCount: 11 대학
            // trCount: 10 // tdCount: 13 학부(과)
            // trCount: 10 // tdCount: 17 학년
            // trCount: 10 // tdCount: 19 입학년도
            // trCount: 10 // tdCount: 21 입학유형
            /*=============================학적사항*/
            // trCount: 18 // tdCount: 2 성명(한자)
            // trCount: 18 // tdCount: 4 성명(영문)
            // trCount: 19 // tdCount: 2 졸업일
            // trCount: 19 // tdCount: 4 출신고교
            /*=============================연락처*/
            // trCount: 22 // tdCount: 4 주소
            // trCount: 22 // tdCount: 6 전화번호
            // trCount: 22 // tdCount: 16 핸드폰 번호
            // trCount: 22 // tdCount: 18 이메일
            // trCount: 33 // tdCount: 4 이름(보호자)
            // trCount: 33 // tdCount: 6 보호자와의 관계
            // trCount: 33 // tdCount: 8 보호자 생년월일
            // trCount: 33 // tdCount: 10 보호자 학력
            // trCount: 33 // tdCount: 12 보호자 주소
            // trCount: 33 // tdCount: 14 보호자 전화번
            // trCount: 33 // tdCount: 16 보호자 핸드폰 번호
            /*
            if (trCount == && tdCount ==){
                //일치하는 정보 추출하는 템플릿
                [[NSString alloc]initWithFormat:@"%@",[[tdNodes objectAtIndex:tdCount] allContents]];
            }*/
            if (trCount == 10 && tdCount == 3){//학번
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _stdNum.text = [[NSString alloc]initWithFormat:@"학번 :%@", resultStr];
            }
            
            if (trCount == 10 && tdCount == 5){//이름
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _stdName.text = [[NSString alloc]initWithFormat:@"이름 : %@",resultStr];
            }
            
            if (trCount == 10 && tdCount == 7){//주민번호
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _idNum.text = [[NSString alloc]initWithFormat:@"주민등록번호 :%@",resultStr];
            }
            
            if (trCount == 10 && tdCount == 11){//대학
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _colName.text = [[NSString alloc]initWithFormat:@"대학 :%@",resultStr];
            }
            
            if (trCount == 10 && tdCount == 9){//학적상태
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _stdStatus.text = [[NSString alloc]initWithFormat:@"학적상태 :%@",resultStr];
            }
            
            if (trCount == 10 && tdCount == 19){//입학년도
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _entranceYear.text = [[NSString alloc]initWithFormat:@"입학년도 :%@",resultStr];
            }
            
            if (trCount == 10 && tdCount == 21){//입학유형
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _entranceType.text = [[NSString alloc]initWithFormat:@"입학유형 :%@",resultStr];
            }
            
            if (trCount == 18 && tdCount == 2){//한문 성명
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _chinesName.text = [[NSString alloc]initWithFormat:@"한문 성명 :%@",resultStr];
            }
            
            if (trCount == 18 && tdCount == 4){//영문 성명
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _engName.text = [[NSString alloc]initWithFormat:@"영문 성명 :%@",resultStr];
            }
            
            if (trCount == 19 && tdCount == 4){//출신고교
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _highSchool.text = [[NSString alloc]initWithFormat:@"출신고교 :%@",resultStr];
            }
            
            if (trCount == 19 && tdCount == 2){//졸업일
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _highSchoolGraduateDate.text = [[NSString alloc]initWithFormat:@"졸업일 :%@",resultStr];
            }
            
            if (trCount == 22 && tdCount == 6){//전화번호
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _phoneNum.text = [[NSString alloc]initWithFormat:@"전화번호 :%@",resultStr];
            }
            
            if (trCount == 22 && tdCount == 16){//핸드폰번호
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _cellPhoneNum.text = [[NSString alloc]initWithFormat:@"핸드폰번호 :%@",resultStr];
            }
            
            if (trCount == 22 && tdCount == 18){//이메일주소
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//줄바꿈 제거
                _emailAdr.text = [[NSString alloc]initWithFormat:@"이메일 :%@",resultStr];
            }
            
            if (trCount == 10&& tdCount == 17){//학년
                NSString *newStr = [[[tdNodes objectAtIndex:tdCount] allContents] stringByReplacingOccurrencesOfString:@" " withString:@""];//공백 제거
                NSString *resultStr = [newStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];//줄바꿈 제거
                _stdYearInfo.text = [[NSString alloc]initWithFormat:@"학년 :%@",resultStr];
            }
                
                
        }
    }
    
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
