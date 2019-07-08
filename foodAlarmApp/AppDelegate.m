//
//  AppDelegate.m
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    USER_DEFAULT = [NSUserDefaults standardUserDefaults];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

     _appDel_addHrID = [NSMutableArray new];
     _appDel_addDayID = [NSMutableArray new];
     _appDel_addMinID = [NSMutableArray new];
    
    
    UILocalNotification *localNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self application:application didReceiveLocalNotification:localNotification];
    }
    
    
   // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i=0; i<[eventArray count]; i++)
//    {
//        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
//        if ([uid isEqualToString:uidtodelete])
//        {
//            //Cancelling local notification
//            [app cancelLocalNotification:oneEvent];
//            break;
//        }
//    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
        
        UIMutableUserNotificationAction *attendingAction = [[UIMutableUserNotificationAction alloc]init];
        [attendingAction setActivationMode:UIUserNotificationActivationModeBackground];
        [attendingAction setTitle:@"CANCEL"];
        [attendingAction setIdentifier:@"ACTION_CANCEL"];
        [attendingAction setDestructive:NO];
        [attendingAction setAuthenticationRequired:NO];
        
        
        UIMutableUserNotificationAction *notAttendingAction = [[UIMutableUserNotificationAction alloc]init];
        [notAttendingAction setActivationMode:UIUserNotificationActivationModeForeground];
        [notAttendingAction setTitle:@"YES"];
        [notAttendingAction setIdentifier:@"ACTION_YES"];
        [notAttendingAction setDestructive:NO];
        [notAttendingAction setAuthenticationRequired:NO];
        
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
        [category setIdentifier:@"CATEGORY"];
        [category setActions:@[attendingAction, notAttendingAction] forContext:UIUserNotificationActionContextDefault];
        //
        [category setActions:@[attendingAction, notAttendingAction] forContext:UIUserNotificationActionContextMinimal];
        
        // specify the settings for the above category
        
        NSSet *categoriesForSettings = [NSSet setWithObject:category];
        
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categoriesForSettings];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    
  //  [self fetchDatas];

    NSString *myAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"];
    if (myAccount != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.window setRootViewController:vc];
    } else {
        // Use Firebase library to configure APIs
        [FIRApp configure];
        
        [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
        [GIDSignIn sharedInstance].delegate = self;
    }
    
    return YES;
}

- (BOOL)application:(nonnull UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *, id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        
        [[FIRAuth auth] signInAndRetrieveDataWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            // User successfully signed in. Get user data from the FIRUser object
            if (authResult == nil) { return; }
            FIRUser *user = authResult.user;
            if (user != nil) {
                NSLog(@"Success!!!!!!!!!");
                
                [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:@"myAccount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
                [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
            } else {
                NSLog(@"Please SignIn !!!!!!!!!!!!!!!!!!!!");
            }
        }];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    
    

//    
    NSDictionary *infoInNotification = notification.userInfo;
    NSString*type = [infoInNotification valueForKey:@"new"];
    NSLog(@"typeisequalto %@",type);

    
    
  //  NSLog(@"dictionary %@ %@",infoInNotification,identifier);
    
    if ([identifier isEqualToString:@"ACTION_YES"]) {
        
        if ([type isEqualToString:@"DINNER"]) {
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"break"];
            [USER_DEFAULT setValue:type forKey:@"dine"];
            
            [self fetchDinnerDatas];
            
        }else if ([type isEqualToString:@"BREAKFAST"]){
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT setValue:type forKey:@"break"];
            [self fetchBreakfastDatas];
            
        }else{
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT removeObjectForKey:@"break"];
            [USER_DEFAULT setValue:type forKey:@"lunc"];
            
            [self FetchlunchData];
        }

        NSLog(@"You chose action 1.");
        
        checkTimer = @"check";
        [USER_DEFAULT setValue:checkTimer forKey:@"checkTime"];

        checkController = @"checkCont";
        [USER_DEFAULT setValue:checkController forKey:@"checkController"];

                
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        scheduleAlaramViewController*timer  = (scheduleAlaramViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
        
       // UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:timer];
        [timer setType:type];
        
        self.window.rootViewController = timer;
        
                                        }
    else if ([identifier isEqualToString:@"ACTION_CANCEL"]) {
        
        NSLog(@"You chose action 2.");
    }
    if (completionHandler) {
        
        completionHandler();
    }
    
    
    
}




