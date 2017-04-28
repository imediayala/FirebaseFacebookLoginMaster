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

@interface ComposeSkillTableViewController : UITableViewController<FireBaseApiDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet UITextField *skillNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *skillDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseFilesProperty;

- (IBAction)sendButton:(id)sender;
- (IBAction)chooseFilesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *privayeSwitch;


@end
