//
//  User.m
//  Sight Assistant
//
//  Created by Rares Soponar on 31/01/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)sharedInstance
{
    static User *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[User alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = [[NSString alloc] init];
        self.userName = [[NSString alloc] init];
        self.password = [[NSString alloc] init];
        self.currentUserName = [[NSString alloc] init];
        self.blind = NO;
        self.rating = 0;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name withUserName:(NSString *)userName withPass:(NSString *)password isBlind:(BOOL)blind withRating:(NSUInteger)rating {
    self = [super init];
    if (self) {
        self.name = name;
        self.userName = userName;
        self.password = password;
        self.blind = blind;
        self.rating = rating;
    }
    return self;
}

@end
