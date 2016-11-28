
//
//  LoginViewController.m
//  KnowledgeMatters
//
//  Created by Daniel Ayala on 20/11/2016.
//  Copyright © 2016 Daniel Ayala. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
@import Firebase;
@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [_userTextField becomeFirstResponder];
    _userTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        NSLog(@"Log in Ok Yes :)");

        
    }
    
    //1 default button fbsdk
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;

    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    

    
}

-(bool) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag==1) {
        //Caso del campo del usuario
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self compruebaFormulario];
    }
    return YES;

}


-(void) compruebaFormulario{
    //    [usuarioTextField resignFirstResponder];
    //    [passTextField resignFirstResponder];
    NSString* usuario=_userTextField.text;
    NSString* pass=_passwordTextField.text;
    if ([usuario isEqualToString:@"admin"]
        && [pass isEqualToString:@"admin"]
        ) {
        NSLog(@"El usuario y la contraseña validan");
        [self performSegueWithIdentifier:@"goHome" sender:self];

    } else {
        NSLog(@"El usuario o la contraseña no son válidos");
    }
    
}


- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginButton:didCompleteWithResult:error:) name: FBSDKAccessTokenDidChangeNotification object:nil];
        
        
        // ...
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      // ...
                                      NSLog(@"FireBaseLogged Initialize");
                                      
                                      FIRUser *userFace = [FIRAuth auth].currentUser;
                                      
                                      NSString* userFaceName;
                                      
                                      userFaceName = userFace.displayName;
                                      
                                      NSLog(@"%@", userFaceName);
                                      [self nextView];



                                  }];
        
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loginButtonClicked
//{
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login
//     logInWithReadPermissions: @[@"public_profile"]
//     fromViewController:self
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         if (error) {
//             NSLog(@"Process error");
//         } else if (result.isCancelled) {
//             NSLog(@"Cancelled");
//         } else {
//             NSLog(@"Logged in");
//         }
//     }];
//}

    
    
-(void) nextView{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        [self performSegueWithIdentifier:@"goHome" sender:self];
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

- (IBAction)loginButton:(id)sender {
    
    [self compruebaFormulario];
}
@end
