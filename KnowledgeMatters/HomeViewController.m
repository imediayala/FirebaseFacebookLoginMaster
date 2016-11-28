//
//  HomeViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//
#import "NSString+MD5.h"
#import "FTWCache.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit.h>
@import Firebase;

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize nameLabel;
@synthesize emailLabel;
@synthesize imageBox;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
    [FBSDKAppEvents logEvent:@"HomeSucces"];
    
//    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];


    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        NSString *name = user.displayName;
        NSString *email = user.email;
      
        
        nameLabel.text = name;
        emailLabel.text = email;
        
        NSURL * imageFromFace = user.photoURL;

        [self loadImageFromURL:imageFromFace.absoluteString];
        
        NSLog(@"%@", name); 

        
        // The user's ID, unique to the Firebase
        // project. Do NOT use this value to
        // authenticate with your backend server, if
        // you have one. Use
        // getTokenWithCompletion:completion: instead.
    } else {
        // No user is signed in.

    }
}

- (void) loadImageFromURL:(NSString*)URL {
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    NSURL * imageFromFace = user.photoURL;
    NSURL *imageURL = [NSURL URLWithString:imageFromFace.absoluteString];
    NSString *key = [URL MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        imageBox.image = image;
    } else {
        imageBox.image = [UIImage imageNamed:@"hostess.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageBox.image = image;
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
