
//
//  RCTableViewController.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCTableViewController.h"
#import "RCChatViewController.h"
#import "RCImgViewController.h"
#import "RCJokeViewController.h"
#define RC_TableCell @"RC_TableCell"
@interface RCTableViewController ()

@end

@implementation RCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"RCBLE";
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RC_TableCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RC_TableCell forIndexPath:indexPath];
    cell.textLabel.text=@[@"聊天",@"传图片",@"段子"][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RCChatViewController * chat=[[RCChatViewController alloc]init];
    RCImgViewController * Img=[[RCImgViewController alloc]init];
    RCJokeViewController * Joke= [[RCJokeViewController alloc]init];
    
    [self.navigationController pushViewController:@[chat,Img,Joke][indexPath.row] animated:YES];
}


@end
