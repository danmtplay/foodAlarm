//
//  DBManager.m
//  AfewTap
//
//  Created by XLIM on 01/03/16.
//  Copyright © 2016 XLIM. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
static DBManager *sharedInstance = nil;
//static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;



@implementation DBManager
//Our mission is to make a copy of that file to the application’s documents directory,
//write the standard definition of all the init methods:

-(NSString *) getDbFilePath {
    
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"Databases.db"];
    
}

+(DBManager*)getSharedInstance{
    
    if (!sharedInstance) {
        
        sharedInstance = [[super allocWithZone:NULL]init];
        
        [sharedInstance createDB];
        
    }
    
    return sharedInstance;
    
}


- (void)closeanyOpenConnection
{
    NSLog(@"1");
    if(sqlite3_open([[self getDbFilePath]UTF8String],&databaseReference)!= SQLITE_OK)
    {
        sqlite3_close(databaseReference);
    }
}

-(BOOL)createDB {
     sqlite3* databaseReference = NULL;
    NSLog(@"DB");
    databasePath = [self getDbFilePath];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &databaseReference) == SQLITE_OK)
        {
            
                       char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS BREAKFAST (TIME INTEGER PRIMARY KEY, DATE TEXT, REGNO TEXT);"
            
            "CREATE TABLE IF NOT EXISTS LUNCH (TIME INTEGER PRIMARY KEY, DATE TEXT, REGNO TEXT);"
            
        "CREATE TABLE IF NOT EXISTS DINNER (TIME INTEGER PRIMARY KEY, DATE TEXT, REGNO TEXT);";
            
            
            
            
            
            if (sqlite3_exec(databaseReference, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(databaseReference);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;

}


//- (BOOL) saveData:(NSString *)registerNumber date:(NSString *)date time:(NSString *)time;
-(BOOL) saveData:(NSString *)time date:(NSString *)date registerNumber:(NSString *)registerNumber

{

    NSLog(@"bDate %@",date);
    NSLog(@"bTime %@",time);
    NSLog(@"bReg no %@",registerNumber);
   
    if (date.length!=0)
        
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into BREAKFAST(TIME,DATE,REGNO) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_int(sqlstatement, 1, [time integerValue]);
            sqlite3_bind_text(sqlstatement, 2, [date UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [registerNumber UTF8String], -1,  SQLITE_TRANSIENT);
                       // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
           
        }
        else
        {
            return NO;
        }
    }
    return NO;


}

-(BOOL) saveLunchData:(NSString *)time date:(NSString *)date registerNumber:(NSString *)registerNumber

{
    
    NSLog(@"lDate %@",date);
    NSLog(@"lTime %@",time);
    NSLog(@"lReg %@",registerNumber);
    
    if (date.length!=0)
        
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into LUNCH(TIME,DATE,REGNO) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_int(sqlstatement, 1, [time integerValue]);
            sqlite3_bind_text(sqlstatement, 2, [date UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [registerNumber UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
            
        }
        else
        {
            return NO;
        }
    }
    return NO;
    
    
}


-(BOOL) saveDinnerData:(NSString *)time date:(NSString *)date registerNumber:(NSString *)registerNumber

{
    
    NSLog(@"dDate %@",date);
    NSLog(@"dTime %@",time);
    NSLog(@"dReg no %@",registerNumber);
    
    if (date.length!=0)
        
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into DINNER(TIME,DATE,REGNO) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_int(sqlstatement, 1, [time integerValue]);
            sqlite3_bind_text(sqlstatement, 2, [date UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [registerNumber UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
            
        }
        else
        {
            return NO;
        }
    }
    return NO;
    
    
}



- (NSMutableArray *) findByRegisterNumber
        {
            
            NSMutableArray *recordSet = [[NSMutableArray alloc]init];
            [self closeanyOpenConnection];
            
            // Query to fetch the emp name and images from the database
           // const char *selectQuery = "select name from DOWNLOAD";
            NSString *querySQL =[NSString stringWithFormat:@"Select time,date,regno from BREAKFAST"];

                                                 
            const char *selectQuery = [querySQL UTF8String];
            sqlite3_stmt *sqlstatement = nil;
            
            
            if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
                
                // declaring a dictionary so that response can be saved in KVC
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                while (sqlite3_step(sqlstatement) == SQLITE_ROW)
                {
                    int regChar = sqlite3_column_int(sqlstatement, 0);
                    NSString *regStr = [NSString stringWithFormat:@"%d",regChar];
                    [dict setValue:regStr forKey:@"regStr"];
                    
                    char* titleChar = (char*)sqlite3_column_text(sqlstatement, 1);
                    NSString *titleStr = [NSString stringWithUTF8String:titleChar];
                   [dict setValue:titleStr forKey:@"FileTitle"];
                   
                    char* fileChar = (char*)sqlite3_column_text(sqlstatement, 2);
                    NSString *fileStr = [NSString stringWithUTF8String:fileChar];
                    [dict setValue:fileStr forKey:@"FileName"];
                    
                                       //  saving the record set in a MutableArray
                    [recordSet addObject:dict];
                   // NSLog(@"value of result set %@",recordSet);
                    
                    // clearing the NSData variable since it will be initalized again and again
                 //   imageDataFromDatabase = nil;
                    
                    // clearing off the dictionary to make sure that it does not contain any garbage data
                    dict = nil;
                    
                    // re- initalizing the dictionary for next record
                    dict = [[NSMutableDictionary alloc]init];
                }
                
                // once all the fetching is one clearing off the dict variable for good.
                dict = nil;
                
            }
            
            
            return  recordSet;

            
            
        }


- (NSMutableArray *) findByRegisterNumberForDinner
{
    
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    // const char *selectQuery = "select name from DOWNLOAD";
    NSString *querySQL =[NSString stringWithFormat:@"Select time,date,regno from DINNER"];
    
    
    const char *selectQuery = [querySQL UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            int regChar = sqlite3_column_int(sqlstatement, 0);
            NSString *regStr = [NSString stringWithFormat:@"%d",regChar];
            [dict setValue:regStr forKey:@"regStr"];
            
            char* titleChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *titleStr = [NSString stringWithUTF8String:titleChar];
            [dict setValue:titleStr forKey:@"FileTitle"];
            
            char* fileChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *fileStr = [NSString stringWithUTF8String:fileChar];
            [dict setValue:fileStr forKey:@"FileName"];
            
            //  saving the record set in a MutableArray
            [recordSet addObject:dict];
            // NSLog(@"value of result set %@",recordSet);
            
            // clearing the NSData variable since it will be initalized again and again
            //   imageDataFromDatabase = nil;
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
    
    
}


- (NSMutableArray *) findByRegisterNumberForLunch
{
    
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    // const char *selectQuery = "select name from DOWNLOAD";
    NSString *querySQL =[NSString stringWithFormat:@"Select time,date,regno from LUNCH"];
    
    
    const char *selectQuery = [querySQL UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            int regChar = sqlite3_column_int(sqlstatement, 0);
            NSString *regStr = [NSString stringWithFormat:@"%d",regChar];
            [dict setValue:regStr forKey:@"regStr"];
            
            char* titleChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *titleStr = [NSString stringWithUTF8String:titleChar];
            [dict setValue:titleStr forKey:@"FileTitle"];
            
            char* fileChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *fileStr = [NSString stringWithUTF8String:fileChar];
            [dict setValue:fileStr forKey:@"FileName"];
            
            //  saving the record set in a MutableArray
            [recordSet addObject:dict];
            // NSLog(@"value of result set %@",recordSet);
            
            // clearing the NSData variable since it will be initalized again and again
            //   imageDataFromDatabase = nil;
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
    
    
}



- (BOOL)deleteFile:(NSString*)time
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from BREAKFAST where time = '%@'",time];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

- (BOOL)deleteDinnerFile:(NSString*)time
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from DINNEr where time = '%@'",time];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

- (BOOL)deleteLunchFile:(NSString*)time
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from LUNCH where time = '%@'",time];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


-(NSMutableArray*)getTimeByDate:(NSString *)date{

    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    NSString *fetchQuery = [NSString stringWithFormat:@"select time from BREAKFAST where date =='%@'",date];
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* fileChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *fileStr = [NSString stringWithUTF8String:fileChar];
            [dict setValue:fileStr forKey:@"FileName"];
            
            
            // fetching the image data from the DB
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            // clearing the NSData variable since it will be initalized again and again
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
}


@end