-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Received Notification %@",notification.alertBody);
    
    NSDictionary*userInfo = notification.userInfo;
    NSString*type = [userInfo valueForKey:@"new"];
    NSLog(@"typeisequalto %@",type);
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        if ([type isEqualToString:@"DINNER"]) {
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"break"];
            [USER_DEFAULT setValue:type forKey:@"dine"];
            
            [self fetchDinnerDatas];
            
        }else if ([type isEqualToString:@"BREAKFAST"]){
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT setValue:type forKey:@"break"];
             [self fetchBreakfastDatas];
            
        }else{
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT removeObjectForKey:@"break"];
            [USER_DEFAULT setValue:type forKey:@"lunc"];
            
            [self FetchlunchData];
        }
        
        
        checkTimer = @"check";
        [USER_DEFAULT setValue:checkTimer forKey:@"checkTime"];

        checkController = @"checkCont";
                [USER_DEFAULT setValue:checkController forKey:@"checkController"];
//
       //  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        scheduleAlaramViewController*timer  = (scheduleAlaramViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
        [timer setType:type];
        //timer.strCheck = @"check";
       // UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:timer];
        
        
        self.window.rootViewController = timer;
        
       

        
       
        
        
    }
    else if([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        
        
        if ([type isEqualToString:@"DINNER"]) {
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"break"];
         
            [USER_DEFAULT setValue:type forKey:@"dine"];
            
            [self fetchDinnerDatas];
            
        }else if ([type isEqualToString:@"BREAKFAST"]){
            [USER_DEFAULT removeObjectForKey:@"lunc"];
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT setValue:type forKey:@"break"];
            
            [self fetchBreakfastDatas];
            
        }else{
            [USER_DEFAULT removeObjectForKey:@"dine"];
            [USER_DEFAULT removeObjectForKey:@"break"];
            [USER_DEFAULT setValue:type forKey:@"lunc"];
            
            [self FetchlunchData];
        }
        
        checkTimer = @"check";
        [USER_DEFAULT setValue:checkTimer forKey:@"checkTime"];
        checkController = @"checkCont";
        [USER_DEFAULT setValue:checkController forKey:@"checkController"];

        // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        scheduleAlaramViewController*timer  = (scheduleAlaramViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
        //UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:timer];
        [timer setType:type];
        
        
        self.window.rootViewController = timer;

        
      
        
    }else if (state == UIApplicationStateInactive){
        
//        if ([type isEqualToString:@"DINNER"]) {
//            [USER_DEFAULT removeObjectForKey:@"lunc"];
//            [USER_DEFAULT removeObjectForKey:@"break"];
//            [USER_DEFAULT setValue:type forKey:@"dine"];
//            
//            [self fetchDinnerDatas];
//            
//        }else if ([type isEqualToString:@"BREAKFAST"]){
//            [USER_DEFAULT removeObjectForKey:@"lunc"];
//            [USER_DEFAULT removeObjectForKey:@"dine"];
//            [USER_DEFAULT setValue:type forKey:@"break"];
//            [self fetchBreakfastDatas];
//            
//        }else{
//            [USER_DEFAULT removeObjectForKey:@"dine"];
//            [USER_DEFAULT removeObjectForKey:@"break"];
//            [USER_DEFAULT setValue:type forKey:@"lunc"];
//            
//            [self FetchlunchData];
//        }
//        
//        
//        checkTimer = @"check";
//        [USER_DEFAULT setValue:checkTimer forKey:@"checkTime"];
//        
//        checkController = @"checkCont";
//        [USER_DEFAULT setValue:checkController forKey:@"checkController"];
//        //
//        //  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        scheduleAlaramViewController*timer  = (scheduleAlaramViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
//        //timer.strCheck = @"check";
//        // UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:timer];
//        
//        
//        self.window.rootViewController = timer;
//        
//        
//        
//
        
        
    }
    
    
}



