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

@interface HomeViewController (){
    
    NSArray *recipePhotos;
}


@end

@implementation HomeViewController

@synthesize nameLabel;
@synthesize emailLabel;
@synthesize imageBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize recipe image array
    recipePhotos = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
    
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
        NSLog(@"%@", email);


        
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
#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return recipePhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[recipePhotos objectAtIndex:indexPath.row]];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)EditingBlogProfileButton:(id)sender {
}
@end
