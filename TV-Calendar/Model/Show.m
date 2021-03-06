//
//  Show.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Show.h"
#import "NetworkManager.h"
#import "SettingsManager.h"
#import "Season.h"
#import "Episode.h"
#import "User.h"

@implementation Show

- (NSString *)enName {
    if (!_enName) {
        _enName = @"";
    }
    return _enName;
}

- (NSString *)chName {
    if (!_chName) {
        _chName = @"";
    }
    return _chName;
}

- (NSString *)imageURL {
    if (!_imageURL) {
        _imageURL = @"";
    }
    return _imageURL;
}

- (NSString *)verticalImageURL {
    if (!_verticalImageURL) {
        _verticalImageURL = @"";
    }
    return _verticalImageURL;
}

- (NSString *)wideImageURL {
    if (!_wideImageURL) {
        _wideImageURL = @"";
    }
    return _wideImageURL;
}

- (NSString *)status {
    if (!_status) {
        _status = @"";
    }
    return _status;
}

- (NSDate *)nextEpTime {
    if (_nextEpTime) {
        _nextEpTime = [NSDate date];
    }
    return _nextEpTime;
}

- (NSString *)area {
    if (!_area) {
        _area = @"";
    }
    return _area;
}

- (NSString *)channel {
    if (!_channel) {
        _channel = @"";
    }
    return _channel;
}

- (NSString *)length {
    if (!_length) {
        _length = @"";
    }
    return _length;
}

- (NSString *)introduction {
    if (!_introduction) {
        _introduction = @"";
    }
    return _introduction;
}

- (NSMutableArray *)seasonsArray {
    if (!_seasonsArray) {
        _seasonsArray = [NSMutableArray array];
    }
    return _seasonsArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showID = -1;
        _seNumOfLastEp = 0;
        _epNumOfLastEp = 0;
        _quantityOfSeason = 0;
        _quantityOfEpisode = 0;
        _isFavorite = NO;
        _quantityOfWatchedEpisode = 0;
        _percentOfWatched = 0;
    }
    return self;
}

+ (void)fetchShowDetailWithID:(NSInteger)showID
                      success:(void (^)(Show *))success
                      failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (currentUser) {
        parameters = @{@"id": [NSString stringWithFormat:@"%ld", (long)showID],
                       @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                       @"u_token": currentUser.token};
    } else {
        parameters = @{@"id": [NSString stringWithFormat:@"%ld", (long)showID]};
    }
    [[NetworkManager defaultManager] GET:@"ShowDetail"
                              parameters:parameters
                                 success:^(NSDictionary *data) {
                                     NSDictionary *showData = data[@"show"];
                                     Show *show = [[Show alloc] init];
                                     show.showID = [showData[@"s_id"] integerValue];
                                     show.enName = showData[@"s_name"];
                                     show.chName = showData[@"s_name_cn"];
                                     show.introduction = showData[@"s_description"];
                                     show.status = showData[@"status"];
                                     show.length = showData[@"length"];
                                     show.area = showData[@"area"];
                                     show.channel = showData[@"channel"];
                                     show.imageURL = showData[@"s_sibox_image"];
                                     show.quantityOfSeason = [showData[@"count_of_se"] integerValue];
                                     show.seNumOfLastEp = [showData[@"last_se_id"] integerValue];
                                     show.epNumOfLastEp = [showData[@"last_ep_num"] integerValue];
                                     NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                     [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                                     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                     show.nextEpTime = [dateFormatter dateFromString:showData[@"next_ep_time"]];
                                     show.isFavorite = [data[@"subscribed"] boolValue];
                                     for (NSDictionary *seData in data[@"seasons"]) {
                                         Season *se = [[Season alloc] init];
                                         se.showID = show.showID;
                                         se.seNum = [seData[@"se_id"] integerValue];
                                         se.quantityOfEpisode = [seData[@"count_of_ep"] integerValue];
                                         int count = 0;
                                         for (NSDictionary *epData in seData[@"episodes"]) {
                                             Episode *ep = [[Episode alloc] init];
                                             ep.episodeID = [epData[@"e_id"] integerValue];
                                             ep.episodeName = epData[@"e_name"];
                                             ep.seNum = se.seNum;
                                             ep.epNum = [epData[@"e_num"] integerValue];
                                             ep.isReleased = [epData[@"e_status"] boolValue];
                                             ep.isWatched = [epData[@"e_Syn"] boolValue];
                                             if (ep.isWatched) {
                                                 count++;
                                             }
                                             ep.airingDate = [dateFormatter dateFromString:epData[@"e_time"]];
                                             [se.episodesArray addObject:ep];
                                         }
                                         se.isAllWatched = (count == se.episodesArray.count) ? true : false;
                                         [show.seasonsArray addObject:se];
                                     }
                                     if (success) {
                                         success(show);
                                     }
                                     
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

+ (void)addToFavouritesWithID:(NSInteger)showID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"AddShowToFavourites"
                              parameters:@{@"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Show]%@", msg[@"OK"]);
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

+ (void)removeFromFavouritesWithID:(NSInteger)showID
                           success:(void (^)())success
                           failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"RemoveShowFromFavourites"
                              parameters:@{@"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Show]%@", msg[@"OK"]);
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

@end
