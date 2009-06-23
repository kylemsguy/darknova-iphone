//
//  player.h
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "spacetrader.h"
#include "EncounterViewControllerRENAME.h"
#include "personellRosterViewController.h"
#import "AudioPlayer.h"
#import "BuyEquipmentViewController.h"
#import "SystemInfoViewController.h"


@interface player : NSObject {
	

	NSUInteger	pilotSkill;
	NSUInteger	fighterSkill;
	NSUInteger	traderSkill;
	NSUInteger	engineerSkill;
	NSString*	pilotName;
	NSUInteger	gameDifficulty;
	NSUInteger	totalSkillPoints;
	NSUInteger	credits;
	NSUInteger	debt;
	NSInteger	policeRecordScore;
	NSInteger	reputationScore;
	NSUInteger	policeKills;
	NSUInteger	traderKills;
	NSUInteger	pirateKills;
	NSUInteger  noClaim;
	NSUInteger  newsSpecialEventCount;
	NSUInteger	currentSystem;
	NSUInteger	days;	
	
	NSArray*	solarSystemName, *systemSize, *techLevel;
	bool		insurance;
	bool		escapePod;
	bool		moonBought;
	bool		remindLoans;
	bool		artifactOnBoard;
	bool		tribbleMessage;
	bool		possibleToGoThroughRip;
	bool		arrivedViaWormhole;
	int			trackedSystem;
	bool		showTrackedRange;
	bool		justLootedMarie;
	int			chanceOfVeryRareEncounter;
	bool		alreadyPaidForNewspaper;
//	bool		canSuperWarp;
	bool		gameLoaded;
	int			monsterHull;
	int			galacticChartSystem;
//	bool		attackFleeing;
	bool		newsAutoPay;
	
	
	int			NewsEvents[MAXSPECIALNEWSEVENTS];
		
	struct SOLARSYSTEM {
		Byte NameIndex;
		Byte TechLevel;			// Tech level
		Byte Politics;			// Political system
		Byte Status;			// Status
		Byte X;					// X-coordinate (galaxy width = 150)
		Byte Y;					// Y-coordinate (galaxy height = 100)
		Byte SpecialResources;	// Special resources
		Byte Size;				// System size
		int Qty[MAXTRADEITEM];	// Quantities of tradeitems. These change very slowly over time.
		Byte CountDown;			// Countdown for reset of tradeitems.
		Boolean Visited;		// Visited Yes or No
		int Special;			// Special event
	} /*currentSystemInfo,*/ solarSystem[MAXSOLARSYSTEM] ;
	
	
	struct SHIP {
		Byte Type;
		int  Cargo[MAXTRADEITEM];
		int  Weapon[MAXWEAPON];
		int  Shield[MAXSHIELD];
		long ShieldStrength[MAXSHIELD];
		int  Gadget[MAXGADGET];
		int  Crew[MAXCREW];
		Byte Fuel;
		long Hull;
		long Tribbles;
		long ForFutureUse[4];
	} ship, Opponent;
	
	// Systems
	long BuyPrice[MAXTRADEITEM];    // Price list current system
	long BuyingPrice[MAXTRADEITEM]; // Total price paid for trade goods
	long SellPrice[MAXTRADEITEM];   // Price list current system
	long ShipPrice[MAXSHIPTYPE];    // Price list current system (recalculate when buy ship screen is entered)
	Byte Wormhole[MAXWORMHOLE];
	//NSString* solarSystemName[MAXSOLARSYSTEM]
	Byte monsterStatus;       // 0 = Space monster isn't available, 1 = Space monster is in Acamar system, 2 = Space monster is destroyed
	Byte dragonflyStatus;     // 0 = Dragonfly not available, 1 = Go to Baratas, 2 = Go to Melina, 3 = Go to Regulas, 4 = Go to Zalkon, 5 = Dragonfly destroyed
	Byte japoriDiseaseStatus; // 0 = No disease, 1 = Go to Japori (always at least 10 medicine cannisters), 2 = Assignment finished or canceled
	Byte jarekStatus;         // Ambassador Jarek 0=not delivered; 1=on board; 2=delivered
	Byte invasionStatus;      // Status Alien invasion of Gemulon; 0=not given yet; 1-7=days from start; 8=too late
	Byte experimentStatus;    // Experiment; 0=not given yet,1-11 days from start; 12=performed, 13=cancelled
	Byte fabricRipProbability; // if Experiment = 8, this is the probability of being warped to a random planet.
	Byte veryRareEncounter;     // bit map for which Very Rare Encounter(s) have taken place (see traveler.c, around line 1850)
	Byte wildStatus;			// Jonathan Wild: 0=not delivered; 1=on board; 2=delivered
	Byte reactorStatus;			// Unstable Reactor Status: 0=not encountered; 1-20=days of mission (bays of fuel left = 10 - (ReactorStatus/2); 21=delivered
	Byte scarabStatus ;		// Scarab: 0=not given yet, 1=not destroyed, 2=destroyed, upgrade not performed, 3=destroyed, hull upgrade performed
	NSUInteger	warpSystem;
	int leaveEmpty;
	bool reserveMoney;
	bool litterWarning;
	bool alwaysInfo;
	NSUInteger countDown;
	int clicks;
	bool raided;
	bool inspected;
	int encounterType;
	bool alwaysIgnorePolice;
	bool alwaysIgnorePirates;
	bool alwaysIgnoreTraders;
	bool alwaysIgnoreTradeInOrbit;
	bool trackAutoOff;
	int ChanceOfTradeInOrbit;
	bool autoFuel;
	bool autoRepair;
	bool playerShipNeedsUpdate;
	bool opponentShipNeedsUpdate;
	bool autoAttack;
	bool autoFlee;
	bool attackIconStatus;
	bool textualEncounters;
	bool continuous;
	bool encounterWindow;
	int activeTradeItem;
	int Bribe;
	bool canSuperWarp;
//	bool musicEnabled;
	int currentGalaxySystem;
	bool firstEncounter;
//	bool lastMessage;
	
