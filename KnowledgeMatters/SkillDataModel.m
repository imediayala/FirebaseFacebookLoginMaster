//
//  SkillDataModel.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/04/2017.
//  Copyright © 2017 Daniel Ayala. All rights reserved.
//

#import "SkillDataModel.h"
#import "User.h"

@implementation SkillDataModel


-(NSString *) getUserName {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        return user.displayName;
    } else {
        return nil;
    }
}

-(void)initWithName:(NSString*)nameSkill andDescription: (NSString*)descriptionSkill andUserId:(NSString*)userId{

    // Create new post at /user-posts/$userid/$postid and at
    // /posts/$postid simultaneously
    // [START write_fan_out]
    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
    NSDictionary *post = @{@"uid": userId,
                           @"skillname": nameSkill,
                           @"skilldescription": descriptionSkill};
    NSDictionary *childUpdates = @{[@"/skills/" stringByAppendingString:key]: post,
                                   [NSString stringWithFormat:@"/user-skills/%@/%@/", userId, key]: post};
    
    [_ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        
    }];

    
    
}


-(void)sendPost:(NSString *)skill andDescription:(NSString *)description{
    
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
                 andUserId:userID];
        
    }];
    
    
}


@end
