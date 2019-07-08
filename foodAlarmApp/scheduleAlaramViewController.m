//
//  scheduleAlaramViewController.m
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import "scheduleAlaramViewController.h"

@interface scheduleAlaramViewController (){
    
    AVAudioPlayer *_audioPlayer;
    NSString*timerCheck,*controllerCheck;
}

@end

@implementation scheduleAlaramViewController

- (void)viewDidLoad {

    if ([_time_order isEqual: @"breakfast"]) {
        background_image.image = [UIImage imageNamed:@"background_breakfast"];
    } else if ([_time_order isEqual: @"lunch"]) {
        background_image.image = [UIImage imageNamed:@"background_lunch"];
    } else if ([_time_order isEqual: @"dinner"]) {
        background_image.image = [UIImage imageNamed:@"background_dinner"];
    }
    
    [self datePickerChanged:_startTimePicker];
    
    [animatedView setHidden:YES];
    
    //imitialising the three arrays
    dayID = [NSMutableArray new];
    
    NSLog(@"type of alarm %@",_type);
    if ([_type isEqualToString:@"BREAKFAST"]) {
        background_image.image = [UIImage imageNamed:@"background_breakfast"];
        alertStr = @"It's time for breakfast!";
    }else if ([_type isEqualToString:@"LUNCH"]){
        background_image.image = [UIImage imageNamed:@"background_lunch"];
        alertStr = @"It's time for lunch!";
    }else if ([_type isEqualToString:@"DINNER"]){
        background_image.image = [UIImage imageNamed:@"background_dinner"];
        alertStr = @"It's time for dinner!";
    }
    
    NSLog(@"%@",_breakFastdayID);
    

    //adding to dayid to new day id
    for (int i = 0; i<_breakFastdayID.count; i++) {
        NSString*dayid = [_breakFastdayID objectAtIndex:i];
        [dayID addObject:dayid];
    }
    
      USER_DEFAULT = [NSUserDefaults standardUserDefaults];
    
    turnOffAlarmBtn.titleLabel.hidden = YES;
 
    timerCheck = [USER_DEFAULT objectForKey:@"checkTime"];
    controllerCheck = [USER_DEFAULT objectForKey:@"checkController"];
    NSLog(@"value for time check is %@",timerCheck);

 //checking notification and ringing alaram
    if ([timerCheck isEqualToString:@"check"]) {
        
        [self ringAlarm];
        [self timertoStopAlarm];
        [self ActivateSilentMode:alertStr];

        
    }else{
       NSLog(@"sdsdsdsdsdsdsdsd");
        
    }
//
    
    [self.navigationItem setTitle:@"Set Alarm"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

   
    
   
        AppDelegate*appDel;
    
    //appDel = [[UIApplication sharedApplication]delegate];
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSLog(@"app delegate array %@ , %@ , %@",appDel.appDel_addMinID , appDel.appDel_addDayID, appDel.appDel_addHrID);
      //_breakFastdayID = [USER_DEFAULT objectForKey:@"breakfastDayId"];
    
    //setting the time on timer for selected time for meal
    NSLog(@"string value is %@  %@  %@",_breakFastdayID,_hrID,_minID);
  
    if (_hrID.count>0) {
        NSString*hrStr = [_hrID objectAtIndex:0];
        NSString*minuStr  = [_minID objectAtIndex:0];
        int h = [hrStr intValue];
        int m = [minuStr intValue];
        NSDate * now = [[NSDate alloc] init];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents * comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [comps setHour:h];
        [comps setMinute:m];
        //  [comps setSecond:0];
        NSDate * date = [cal dateFromComponents:comps];
        [self.startTimePicker setDate:date animated:TRUE];
        [self.startTimePicker setUserInteractionEnabled:NO];
        edit = YES;

    }   else if ([appDel.appDel_addDayID count]>0){
        
        NSString*hrStr = [appDel.appDel_addHrID objectAtIndex:0];
        NSString*minuStr  = [appDel.appDel_addMinID objectAtIndex:0];
        int h = [hrStr intValue];
        int m = [minuStr intValue];
        NSDate * now = [[NSDate alloc] init];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents * comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [comps setHour:h];
        [comps setMinute:m];
        //  [comps setSecond:0];
        NSDate * date = [cal dateFromComponents:comps];
        [self.startTimePicker setDate:date animated:TRUE];
        [self.startTimePicker setUserInteractionEnabled:NO];
        edit = YES;

        
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideAnimate)];
    
    [self.view addGestureRecognizer:tap];
    
    
    [self.startTimePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
    [USER_DEFAULT synchronize];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timertoStopAlarm
{
    stopAlarmTimer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(stopAlarm) userInfo:nil repeats:NO];
}

-(void)stopAlarm{
    
    [_audioPlayer stop];
    turnOffAlarmBtn.titleLabel.hidden = YES;
    
}

-(void)ringAlarm{
    
    turnOffAlarmBtn.titleLabel.hidden = NO;
    NSString *path = [NSString stringWithFormat:@"%@/alarm.aiff", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer play];
    
    
    [USER_DEFAULT removeObjectForKey:@"checkTime"];
//    
    
}

-(void)ActivateSilentMode:(NSString *)Message{
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:Message
                                                    message:@"It's time to eat!!!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert1.tag = 2;
    [alert1 show];

}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm a"];
    
    selectedTime =    [self.dateFormatter stringFromDate:self.startTimePicker.date];
    NSLog(@"selected day %@",selectedTime);
    
    hour = [[selectedTime substringToIndex:2] intValue];
    min = [[selectedTime substringFromIndex:3] intValue];
    
    hourStr = [NSString stringWithFormat:@"%d",hour];//reg//14
    
    minStr = [NSString stringWithFormat:@"%d",min];//time//56
    
    NSLog(@"set time and hour %d%d",hour,min);

}



