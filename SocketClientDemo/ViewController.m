//
//  ViewController.m
//  SocketClientDemo
//
//  Created by Start on 2017/7/17.
//  Copyright © 2017年 het. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *IPAddress;
@property (weak, nonatomic) IBOutlet UITextField *Port;
@property (weak, nonatomic) IBOutlet UITextField *SendDataText;
@property (weak, nonatomic) IBOutlet UITextView *ReceiveData;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1、初始化
    self.clinetSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (IBAction)bindBtn:(id)sender {
    
    //2、连接服务器
    [self.clinetSocket connectToHost:self.IPAddress.text onPort:self.Port.text.integerValue withTimeout:-1 error:nil];
    
}

- (IBAction)SendBtn:(id)sender {
    
    NSData *data = [self.SendDataText.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1 :无穷大
    //tag： 消息标记
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
    
}


//回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP ： %@", host]];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}
//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

- (void)showMessageWithStr:(NSString *)str{
    self.ReceiveData.text = [self.ReceiveData.text stringByAppendingFormat:@"%@\n", str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
