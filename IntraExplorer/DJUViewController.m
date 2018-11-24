//
//  DJUViewController.m
//  IntraExplorer
//
//  Created by interruping on 2014. 4. 9..
//  Copyright (c) 2014년 interruping. All rights reserved.
//

#import "DJUViewController.h"
#import "AES256Util.h"
#import "DJUDiviceUniqueKey.h"

@interface DJUViewController ()

@end

@implementation DJUViewController

- (IBAction) DJULogin
{
    
    DJUUserModel *user = [[DJUUserModel alloc]init];
    BOOL successLogin = [user loginWithId:_djuUserId.text andPassword:_djuUserPassword.text]; //로그인 시도
    
    if (successLogin) { //로그인 성공할 경우
        
        _djuCookie = user.userCookie; //쿠키 불러오기
        
        if ([_djuUserInfoStoreSwitch isOn])//아이디 비밀번호 저장이 ON일 경우
        {
            NSArray *dirPaths;
            NSString *docsDir;
            NSString *dataFile;
            
            
            dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            docsDir = dirPaths[0];
            dataFile = [docsDir stringByAppendingString:@"/userfile.dat"];//도큐먼트폴더에 userfile.dat파일을 생성할 최종경로
            
            {//아이디 & 패스워드 암호화 저장 블록
                NSData *databuffer;
                
                [[NSFileManager defaultManager]createFileAtPath:dataFile contents:nil attributes:nil];
                NSFileHandle *fileHnd = [NSFileHandle fileHandleForWritingAtPath:dataFile];
                
                if( fileHnd == nil )
                    NSLog (@"file write fail");
                
                NSString *isKey = [DJUDiviceUniqueKey getKey];//디바이스별 고유 키값 불러오기
                NSString *encId = [AES256Util encWithString: _djuUserId.text key:isKey]; //아이디 암호화
                NSString *encPw = [AES256Util encWithString: _djuUserPassword.text key:isKey]; //비밀번호 암호화
                
                NSLog (@"encrypt Id: %@", encId);
                NSLog (@"encrypt Pw: %@", encPw);
                
                databuffer = [[NSString stringWithFormat: @"%@\r\n", encId]dataUsingEncoding:NSUTF8StringEncoding];//새줄쓰기로 아이디 데이터기록
                [fileHnd seekToEndOfFile];
                [fileHnd writeData:databuffer];
                
                databuffer = [[NSString stringWithFormat: @"%@\r\n", encPw]dataUsingEncoding:NSUTF8StringEncoding];//새줄쓰기로 비밀번호 데이터기록
                
                [fileHnd writeData:databuffer];
                [fileHnd closeFile];
                
            }//아이디 & 패스워드 암호화 저장 블록
            
        }//if ([_djuUserInfoStoreSwitch isOn])
        
            
            
        
        [self performSegueWithIdentifier:@"loginSuccess" sender: self];
    }
    
}

- (IBAction)storeUserInfo:(id) sender
{
        if([_djuUserInfoStoreSwitch isOn])//아이디 비밀번호 저장이 ON일경우
        {
            _djuUserInfoStoreStatus.text = @"ON"; //상태 레이블 ON
        }
        else
        {
            _djuUserInfoStoreStatus.text = @"OFF"; //상태 레이블 OFF
            
            NSArray *dirPaths;
            NSString *docsDir;
            NSString *dataFile;
            NSFileManager *filemgr = [NSFileManager defaultManager];
            
            dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            docsDir = dirPaths[0];
            dataFile = [docsDir stringByAppendingString:@"/userfile.dat"];
            
            [filemgr removeItemAtPath:dataFile error:nil]; //저장 기능을 껏으므로 아이디 비밀번호 저장파일 삭제
            
            
        }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender //로그인 성공시 수행할 segue
{
    
    DJUUserInfoViewController *destination = [segue destinationViewController];
    destination.DJUUserCookie = _djuCookie;
    _djuUserId.text = nil;
    _djuUserPassword.text = nil;
    [self storeUserInfo:nil];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _djuLogo.image = [UIImage imageNamed:@"DJU_logo.png"]; //로고 불러오기
    _djuUserId.text = nil;
    _djuUserPassword.text = nil;
    
    
    {
        NSArray *dirPaths;
        NSString *docsDir;
        NSString *dataFile;
        NSFileManager *filemgr;
        NSData *databuffer;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        dataFile = [docsDir stringByAppendingString:@"/userfile.dat"];
        filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath:dataFile])
        {
            [_djuUserInfoStoreSwitch setOn:YES animated:NO];
            _djuUserInfoStoreStatus.text = @"ON";
            databuffer = [filemgr contentsAtPath: dataFile];
            if (databuffer != nil)
            {
                NSString *isKey = [DJUDiviceUniqueKey getKey];
                NSString *fileContent = [[NSString alloc] initWithData: databuffer encoding:NSUTF8StringEncoding];
                NSArray *allLinedStrings = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];//줄단위로 끊어서 배열객체로 뿌림
                NSString *decId = [AES256Util decWithString:[allLinedStrings objectAtIndex:0] key:isKey]; // 아이디 복호화
                NSString *decPw = [AES256Util decWithString:[allLinedStrings objectAtIndex:2] key:isKey]; // 비밀번호 복호화
                _djuUserId.text = decId; //아이디 불러오기 완료
                _djuUserPassword.text = decPw; //비밀번호 불러오기 완료
            }
            
        }
    
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
