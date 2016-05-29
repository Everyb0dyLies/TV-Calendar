//
//  MainVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/11.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "MainVC.h"
#import "DailyEpisodesListVC.h"
#import "ShowListVC.h"
#import "FavouriteShowsVC.h"

@interface MainVC () <UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *contentTabBarController;

@end

@implementation MainVC

- (UITabBarController *)contentTabBarController {
    if (!_contentTabBarController) {
        _contentTabBarController = [[UITabBarController alloc] init];
        _contentTabBarController.delegate = self;
        
        DailyEpisodesListVC *dailyEpisodesListVC = [[DailyEpisodesListVC alloc] init];
        ShowListVC *showListVC = [[ShowListVC alloc] init];
        FavouriteShowsVC *favouriteShowsVC = [[FavouriteShowsVC alloc] init];
        UINavigationController *firstContentVC = [[UINavigationController alloc] initWithRootViewController:dailyEpisodesListVC];
        UINavigationController *secondContentVC = [[UINavigationController alloc] initWithRootViewController:showListVC];
        UINavigationController *thirdContentVC = [[UINavigationController alloc] initWithRootViewController:favouriteShowsVC];
        
        _contentTabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstContentVC, secondContentVC, thirdContentVC, nil];
    }
    return _contentTabBarController;
}

- (void)loadView {
    [super loadView];
    
    [self addChildViewController:self.contentTabBarController];
    [self.view addSubview:self.contentTabBarController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UIViewController *vc = [(UINavigationController *)viewController topViewController];
    if ([vc isKindOfClass:[DailyEpisodesListVC class]]) {
        [(DailyEpisodesListVC *)vc refresh];
    }
    if ([vc isKindOfClass:[ShowListVC class]]) {
        [(ShowListVC *)vc refresh];
    }
    if ([vc isKindOfClass:[FavouriteShowsVC class]]) {
        
    }
}

@end
