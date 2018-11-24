//
//  DJUUserModel.m
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 10..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUUserModel.h"

@implementation DJUUserModel
- (BOOL)loginWithId:(NSString *)inputId andPassword:(NSString *)inputPassword
{
    _userId = inputId;
    _userPassword = inputPassword;
    
    _userId = [[NSString alloc] initWithFormat:@"id=%@",_userId];
    _userPassword = [[NSString alloc] initWithFormat:@"&pwd=%@",_userPassword];
    
    NSString *tempContent = @"proc_gubun=2&pgm_id=SYS200PE&msg=%EC%8B%A0%EB%B6%84%EA%B5%AC%EB%B6%84%EC%9D%84+%EC%84%A0%ED%83%9D%ED%95%98%EC%8B%9C%EC%9A%94&shin_gubun=on&login_gubun=on&";
    NSString *loginRequestUrl = @"http://intra.dju.kr/servlet/sys.syd.syd01Svl03";
    
    NSMutableString *content = [NSMutableString stringWithString:tempContent];
    [content insertString:_userId atIndex:[content length]];
    [content insertString:_userPassword atIndex:[content length]];
    
    NSLog (@"request-content: %@", content);
    
    NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postlenght = [NSString stringWithFormat:@"%d",[data length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:loginRequestUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postlenght forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    NSTimer *timedOut = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(loginRequestTimedOut) userInfo:nil repeats:NO];
    NSError *error=nil;
    NSURLResponse *response=nil;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse *myResponse = (NSHTTPURLResponse *)response;//allHeaderFields메소드를 사용하여 header의 값을 얻기위해 변환.
    
    NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
    //NSLog (@"normal bodyContent : %@", bodyContent);

    if (response != nil){
        NSLog (@"request 요청 성공.");
        
    }
    
    NSDictionary *userHeader = [myResponse allHeaderFields];
    NSString *cookie = [userHeader objectForKey: @"Set-Cookie"];
    
    
    if (!cookie)
    {
        cookie = @" ";//NSString이 null일때 rangeOfString은 NSNotFound를 반환하지 않는다.
       
    }
    
    
    NSRange loginResult = [cookie rangeOfString:@"LOGIN_AUTH"];
    NSLog (@"Cookie: %@", cookie);
    NSString *loginStatus;
    
    loginStatus = @"로그인 실패";//Default로 실패, cookie를 성공적으로 얻어왔을떄 추후 성공으로 바뀜.
    
    if (loginResult.location == NSNotFound)
    {
        loginRequestUrl = @"http://intra.dju.kr/servlet/sys.syc.syc01Svl07";
        tempContent = @"pass_gbn=4&gubun=1&change_gubun=4";
        NSString *pedding = @"&id=&old_pwd=&new_pwd1=&new_pwd2=";
        cookie = [userHeader objectForKey: @"Set-Cookie"];
        _userId = [[NSString alloc] initWithFormat:@"&dkdlel=%@",inputId];
        _userPassword = [[NSString alloc] initWithFormat:@"&qlalfqjsgh=%@",inputPassword];
        content = [NSMutableString stringWithString:tempContent];
        [content insertString:_userId atIndex:[content length]];
        [content insertString:_userPassword atIndex:[content length]];
        [content insertString:pedding atIndex:[content length]];
        NSLog (@"Except Request URL: %@", content);
        NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:loginRequestUrl]];//비밀번호 변경예외시
        [request setHTTPMethod:@"POST"];
        [request setValue:postlenght forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];
        [request setValue:cookie forHTTPHeaderField:@"Cookie" ];
        [request setValue:@"http://intra.dju.kr/servlet/sys.syd.syd01Svl03" forHTTPHeaderField:@"Referer" ];
        [request setHTTPBody:data];
        NSError *error=nil;
        NSURLResponse *response=nil;
        NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *bodyContent = [[NSString alloc]initWithData: result encoding: NSUTF8StringEncoding];
        NSLog (@"Ex bodyContent : %@", bodyContent);
        
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse *)response;
        NSDictionary *userHeader = [myResponse allHeaderFields];
        NSString *exCookie = [userHeader objectForKey: @"Set-Cookie"];
        if (!exCookie)
            cookie = @" ";
        else{
            cookie = [userHeader objectForKey: @"Set-Cookie"];
            loginResult = [cookie rangeOfString:@"LOGIN_AUTH"];
            NSLog (@"Ex cookie : %@",cookie);
        }
    }
    
    
    if (loginResult.location != NSNotFound)//4&dkdlel=20132322&qlalfqjsgh=ehdtjd00
    {
        loginStatus = @"로그인 성공";
        _userCookie = [NSString stringWithString:cookie];
        NSLog (@"cookie 얻어오기 성공");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:loginStatus message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [timedOut invalidate];
        //[alert show];
        return YES;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:loginStatus message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    
    
    [alert show];
    return NO;
    
    

}

- (void)loginRequestTimedOut
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"네트워크 에러" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
}
@end
