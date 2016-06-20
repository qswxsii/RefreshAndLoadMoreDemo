//
//  QYTableViewController.m
//  02-RefreshAndLoadMoreDemo
//
//  Created by qingyun on 16/5/17.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYTableViewController.h"

@interface QYTableViewController ()
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UIButton *footerBtn;
@end

@implementation QYTableViewController

-(void)loadDatas{
    NSArray *array = @[@"张三",@"李四",@"王五",@"赵六",@"田七",@"宋八",@"啤酒",@"建业"];
    _datas = [NSMutableArray arrayWithArray:array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载datas
    [self loadDatas];
    
    //设置行高
    self.tableView.rowHeight = 120;
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    //加载更多
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [footBtn setBackgroundColor:[UIColor orangeColor]];
    footBtn.frame = CGRectMake(0, 0, 0, 44);
    //[footBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footBtn;
    
    _footerBtn = footBtn;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
}
//刷新
-(void)refresh{
    [self performSelector:@selector(freshUI) withObject:nil afterDelay:3];
}

-(void)freshUI{
    [self.refreshControl endRefreshing];
    [self loadDatas];
    //重新加载界面
    [self.tableView reloadData];
}

//加载更多
-(void)loadMoreData{
    NSArray *moreArray = @[@"奥迪",@"宝马",@"奔驰",@"保时捷",@"法拉利",@"BYD",@"吉利",@"大众",@"时风"];
    [self.datas addObjectsFromArray:moreArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

//根据偏移量来更改UI界面
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [_footerBtn setTitle:@"松开手之后,加载更多..." forState:UIControlStateNormal];
    }else{
        [_footerBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    }
}

//当停止拖动,将要减速的时候,判断是否需要加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self loadMoreData];
    }
}

@end
