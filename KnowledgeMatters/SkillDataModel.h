//
//  SkillDataModel.h
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 01/04/2017.
//  Copyright © 2017 Daniel Ayala. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@protocol FireBaseApiDelegate;


@interface SkillDataModel : NSObject{

FIRDatabaseHandle skillsCoverHandle;

}


//Strings for database 
@property (strong,nonatomic) NSString * nameSkill;
@property (strong,nonatomic) NSString *descriptionSkill;
@property BOOL privateBool;
@property (strong, nonatomic) NSURL *imagesStorage;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *storageRef;


@property (nonatomic, weak) id <FireBaseApiDelegate> delegate;

-(void)initWithName:(NSString*)nameSkill andDescription: (NSString*)descriptionSkill andUserId:(NSString*)userId andUrl: (NSString*)url skillStartedDate:(NSString*) dateString;
-(void)sendPost:(NSString *)skill andDescription:(NSString *)description urlFromPicker:(NSString*) url;
//- (void)sendCoverImage:(NSDictionary *)data ;

@end

@protocol FireBaseApiDelegate



@end
