//
//  RCChatViewController.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCChatViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#define TabVCell @"RCTableCell"
#define SERVICE_TYPE @"RCserviceType"
@interface RCChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MCBrowserViewControllerDelegate, MCSessionDelegate>
@property (nonatomic ,strong) UITableView * tableV;
@property (nonatomic ,strong) UIImageView * imageV;
@property (nonatomic ,strong) UITextField * input_TF;
@property (nonatomic ,strong) NSMutableArray * dataArray;


@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *assistant;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, assign) MCSessionState state;
@end

@implementation RCChatViewController
- (NSMutableArray*)dataArray{
    if(!_dataArray){
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (UIImageView*)imageV{
    if(!_imageV){
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT-45, WIDTH, 45)];
        _imageV.image = [UIImage imageNamed:@"toolbar_bottom_bar"];
        _imageV.userInteractionEnabled = YES;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateHighlighted];
        btn1.frame = CGRectMake(5, 5, 37, 40);
        [btn1 addTarget:self action:@selector(btn1Aciton) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:btn1];
        
        UITextField * tf=[[UITextField alloc] initWithFrame:CGRectMake(47, 6, WIDTH - 47 - 95, 32)];
        tf.layer.cornerRadius = 6;
        tf.tag = 1001;
        tf.backgroundColor = [UIColor whiteColor];
        tf.returnKeyType=UIReturnKeySend;
        tf.enablesReturnKeyAutomatically = YES;
        tf.delegate = self;
        [_imageV addSubview:tf];
        self.input_TF=tf;
        
       
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:(UIControlEventTouchUpInside)];
        btn2.frame = CGRectMake(WIDTH-90, -2, 50, 50);
        [_imageV addSubview:btn2];
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(btn2Click) forControlEvents:(UIControlEventTouchUpInside)];
        btn3.frame = CGRectMake(WIDTH-50, -2, 50, 50);
        [_imageV addSubview:btn3];
    }
    return _imageV;
}
-(void)btn1Aciton {
    NSLog(@"正在集成中。。。。。");
}
- (void)btn2Click{
    NSLog(@"正在集成中。。。。。");
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(string.length>0){
        self.input_TF.enablesReturnKeyAutomatically=NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>0 && self.assistant != nil && self.peerID != nil && self.state == MCSessionStateConnected) {
        NSData * data=[textField.text dataUsingEncoding:NSUTF8StringEncoding];
        [self.session sendData:data toPeers:@[self.peerID] withMode:MCSessionSendDataReliable error:nil];
         [self.tableV setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        NSDictionary *dic = @{@"icon":@"icon1.jpg",
                              @"content":textField.text,
                            };
        RCModel * model =[RCModel modelWithDic:dic];
        
        [self.dataArray addObject:model];
        
        [self.tableV reloadData];
        textField.text = @"";
    }else{
        
        UIAlertController *alertCtr;
        UIAlertAction *acition = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertCtr dismissViewControllerAnimated:YES completion:nil];
        }];
        
        if (self.assistant == nil) {
            
            alertCtr = [UIAlertController alertControllerWithTitle:@"请打开Switch开关" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertCtr addAction:acition];
            [self presentViewController:alertCtr animated:YES completion:nil];
            
        }
        if (self.state != MCSessionStateConnected) {
            
            alertCtr = [UIAlertController alertControllerWithTitle:@"设备还未连接蓝牙设备." message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertCtr addAction:acition];
            [self presentViewController:alertCtr animated:YES completion:nil];
            
        }
        
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UISwitch * sw=[[UISwitch alloc]init];
    sw.on=NO;
    self.navigationItem.titleView=sw;
    [sw addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:(UIBarButtonItemStyleDone) target:self action:@selector(SousuoClick)];
    
    self.state = MCSessionStateNotConnected;
    
    self.session = [[MCSession alloc] initWithPeer:[[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name]];
    self.session.delegate = self;
    
    UITableView * tabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-45) style:(UITableViewStylePlain)];
    tabV.delegate=self;
    tabV.dataSource=self;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabV.contentOffset = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    [tabV registerClass:[RCTableViewCell class] forCellReuseIdentifier:TabVCell];
    [self.view addSubview:tabV];
    self.tableV = tabV;
    [self.view addSubview:self.imageV];
    
     [self loadDataArray];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
   
    
}
-(void)loadDataArray {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"joke" ofType:@"plist"];
    NSArray * array = [NSMutableArray arrayWithContentsOfFile:path];
    
    for (int i = 7 ; i<12; i++){
        NSDictionary * dic = array[i];
        RCModel * model =[RCModel  modelWithDic:dic ];
        [self.dataArray addObject:model];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TabVCell];
    RCModel* model=self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCModel *message = self.dataArray[indexPath.row];
    return message.height +55;
}
- (void)keyboardWillShow:(NSNotification*)notification{
   
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableV.frame = CGRectMake(0, -keyBoardFrame.size.height, WIDTH, HEIGHT-45);
        self.imageV.frame = CGRectMake(0,  HEIGHT-45-keyBoardFrame.size.height, WIDTH, 45);
    }];
}
-(void)keyboardWillHide:(NSNotification*)notification{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageV.frame = CGRectMake(0, HEIGHT-45, WIDTH, 45);
        self.tableV.frame = CGRectMake(0, 0, WIDTH, HEIGHT-45);
    }];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self animateWithResignFirstResponder];
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self animateWithResignFirstResponder];
}
- (void)animateWithResignFirstResponder{
    [UIView animateWithDuration:0.5 animations:^{
        self.imageV.frame = CGRectMake(0, HEIGHT-45, WIDTH, 45);
        self.tableV.frame = CGRectMake(0, 0, WIDTH, HEIGHT-45);
        [self.input_TF resignFirstResponder];
    }];
}
//------*----------*------*-----------*-----------
// 搜索 连接设备
-(void)SousuoClick{
    if (self.assistant != nil) {
        MCBrowserViewController *brower = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:self.session];
        brower.delegate = self;
        [self presentViewController:brower animated:YES completion:nil];
    }else{
        NSLog(@"设备无法被扫描到.");
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"请打开\"设备可被发现\"!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *acition = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertCtr dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertCtr addAction:acition];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }

}
- (void)switchClick:(UISwitch*)sender{
    if (sender.on) {
        
        MCAdvertiserAssistant *assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil
        session:self.session];
        self.assistant = assistant;
        [self.assistant start];
    }else{
        [self.assistant stop];
        self.assistant = nil;
    }
}
#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController
      shouldPresentNearbyPeer:(MCPeerID *)peerID
            withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info{
    NSLog(@"---已发现设备---peerID: %@", peerID);
    return YES;
}
#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    self.peerID = peerID;
    self.state = state;
    switch (state) {
        case MCSessionStateNotConnected:
            NSLog(@"未连接!");
            break;
        case MCSessionStateConnecting:
            NSLog(@"连接中...");
            break;
        case MCSessionStateConnected:
            NSLog(@"已连接.");
            break;
        default:
            break;
    }
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    if (data != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"-------接收到的消息--：%@",str);
            [self.tableV setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            NSDictionary *dic = @{@"icon":@"icon2.jpg",
                                  @"content":str,
                                };
            RCModel * model =[RCModel modelWithDic:dic];
            
            [self.dataArray addObject:model];
            [self.tableV reloadData];
            
        });
    }
}

- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID{
    
}

- (void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
   withProgress:(NSProgress *)progress{
    NSLog(@"----progress:%@", progress);
}


- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
