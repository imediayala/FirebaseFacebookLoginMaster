//
//  ComposeSkillTableViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/12/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import "ComposeSkillTableViewController.h"
#import "SkillDataModel.h"
#import "Constants.h"
@import Firebase;
@import Photos;



@interface ComposeSkillTableViewController ()

@property(strong,nonatomic) NSString* nameSkill;
@property(strong,nonatomic) NSString* descriptionSkill;
@property(nonatomic,strong) NSString *urlFromPicker;
@property BOOL isPrivate;
@property(strong,nonatomic) SkillDataModel * skillsApi;


@end

@implementation ComposeSkillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    _skillsApi = [[SkillDataModel alloc] init];
    [_skillsApi setDelegate:self];
    [self configureStorage];
    
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        NSString *name = user.displayName;
        NSString *email = user.email;
        NSURL *photoUrl = user.photoURL;
        
        //NSString *formatToString = [photoUrl absoluteString];
        NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
        self.imageBox.image = [UIImage imageWithData:imageData];
        //
    } else {
        
        // No user is signed in.
    }



     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://knowledge-150922.appspot.com/"];
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
    return 6;
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
    
    
 [self.skillsApi sendPost:_skillNameLabel.text andDescription:_skillDescriptionTextField.text urlFromPicker:self.urlFromPicker];
    
// [self.skillsApi sendCoverImage:@{MessageFieldsphotoUrl:
//                            self.urlFromPicker}];

    
    [ self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCoverImage:(NSDictionary *)data {

    NSMutableDictionary *mdata = [data mutableCopy];
    FIRUser *user = [FIRAuth auth].currentUser;

    NSString  *userName = user.displayName;
    mdata[MessageFieldsname] = userName;

    // Push data to Firebase Database
    [[[_ref child:@"SkillsCover"] childByAutoId] setValue:mdata];


}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.activitySpinner startAnimating];

    NSURL *referenceUrl = info[UIImagePickerControllerReferenceURL];
    PHFetchResult* assets = [PHAsset fetchAssetsWithALAssetURLs:@[referenceUrl] options:nil];
    PHAsset *asset = [assets firstObject];
    [asset requestContentEditingInputWithOptions:nil
                               completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                   NSURL *imageFile = contentEditingInput.fullSizeImageURL;
                                   NSString *filePath = [NSString stringWithFormat:@"%@/%lld/%@", [FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0), [referenceUrl lastPathComponent]];
                                   FIRStorageMetadata *metadata = [FIRStorageMetadata new];
                                   metadata.contentType = @"image/jpeg";
                                   [[_storageRef child:filePath]
                                    putFile:imageFile metadata:metadata
                                    completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                        if (error) {
                                            NSLog(@"Error uploading: %@", error);
                                            return;
                                        }
                                        
                                        [self.activitySpinner stopAnimating];
                                        self.urlFromPicker = metadata.downloadURL.absoluteString;
                                         [self sendCoverImage:@{MessageFieldsphotoUrl:
                                                                    metadata.downloadURL.absoluteString}];
                                        
                                    }
                                    ];
                               }];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

    
}

- (IBAction)chooseImageButton:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (IBAction)takePhotoButton:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
