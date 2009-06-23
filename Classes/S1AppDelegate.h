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
#import "PlayerRENAME.h"
#import <Foundation/NSRunLoop.h>
#import "AlertModalWindow.h"
#import "startGameViewController.h"
#import "startGameToolBar.h"
#import "AudioPlayer.h"
#import "commandViewController.h"
#import "gameViewController.h"
#import "SaveGameViewController.h"
#import "helpViewController.h"
#import "shipInfoViewController.h"
#import "buyShipViewController.h"
#import "helpViewController.h"

@class S1ViewController;
@class PlayerRENAME;
@class mainTabBar;
@class commandViewController;
@class mainToolBar;
@class gameViewController;


@interface S1AppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController	*navigationController;
	//IBOutlet mainTabBar * tabbarController;
//	IBOutlet helloWindowViewController* helloWindow;
	IBOutlet mainToolBar* mainToolbar;
	IBOutlet startGameToolBar * startToolbar;
	IBOutlet UIBarButtonItem	*gameOptionsButton;

	helpViewController * helpWindow;
	IBOutlet commandViewController* commandView;
	IBOutlet gameViewController* gameView;
	IBOutlet bankViewController* mainBankViewController;
//	IBOutlet startGameViewController* startViewController;
	startGameViewController * newGame;
	SaveGameViewController * saveGame;

	PlayerRENAME * gamePlayer;
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
@property (nonatomic, retain) mainToolBar* mainToolbar;
@property (nonatomic, retain) PlayerRENAME* gamePlayer;
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

