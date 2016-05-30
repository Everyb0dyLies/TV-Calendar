//
//  FavouriteShowsVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/10.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "FavouriteShowsVC.h"
#import "LoginVC.h"
#import "User.h"
#import "ShowList.h"
#import "FavouriteShowsTVC.h"
#import "MJRefresh.h"
#import "ShowDetailsVC.h"
#import "Show.h"

@interface FavouriteShowsVC ()

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) ShowList *showList;

@end

@implementation FavouriteShowsVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchData)];
    }
    return _tableView;
}

- (ShowList *)showList {
    if (!_showList) {
        _showList = [[ShowList alloc] init];
    }
    return _showList;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    NSMutableArray *cs = [NSMutableArray array];
    NSDictionary *vs = @{@"tlg": self.topLayoutGuide,
                         @"tableView": self.tableView};
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [cs addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tlg][tableView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:vs]];
    [self.view addConstraints:cs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadLoginState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLoginState {
    UIBarButtonItem *loginItem;
    if (!currentUser) {
        loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(showLoginViewController)];
        [self.tableView reloadData];
    } else {
        loginItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(logout)];
        [self.tableView.mj_header beginRefreshing];
    }
    self.navigationItem.rightBarButtonItem = loginItem;
}

- (void)showLoginViewController {
    [self showDetailViewController:[LoginVC viewController] sender:self];
}

- (void)logout {
    [User logout];
    [self loadLoginState];
}

- (void)fetchData {
    if (!currentUser) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    FavouriteShowsVC  __weak *weakSelf = self;
    [self.showList fetchFavouriteShowListWithSuccess:^{
                                                  [weakSelf.tableView reloadData];
                                                  [weakSelf.tableView.mj_header endRefreshing];
                                              }
                                              failure:^(NSError *error) {
                                                  NSLog(@"[FavouriteShowsVC]%@", error);
                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                  UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发生了一点小问题！"
                                                                                                              message:@"请下拉刷新"
                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                  [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:nil]];
                                              }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (currentUser) {
            return 0;
        } else {
            return 1;
        }
    }
    if (section == 1) {
        return self.showList.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"您尚未登录，请先登录！";
//        cell.detailTextLabel.text = @"test";
//        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
//        v.backgroundColor = [UIColor redColor];
//        cell.accessoryView = v;
        return cell;
    }
    if (indexPath.section == 1) {
        FavouriteShowsTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteShowsTVC"];
        if (!cell) {
            cell = [FavouriteShowsTVC cell];
        }
        [cell updateWithShow:self.showList.list[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ShowDetailsVC *vc = [ShowDetailsVC viewControllerWithShowID:((Show *)self.showList.list[indexPath.row]).showID];
        [self.navigationController showViewController:vc
                                               sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    if (indexPath.section == 1) {
//        return 210;
    }
    return UITableViewAutomaticDimension;
}

@end