	bool audioPlayerReleased;
	
	EncounterViewControllerRENAME* encounterViewControllerInstance;
	AudioPlayer* audioPlayer;
	
	SystemSoundID sound[20];
};

//@property bool							musicEnabled;
@property bool							alwaysIgnorePolice;
@property bool							alwaysIgnorePirates;
@property bool							alwaysIgnoreTraders;
@property bool							alwaysIgnoreTradeInOrbit;
@property bool							autoFuel;
@property bool							autoRepair;
@property bool							reserveMoney;
@property int							leaveEmpty;
@property  NSUInteger					pilotSkill;
@property  NSUInteger					fighterSkill;
@property  NSUInteger					traderSkill;
@property  NSUInteger					engineerSkill;
@property  NSUInteger					gameDifficulty;
@property  NSUInteger					totalSkillPoints;
@property (nonatomic, retain) NSString*	pilotName;
@property NSUInteger					noClaim;
@property NSUInteger					credits;
@property NSUInteger					debt;
@property NSInteger						policeRecordScore;
@property NSInteger						reputationScore;
@property NSUInteger					policeKills;
@property NSUInteger					traderKills;
@property NSUInteger					pirateKills;
@property NSUInteger					currentSystem;
@property bool							insurance;
@property bool							escapePod;
@property NSUInteger					newsSpecialEventCount;
@property (nonatomic,copy) NSArray*		solarSystemName;
@property (nonatomic,copy) NSArray*		systemSize;
@property (nonatomic,copy) NSArray*		techLevel;
@property NSUInteger					days;
@property Byte							monsterStatus;       // 0 = Space monster isn't available, 1 = Space monster is in Acamar system, 2 = Space monster is destroyed
@property Byte							dragonflyStatus;     // 0 = Dragonfly not available, 1 = Go to Baratas, 2 = Go to Melina, 3 = Go to Regulas, 4 = Go to Zalkon, 5 = Dragonfly destroyed
@property Byte							japoriDiseaseStatus; // 0 = No disease, 1 = Go to Japori (always at least 10 medicine cannisters), 2 = Assignment finished or canceled
@property Byte							jarekStatus;         // Ambassador Jarek 0=not delivered; 1=on board; 2=delivered
@property Byte							invasionStatus;      // Status Alien invasion of Gemulon; 0=not given yet; 1-7=days from start; 8=too late
@property Byte							experimentStatus;    // Experiment; 0=not given yet,1-11 days from start; 12=performed, 13=cancelled
@property Byte							fabricRipProbability; // if Experiment = 8, this is the probability of being warped to a random planet.
@property Byte							veryRareEncounter;     // bit map for which Very Rare Encounter(s) have taken place (see traveler.c, around line 1850)
@property Byte							wildStatus;			// Jonathan Wild: 0=not delivered; 1=on board; 2=delivered
@property Byte							reactorStatus;			// Unstable Reactor Status: 0=not encountered; 1-20=days of mission (bays of fuel left = 10 - (ReactorStatus/2); 21=delivered
@property Byte							scarabStatus ;		// Scarab: 0=not given yet, 1=not destroyed, 2=destroyed, upgrade not performed, 3=destroyed, hull upgrade performed
@property  NSUInteger					warpSystem;
@property int							trackedSystem;
@property int							currentGalaxySystem;
@property bool							showTrackedRange;
@property bool							alwaysInfo;
@property NSUInteger					countDown;
@property bool							autoAttack;
@property bool							autoFlee;
@property bool							attackIconStatus;
@property int							encounterType;
@property bool							textualEncounters;
@property int							clicks;
@property bool							alreadyPaidForNewspaper;
@property bool							newsAutoPay;
@property bool							trackAutoOff;
@property bool							remindLoans;
@property bool							canSuperWarp;
//@property (nonatomic, retain) SOLARSYSTEM*	currentSystemInfo;