//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)saveDate:(NSString *)time hourS:(NSString *)hourS minute:(NSString *)mint{
    NSLog(@"Breakfast");
          
        [[DBManager getSharedInstance]createDB];
        BOOL success = NO;
        NSString *alertString = @"Data Insertion failed";
        if (![alertString isEqualToString:@""])
        {
          
           // success = [[DBManager getSharedInstance]saveData:hourS date:time time:mint];
            success= [[DBManager getSharedInstance]saveData:time date:hourS registerNumber:mint];
            
            
            
        }
        else{
            alertString = @"Enter all fields";
        }
        
        if (success == NO) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
//                                  alertString message:nil
//                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
              NSLog(@"unsaved");
            
        }else{
            NSLog(@"saved");
        }
        

    

}

-(void)saveDateLunch:(NSString *)time hourL:(NSString *)hourL minuteL:(NSString *)mint{
    
    NSLog(@"Lunch");
    [[DBManager getSharedInstance]createDB];
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    if (![alertString isEqualToString:@""])
    {
        
        // success = [[DBManager getSharedInstance]saveData:hourS date:time time:mint];
        success= [[DBManager getSharedInstance]saveLunchData:time date:hourL registerNumber:mint];
        
        
        
    }
    else{
        alertString = @"Enter all fields";
    }
    
    if (success == NO) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
//                              alertString message:nil
//                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
          NSLog(@"unsaved");
    }else{
        NSLog(@"saved");
    }
    
    
    
    
}


-(void)saveDateDinner:(NSString *)time hourD:(NSString *)hourD minuteL:(NSString *)mint{
    
    NSLog(@"Dinner");
    [[DBManager getSharedInstance]createDB];
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    if (![alertString isEqualToString:@""])
    {
        
        // success = [[DBManager getSharedInstance]saveData:hourS date:time time:mint];
        success= [[DBManager getSharedInstance]saveDinnerData:time date:hourD registerNumber:mint];
        
        
        
    }
    else{
        alertString = @"Enter all fields";
    }
    
    if (success == NO) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
//                              alertString message:nil
//                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
        NSLog(@"unsaved");
        
    }else{
        NSLog(@"saved");
    }
    
    
    
    
}







-(void)deleteFile:(NSString *)day{//call this method where u want
    
    BOOL deleteflag = [[DBManager getSharedInstance]deleteFile:day];
    //   NSLog(@"delete flag %@",deleteflag);
    
    if (deleteflag == YES)
    {
        NSLog(@" deleted");
        
        
    }
    
    else{
        
        NSLog(@"not deleted");
        
    }
    
}

