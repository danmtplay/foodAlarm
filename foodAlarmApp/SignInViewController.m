//
//  ViewController.m
//  a
//
//  Created by AlexSong on 2018/8/17.
//  Copyright © 2018 AlexSong. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [GIDSignIn sharedInstance].uiDelegate = self;
    //    [[GIDSignIn sharedInstance] signIn];
/*
    NSString *myAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"myAccount"];
    if (myAccount != nil) {
         homeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
         [self presentViewController:homeVC animated:YES  completion:nil];
    } else {
        
    }*/
}
/*
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // ...
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
                UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
                [self presentViewController:homeVC animated:YES  completion:nil];
            } else {
                NSLog(@"Please SignIn !!!!!!!!!!!!!!!!!!!!");
            }
         }];
    } else {
        NSLog(@"%@", error);
    }
}
*/
@end
