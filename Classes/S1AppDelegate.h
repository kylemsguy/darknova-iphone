//
//  S1AppDelegate.h
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "helloWindowViewController.h"
#import "BankViewController.h"
#import "Player.h"
#import <Foundation/NSRunLoop.h>
#import "AlertModalWindow.h"
#import "startGameViewController.h"
#import "startGameToolBar.h"
#import "AudioPlayer.h"
#import "commandViewController.h"
#import "GameViewController.h"
#import "SaveGameViewController.h"
#import "HelpViewController.h"
#import "ShipInfoViewControllerRENAME.h"
#import "BuyShipViewController.h"
#import "HelpViewController.h"

@class S1ViewController;
@class Player;
@class mainTabBar;
@class commandViewController;
@class MainToolBar;
@class GameViewController;


@interface S1AppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController	*navigationController;
	//IBOutlet mainTabBar * tabbarController;
//	IBOutlet helloWindowViewController* helloWindow;
	IBOutlet MainToolBar* mainToolbar;
	IBOutlet startGameToolBar * startToolbar;
	IBOutlet UIBarButtonItem	*gameOptionsButton;

	HelpViewController * helpWindow;
	IBOutlet commandViewController* commandView;
	IBOutlet GameViewController* gameView;
	IBOutlet BankViewController* mainBankViewController;
//	IBOutlet startGameViewController* startViewController;
	startGameViewController * newGame;
	SaveGameViewController * saveGame;

	Player * gamePlayer;
	bool isGameLoaded;
	BuyShipViewController * buyShipController;
	
	ShipInfoViewControllerRENAME * shipInfoController;	
//	AudioPlayer* audioPlayer;

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) commandViewController *commandView;
@property (nonatomic, retain) ShipInfoViewControllerRENAME *shipInfoController;
@property (nonatomic, retain) BuyShipViewController *buyShipController;
@property (nonatomic, retain) GameViewController* gameView;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) MainToolBar* mainToolbar;
@property (nonatomic, retain) Player* gamePlayer;
@property (nonatomic, retain) BankViewController* mainBankViewController;
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

