//
//  HomeViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface HomeViewController : UIViewController<UINavigationControllerDelegate, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageBox;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillCount;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
- (IBAction)EditingBlogProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editingButtonProperty;
 ///
@property (weak, nonatomic) IBOutlet UICollectionView *collectionTable;
@property(strong,nonatomic) NSMutableArray  *skillsDataArray;
@property (strong, nonatomic) FIRDatabaseReference *skillsRef;
@property(strong,nonnull) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDataSnapshot *details;


@end
