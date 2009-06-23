//
//  S1AppDelegate.h
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "helloWindowViewController.h"
#import "bankViewController.h"
#import "Player.h"
#import <Foundation/NSRunLoop.h>
#import "AlertModalWindow.h"
#import "startGameViewController.h"
#import "startGameToolBar.h"
#import "AudioPlayer.h"
#import "commandViewController.h"
#import "gameViewController.h"
#import "SaveGameViewController.h"
#import "HelpViewControllerRENAME.h"
#import "shipInfoViewController.h"
#import "buyShipViewController.h"
#import "HelpViewControllerRENAME.h"

@class S1ViewController;
@class Player;
@class mainTabBar;
@class commandViewController;
@class MainToolBar;
@class gameViewController;


@interface S1AppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController	*navigationController;
	//IBOutlet mainTabBar * tabbarController;
//	IBOutlet helloWindowViewController* helloWindow;
	IBOutlet MainToolBar* mainToolbar;
	IBOutlet startGameToolBar * startToolbar;
	IBOutlet UIBarButtonItem	*gameOptionsButton;

	HelpViewControllerRENAME * helpWindow;
	IBOutlet commandViewController* commandView;
	IBOutlet gameViewController* gameView;
	IBOutlet bankViewController* mainBankViewController;
//	IBOutlet startGameViewController* startViewController;
	startGameViewController * newGame;
	SaveGameViewController * saveGame;

	Player * gamePlayer;
	bool isGameLoaded;
	buyShipViewController * buyShipController;
	
	shipInfoViewController * shipInfoController;	
//	AudioPlayer* audioPlayer;

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) commandViewController *commandView;
@property (nonatomic, retain) shipInfoViewController *shipInfoController;
@property (nonatomic, retain) buyShipViewController *buyShipController;
@property (nonatomic, retain) gameViewController* gameView;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) MainToolBar* mainToolbar;
@property (nonatomic, retain) Player* gamePlayer;
@property (nonatomic, retain) bankViewController* mainBankViewController;
@property (nonatomic, retain) UIBarButtonItem* gameOptionsButton;
@property bool isGameLoaded;
-(void)switchBarToGame;

//- (IBAction)click:(id)sender;
//- (IBAction)newGame:(id)sender;
//-(IBAction)newGame2;
-(IBAction)commandCommand;
-(IBAction)fileCommand;
-(IBAction)gameCommand;
-(IBAction)helpCommand;
-(IBAction)shipYardCommand;
-(IBAction)sellCargoAction;
-(IBAction)systemInfoCommand;
-(IBAction)navigateAction;

-(IBAction) startNewGame;
-(IBAction) loadGame;
-(IBAction) help;

//-(void) doWarp;
-(void)showStartGame;
//-(void) click:
@end

