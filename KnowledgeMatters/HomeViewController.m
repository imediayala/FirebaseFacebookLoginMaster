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
#import "HomeCollectionViewCell.h"
#import "Constants.h"
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
    
    [FBSDKAppEvents logEvent:@"HomeSucces"];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    self.skillsDataArray = [[NSMutableArray alloc] init];
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        NSString *name = user.displayName;
        NSString *email = user.email;
        nameLabel.text = name;
        emailLabel.text = email;
        NSLog(@"%@", name);
        NSLog(@"%@", email);
        NSLog(@"%@", user.photoURL);
        
        //Set Database Refs
        self.ref = [FIRDatabase database].reference;
        self.skillsRef = [[self.ref child:@"user-skills"] child:user.uid];


    } else {
        
        // No user is signed in.
    }
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
     

    }
    [self loadImageFromURL];
    [self getSkills];
    
    
    

}

-(void) initialize{
    
    NSString *skillCount = [NSString stringWithFormat: @"%ld", (long)self.skillsDataArray.count];
    self.skillCount.text = skillCount;

}

- (void)viewWillAppear:(BOOL)animated {
   
   }

-(void) getSkills{

    [self.activitySpinner startAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.skillsDataArray removeAllObjects];
        //    // [START child_event_listener]
        //    // Listen for new comments in the Firebase database
        [self.skillsRef
         observeEventType:FIRDataEventTypeChildAdded
         withBlock:^(FIRDataSnapshot *snapshot) {
             [self.skillsDataArray addObject:snapshot];
             [self.collectionTable reloadData];
             //         [self.collectionTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.self.skillsDataArray count] - 1 inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
             
         }];
        
        
    });

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.skillsRef removeAllObservers];
    
}



- (void) loadImageFromURL {
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    NSURL * imageFromFace = [user.providerData[0]photoURL];
    NSURL *imageURL = [NSURL URLWithString:imageFromFace.absoluteString];
    NSString *key = [imageFromFace.absoluteString MD5Hash];
    NSData *data =  [NSData dataWithContentsOfURL:imageFromFace];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        imageBox.image = image;
    } else {
        imageBox.image = [UIImage imageNamed:@"icoFormularioPrincipal@2x.png"];
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
    return self.skillsDataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    [self initialize];
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//    recipeImageView.image = [UIImage imageNamed:[recipePhotos objectAtIndex:indexPath.row]];
    
    FIRDataSnapshot *messageSnapshot = self.skillsDataArray[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[MessageFieldsname];
    NSString *text = message[MessageFieldsSkillName];
    NSString *coverImgUrl = message[MessageFieldsphotoUrl];
    cell.skillNameLabel.text = [NSString stringWithFormat:@"%@", text];

    //Get image and put on collectioCell
   NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", coverImgUrl]];
   NSString *key = [[NSString stringWithFormat:@"%@", coverImgUrl] MD5Hash];
  // NSData *data = [self imagesData];
   NSData *data =  [NSData dataWithContentsOfURL:imageURL];
   if (data) {
       UIImage *image = [UIImage imageWithData:data];
       cell.coverImageBox.image = image;
       [self.activitySpinner stopAnimating];

    } else {
        cell.coverImageBox.image = [UIImage imageNamed:@"icoFormularioPrincipal@2x.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
       dispatch_async(queue, ^{
           NSData *data = [NSData dataWithContentsOfURL:imageURL];
           [FTWCache setObject:data forKey:key];
          UIImage *image = [UIImage imageWithData:data];
               cell.coverImageBox.image = image;
            });    
    }
    
 
    return cell;
}

-(NSData*)imagesData {

    NSIndexPath *indexPath = nil;
    FIRDataSnapshot *messageSnapshot = self.skillsDataArray[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *coverImgUrl = message[MessageFieldsphotoUrl];
    
    //Get image and put on collectioCell
    
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", coverImgUrl]];
    NSString *key = [[NSString stringWithFormat:@"%@", coverImgUrl] MD5Hash];
    
    NSData *data =  [NSData dataWithContentsOfURL:imageURL];

        
   

    return data;

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
