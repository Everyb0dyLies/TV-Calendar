//
//  WatchedShowTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/10.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "WatchedShowTVC.h"
#import "LoginVC.h"
#import "User.h"

@interface WatchedShowTVC ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation WatchedShowTVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = false;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
    }
    return _tableView;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (!currentUser) {
        UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showLoginViewController)];
        self.navigationItem.rightBarButtonItem = loginItem;
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginViewController {
    [self showDetailViewController:[LoginVC viewController] sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = @"sdfghjk";
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
        v.backgroundColor = [UIColor redColor];
        cell.accessoryView = v;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor redColor];
    return cell;
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    return 45;
}

@end
