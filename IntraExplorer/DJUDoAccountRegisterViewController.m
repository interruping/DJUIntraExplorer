//
//  DJUDoAccountRegisterViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 5. 30..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUDoAccountRegisterViewController.h"

@interface DJUDoAccountRegisterViewController ()

@end

@implementation DJUDoAccountRegisterViewController

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
    _djuBanks = [NSMutableDictionary dictionary];
    _bankNames = [NSMutableArray array];
    [self loadAccountRegister];
    NSLog(@"convert:%@",[self NSStringToUnicode:@"임근영"]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)loadAccountRegister
{
    NSString *tempContent = @"par=BANK";//은행정보 json으로 가져오기
    NSMutableString *content = [NSMutableString stringWithString:tempContent];
    
    
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
    //NSHTTPURLResponse * myResponse = (NSHTTPURLResponse *)response;
    NSError *jsonParsingError = nil;
    NSArray *jsonBankList = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonParsingError];//json 파싱
    NSDictionary *bankList;
    for (int i = 0; i < [jsonBankList count];i++)
    {
        bankList = [jsonBankList objectAtIndex:i];
        [_djuBanks setObject:[bankList objectForKey:@"b-cd"] forKey:[bankList objectForKey:@"b-nm"]];
    }
    
    NSArray *keyOfBank = [_djuBanks allKeys];
    for(NSString *tmpStr in keyOfBank)
    {
        NSLog(@"banksName: %@",tmpStr);
    }
    
    for (int i = 0; i < [keyOfBank count]; i++)
    {
        [_bankNames addObject:keyOfBank[i]];
    }
    
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    NSLog (@"bodyContent dddddd: %@", bodyContent);
}

-(IBAction)registerBank
{
    if(_bankCode == nil)
        _bankCode = [_djuBanks objectForKey:_bankNames[0]];//뱅크코드가 미설정되있을경우 현재선택되어있는 행의 코드삽입
    
    NSLog(@"ownerName : %@, stdNum: %@", _ownerNm.text, _stdNum);
    NSString *tempContent = @"par=SAVE&std_cd=";//은행정보 json으로 가져오기
    NSMutableString *content = [NSMutableString stringWithString:tempContent];
    [content appendString:_stdNum];//학번추가
    [content appendFormat:@"&bank_cd=%@",_bankCode];
    [content appendFormat:@"&bank_num=%@", _bankNum.text];
    [content appendFormat:@"&owner_nm=%@",[self NSStringToUnicode:_ownerNm.text]];
    [content appendString:@"&use=Y"];
    
    NSLog(@"accountregistercontent = %@", content);
    NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://intra.dju.kr/servlet/su.suc.suc01Jsp23DS"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:_djuUserCookie forHTTPHeaderField:@"Cookie" ];
    [request setHTTPBody:data];
    
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    NSRange registerResult = [bodyContent rangeOfString:@"Code"];
    
   
    
    if(response == nil){
        NSLog (@"Connection Fail");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"네트워크 오류." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
    }else if (registerResult.location != NSNotFound){
        NSLog (@"register Fail...");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"계좌등록실패\r\n올바른정보를 입력해주세요." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
    }
    else{
        [self performSegueWithIdentifier:@"unwindBankAccount" sender:self];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"등록성공" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
    }
    
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [_bankNum resignFirstResponder];
    [_ownerNm resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_bankNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _bankNames[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _bankCode = [_djuBanks objectForKey:_bankNames[row]];
    NSLog(@"bankCode set complete! %@", _bankCode);
}

- (NSString *)NSStringToUnicode: (NSString *)rawStr
{
   
   
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [rawStr length]; i++)
    {
        unichar convUniChar = [rawStr characterAtIndex:i];
        [result appendFormat:@"%%25u%X", convUniChar];
        
    }
    
        
    return (NSString *)result;
    
    
    
    
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