-(void)deleteLunchFile:(NSString *)day{//call this method where u want
    
    BOOL deleteflag = [[DBManager getSharedInstance]deleteLunchFile:day];
    //   NSLog(@"delete flag %@",deleteflag);
    
    if (deleteflag == YES)
    {
        NSLog(@" deleted");
        
        
    }
    
    else{
        
        NSLog(@"not deleted");
        
    }
    
}

-(void)deleteDinnerFile:(NSString *)day{//call this method where u want
    
    BOOL deleteflag = [[DBManager getSharedInstance]deleteDinnerFile:day];
    //   NSLog(@"delete flag %@",deleteflag);
    
    if (deleteflag == YES)
    {
        NSLog(@" deleted");
        
        
    }
    
    else{
        
        NSLog(@"not deleted");
        
    }
    
}




-(void)fireNotificationForBreakfast:(NSDate *)date{
    
    
    UILocalNotification *notification = [[UILocalNotification alloc]  init] ;
    notification.fireDate = date ;
    notification.timeZone = [NSTimeZone defaultTimeZone] ;
    notification.alertBody = [NSString stringWithFormat: @"It's time for breakfast!"] ;
    notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"BREAKFAST"] forKey:@"new"];
    notification.repeatInterval= NSWeekCalendarUnit ;
    notification.soundName=@"alarm.aiff";
    notification.hasAction = YES;
    notification.category = @"CATEGORY";
    NSLog(@"notification: %@",notification);//it indicates that the notif will be triggered today at 8PM and not Sunday.
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;
    
    
    
    
}




-(void)setBreakfastNotification{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    
    
    
    for (int k = 0; k<[FinalsaveDay count]; k++) {
        
        NSString*day = [FinalsaveDay objectAtIndex:k];
        int daay = [day intValue];
        
        [componentsForFireDate setWeekday: daay] ; //for fixing Sunday
        [componentsForFireDate setHour: hour] ; //for fixing 8PM hour
        [componentsForFireDate setMinute:min] ;
        [componentsForFireDate setSecond:0] ;
        
        NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
       // NSDate *fiveMinutesBeforeDate = [NSDate dateWithTimeInterval:-60*1 sinceDate:fireDateOfNotification];
        
      //  NSLog(@"fire date is %@",fiveMinutesBeforeDate);
        [self fireNotificationForBreakfast:fireDateOfNotification];
        
    }
    
    
}


-(void)fireNotificationForlunch:(NSDate *)date{
    
    
    UILocalNotification *notification = [[UILocalNotification alloc]  init] ;
    notification.fireDate = date ;
    notification.timeZone = [NSTimeZone defaultTimeZone] ;
    notification.alertBody = [NSString stringWithFormat: @"It's time for lunch!"] ;
    notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"LUNCH"] forKey:@"new"];
    notification.repeatInterval= NSWeekCalendarUnit ;
    notification.soundName=@"alarm.aiff";
    notification.hasAction = YES;
    notification.category = @"CATEGORY";
    NSLog(@"notification: %@",notification);//it indicates that the notif will be triggered today at 8PM and not Sunday.
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;
    
    
    
    
}




-(void)setLunchNotification{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    
    
    
    for (int k = 0; k<[FinalsaveDay count]; k++) {
       
        NSString*day = [FinalsaveDay objectAtIndex:k];
        int daay = [day intValue];
        
        [componentsForFireDate setWeekday: daay] ; //for fixing Sunday
        [componentsForFireDate setHour: hour] ; //for fixing 8PM hour
        [componentsForFireDate setMinute:min] ;
        [componentsForFireDate setSecond:0] ;
        
        NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
      //  NSDate *fiveMinutesBeforeDate = [NSDate dateWithTimeInterval:-60*1 sinceDate:fireDateOfNotification];
        
       // NSLog(@"fire date is %@",fiveMinutesBeforeDate);
        [self fireNotificationForlunch:fireDateOfNotification];

    }
 

}


-(void)fireNotificationForDinner:(NSDate *)date{
    
    
    UILocalNotification *notification = [[UILocalNotification alloc]  init] ;
    notification.fireDate = date ;
    notification.timeZone = [NSTimeZone defaultTimeZone] ;
    notification.alertBody = [NSString stringWithFormat: @"It's time for dinner!"] ;
    notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"DINNER"] forKey:@"new"];
    notification.repeatInterval= NSWeekCalendarUnit ;
    notification.soundName=@"alarm.aiff";
    notification.hasAction = YES;
    notification.category = @"CATEGORY";
    NSLog(@"notification: %@",notification);//it indicates that the notif will be triggered today at 8PM and not Sunday.
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;
    

    
    
}

