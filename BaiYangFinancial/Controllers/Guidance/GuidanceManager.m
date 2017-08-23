//
//  GuidanceManager.m
//  GuaGua
//
//  Created by cc on 13-9-13.
//  Copyright (c) 2013年 呱呱. All rights reserved.
//

#import "GuidanceManager.h"


#define GuidingPlayedState_UserDefaults_Key   @"GuidingPlayedState"

@interface GuidanceManager ()

@property (nonatomic, strong) NSString * versionString;

@end


@implementation GuidanceManager

- (id)init
{
    if (self = [super init])
    {
        self.versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    }
    return self;
}

- (NSString *)guidancePlayedStateString
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    NSString * state = [NSString stringWithObject:[userDefault valueForKey:GuidingPlayedState_UserDefaults_Key]];
    NSString *state = [userDefault valueForKey:GuidingPlayedState_UserDefaults_Key];
    return state;
}

- (BOOL)needShowGuidancePage
{
    if ([self guidancePlayedStateString].length != 0)
    {
        if ([[self guidancePlayedStateString] isEqualToString:self.versionString])
        {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)storageGuidancePlayedState
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if (getObjectFromUserDefaults(GuidingPlayedState_UserDefaults_Key)) {
        removeObjectFromUserDefaults(GuidingPlayedState_UserDefaults_Key);
    }
    saveObjectToUserDefaults(self.versionString, GuidingPlayedState_UserDefaults_Key);
    if (getObjectFromUserDefaults(RECORDFIRSTSCORETIME)) {
        removeObjectFromUserDefaults(RECORDFIRSTSCORETIME);
    }
    if (getObjectFromUserDefaults(RecordScoreTime)) {
        removeObjectFromUserDefaults(RecordScoreTime);
    }
    if (getObjectFromUserDefaults(REJECTSCORE)) {
        removeObjectFromUserDefaults(REJECTSCORE);
    }
    [userDefault synchronize];
}

@end
