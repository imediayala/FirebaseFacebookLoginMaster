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
#import "Constants.h"
#import "HomeMainCollectionViewCell.h"
#import "SkillLayOverViewController.h"
@import Firebase;


@interface HomeViewController (){
    
    NSArray *recipePhotos;
}
@property (strong, nonatomic) UIImageView *skillCoverImage;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property(strong, nonatomic) FIRStorage *storage;
@property(strong, nonatomic) NSString *skillUrlString;
@property(nonatomic) NSInteger imageCount;
@property (strong, nonatomic) IBOutlet UIView *skillPopView;


@end

@implementation HomeViewController
@synthesize nameLabel;
@synthesize emailLabel;
@synthesize imageBox;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.skillCoverImage = [[UIImageView alloc]init]; ;

    

    // Get a reference to the storage service, using the default Firebase App
    self.storage = [FIRStorage storage];
    // Create a storage reference from our storage service
    self.storageRef = [self.storage referenceForURL:@"gs://knowledge-150922.appspot.com"];
    
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
    
    imageBox.layer.cornerRadius = 6;
    imageBox.layer.masksToBounds = YES;

//    imageBox.layer.borderWidth = 2;
    

}
- (void)viewWillAppear:(BOOL)animated {
    
    [self counters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.skillsRef removeAllObservers];
    
}

-(void) initialize{
    
    UINib *cellNib = [UINib nibWithNibName:@"HomeMainCollectionViewCell" bundle:nil];
    [self.collectionTable registerNib:cellNib forCellWithReuseIdentifier:@"claimCellReuse"];
    self.collectionTable.allowsSelection = YES;
    self.collectionTable.allowsMultipleSelection = NO;
    
}

-(void) initTaps{

    // Creamos los reconocedores
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didTap:)];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didPan:)];
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(didSwipe:)];
    
    // Añadir los gesture recognizers a  la vista
    [self.skillPopView addGestureRecognizer:pan];
    
}

#pragma  mark - Taps Actions

-(void) didTap:(UITapGestureRecognizer *) tap{
    
    if (tap.state == UIGestureRecognizerStateRecognized) {
//        UIImageView *crack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crackedGlass.png"]];
//        crack.center = [tap locationInView:self.belenView];
//        [self.belenView addSubview:crack];
//        
//        // reproducir un sonido
//        [self playPunch];
    }
}

-(void) didPan:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateRecognized) {
        
        [self.skillPopView removeFromSuperview];
    }
    
}

#pragma mark INFO SCREEN COUNTERS METHODS

-(void) counters{
    
    NSString *skillCount = [NSString stringWithFormat: @"%ld", (long)self.skillsDataArray.count];
    self.skillCount.text = skillCount;
}

#pragma mark FIREBASE METHOD FOR LOADING DATA

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
-(void)getUrlImage:(NSString*) urlString{
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];
    NSURL *imageURLi = [NSURL URLWithString:urlString];
    NSString *key = [imageURL.absoluteString MD5Hash];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        [self.skillCoverImage setImage:image];
        
        self.imageCount = self.imageCount +1;
        
        
    } else {
        self.skillCoverImage.image = [UIImage imageNamed:@"icoFormularioPrincipal@2x.png"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURLi];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.skillCoverImage setImage:image];
            });
        });
    }
    
    
}




#pragma mark - COLLECTION VIEW DATA SOURCE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.skillsDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"claimCellReuse";
    [self initialize];
    
    HomeMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //Style cells
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [[UIColor blackColor]CGColor];

    //Get firebase snapshots from array
    FIRDataSnapshot *messageSnapshot = self.skillsDataArray[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *text = message[MessageFieldsSkillName];
    NSString *coverImgUrl = message[MessageFieldsphotoUrl];
    cell.cellSkillLabel.text = [NSString stringWithFormat:@"%@", text];

    if (self.skillsDataArray.count > self.imageCount) {
        
        [self getUrlImage:coverImgUrl];
    }
    
    cell.cellImageBox.image = self.skillCoverImage.image;

    return cell;
}


- (CGSize)collectionView :( UICollectionView *)collectionView
                  layout :( UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath :( NSIndexPath *)indexPath
{
    
    // Adjust cell size for orientation
    return CGSizeMake(320, 90);
}


-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"claimCellReuse" forIndexPath:indexPath];
    
    [[NSBundle mainBundle] loadNibNamed:@"SkillLayOverViewController" owner:self options:nil];
    
    self.skillPopView = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, collectionView.frame.origin.y+15, cell.frame.size.width, collectionView.frame.size.height-15)];
    
    self.skillPopView.backgroundColor = [UIColor lightGrayColor];
    self.skillPopView.layer.cornerRadius = 6;
    self.skillPopView.layer.masksToBounds = YES;
    [self.view addSubview:self.skillPopView];

    [self.skillPopView setAlpha:0];

    [self initTaps];
    
    //Animate alpha for overlay view
    [UIView animateWithDuration:0.5 animations:^{

        [self.skillPopView setAlpha:1];
        
    } completion:nil];


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