-(void)setDinnerNotification{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    
    
    
    for (int k = 0; k<[FinalsaveDay count]; k++) {
        
        NSString*day = [FinalsaveDay objectAtIndex:k];
        int daay = [day intValue];
        
        [componentsForFireDate setWeekday: daay] ; //for fixing Sunday
        [componentsForFireDate setHour: hour] ; //for fixing 8PM hour
        [componentsForFireDate setMinute:min] ;
        [componentsForFireDate setSecond:0] ;
        
        NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
    //    NSDate *fiveMinutesBeforeDate = [NSDate dateWithTimeInterval:-60*1 sinceDate:fireDateOfNotification];
        
    //    NSLog(@"fire date is %@",fiveMinutesBeforeDate);
        [self fireNotificationForDinner:fireDateOfNotification];
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
       NSLog(@"string value is %@  %@  %@",_breakFastdayID,_hrID,_minID);
    
     NSLog(@"break fast id %lu",(unsigned long)_breakFastdayID.count);
    
       AppDelegate*appDel;
    
    FinalsaveDay = [NSMutableArray new];

    //appDel = [[UIApplication sharedApplication]delegate];
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"app delegate array %@ , %@ , %@",appDel.appDel_addMinID , appDel.appDel_addDayID, appDel.appDel_addHrID);
   // _breakFastdayID = [USER_DEFAULT objectForKey:@"breakfastDayId"];
   
   
    if (dayID.count>0) {
        
        
         //   marking checkmark on selected days at time of going from slected meal to schedule meal
       
        for (int j = 0; j<[dayID count]; j++) {
            NSString*bIDStr = [dayID objectAtIndex:j];
            [FinalsaveDay addObject:bIDStr];
            NSLog(@"final save da %@",FinalsaveDay);
            int tagg = [bIDStr intValue];
            UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:tagg];
            [myImageView setImage:[UIImage imageNamed:@"check"]];
        
            
        }
    }
    
    else if ([appDel.appDel_addDayID count]>0){
        
     //   marking checkmark on selected days at time of receiving alarm notification
      
        for (int j = 0; j<[appDel.appDel_addDayID count]; j++) {
            NSString*bIDStr = [appDel.appDel_addDayID objectAtIndex:j];
            [FinalsaveDay addObject:bIDStr];
            [dayID addObject:bIDStr];
            
            NSLog(@"final save da %@",FinalsaveDay);
            int tagg = [bIDStr intValue];
            UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:tagg];
            [myImageView setImage:[UIImage imageNamed:@"check"]];
            
            
        }
        
        
    }
   
}








