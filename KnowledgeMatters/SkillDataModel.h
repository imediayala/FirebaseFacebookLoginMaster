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


@interface SkillDataModel : NSObject



@property (strong,nonatomic) NSString * nameSkill;
@property (strong,nonatomic) NSString *descriptionSkill;
@property BOOL privateBool;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *postRef;

@property (nonatomic, weak) id <FireBaseApiDelegate> delegate;

-(void)initWithName:(NSString*)nameSkill andDescription: (NSString*)descriptionSkill ;
-(void)sendPost:(NSString *)skill andDescription:(NSString *)description;

@end

@protocol FireBaseApiDelegate



@end