enum eSystemSound 
{
	eAlienEncounter,
	eAlienReturnArtifact,
	eBeginGame,
	eBottleEncounter,
	eBuyInsurance,
	eBuyNewShip,
	eBuyShipUpgardes,
	eCantSelectAnything,
	eFireMercenary,
	eFireOpponent,
	eGetGas,
	eGetLoan,
	eHirMercenary,
	ePoliceEncounter,
	eTribble,
	eWormholeJump,
	eYouAreDestroyed,
	eYouLose,
	eYouRetirelavishly,
	eYouRetirePoorly,
	eCommanderHit
};	



-(void)updateMercenary0Data;
-(id)initEmpty;
-(NSUInteger) currentWorth;
-(void) payInterest;
-(long) maxLoan;
-(void) getLoan:(long) Loan;
-(void) payBack:(long) Loan;
-(long) currentShipPriceWithoutCargo:(bool)forInsurance;
-(long) insuranceMoney;
-(bool) isNewsEvent:(int) eventFlag;
-(int) latestNewsEvent;
-(void) resetNewsEvents;
-(void) replaceNewsEvent:(int)originalEventFlag replacementEventFlag:(int)replacementEventFlag;
-(void) addNewsEvent:(int) eventFlag;
-(NSString*)getCurrentSystemName;
-(NSString*)getCurrentSystemSize;
-(NSString*)getCurrentSystemTechLevel;
-(NSString*)getCurrentSystemPolitics;
-(NSString*)getCurrentSystemPolice;
-(NSString*)getCurrentSystemSpecalResources;
-(NSString*)getCurrentSystemPirates;

-(NSString*)getWarpSystemName;
-(NSString*)getWarpSystemSize;
-(NSString*)getWarpSystemTechLevel;
-(NSString*)getWarpSystemPolitics;
-(NSString*)getWarpSystemPolice;
-(NSString*)getWarpSystemSpecalResources;
-(NSString*)getWarpSystemPirates;

-(NSString*)getSystemTechLevel:(int)index;

-(NSUInteger)adaptPilotSkill;
-(NSUInteger)adaptEngineerSkill;
-(NSUInteger)adaptFighterSkill;
-(NSUInteger)adaptTraderSkill;
-(NSString*)currentPoliceRecord;
-(NSString*)currentReputation;
-(bool) StartNewGame;
-(long)getSellPrice:(int)num;
-(long)getBuyPrice:(int)num;
-(long)getBuyingPrice:(int)num;
-(int) filledCargoBays;
-(int) totalCargoBays;
-(void) buyCargo:(int)Index  Amount:(int)Amount;
-(int)getAmountToBuy:(int)Index;
-(int)getOpponentAmountToSell:(int)Index;
-(int)getAmountToSell:(int)Index;
-(void) sellCargo:(int)Index  Amount:(int)Amount Operation:(Byte)Operation ;
-(Byte) getFuel;
-(void) BuyFuel:(int) Amount;
-(int) getSolarSystemX:(int)Index;
-(int) getSolarSystemY:(int)Index;
-(bool) getSolarSystemVisited:(int)Index;
-(NSString*)getSolarSystemName:(int)Index;
-(int)getCurrentSystemIndex;
-(Byte)getCurrentSystemTechLevelInt;
-(bool) wormholeExists:(int)a b:(int) b;
-(long) realDistance:(int)a  b:(int)b;
-(void) doWarp:(bool)viaSingularity;
-(Byte)getWormhole:(int)Index;
-(void) DeterminePrices:(Byte)SystemID;
-(long) CurrentShipPrice:(bool) ForInsurance;
-(void) buyRepairs:( int) Amount;
-(int) GetFirstEmptySlot:( char) Slots Item:( int*) Item;
-(long) GetHullStrength;
-(long) getShipHull;
-(Byte)getCurrentShipTechLevel;
-(Byte) GetFuelTanks;
-(int)getFuelCost;
-(int)getRepairCost;
-(long) toSpend;