- (IBAction)setDayTapp:(UIButton*)sender {
    
    NSLog(@"sender tag %ld",(long)sender.tag);
    
    UIImage*image1 = [UIImage imageNamed:@"uncheck"];
    NSData *checkImageData = UIImagePNGRepresentation(image1);
    
        if ((sender.tag  == 1)) {
            
            NSLog(@"sunday");
            Saveday = @"1";
            NSData *propertyImageData = UIImagePNGRepresentation(sunImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                sunImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
                }else{
                sunImage.image = [UIImage imageNamed:@"uncheck"];
                    [FinalsaveDay removeObject:Saveday];
                }
          
            
           
        }
    
        else if ((sender.tag == 2)){
            
            
             NSLog(@"monday");
             Saveday = @"2";
           
            NSData *propertyImageData = UIImagePNGRepresentation(monImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                monImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                monImage.image = [UIImage imageNamed:@"uncheck"];
                 [FinalsaveDay removeObject:Saveday];
            }
            
              NSLog(@"finaal save day %@",FinalsaveDay);
    
        }
    
        else if ((sender.tag == 3)){
    
             NSLog(@"tuesday");
             Saveday = @"3";
            
                        NSData *propertyImageData = UIImagePNGRepresentation(tueImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                tueImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                tueImage.image = [UIImage imageNamed:@"uncheck"];
                [FinalsaveDay removeObject:Saveday];
            }
           
              NSLog(@"finaal save day %@",FinalsaveDay);
    
        }
    
        else if ((sender.tag == 4)){
    
                 NSLog(@"4");
             Saveday = @"4";
            
                      NSData *propertyImageData = UIImagePNGRepresentation(wedImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                wedImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                wedImage.image = [UIImage imageNamed:@"uncheck"];
                 [FinalsaveDay removeObject:Saveday];
            }
                         NSLog(@"finaal save day %@",FinalsaveDay);
        }
    
        else if ((sender.tag == 5)){
    
             NSLog(@"thursday");
             Saveday = @"5";
          
            NSData *propertyImageData = UIImagePNGRepresentation(thuImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                thuImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                thuImage.image = [UIImage imageNamed:@"uncheck"];
                 [FinalsaveDay removeObject:Saveday];
            }
            
                        NSLog(@"finaal save day %@",FinalsaveDay);
    
        }
    
        else if ((sender.tag == 6)){
    
                NSLog(@"friday");
             Saveday = @"6";
            
                       NSData *propertyImageData = UIImagePNGRepresentation(friImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                friImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                friImage.image = [UIImage imageNamed:@"uncheck"];
                  [FinalsaveDay removeObject:Saveday];
            }
            
              NSLog(@"finaal save day %@",FinalsaveDay);
    
        }
    
        else if ((sender.tag == 7)){
            
            
            NSLog(@"saturday");
             Saveday = @"7";
            
                      NSData *propertyImageData = UIImagePNGRepresentation(satImage.image);
            
            if ([checkImageData isEqualToData:propertyImageData]) {
                satImage.image = [UIImage imageNamed:@"check"];
                [FinalsaveDay addObject:Saveday];
            }else{
                satImage.image = [UIImage imageNamed:@"uncheck"];
                 [FinalsaveDay removeObject:Saveday];            }
            
            
              NSLog(@"finaal save day %@",FinalsaveDay);
        }
}

-(void)ViewAnimate{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    CGRect rect = [animatedView frame];
    rect.origin.y = 70;
    [animatedView setFrame:rect];
    [UIView commitAnimations];
    
    
    
    
}
-(void)hideAnimate{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    CGRect rect = [animatedView frame];
    rect.origin.y = -125;
    [animatedView setFrame:rect];
    [UIView commitAnimations];
    
}




- (IBAction)editTapp:(id)sender {
  
    if (edit == YES) {
        [APPDELEGATE showAlertWithMessage:@"You Can Edit Now"];
         [self.startTimePicker setUserInteractionEnabled:YES];
        [self hideAnimate];
        edit = NO;
    }else{
       [APPDELEGATE showAlertWithMessage:@"Already Editable"];
     [self hideAnimate];
    }
    
}

