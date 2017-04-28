//
//  ComposeSkillTableViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/12/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import "ComposeSkillTableViewController.h"
#import "SkillDataModel.h"
@import Firebase;


@interface ComposeSkillTableViewController ()

@property(strong,nonatomic) NSString* nameSkill;
@property(strong,nonatomic) NSString* descriptionSkill;
@property BOOL isPrivate;
@property(strong,nonatomic) SkillDataModel * skillsApi;


@end

@implementation ComposeSkillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    _skillsApi = [[SkillDataModel alloc] init];
    [_skillsApi setDelegate:self];


     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initValues{
    
    
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseFilesButton:(id)sender {
}
- (IBAction)sendButton:(id)sender {
    
    
    [self.skillsApi sendPost:_skillNameLabel.text andDescription:_skillDescriptionTextField.text];
    


//       NSString *userID = [FIRAuth auth].currentUser.uid;
//    FIRUser *user = [FIRAuth auth].currentUser;
//    
//     [[[_ref child:@"skills"] child:user.uid]
//     setValue:@{@"username": user.displayName,
//                @"skillname":self.skillNameLabel.text,
//                @"skilldescription": self.skillDescriptionTextField.text}];
//    
//    
//
//    
    
    [ self dismissViewControllerAnimated:YES completion:nil];
}
@end