-(void)fetchBreakfastDatas{
    data = [[DBManager getSharedInstance]findByRegisterNumber];
    NSLog(@"value of data arrays %@",data);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    [_appDel_addMinID removeAllObjects];
    [_appDel_addHrID removeAllObjects];
    [_appDel_addDayID removeAllObjects];
    
    for (int i = 0; i<[data count]; i++) {
        NSString*hour = [[data objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[data objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[data objectAtIndex:i] valueForKey:@"regStr"];
        [_appDel_addDayID addObject:day];
        [_appDel_addHrID addObject:hour];
        [_appDel_addMinID addObject:min];
        //        [USER_DEFAULT setValue:addDayID forKey:@"breakfastDayId"];
        //        [USER_DEFAULT setValue:addHrID forKey:@"breakfastHourId"];
        //        [USER_DEFAULT setValue:addMinID forKey:@"breakfastMinId"];
        
        NSLog(@"HOUR,MIN,DAY %@%@%@",hour,min,day);
    }
    
    if (data == nil) {
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
        //                              @"Data not found" message:nil delegate:nil cancelButtonTitle:
        //                              @"OK" otherButtonTitles:nil];
        //        [alert show];
        
        
    }
    else{
        
        
        //  NSLog(@"Record set %@",data);
        
        
    }
    
}




-(void)FetchlunchData{
    lunchData = [[DBManager getSharedInstance]findByRegisterNumberForLunch];
    NSLog(@"value of data arrays %@",lunchData);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    
    [_appDel_addMinID removeAllObjects];
    [_appDel_addHrID removeAllObjects];
    [_appDel_addDayID removeAllObjects];
    
    for (int i = 0; i<[lunchData count]; i++) {
        NSString*hour = [[lunchData objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[lunchData objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[lunchData objectAtIndex:i] valueForKey:@"regStr"];
        [_appDel_addDayID addObject:day];
        [_appDel_addHrID addObject:hour];
        [_appDel_addMinID addObject:min];
        //        [USER_DEFAULT setValue:addDayID forKey:@"breakfastDayId"];
        //        [USER_DEFAULT setValue:addHrID forKey:@"breakfastHourId"];
        //        [USER_DEFAULT setValue:addMinID forKey:@"breakfastMinId"];
        
        NSLog(@"HOUR,MIN,DAY %@%@%@",hour,min,day);
    }
    
    if (data == nil) {
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
        //                              @"Data not found" message:nil delegate:nil cancelButtonTitle:
        //                              @"OK" otherButtonTitles:nil];
        //        [alert show];
        
        
    }
    else{
        
        
        //  NSLog(@"Record set %@",data);
        
        
    }
    
}

//
-(void)fetchDinnerDatas{
    dinnerData = [[DBManager getSharedInstance]findByRegisterNumberForDinner];
    NSLog(@"value of data arrays %@",dinnerData);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    
    [_appDel_addMinID removeAllObjects];
    [_appDel_addHrID removeAllObjects];
    [_appDel_addDayID removeAllObjects];
    
    for (int i = 0; i<[dinnerData count]; i++) {
        NSString*hour = [[dinnerData objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[dinnerData objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[dinnerData objectAtIndex:i] valueForKey:@"regStr"];
        [_appDel_addDayID addObject:day];
        [_appDel_addHrID addObject:hour];
        [_appDel_addMinID addObject:min];
        //        [USER_DEFAULT setValue:addDayID forKey:@"breakfastDayId"];
        //        [USER_DEFAULT setValue:addHrID forKey:@"breakfastHourId"];
        //        [USER_DEFAULT setValue:addMinID forKey:@"breakfastMinId"];
        
        NSLog(@"HOUR,MIN,DAY %@%@%@",hour,min,day);
    }
    
    if (data == nil) {
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
        //                              @"Data not found" message:nil delegate:nil cancelButtonTitle:
        //                              @"OK" otherButtonTitles:nil];
        //        [alert show];
        
        
    }
    else{
        
        
        //  NSLog(@"Record set %@",data);
        
        
    }
    
}

-(void)showAlertWithMessage:(NSString *)message

{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [USER_DEFAULT removeObjectForKey:@"checkTime"];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    //[USER_DEFAULT removeObjectForKey:@"checkTime"];
   // [USER_DEFAULT removeObjectForKey:@"checkController"];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