- (IBAction)saveTapp:(id)sender {
    
   [self hideAnimate];
    
    NSLog(@"break fast id count %@",dayID);
    
    
    if (FinalsaveDay.count == 0) {
        [APPDELEGATE showAlertWithMessage:@"Please select the days first"];
    }else{
        
        [APPDELEGATE showAlertWithMessage:@"Alarm Saved"];
        NSLog(@"break fast id count %lu",(unsigned long)_breakFastdayID.count);
        
        NSString * type  = @"";
        
        if ([[USER_DEFAULT objectForKey:@"breakfast"]isEqualToString:@"breakfast"])
            type = @"BREAKFAST";
        else if ([[USER_DEFAULT objectForKey:@"lunch"]isEqualToString:@"lunch"])
            type = @"LUNCH";
        else if ([[USER_DEFAULT objectForKey:@"dinner"]isEqualToString:@"dinner"])
            type = @"DINNER";
        
        NSLog(@"%@",FinalsaveDay);
        
        if (FinalsaveDay.count>0) {
            //            for (int i = 0; i<[dayID count]; i++) {
            //                NSString*day = [dayID objectAtIndex:i];
            //                int daay = [day intValue];
            //                NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
            //                NSLog(@"%@",finalDayValue);
            //
            //                [self deleteFile:finalDayValue];
            //            }
            
            
            UIApplication *app = [UIApplication sharedApplication];
            NSArray *eventArray = [app scheduledLocalNotifications];
            NSLog(@"user info is no is %lu",(unsigned long)eventArray.count);
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            for (int i=0; i<[eventArray count]; i++)
            {
                UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                NSLog(@"one event %@",oneEvent);
                NSDictionary *userInfoCurrent = oneEvent.userInfo;
                NSLog(@"user info is no is %@",userInfoCurrent);
                NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"new"]];
                NSLog(@"uid no is %@",uid);
                
                NSDateComponents * comps = [cal components:NSWeekdayCalendarUnit fromDate:oneEvent.fireDate];
                
                NSLog(@"%d",comps.weekday);
                
                if ([uid isEqualToString:type]&&[FinalsaveDay containsObject:[NSString stringWithFormat:@"%ld",(long)comps.weekday]])
                {
                    NSString*day = [FinalsaveDay objectAtIndex:[FinalsaveDay indexOfObject:[NSString stringWithFormat:@"%ld",(long)comps.weekday]]];
                    int daay = [day intValue];
                    NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
                    NSLog(@"%@",finalDayValue);
                    
                    [self deleteFile:finalDayValue];
                    
                    //Cancelling local notification
                    [app cancelLocalNotification:oneEvent];
                    
                }
            }
            
            
            
        }else{
            NSLog(@"no delete");
        }
        
        NSLog(@"%@",FinalsaveDay);
        
        for (int i = 0; i<[FinalsaveDay count]; i++) {
            NSString*day = [FinalsaveDay objectAtIndex:i];
            int daay = [day intValue];
            NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
            NSLog(@"final day %@-%@-%@",finalDayValue,hourStr,minStr);
            
            if ([[USER_DEFAULT objectForKey:@"breakfast"]isEqualToString:@"breakfast"])
                [self saveDate:finalDayValue hourS:hourStr minute:minStr];
            else if ([[USER_DEFAULT objectForKey:@"lunch"]isEqualToString:@"lunch"])
                [self saveDateLunch:finalDayValue hourL:hourStr minuteL:minStr];
            else if ([[USER_DEFAULT objectForKey:@"dinner"]isEqualToString:@"dinner"])
                [self saveDateDinner:finalDayValue hourD:hourStr minuteL:minStr];
            
            
        }
        
        if ([[USER_DEFAULT objectForKey:@"breakfast"]isEqualToString:@"breakfast"])
            [self setBreakfastNotification];
        else if ([[USER_DEFAULT objectForKey:@"lunch"]isEqualToString:@"lunch"])
            [self setLunchNotification];
        else if ([[USER_DEFAULT objectForKey:@"dinner"]isEqualToString:@"dinner"])
            [self setDinnerNotification];
        
    }
        
