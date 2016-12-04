//
//  ComposeSkillTableViewController.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/12/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface ComposeSkillTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *skillNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *skillDescriptionTextField;
- (IBAction)chooseFilesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseFilesProperty;
- (IBAction)sendButton:(id)sender;

@property (strong, nonatomic) FIRDatabaseReference *ref;


@end
