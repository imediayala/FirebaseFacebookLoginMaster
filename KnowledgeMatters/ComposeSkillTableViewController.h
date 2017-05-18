//
//  ComposeSkillTableViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/12/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillDataModel.h"

@import Firebase;

@interface ComposeSkillTableViewController : UITableViewController<FireBaseApiDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (weak, nonatomic) IBOutlet UITextField *skillNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *skillDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseFilesProperty;
@property (weak, nonatomic) IBOutlet UIImageView *imageBox;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (strong, nonatomic) FIRDatabaseReference *imagesRef;
@property (strong, nonatomic) FIRDataSnapshot *details;



- (IBAction)sendButton:(id)sender;
- (IBAction)chooseFilesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *privayeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;

- (IBAction)chooseImageButton:(id)sender;

@end