-(NSString*)getShipName:(Byte)index;
-(NSString*)getShipSize:(Byte)index;
-(int)getShipCargoBays:(Byte)index;
-(int)getShipRange:(Byte)index;
-(int)getShipHullStrength:(Byte)index;
-(int)getShipWeaponSlots:(Byte)index;
-(int)getShipShieldSlots:(Byte)index;
-(int)getShipGadgetSlots:(Byte)index;
-(int)getShipCrewQuarters:(Byte)index;
-(NSString*)getShipPriceStr:(int)index;
-(int)getShipPriceInt:(int)index;
-(void) buyShip:(int) Index ;
-(void) DetermineShipPrices;
-(Byte)getCurrentShipType;


-(bool)canBuyShip:(int)index;
-(void)Travel;
-(bool)isShipCloaked;
-(int)getShipOpponentType;
-(bool)attack;
-(bool)flee;
-(bool)ignore;
-(bool)trade;
-(bool)yield;
-(bool)surrender;

-(bool)bribe; 
-(bool)submit; 
-(bool)plunder; 
-(bool)interrupt; 
-(bool)meet; 
-(bool)board; 
-(bool)drink;
-(bool)bribeContinue;
-(bool) submitContinue;
-(NSString*)getShipImageName:(Byte)index;
-(NSString*)getShipDamagedImageName:(Byte)index;
-(NSString*)getShipShieldImageName:(Byte)index;
-(NSString*)getShipImageNameBg:(Byte)index;

-(NSString*) drawQuestsForm:(SystemInfoViewController*)controller;
-(NSString*) drawSpecialCargoForm;
-(NSString*) drawCurrentShipForm;
-(NSString*) getEquipmentName:(int)index;
-(NSString*)getShipEquipmentName:(int)index; // Return equipment name installed on the ship
-(int)getEquipmentPrice:(int)index;
-(int)getSellEquipmentPrice:(int)index;
-(void)buyItem:(int)index controller:(BuyEquipmentViewController*)controller;
-(void)sellEquipment:(int)index;
-(void) updateRosterWindow:(personellRosterViewController*)controller;
-(void) updateRosterWindow:(personellRosterViewController*)controller;
-(void) fireMercenary:(int)index; 
-(void) hireMercenaryFromRoster;

-(NSString*)getSolarSystemSpecalResources:(int)index;
-(NSString*)getPriceDifference:(int)itemIndex difference:(bool)difference realPrice:(int*)realPrice maxCount:(int*)maxCount  isSmart:(int*)isSmart;
-(int) mercenaryMoney;
-(long) WormholeTax:(int)a b:(int) b;
-(int) nextSystemWithinRange:(int) Current Back:(Boolean) Back;
-(void)SaveGame:(NSString*)name;
-(void)LoadGame:(NSString*)name;
-(void)ShowSaveGames:(NSMutableArray*)array name:(NSMutableArray*)name additional:(NSMutableArray*)additional;

-(long)getShipOpponentHull;
-(long)getShipShield;
-(long)getShipOpponentShield;
-(long)getShipShieldMax;
-(long)getShipOpponentShieldMax;
-(long)getShipHullMax;
-(long)getShipOpponentHullMax;

-(bool)IsNewsExist;
-(bool)IsHireExist;
-(bool)IsSpecialExist;
-(void)payForNewsPaper:(int)sum;
-(void)FrmAlert:(NSString *)MessageId;

-(void)playMusic;
-(void)stopMusic;
-(void)disableMusic;
-(void)enableMusic;
-(void)playSound:(enum eSystemSound)soundType;
-(bool)isMusicEnabled;
-(void)disableSound;
-(void)enableSound;
-(bool)isSoundEnabled;

-(NSString*)drawNewspaperForm;
-(void)showSpecialEvent;
-(void) specialEventFormHandleEvent;
-(void)showRetiredForm;
-(void)clearHighScores;
-(void)fillHighScores:(NSMutableArray*)array;
-(bool) EndOfGame:( char) EndStatus;
-(void) initSounds;
-(void)eraseAutoSave;
-(void)restartMusic;
-(NSString*) drawQuestsForm;
-(void)initGlobals;
-(void) setInfoViewController:(SystemInfoViewController*)controller;
-(void)continuePlunder;
-(void)plunderItems:(int) index count:(int)count;
@end
