//
//  AppDelegate.h
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "scheduleAlaramViewController.h"
@import Firebase;
@import GoogleSignIn;

#define APPDELEGATE (AppDelegate *)[ [UIApplication sharedApplication] delegate]
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>{
    NSUserDefaults*USER_DEFAULT;
    NSArray*data,*lunchData,*dinnerData;
    NSString*checkTimer;
    NSString*checkController;

}
-(void)showAlertWithMessage:(NSString *)message;
@property (nonatomic, retain) NSMutableArray *appDel_addDayID;
@property (nonatomic, retain) NSMutableArray *appDel_addHrID;
@property (nonatomic, retain) NSMutableArray *appDel_addMinID;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<UIApplicationDelegate>delagete;


@end

