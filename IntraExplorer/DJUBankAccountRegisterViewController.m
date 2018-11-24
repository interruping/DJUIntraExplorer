//
//  DJUBankAccountRegisterViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 29..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUBankAccountRegisterViewController.h"
#import "DJUDoAccountRegisterViewController.h"

@interface DJUBankAccountRegisterViewController ()

@end

@implementation DJUBankAccountRegisterViewController

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
    [self loadBankAccountInfo];
    [_activityIndicator stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBankAccountInfo
{
    NSString *tempContent = @"par=STD&std_cd=";
    NSMutableString *content = [NSMutableString stringWithString:tempContent];
    
    NSString *newStdNum = [_stdNum stringByReplacingOccurrencesOfString:@"  " withString:@""];//"  "제거
    _stdNum = [newStdNum stringByReplacingOccurrencesOfString:@"학번:" withString:@""];//"학번:" 제거
    NSLog(@" std_cd=%@", _stdNum);
    [content insertString:_stdNum atIndex:[tempContent length]];//<par=STD&std_cd=셋팅된학번>으로 데이터설정
    
    NSLog(@"tempContent = %@", content);
    NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.suc.suc01Jsp23DS"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    [request setHTTPBody:data];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    NSError *jsonParsingError = nil;
    NSArray *bankAccountInfo = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonParsingError];//json 파싱
    
    NSDictionary *bank = [bankAccountInfo objectAtIndex: 0];//파싱데이터 딕셔너리데이터로
    NSLog (@"bankAccountInfo count: %i", [bankAccountInfo count]);
    NSLog(@"sys-dt: %@", [bank objectForKey:@"sys-dt"]);
    NSLog(@"bank: %@", [bank objectForKey:@"bank-nm"]);//은행명
    _bank.text = [bank objectForKey:@"bank-nm"];
    NSLog(@"std-cd: %@", [bank objectForKey:@"std-cd"]);//학번
    NSLog(@"bank-owner: %@",[bank objectForKey:@"bank-owner"]);//예금주
    _bankOwner.text = [bank objectForKey:@"bank-owner"];
    NSLog(@"modify-dt: %@", [bank objectForKey:@"modify-dt"]);//신청일자
    _modyfiyDt.text = [bank objectForKey:@"modify-dt"];
    NSLog(@"bank-num: %@", [bank objectForKey:@"bank-num"]);//계좌번호
    _bankNum.text = [bank objectForKey:@"bank-num"];
    NSLog(@"bank-num-yn %@", [bank objectForKey:@"bank-num-yn"]);//개인정보활용동의
    _bankNumYn.text = [bank objectForKey:@"bank-num-yn"];
    NSLog(@"std-nm: %@", [bank objectForKey:@"std-nm"]);//학생이름 (신청인)
    _stdNm.text = [bank objectForKey:@"std-nm"];
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];//계좌정보를 json데이터로 가져옴
    NSLog (@"BankAccount === %@", bodyContent);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"RegisterBank"]){
        DJUDoAccountRegisterViewController *destination = [segue destinationViewController];
        NSLog(@"stdNum is %@",_stdNum);
        destination.stdNum = _stdNum;
        destination.djuUserCookie = _djuUserCookie;
        
    }
}

-(IBAction)returned:(UIStoryboardSegue *)segue
{
    
}

@end
