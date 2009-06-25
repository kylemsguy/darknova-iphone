//
//  S1AppDelegate.h
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWindowViewController.h"
#import "BankViewController.h"
#import "Player.h"
#import <Foundation/NSRunLoop.h>
#import "AlertModalWindow.h"
#import "StartGameViewController.h"
#import "StartGameToolBar.h"
#import "AudioPlayer.h"
#import "CommandViewController.h"
#import "GameViewController.h"
#import "SaveGameViewController.h"
#import "HelpViewController.h"
#import "ShipInfoViewController.h"
#import "BuyShipViewController.h"
#import "HelpViewController.h"

@class S1ViewController;
@class Player;
@class mainTabBar;
@class CommandViewController;
@class MainToolBar;
@class GameViewController;


@interface S1AppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController	*navigationController;
	//IBOutlet mainTabBar * tabbarController;
//	IBOutlet helloWindowViewController* helloWindow;
	IBOutlet MainToolBar* mainToolbar;
	IBOutlet StartGameToolBar * startToolbar;
	IBOutlet UIBarButtonItem	*gameOptionsButton;

	HelpViewController * helpWindow;
	IBOutlet CommandViewController* commandView;
	IBOutlet GameViewController* gameView;
	IBOutlet BankViewController* mainBankViewController;
//	IBOutlet startGameViewController* startViewController;
	StartGameViewController * newGame;
	SaveGameViewController * saveGame;

	Player * gamePlayer;
	bool isGameLoaded;
	BuyShipViewController * buyShipController;
	
	ShipInfoViewController * shipInfoController;	
//	AudioPlayer* audioPlayer;

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) CommandViewController *commandView;
@property (nonatomic, retain) ShipInfoViewController *shipInfoController;
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

