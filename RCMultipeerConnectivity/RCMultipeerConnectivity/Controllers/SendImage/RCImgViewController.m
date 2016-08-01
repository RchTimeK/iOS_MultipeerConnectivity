//
//  RCImgViewController.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/8/1.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCImgViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVICE_TYPE @"serviceType"
@interface RCImgViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *assistant;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, assign) MCSessionState state;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation RCImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"传图片";
    self.view.backgroundColor=[UIColor whiteColor];
    self.state = MCSessionStateNotConnected;
    
    self.session = [[MCSession alloc] initWithPeer:[[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name]];
    self.session.delegate = self;
    
}
- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)seekClick:(id)sender {
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
- (IBAction)sendClick:(id)sender {
    if (self.image.image != nil && self.assistant != nil && self.peerID != nil && self.state == MCSessionStateConnected) {
        NSData * data=UIImageJPEGRepresentation(self.image.image, 0.1);
        [self.session sendData:data toPeers:@[self.peerID] withMode:MCSessionSendDataUnreliable error:nil];
    }else{
        
        UIAlertController *alertCtr;
        UIAlertAction *acition = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertCtr dismissViewControllerAnimated:YES completion:nil];
        }];
        
        if (self.assistant == nil) {
            
            alertCtr = [UIAlertController alertControllerWithTitle:@"请打开Switch开关" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertCtr addAction:acition];
            [self presentViewController:alertCtr animated:YES completion:nil];
            return;
        }
        if (self.state != MCSessionStateConnected) {
            
            alertCtr = [UIAlertController alertControllerWithTitle:@"设备还未连接蓝牙设备." message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertCtr addAction:acition];
            [self presentViewController:alertCtr animated:YES completion:nil];
            return;
        }
        if (self.image.image == nil) {
            NSLog(@"请选择要发送的图片.");
            alertCtr = [UIAlertController alertControllerWithTitle:@"请选择要发送的图片." message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertCtr addAction:acition];
            [self presentViewController:alertCtr animated:YES completion:nil];
            return;
        }
        
    }

}
- (IBAction)swithClick:(UISwitch *)sender {
    UISwitch *s = (UISwitch *)sender;
    if (s.on) {
       
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
            self.image.image = [UIImage imageWithData:data];
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

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.image.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
