//
//  homeViewController.m
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import "homeViewController.h"

@interface homeViewController (){
    
    BOOL islandscape;
}

@end

@implementation homeViewController

- (void)viewDidLoad {
    // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
        
    [super viewDidLoad];
    
    USER_DEFAULT = [NSUserDefaults standardUserDefaults];
   
    
    addDayID = [NSMutableArray new];
    addHrID = [NSMutableArray new];
    addMinID = [NSMutableArray new];
    
    addLunchDayId = [NSMutableArray new];
    addLunchHourID = [NSMutableArray new];
    addLunchminID = [NSMutableArray new];
    
    
    addDinnerDayID = [NSMutableArray new];
    AddDinnerHourID = [NSMutableArray new];
    addDinnerMinID = [NSMutableArray new];
    
    //neverSkipMealAgain.font = [UIFont fontWithName:@"Aileron-Regular" size:20];
   //  theDinnerBellApp.font = [UIFont fontWithName:@"Aileron-Regular" size:20];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)fetchBreakfastDatas{
    data = [[DBManager getSharedInstance]findByRegisterNumber];
    NSLog(@"value of data arrays %@",data);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    [addDayID removeAllObjects];
    [addHrID removeAllObjects];
    [addMinID removeAllObjects];
    
    for (int i = 0; i<[data count]; i++) {
        NSString*hour = [[data objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[data objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[data objectAtIndex:i] valueForKey:@"regStr"];
        [addDayID addObject:day];
        [addHrID addObject:hour];
        [addMinID addObject:min];
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

    [USER_DEFAULT setValue:@"breakfast" forKey:@"breakfast"];
    [USER_DEFAULT removeObjectForKey:@"lunch"];
    [USER_DEFAULT removeObjectForKey:@"dinner"];
    
   // [self performSegueWithIdentifier:@"breakfast" sender:self];
    
}


-(void)FetchlunchData{
    LunchData = [[DBManager getSharedInstance]findByRegisterNumberForLunch];
    NSLog(@"value of data arrays %@",LunchData);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    
    
    [addLunchHourID removeAllObjects];
    [addLunchminID removeAllObjects];
    [addLunchDayId removeAllObjects];
    
    for (int i = 0; i<[LunchData count]; i++) {
        NSString*hour = [[LunchData objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[LunchData objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[LunchData objectAtIndex:i] valueForKey:@"regStr"];
        [addLunchDayId addObject:day];
        [addLunchHourID addObject:hour];
        [addLunchminID addObject:min];
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
    
    NSString*Breakfast = @"lunch";
    [USER_DEFAULT setValue:Breakfast forKey:@"lunch"];
    [USER_DEFAULT removeObjectForKey:@"breakfast"];
    [USER_DEFAULT removeObjectForKey:@"dinner"];
    
    
}

-(void)fetchDinnerDatas{
    DinnerData = [[DBManager getSharedInstance]findByRegisterNumberForDinner];
    NSLog(@"value of data arrays %@",DinnerData);
    NSLog(@"data manager count %lu",(unsigned long)data.count);
    
    [addDinnerMinID removeAllObjects];
    [AddDinnerHourID removeAllObjects];
    [addDinnerDayID removeAllObjects];
    
    for (int i = 0; i<[DinnerData count]; i++) {
        NSString*hour = [[DinnerData objectAtIndex:i] valueForKey:@"FileTitle"];
        NSString*min = [[DinnerData objectAtIndex:i] valueForKey:@"FileName"];
        NSString*day = [[DinnerData objectAtIndex:i] valueForKey:@"regStr"];
        [addDinnerDayID addObject:day];
        [AddDinnerHourID addObject:hour];
        [addDinnerMinID addObject:min];
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
    NSString*Breakfast = @"dinner";
    [USER_DEFAULT setValue:Breakfast forKey:@"dinner"];
    [USER_DEFAULT removeObjectForKey:@"breakfast"];
    [USER_DEFAULT removeObjectForKey:@"lunch"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)breakFastTap:(UIButton *)sender {
    scheduleAlaramViewController *scheduleAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
    scheduleAlarmVC.time_order = @"breakfast";
    
    [self fetchBreakfastDatas];
    NSLog(@"minutes %@",addMinID);
    NSLog(@"hour %@",addHrID);
    NSLog(@"day %@",addDayID);
    [scheduleAlarmVC setBreakFastdayID:addDayID];
    [scheduleAlarmVC setHrID:addHrID];
    [scheduleAlarmVC setMinID:addMinID];
    [self presentViewController:scheduleAlarmVC animated:YES  completion:nil];
}

- (IBAction)lunchTap:(UIButton *)sender {
    scheduleAlaramViewController *scheduleAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
    scheduleAlarmVC.time_order = @"lunch";
    
    [self FetchlunchData];
    NSLog(@"minutes %@",addLunchDayId);
    NSLog(@"hour %@",addLunchminID);
    NSLog(@"day %@",addLunchHourID);
    [scheduleAlarmVC setBreakFastdayID:addLunchDayId];
    [scheduleAlarmVC setHrID:addLunchHourID];
    [scheduleAlarmVC setMinID:addLunchminID];
    [self presentViewController:scheduleAlarmVC animated:YES  completion:nil];
}

- (IBAction)dinnerTap:(UIButton *)sender {
    scheduleAlaramViewController *scheduleAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleAlaramView"];
    scheduleAlarmVC.time_order = @"dinner";
    
    [self fetchDinnerDatas];
    NSLog(@"minutes %@",addDinnerDayID);
    NSLog(@"hour %@",addDinnerMinID);
    NSLog(@"day %@",AddDinnerHourID);
    
    [scheduleAlarmVC setBreakFastdayID:addDinnerDayID];
    [scheduleAlarmVC setHrID:AddDinnerHourID];
    [scheduleAlarmVC setMinID:addDinnerMinID];
    [self presentViewController:scheduleAlarmVC animated:YES  completion:nil];
}
@end
