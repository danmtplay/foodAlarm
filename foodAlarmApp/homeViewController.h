//
//  homeViewController.h
//  foodAlarmApp
//
//  Created by Dolphin Mobile on 07/05/16.
//  Copyright © 2016 Dolphin Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "scheduleAlaramViewController.h"

@interface homeViewController : UIViewController{
    
    NSUserDefaults*USER_DEFAULT;
    NSArray*data,*LunchData,*DinnerData;
    NSMutableArray*addDayID;
    NSMutableArray*addHrID;
    NSMutableArray*addMinID,*addLunchDayId,*addLunchHourID,*addLunchminID,*addDinnerDayID,*AddDinnerHourID,*addDinnerMinID;
    
    IBOutlet UILabel*neverSkipMealAgain;
    IBOutlet UILabel*theDinnerBellApp;
    
}

- (IBAction)breakFastTap:(id)sender;
- (IBAction)lunchTap:(id)sender;
- (IBAction)dinnerTap:(id)sender;
@end