//    if ([[USER_DEFAULT objectForKey:@"breakfast"]isEqualToString:@"breakfast"]) {
//     
//        
//        }
//        
//    }else if ([[USER_DEFAULT objectForKey:@"lunch"]isEqualToString:@"lunch"]){
//        
//        if (FinalsaveDay.count == 0) {
//            [APPDELEGATE showAlertWithMessage:@"Please select the days first"];
//        }else{
//        [APPDELEGATE showAlertWithMessage:@"Alarm Saved"];
//            
//            if (FinalsaveDay.count>0) {
////            for (int i = 0; i<[dayID count]; i++) {
////                NSString*day = [dayID objectAtIndex:i];
////                int daay = [day intValue];
////                NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
////                [self deleteLunchFile:finalDayValue];
////            }
//            
//         
//            UIApplication *app = [UIApplication sharedApplication];
//            NSArray *eventArray = [app scheduledLocalNotifications];
//            NSLog(@"user info is no is %lu",(unsigned long)eventArray.count);
//            for (int i=0; i<[eventArray count]; i++)
//            {
//                UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//                NSLog(@"one event %@",oneEvent);
//                NSDictionary *userInfoCurrent = oneEvent.userInfo;
//                NSLog(@"user info is no is %@",userInfoCurrent);
//                NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"new"]];
//                NSLog(@"uid no is %@",uid);
//                if ([uid isEqualToString:@"LUNCH"])
//                {
//                    //Cancelling local notification
//                    [app cancelLocalNotification:oneEvent];
//                    
//                }
//            }
//
//            
//        }else{
//            NSLog(@"no delete");
//        }
//        
//        for (int i = 0; i<[FinalsaveDay count]; i++) {
//            NSString*day = [FinalsaveDay objectAtIndex:i];
//            int daay = [day intValue];
//            NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
//            NSLog(@"final day %@",finalDayValue);
//            
//            [self saveDateLunch:finalDayValue hourL:hourStr minuteL:minStr];
//            
//            
//        }
//        
//        
//        [self setLunchNotification];
//        }
//        
//        
//    }else if ([[USER_DEFAULT objectForKey:@"dinner"]isEqualToString:@"dinner"]){
//        
//        NSLog(@"save on dinner");
//        
//        if (FinalsaveDay.count == 0) {
//            [APPDELEGATE showAlertWithMessage:@"Please select the days first"];
//        }else{
//        [APPDELEGATE showAlertWithMessage:@"Alarm Saved"];
//            
//        if (dayID.count>0) {
//            for (int i = 0; i<[dayID count]; i++) {
//                NSString*day = [dayID objectAtIndex:i];
//                int daay = [day intValue];
//                NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
//                [self deleteDinnerFile:finalDayValue];
//            }
//         
//            UIApplication *app = [UIApplication sharedApplication];
//            NSArray *eventArray = [app scheduledLocalNotifications];
//            NSLog(@"user info is no is %lu",(unsigned long)eventArray.count);
//            for (int i=0; i<[eventArray count]; i++)
//            {
//                UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//                NSLog(@"one event %@",oneEvent);
//                NSDictionary *userInfoCurrent = oneEvent.userInfo;
//                NSLog(@"user info is no is %@",userInfoCurrent);
//                NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"new"]];
//                NSLog(@"uid no is %@",uid);
//                if ([uid isEqualToString:@"DINNER"])
//                {
//                    //Cancelling local notification
//                    [app cancelLocalNotification:oneEvent];
//                    
//                }
//            }
//
//         
//            
//        }else{
//            NSLog(@"no delete");
//        }
//        
//        for (int i = 0; i<[FinalsaveDay count]; i++) {
//            NSString*day = [FinalsaveDay objectAtIndex:i];
//            int daay = [day intValue];
//            NSString*finalDayValue  = [NSString stringWithFormat:@"%d",daay];
//            NSLog(@"final day %@",finalDayValue);
//            
//            [self saveDateDinner:finalDayValue hourD:hourStr minuteL:minStr];
//            
//            
//        }
//        
//        
//        [self setDinnerNotification];
//        
//        
//        }
//        
//    }
    

}
- (IBAction)turnOffAlarmTap:(id)sender {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"Silence Alarm?"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"CANCEL",nil];
    alert.tag = 1;
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            
            
            [_audioPlayer stop];
        }else{
            
            NSLog(@"ASHISH SHARMA");
        }
    }else if (alertView.tag == 2){
        
        if (buttonIndex == 0) {
            /*if (&UIApplicationOpenSettingsURLString != NULL) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }

            else {
                // Present some dialog telling the user to open the settings app.
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                                message:@"This feature is not availaible.Please update your OS."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil,nil];
               
                [alert2 show];
            }*/
        }else{
            
            NSLog(@"ASHISH SHARMA");

        }
        
        
    }
    
}


- (IBAction)setandsaveNotification:(id)sender {
    
    [animatedView setHidden:NO];
      [self ViewAnimate];
    
}

- (IBAction)closeTap:(id)sender {
    
    [animatedView setHidden:YES];
    
    if ([controllerCheck isEqualToString:@"checkCont"]) {
        
        AppDelegate*appDel;
        
        //appDel = [[UIApplication sharedApplication]delegate];
        appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSLog(@"app delegate array %@ , %@ , %@",appDel.appDel_addMinID , appDel.appDel_addDayID, appDel.appDel_addHrID);
        // removing the data from app delegate array to get new data
        
        [appDel.appDel_addMinID  removeAllObjects];
        [appDel.appDel_addDayID removeAllObjects];
          [appDel.appDel_addHrID removeAllObjects];
        
        homeViewController*HomeView = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self presentViewController:HomeView animated:YES completion:nil];
        [USER_DEFAULT removeObjectForKey:@"checkController"];
        
    }
    else
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
@end
