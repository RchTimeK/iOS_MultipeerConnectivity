//
//  RCJokeViewController.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCJokeViewController.h"

@interface RCJokeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * tableV;
@property (nonatomic ,strong) NSMutableArray * dataArray;
@end

@implementation RCJokeViewController
- (NSMutableArray*)dataArray{
    if(!_dataArray){
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"未完待续";
    UITableView * tabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-45) style:(UITableViewStylePlain)];
    tabV.delegate=self;
    tabV.dataSource=self;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabV.contentOffset = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    [tabV registerClass:[RCTableViewCell class] forCellReuseIdentifier:@"rcCell"];
    [self.view addSubview:tabV];
    self.tableV = tabV;
    [self loadDataArray];
}
-(void)loadDataArray {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"joke" ofType:@"plist"];
    NSArray * array = [NSMutableArray arrayWithContentsOfFile:path];
    
    for (int i =0 ; i<7; i++){
        NSDictionary * dic = array[i];
        RCModel * model =[RCModel  modelWithDic:dic ];
        [self.dataArray addObject:model];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rcCell"];
    RCModel* model=self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCModel *message = self.dataArray[indexPath.row];
    return message.height +55;
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
