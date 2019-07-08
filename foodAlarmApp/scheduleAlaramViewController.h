//
//  scheduleAlaramViewController.h
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "homeViewController.h"

@interface scheduleAlaramViewController : UIViewController{
    
  
    NSString*Saveday,*selectedTime,*hourStr,*minStr,*alertStr;;

    NSMutableArray*FinalsaveDay;
    int hour;
    int min;
    IBOutlet UIImageView *background_image;
    IBOutlet UIImageView*sunImage;
    IBOutlet UIImageView*monImage;
    IBOutlet UIImageView*tueImage;
    IBOutlet UIImageView*wedImage;
    IBOutlet UIImageView*thuImage;
    IBOutlet UIImageView*friImage;
    IBOutlet UIImageView*satImage;
    IBOutlet UIView*animatedView;
    NSTimer*stopAlarmTimer;
    
    NSUserDefaults*USER_DEFAULT;
    NSMutableArray*dayID;
  //  NSArray*breakFastdayID;
    BOOL edit;
    
  IBOutlet  UIButton*turnOffAlarmBtn;
    
}

- (IBAction)turnOffAlarmTap:(id)sender;

- (IBAction)setandsaveNotification:(id)sender;
- (IBAction)closeTap:(id)sender;

@property (strong,nonatomic) NSArray*breakFastdayID;
@property (strong,nonatomic) NSArray*hrID;
@property (strong,nonatomic) NSArray*minID;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (strong, nonatomic) NSDate *selectedStartTime;
@property (strong,nonatomic) NSString*type;
@property (nonatomic, assign) NSString *time_order;


- (IBAction)setDayTapp:(UIButton*)sender;
- (IBAction)editTapp:(id)sender;
- (IBAction)saveTapp:(id)sender;



@end
