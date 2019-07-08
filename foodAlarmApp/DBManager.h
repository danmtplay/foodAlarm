//
//  DBManager.h
//  AfewTap
//
//  Created by XLIM on 01/03/16.
//  Copyright © 2016 XLIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject{
    NSString *databasePath;
    sqlite3 *databaseReference;
    int count;
}


+(DBManager*)getSharedInstance;

-(BOOL)createDB;

//-(BOOL) saveData:(NSString*)registerNumber date:(NSString*)date time:(NSString*)time;

-(BOOL) saveData:(NSString*)time date:(NSString*)date registerNumber:(NSString*)registerNumber;
-(BOOL) saveLunchData:(NSString *)time date:(NSString *)date registerNumber:(NSString *)registerNumber;
-(BOOL) saveDinnerData:(NSString *)time date:(NSString *)date registerNumber:(NSString *)registerNumber;

-(NSMutableArray*) findByRegisterNumber;
- (NSMutableArray *) findByRegisterNumberForLunch;
- (NSMutableArray *) findByRegisterNumberForDinner;


- (void)closeanyOpenConnection;


- (BOOL)deleteFile:(NSString*)time;
- (BOOL)deleteLunchFile:(NSString*)time;
- (BOOL)deleteDinnerFile:(NSString*)time;


-(NSMutableArray*)getTimeByDate:(NSString*)date;


@end
