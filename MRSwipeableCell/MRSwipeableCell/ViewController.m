//
//  ViewController.m
//  MRSwipeableCell
//
//  Created by maqinjun on 15/11/9.
//  Copyright © 2015年 micro-robot. All rights reserved.
//
#import "CustomCell.h"
#import "ViewController.h"
#import "MultiFunctionCell.h"
#import "MultiFunctionTableView.h"

@interface ViewController ()<MultiFunctionTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initTableView];
}

- (void)initTableView{
    MultiFunctionTableView *tableView = [[MultiFunctionTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.multiTableDelegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 60.f;
    
    [self.view addSubview:tableView];
}

#pragma mark - MultiFunctionTableViewDelegate

- (void)returnCellMenuIndex:(NSIndexPath *)indexPath menuIndexNum:(NSInteger)menuIndexNum isLeftMenu:(BOOL)isLeftMenu{
    NSLog(@"%s, %ld, %ld, %d", __FUNCTION__, indexPath.row, menuIndexNum, isLeftMenu);
}

- (void)cellWillShowRightMenu{
    NSLog(@"%s", __FUNCTION__);
}

- (void)cellDidHideRightMenu{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const kCellIdentifier = @"multifunctionCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:kCellIdentifier
                                    containingTableView:tableView
                                     leftUtilityButtons:@[@"完成"] rightUtilityButtons:@[@"取消", @"安排"]];
    }
    
    cell.cellActionDelegate = (id<MultiFunctionCellActionDelegate>)tableView;
    
    [cell setTitle:[NSString stringWithFormat:@"row %ld", indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
