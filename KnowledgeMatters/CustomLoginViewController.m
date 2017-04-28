//
//  CustomLoginViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 08/04/2017.
//  Copyright © 2017 Daniel Ayala. All rights reserved.
//

#import "CustomLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlogsCollectionViewController.h"


@interface CustomLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation CustomLoginViewController

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    self.modalView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.modalView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.modalView.layer.shadowOpacity = 1;
//    self.modalView.layer.shadowRadius = 2.0;
//}



-(void) checkLoginFields{
    //    [usuarioTextField resignFirstResponder];
    //    [passTextField resignFirstResponder];
    NSString* usuario=self.userTextField.text;
    NSString* pass=self.passTextField.text;
    if ([usuario isEqualToString:@"admin"]
        && [pass isEqualToString:@"admin"]
        ) {
        NSLog(@"El usuario y la contraseña validan");
        
    } else {
        NSLog(@"El usuario o la contraseña no son válidos");
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
