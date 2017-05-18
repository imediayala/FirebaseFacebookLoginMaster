//
//  SkillDataModel.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/04/2017.
//  Copyright © 2017 Daniel Ayala. All rights reserved.
//

#import "SkillDataModel.h"
#import "User.h"
#import "Constants.h"
@import Firebase;


@implementation SkillDataModel



-(NSString *) getUserName {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        return user.displayName;
    } else {
        return nil;
    }
}

-(void)initWithName:(NSString*)nameSkill andDescription: (NSString*)descriptionSkill andUserId:(NSString*)userId andUrl: (NSString*)url skillStartedDate:(NSString*) dateString{

    // Create new post at /user-posts/$userid/$postid and at
    // /posts/$postid simultaneously
    // [START write_fan_out]
    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
    NSDictionary *post = @{@"uid": userId,
                           @"skillname": nameSkill,
                           @"skilldescription": descriptionSkill,
                           @"photoUrl":url,
                           @"skillStartedAtDate":dateString};
    
    NSDictionary *childUpdates = @{[@"/skills/" stringByAppendingString:key]: post,
                                   [NSString stringWithFormat:@"/user-skills/%@/%@/", userId, key]: post};
    
    [_ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        
    }];

    
    
}


-(void)sendPost:(NSString *)skill andDescription:(NSString *)description urlFromPicker:(NSString*) url{
    
    // Reference for FiDataBase
    
    _ref = [[FIRDatabase database] reference];
    _postRef = [_ref child:@"posts"];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MMMM dd, yyyy HH:mm:ss";
    NSString* dateString = [formatter stringFromDate:date];
    
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
    
        [self initWithName:skill
            andDescription:description
                 andUserId:userID
                    andUrl:url
          skillStartedDate:dateString];
        
    }];
    
    
}

//- (void)sendCoverImage:(NSDictionary *)data {
//    
//    NSMutableDictionary *mdata = [data mutableCopy];
//    FIRUser *user = [FIRAuth auth].currentUser;
//    
//    NSString  *userName = user.displayName;
//    mdata[MessageFieldsname] = userName;
//    
//    // Push data to Firebase Database
//    [[[_ref child:@"SkillsCover"] childByAutoId] setValue:mdata];
//    
//    
//}

//- (NSMutableArray*) reloadMessages {
//    
//        //Create Array to store objects from firebase
//        NSMutableArray *skillsArray = [[NSMutableArray alloc] init];
//
//        // Listen for new messages in the Firebase database
//    self->skillsCoverHandle = [[_ref child:@"posts"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//        
//        [skillsArray insertObject:snapshot atIndex:0];
//
//        
//    }];
// 
//    return skillsArray;
//}



@end
