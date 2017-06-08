
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
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomLoginViewController.h"
#import <QuartzCore/QuartzCore.h>


@import MediaPlayer;
@import Firebase;

@interface LoginViewController ()

@property UISlider *slider;
@property UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (weak, nonatomic) IBOutlet UIView *referencedView;
-(IBAction)connectedActionsViewTouchedUp:(UIButton*) button;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UIImageView* blurImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabelPlaceholder;

@end


@implementation LoginViewController{
    
    NSURL* videoURL;
    AVQueuePlayer* queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }

    [self playAndLoopLoginVideo];
    [self initializeBlurImage];
    
    // Instantiate a referenced view (assuming outlet has hooked up in XIB).
    [[NSBundle mainBundle] loadNibNamed:@"CustomLoginView" owner:self options:nil];
    
    // Controller's outlet has been bound during nib loading, so we can access view trough the outlet.
    [self.view addSubview:self.referencedView];
    
    //Uitextfield Delegate and Attributes
    [self.userTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    
    _userTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    _userTextField.layer.borderWidth=1.0;
    _passwordTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    _passwordTextField.layer.borderWidth=1.0;
    
    // Create LoginButton Facebook
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    
    // Optional: Place the button in the center of your view.
    loginButton.center = CGPointMake(200,600);
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];

}


-(IBAction)connectedActionsViewTouchedUp:(UIButton*) button
{

    NSLog(@"Login Button OK");
    
    [self checksUserCredentials];
    
}


-(bool) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag==1) {
        //Caso del campo del usuario
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self checksUserCredentials];
    }
    return YES;
}


-(bool)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([self.userTextField.text isEqualToString:@""]) {

    }
    return YES;
}


-(bool)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButton:) name:UITextFieldTextDidChangeNotification object:nil];

    return YES;
}

-(void) updateButton:(NSNotification *)notification {

    NSLog(@"Watching TextFields Characters");
    
//    if ([self.userTextField.text isEqualToString:@""]) {
//        self.userLabelPlaceholder.hidden = YES;
//    }else{
//        if (![self.userTextField.text isEqualToString:@""]) {
//            self.userLabelPlaceholder.hidden = YES;
//
//        }
//    }

}


-(void) initializeBlurImage{
    
    //Add a backgroun picture
    
      self.blurImage = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height)];
      self.blurImage.image = [UIImage imageNamed:@"icoFormularioPrincipal@2x.png"];
    self.blurImage.backgroundColor = [UIColor blueColor];
      [self.view addSubview:self.blurImage];
    
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:
                        [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _visualEffectView.frame = self.blurImage.frame;
    _visualEffectView.alpha = 20;
    [self.view addSubview:_visualEffectView];
    
//    CGPoint userPositionX = self.visualEffectView.frame.origin;
//    CGPoint userPositionY = self.visualEffectView.frame.origin;
    //create path
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.blurImage.bounds];
//    UIBezierPath *otherPath = [[UIBezierPath bezierPathWithRect:CGRectMake(userPositionX.x, userPositionY.y, self.visualEffectView.frame.size.width, self.visualEffectView.frame.size.height)] bezierPathByReversingPath];
//    [maskPath appendPath:otherPath];
    
    //set mask
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
////    maskLayer.path = maskPath.CGPath;
//    [_visualEffectView.layer setMask:maskLayer];

    
}


-(void) checksUserCredentials{
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
    [self performSegueWithIdentifier:@"goHome" sender:self];

    
}




-(void) playAndLoopLoginVideo{

    NSString *resourceName = @"video.mov";
    NSString* movieFilePath = [[NSBundle mainBundle]
                               pathForResource:resourceName ofType:nil];
    videoURL = [NSURL fileURLWithPath:movieFilePath];
    
    AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
    queue = [[AVQueuePlayer alloc] initWithItems:@ [video]];
    video = [[AVPlayerItem alloc] initWithURL:videoURL];
    AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:queue];
    
    self.player = queue;
    self.showsPlaybackControls = FALSE;
    [self.player play];
    [queue insertItem:video afterItem:nil];
    
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {
                            AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
                            [queue insertItem:video afterItem:nil];
                        }];
    
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



@end
