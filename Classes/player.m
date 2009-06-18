//
//  player.m
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "player.h"
#include "spacetrader.h"
#include "S1AppDelegate.h"
#import "SystemInfoViewController.h"
#import "endOfGameViewController.h"


@implementation player
@synthesize pilotName, pilotSkill, fighterSkill, traderSkill, engineerSkill, gameDifficulty, totalSkillPoints,
credits, debt, reputationScore, policeKills, traderKills, pirateKills, policeRecordScore, insurance, noClaim, escapePod, newsSpecialEventCount, solarSystemName,
currentSystem, techLevel, systemSize, days, monsterStatus, dragonflyStatus,japoriDiseaseStatus, jarekStatus, invasionStatus, experimentStatus, fabricRipProbability,
veryRareEncounter, wildStatus, reactorStatus, scarabStatus, warpSystem, trackedSystem, showTrackedRange, alwaysInfo, countDown, autoAttack, autoFlee, attackIconStatus,
encounterType, textualEncounters, clicks, alreadyPaidForNewspaper, newsAutoPay, alwaysIgnorePolice, alwaysIgnorePirates, currentGalaxySystem;
@synthesize alwaysIgnoreTraders;
@synthesize	alwaysIgnoreTradeInOrbit;
@synthesize	autoFuel;
@synthesize	autoRepair, reserveMoney, trackAutoOff, remindLoans, leaveEmpty, canSuperWarp;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool bWaitFinishPlunder = false;

int *saveItem, savePrice, saveSlot, saveItemIndex;
bool viaSingularitySaved;
buyEquipmentViewController * buyController;
SystemInfoViewController * systemInfoController;

bool bLastMessage;
int plunderItem;
int plunderCount;

typedef enum  {
	eDummy,
	eSureToFleeOrBribeAlert,
	eTradeInOrbit,
	eSellInOrbit,
	eYieldChoice,
	eSurrenderArtifact,
	eSurrender,
	eBottleGood,
	eBottleStrange,
	eBoard,
	ePlunderForm,
	eBribePropsal,
	eBribeOffer,
	eSubmit,
	eEngageCaptainAhabAlert,
	eEngageCaptainConradAlert,
	eEngageCaptainHuieAlert,
	eBuyEquipment,
	eSpecialEvent,
	eWildWeaponBuy,
	ePlunderRemoveGoods,
	eUpdateSpecial,
	ePlunderShipForm
	
} eAlertState;

struct CommonGameOptions {
	int musicEnabled;
	int soundEnabled;
};

struct CommonGameOptions options;


eAlertState currentState;

typedef struct HighScoreType {
	char Name[NAMELEN+1];
	Byte Status; // 0 = killed, 1 = Retired, 2 = Bought moon
	int Days;
	long Worth;
	Byte Difficulty;
	Byte ForFutureUse;
} HIGHSCORE;

HIGHSCORE Hscores[MAXHIGHSCORE];



typedef struct {
	char* Name;
	Byte ReactionIllegal;   // Reaction level of illegal goods 0 = total acceptance (determines how police reacts if they find you carry them)
	Byte StrengthPolice;	// Strength level of police force 0 = no police (determines occurrence rate)
	Byte StrengthPirates;	// Strength level of pirates 0 = no pirates
	Byte StrengthTraders;	// Strength levcel of traders 0 = no traders
	Byte MinTechLevel;      // Mininum tech level needed
	Byte MaxTechLevel; 		// Maximum tech level where this is found
	Byte BribeLevel;		// Indicates how easily someone can be bribed 0 = unbribeable/high bribe costs
	Boolean DrugsOK;		// Drugs can be traded (if not, people aren't interested or the governemnt is too strict)
	Boolean FirearmsOK;		// Firearms can be traded (if not, people aren't interested or the governemnt is too strict)
	int Wanted;				// Tradeitem requested in particular in this type of government
} POLITICS;

const POLITICS Politics[MAXPOLITICS] =
{
{ "Anarchy",          0, 0, 7, 1, 0, 5, 7, true,  true,  FOOD },
{ "Capitalist State", 2, 3, 2, 7, 4, 7, 1, true,  true,  ORE },
{ "Communist State",  6, 6, 4, 4, 1, 5, 5, true,  true,  -1 },
{ "Confederacy",      5, 4, 3, 5, 1, 6, 3, true,  true,  GAMES },
{ "Corporate State",  2, 6, 2, 7, 4, 7, 2, true,  true,  ROBOTS },
{ "Cybernetic State", 0, 7, 7, 5, 6, 7, 0, false, false, ORE },
{ "Democracy",        4, 3, 2, 5, 3, 7, 2, true,  true,  GAMES },
{ "Dictatorship",     3, 4, 5, 3, 0, 7, 2, true,  true,  -1 },
{ "Fascist State",    7, 7, 7, 1, 4, 7, 0, false, true,  MACHINERY },
{ "Feudal State",     1, 1, 6, 2, 0, 3, 6, true,  true,  FIREARMS },
{ "Military State",   7, 7, 0, 6, 2, 7, 0, false, true,  ROBOTS },
{ "Monarchy",         3, 4, 3, 4, 0, 5, 4, true,  true,  MEDICINE },
{ "Pacifist State",   7, 2, 1, 5, 0, 3, 1, true,  false, -1 },
{ "Socialist State",  4, 2, 5, 3, 0, 5, 6, true,  true,  -1 },
{ "State of Satori",  0, 1, 1, 1, 0, 1, 0, false, false, -1 },
{ "Technocracy",      1, 6, 3, 6, 4, 7, 2, true,  true,  WATER },
{ "Theocracy",        5, 6, 1, 4, 0, 4, 0, true,  true,  NARCOTICS }
};

typedef struct {
	char* Name;
	int MinScore;
} POLICERECORD;


typedef struct {
	char* Name;
	int MinScore;
} REPUTATION;

const POLICERECORD PoliceRecord[MAXPOLICERECORD] =
{
{ "Psycho",   -100 },
{ "Villain",  PSYCHOPATHSCORE },
{ "Criminal", VILLAINSCORE },
{ "Crook",    CRIMINALSCORE },
{ "Dubious",  DUBIOUSSCORE },
{ "Clean",    CLEANSCORE },
{ "Lawful",   LAWFULSCORE },
{ "Trusted",  TRUSTEDSCORE },
{ "Liked",    HELPERSCORE },
{ "Hero",     HEROSCORE }
};


const REPUTATION Reputation[MAXREPUTATION] =
{
{ "Harmless",        HARMLESSREP },
{ "Mostly harmless", MOSTLYHARMLESSREP },
{ "Poor",            POORREP },
{ "Average",         AVERAGESCORE },
{ "Above average",   ABOVEAVERAGESCORE },
{ "Competent",       COMPETENTREP },
{ "Dangerous",       DANGEROUSREP },
{ "Deadly",          DEADLYREP },
{ "Elite",           ELITESCORE } 
};

typedef struct {
	char* Name;
	Byte TechProduction; 	// Tech level needed for production
	Byte TechUsage;			// Tech level needed to use
	Byte TechTopProduction;	// Tech level which produces this item the most
	int PriceLowTech;		// Medium price at lowest tech level			
	int PriceInc;			// Price increase per tech level
	int Variance;			// Max percentage above or below calculated price
	int DoublePriceStatus;	// Price increases considerably when this event occurs
	int CheapResource;		// When this resource is available, this trade item is cheap
	int ExpensiveResource;  // When this resource is available, this trade item is expensive
	int MinTradePrice;		// Minimum price to buy/sell in orbit
	int MaxTradePrice;		// Minimum price to buy/sell in orbit
	int RoundOff;			// Roundoff price for trade in orbit
} TRADEITEM;

const TRADEITEM Tradeitem[MAXTRADEITEM] =
{
{ "Water",     0, 0, 2,   30,   +3,   4, DROUGHT,       LOTSOFWATER,    DESERT,        30,   50,   1 },
{ "Furs", 	  0, 0, 0,  250,  +10,  10, COLD,          RICHFAUNA,      LIFELESS,     230,  280,   5 },
{ "Food", 	  1, 0, 1,  100,   +5,   5, CROPFAILURE,   RICHSOIL,       POORSOIL,      90,  160,   5 },
{ "Ore", 	  2, 2, 3,  350,  +20,  10, WAR,           MINERALRICH,    MINERALPOOR,  350,  420,  10 },
{ "Games",     3, 1, 6,  250,  -10,   5, BOREDOM,       ARTISTIC,       -1,           160,  270,   5 },
{ "Firearms",  3, 1, 5, 1250,  -75, 100, WAR,           WARLIKE,        -1,           600, 1100,  25 },
{ "Medicine",  4, 1, 6,  650,  -20,  10, PLAGUE,        LOTSOFHERBS,    -1,           400,  700,  25 },
{ "Machines",  4, 3, 5,  900,  -30,   5, LACKOFWORKERS, -1,             -1,           600,  800,  25 },
{ "Narcotics", 5, 0, 5, 3500, -125, 150, BOREDOM,       WEIRDMUSHROOMS, -1,          2000, 3000,  50 },
{ "Robots",    6, 4, 7, 5000, -150, 100, LACKOFWORKERS, -1,             -1,          3500, 5000, 100 }
};

typedef struct {
	char* Name;
	Byte CargoBays;		// Number of cargo bays
	Byte WeaponSlots;	// Number of lasers possible
	Byte ShieldSlots;	// Number of shields possible
	Byte GadgetSlots;	// Number of gadgets possible (e.g. docking computers)
	Byte CrewQuarters;	// Number of crewmembers possible
	Byte FuelTanks;		// Each tank contains enough fuel to travel 10 parsecs
	Byte MinTechLevel;	// Minimum tech level needed to build ship
	Byte CostOfFuel;	// Cost to fill one tank with fuel
	long Price;			// Base ship cost
	int Bounty;			// Base bounty
	int Occurrence;		// Percentage of the ships you meet
	long HullStrength;	// Hull strength
	int Police;			// Encountered as police with at least this strength
	int Pirates;		// idem Pirates
	int Traders;		// idem Traders
	Byte RepairCosts;	// Repair costs for 1 point of hull strength.
	Byte Size;			// Determines how easy it is to hit this ship
} SHIPTYPE;

/*
 WEAPONS
 
 { "Pulse Laser", PULSELASERPOWER, 2000, 5, 50 },
 
 { "Regolian Disrupters", BEAMLASERPOWER, 12500, 6, 35 },
 
 { "Justice Mk. V", MILITARYLASERPOWER, 35000, 7, 15 },
 
 // The weapons below cannot be bought
 
 { "BOAKYAG Laser", MORGANLASERPOWER, 50000, 8, 0 }
 
 SHIPS
 
 { "Nanomite", 10, 0, 0, 0, 1, MAXRANGE, 4, 1, 2000, 5, 2, 25, -1, -1, 0, 1, 0 },
 
 { "Minox", 15, 1, 0, 1, 1, 14, 5, 2, 10000, 50, 28, 100, 0, 0, 0, 1, 1 },
 
 { "Spathi Scout", 20, 1, 1, 1, 1, 17, 5, 3, 25000, 75, 20, 100, 0, 0, 0, 1, 1 },
 
 { "T-16 Womprat", 15, 2, 1, 1, 1, 13, 5, 5, 30000, 100, 20, 100, 0, 1, 0, 1, 1 },
 
 { "Vorchan", 25, 1, 2, 2, 2, 15, 5, 7, 60000, 125, 15, 100, 1, 1, 0, 1, 2 },
 
 { "Hirogen Freighter", 50, 0, 1, 1, 3, 14, 5, 10, 80000, 50, 3, 50, -1, -1, 0, 1, 2 },
 
 { "Vorlon Cruiser", 20, 3, 2, 1, 2, 16, 6, 15, 100000, 200, 6, 150, 2, 3, 1, 2, 3 },
 
 { "YT-1300", 30, 2, 2, 3, 3, 15, 6, 15, 150000, 300, 2, 150, 3, 4, 2, 3, 3 },
 
 { "T'khar Uberhauler", 60, 1, 3, 2, 3, 13, 7, 20, 225000, 300, 2, 200, 4, 5, 3, 4, 4 },
 
 { "Vix Dreadnought", 35, 3, 2, 2, 3, 14, 7, 20, 300000, 500, 2, 200, 5, 6, 4, 5, 4 },
 
 // The ships below can't be bought
 
 { "Leviathan", 0, 3, 0, 0, 1, 1, 8, 1, 500000, 0, 0, 500, 8, 8, 8, 1, 4 },
 
 { "Kor'ah Menace", 0, 2, 3, 2, 1, 1, 8, 1, 500000, 0, 0, 10, 8, 8, 8, 1, 1 },
 
 { "Mantis", 0, 3, 1, 3, 3, 1, 8, 1, 500000, 0, 0, 300, 8, 8, 8, 1, 2 },
 
 { "Scarab", 20, 2, 0, 0, 2, 1, 8, 1, 500000, 0, 0, 400, 8, 8, 8, 1, 3 },
 
 { "Bottle", 0, 0, 0, 0, 0, 1, 8, 1, 100, 0, 0, 10, 8, 8, 8, 1, 1 }
 */

const SHIPTYPE Shiptype[MAXSHIPTYPE+EXTRASHIPS] =
{
/*
 { "Flea",          10, 0, 0, 0, 1, MAXRANGE, 4,  1,   2000,   5,  2,  25, -1, -1,  0, 1, 0 },
 { "Gnat",          15, 1, 0, 1, 1, 14,       5,  2,  10000,  50, 28, 100,  0,  0,  0, 1, 1 },
 { "Firefly",       20, 1, 1, 1, 1, 17,       5,  3,  25000,  75, 20, 100,  0,  0,  0, 1, 1 },
 { "Mosquito",      15, 2, 1, 1, 1, 13,       5,  5,  30000, 100, 20, 100,  0,  1,  0, 1, 1 },
 { "Bumblebee",     25, 1, 2, 2, 2, 15,       5,  7,  60000, 125, 15, 100,  1,  1,  0, 1, 2 },
 { "Beetle",        50, 0, 1, 1, 3, 14,       5, 10,  80000,  50,  3,  50, -1, -1,  0, 1, 2 },
 { "Hornet",        20, 3, 2, 1, 2, 16, 	     6, 15, 100000, 200,  6, 150,  2,  3,  1, 2, 3 }, 
 { "Grasshopper",   30, 2, 2, 3, 3, 15,       6, 15, 150000, 300,  2, 150,  3,  4,  2, 3, 3 },
 { "Termite",       60, 1, 3, 2, 3, 13,       7, 20, 225000, 300,  2, 200,  4,  5,  3, 4, 4 },
 { "Wasp",          35, 3, 2, 2, 3, 14,       7, 20, 300000, 500,  2, 200,  5,  6,  4, 5, 4 },
 // The ships below can't be bought
 { "Space monster",  0, 3, 0, 0, 1,  1,       8,  1, 500000,   0,  0, 500,  8,  8,  8, 1, 4 },
 { "Dragonfly",      0, 2, 3, 2, 1,  1,       8,  1, 500000,   0,  0,  10,  8,  8,  8, 1, 1 },
 { "Mantis",         0, 3, 1, 3, 3,  1,       8,  1, 500000,   0,  0, 300,  8,  8,  8, 1, 2 },
 { "Scarab",        20, 2, 0, 0, 2,  1,       8,  1, 500000,   0,  0, 400,  8,  8,  8, 1, 3 },
 { "Bottle",         0, 0, 0, 0, 0,  1,       8,  1,    100,   0,  0,  10,  8,  8,  8, 1, 1 }
 */
{ "Nanomite", 10, 0, 0, 0, 1, MAXRANGE, 4, 1, 2000, 5, 2, 25, -1, -1, 0, 1, 0 },
{ "Minox", 15, 1, 0, 1, 1, 14, 5, 2, 10000, 50, 28, 100, 0, 0, 0, 1, 1 },
{ "Spathi Scout", 20, 1, 1, 1, 1, 17, 5, 3, 25000, 75, 20, 100, 0, 0, 0, 1, 1 },
{ "T-16 Womprat", 15, 2, 1, 1, 1, 13, 5, 5, 30000, 100, 20, 100, 0, 1, 0, 1, 1 },
{ "Vorchan", 25, 1, 2, 2, 2, 15, 5, 7, 60000, 125, 15, 100, 1, 1, 0, 1, 2 },
{ "Hirogen Freighter", 50, 0, 1, 1, 3, 14, 5, 10, 80000, 50, 3, 50, -1, -1, 0, 1, 2 },
{ "Vorlon Cruiser", 20, 3, 2, 1, 2, 16, 6, 15, 100000, 200, 6, 150, 2, 3, 1, 2, 3 },
{ "YT-1300", 30, 2, 2, 3, 3, 15, 6, 15, 150000, 300, 2, 150, 3, 4, 2, 3, 3 },
{ "T'khar Uberhauler", 60, 1, 3, 2, 3, 13, 7, 20, 225000, 300, 2, 200, 4, 5, 3, 4, 4 },
{ "Vix Dreadnought", 35, 3, 2, 2, 3, 14, 7, 20, 300000, 500, 2, 200, 5, 6, 4, 5, 4 },
// The ships below can't be bought
{ "Leviathan", 0, 3, 0, 0, 1, 1, 8, 1, 500000, 0, 0, 500, 8, 8, 8, 1, 4 },
{ "Kor'ah Menace", 0, 2, 3, 2, 1, 1, 8, 1, 500000, 0, 0, 10, 8, 8, 8, 1, 1 },
{ "Mantis", 0, 3, 1, 3, 3, 1, 8, 1, 500000, 0, 0, 300, 8, 8, 8, 1, 2 },
{ "Scarab", 20, 2, 0, 0, 2, 1, 8, 1, 500000, 0, 0, 400, 8, 8, 8, 1, 3 },
{ "Bottle", 0, 0, 0, 0, 0, 1, 8, 1, 100, 0, 0, 10, 8, 8, 8, 1, 1 }
};

const char * ShipImages[MAXSHIPTYPE+EXTRASHIPS] =
{
"1-Nanomite.png",
"2-Minox.png",
"3-SpathiScout.png",
"4-T16Womprat.png",
"5-Vorchan.png",
"6-HirogenFreighter.png",
"7-VorlonCruiser.png",
"8-YT1300.png",
"9-TkharUberhauler.png",
"10-VixDreadnaught.png",
"14-Leviathon.png",
"11-KorahMenace.png",
"12-Mantis.png",
"13-Scarab.png",
"15-Bottle.png"
};

const char * ShipImagesBg[MAXSHIPTYPE+EXTRASHIPS] =
{
"1-Nanomite-Bg.jpg",
"2-Minox-Bg.jpg",
"3-SpathiScout-Bg.jpg",
"4-T16Womprat-Bg.jpg",
"5-Vorchan-Bg.jpg",
"6-HirogenFreighter-Bg.jpg",
"7-VorlonCruiser-Bg.jpg",
"8-YT1300-Bg.jpg",
"9-TkharUberhauler-Bg.jpg",
"10-VixDreadnaught-Bg.jpg",
"14-Leviathon-Bg.jpg",
"11-KorahMenace-Bg.jpg",
"12-Mantis-Bg.jpg",
"13-Scarab-Bg.jpg",
"15-Bottle.jpg"
};
const char * ShipImagesDamaged[MAXSHIPTYPE+EXTRASHIPS] =
{
"1-NanomiteD.png",
"2-MinoxD.png",
"3-SpathiScoutD.png",
"4-T16WompratD.png",
"5-VorchanD.png",
"6-HirogenFreighterD.png",
"7-VorlonCruiserD.png",
"8-YT1300D.png",
"9-TkarUberhaulerD.png",
"10-VixDreadnaughtD.png",
"14-LeviathonD.png",
"11-KorahMenaceD.png",
"12-MantisD.png",
"13-ScarabD.png",
"15-Bottle.png"
};

const char * ShipImagesShield[MAXSHIPTYPE+EXTRASHIPS] =
{
"1-NanomiteS.png",
"2-MinoxS.png",
"3-SpathiScoutS.png",
"4-T16WompratS.png",
"5-VorchanS.png",
"6-HirogenFreighterS.png",
"7-VorlonCruiserS.png",
"8-YT1300S.png",
"9-TkarUberhaulerS.png",
"10-VixDreadnaughtS.png",
"14-LeviathonS.png",
"11-KorahMenaceS.png",
"12-MantisS.png",
"13-ScarabS.png",
"15-Bottle.png"
};


-(void) initGlobals {
	
	// Many of these names are from Star Trek: The Next Generation, or are small changes
	// to names of this series. A few have different origins.
	solarSystemName = [[NSArray arrayWithObjects:
						@"Acamar",
						@"Adahn",		// The alternate personality for The Nameless One in "Planescape: Torment"
						@"Aldea",
						@"Andevian",
						@"Antedi",
						@"Balosnee",
						@"Baratas",
						@"Brax",			// One of the heroes in Master of Magic
						@"Bretel",		// This is a Dutch device for keeping your pants up.
						@"Calondia",
						@"Campor",
						@"Capelle",		// The city I lived in while programming this game
						@"Carzon",
						@"Castor",		// A Greek demi-god
						@"Cestus",
						@"Cheron",		
						@"Courteney",	// After Courteney Cox...
						@"Daled",
						@"Damast",
						@"Davlos",
						@"Deneb",
						@"Deneva",
						@"Devidia",
						@"Draylon",
						@"Drema",
						@"Endor",
						@"Esmee",		// One of the witches in Pratchett's Discworld
						@"Exo",
						@"Ferris",		// Iron
						@"Festen",		// A great Scandinavian movie
						@"Fourmi",		// An ant, in French
						@"Frolix",		// A solar system in one of Philip K. Dick's novels
						@"Gemulon",
						@"Guinifer",		// One way of writing the name of king Arthur's wife
						@"Hades",		// The underworld
						@"Hamlet",		// From Shakespeare
						@"Helena",		// Of Troy
						@"Hulst",		// A Dutch plant
						@"Iodine",		// An element
						@"Iralius",
						@"Janus",		// A seldom encountered Dutch boy's name
						@"Japori",
						@"Jarada",
						@"Jason",		// A Greek hero
						@"Kaylon",
						@"Khefka",
						@"Kira",			// My dog's name
						@"Klaatu",		// From a classic SF movie
						@"Klaestron",
						@"Korma",		// An Indian sauce
						@"Kravat",		// Interesting spelling of the French word for "tie"
						@"Krios",
						@"Laertes",		// A king in a Greek tragedy
						@"Largo",
						@"Lave",			// The starting system in Elite
						@"Ligon",
						@"Lowry",		// The name of the "hero" in Terry Gilliam's "Brazil"
						@"Magrat",		// The second of the witches in Pratchett's Discworld
						@"Malcoria",
						@"Melina",
						@"Mentar",		// The Psilon home system in Master of Orion
						@"Merik",
						@"Mintaka",
						@"Montor",		// A city in Ultima III and Ultima VII part 2
						@"Mordan",
						@"Myrthe",		// The name of my daughter
						@"Nelvana",
						@"Nix",			// An interesting spelling of a word meaning "nothing" in Dutch
						@"Nyle",			// An interesting spelling of the great river
						@"Odet",
						@"Og",			// The last of the witches in Pratchett's Discworld
						@"Omega",		// The end of it all
						@"Omphalos",		// Greek for navel
						@"Orias",
						@"Othello",		// From Shakespeare
						@"Parade",		// This word means the same in Dutch and in English
						@"Penthara",
						@"Picard",		// The enigmatic captain from ST:TNG
						@"Pollux",		// Brother of Castor
						@"Quator",
						@"Rakhar",
						@"Ran",			// A film by Akira Kurosawa
						@"Regulas",
						@"Relva",
						@"Rhymus",
						@"Rochani",
						@"Rubicum",		// The river Ceasar crossed to get into Rome
						@"Rutia",
						@"Sarpeidon",
						@"Sefalla",
						@"Seltrice",
						@"Sigma",
						@"Sol",			// That's our own solar system
						@"Somari",
						@"Stakoron",
						@"Styris",
						@"Talani",
						@"Tamus",
						@"Tantalos",		// A king from a Greek tragedy
						@"Tanuga",
						@"Tarchannen",
						@"Terosa",
						@"Thera",		// A seldom encountered Dutch girl's name
						@"Titan",		// The largest moon of Jupiter
						@"Torin",		// A hero from Master of Magic
						@"Triacus",
						@"Turkana",
						@"Tyrus",
						@"Umberlee",		// A god from AD&D, which has a prominent role in Baldur's Gate
						@"Utopia",		// The ultimate goal
						@"Vadera",
						@"Vagra",
						@"Vandor",
						@"Ventax",
						@"Xenon",
						@"Xerxes",		// A Greek hero
						@"Yew",			// A city which is in almost all of the Ultima games
						@"Yojimbo",		// A film by Akira Kurosawa
						@"Zalkon",
						@"Zuul",			// From the first Ghostbusters movie
						nil] retain];
	
	systemSize =[[NSArray arrayWithObjects:	@"Tiny",  @"Small", @"Medium", @"Large", @"Huge", nil] retain];	
	
	techLevel = [[NSArray arrayWithObjects: @"Pre-agricultural", @"Agricultural", @"Medieval", @"Renaissance", @"Early Industrial",
				  @"Industrial", @"Post-industrial", @"Hi-tech", nil] retain];	
	
	
}

typedef struct {
	Byte NameIndex;
	Byte Pilot;
	Byte Fighter;
	Byte Trader;
	Byte Engineer;
	Byte CurSystem;
} CREWMEMBER;


/*
char* MercenaryName[MAXCREWMEMBER] =
{
"Jameson",
"Alyssa",
"Armatur",
"Bentos",
"C2U2",			
"Chi'Ti",
"Crystal",
"Dane",
"Deirdre",		
"Doc",
"Draco",
"Iranda",
"Jeremiah",
"Jujubal",
"Krydon",
"Luis",
"Mercedez",
"Milete",
"Muri-L",		
"Mystyc",
"Nandi",		
"Orestes",
"Pancho",
"PS37",			
"Quarck",		
"Sosumi",
"Uma",			
"Wesley",
"Wonton",
"Yorvick",
"Zeethibal" // anagram for Elizabeth
 };char* MercenaryName[MAXCREWMEMBER] =
 {
 "Mr. Cutforth",
 "Lothar",
 "4QU2",
 "Toro",
 "Yori",			
 "Lexus Mercedes",
 "Jameson Browne",
 "Wesley Willis",
 "Sarek",		
 "Flynn",
 "Woz",
 "Ronald Jeremy",
 "Roddenberry",
 "Doctor No",
 "Johnny Fingers",
 "Tek Jansen",
 "Femme Fatale",
 "Fett Man",
 "Bon Scott",		
 "Ham Solo",
 "Yavin Friday",		
 "Quark",
 "Penthar Mull",
 "Fonz",			
 "Trader Vic",		
 "Hop Sing",
 "Dinah Cancer",			
 "Obsidian",
 "Chk Chk Chk",
 "Fela Kuti",
 "Hope Sandoval" 
 };
 
 */

char* MercenaryName[MAXCREWMEMBER] =
{
"Mr. Cutforth",
"Lothar",
"4QU2",
"Toro",
"Yori",			
"Lexus Mercedes",
"Jameson Browne",
"Wesley Willis",
"Sarek",		
"Flynn",
"Woz",
"Ronald Jeremy",
"Roddenberry",
"Doctor No",
"Johnny Fingers",
"Tek Jansen",
"Femme Fatale",
"Fett Man",
"Bon Scott",		
"Ham Solo",
"Yavin Friday",		
"Quark",
"Penthar Mull",
"Fonz",			
"Trader Vic",		
"Hop Sing",
"Dinah Cancer",			
"Obsidian",
"Chk Chk Chk",
"Fela Kuti",
"Hope Sandoval" 
};


CREWMEMBER Mercenary[MAXCREWMEMBER + 1];


typedef struct {
	char* Title;
	char* QuestStringID;
//	int QuestStringID;
	long Price;
	Byte Occurrence;
	Boolean JustAMessage;
} SPECIALEVENT;

SPECIALEVENT SpecialEvent[MAXSPECIALEVENT] =
{
{ "Dragonfly Destroyed",	"QuestDragonflyDestroyedString",		0, 0, true },
{ "Weird Ship",				"QuestWeirdShipString",				0, 0, true },
{ "Lightning Ship",			"QuestLightningShipString",			0, 0, true },
{ "Strange Ship",			"QuestStrangeShipString",				0, 0, true },
{ "Monster Killed", 		"QuestMonsterKilledString", 	   -15000, 0, true },
{ "Medicine Delivery", 		"QuestMedicineDeliveredString",		0, 0, true },
{ "Retirement",     		"QuestRetirementString",				0, 0, false },
{ "Moon For Sale",  		"QuestMoonForSaleString", 	 COSTMOON, 4, false },
{ "Skill Increase", 		"QuestSkillIncreaseString",		 3000, 3, false },
{ "Merchant Prince",		"QuestMerchantPrinceString",		 1000, 1, false },
{ "Erase Record",   		"QuestEraseRecordString",			 5000, 3, false },
{ "Tribble Buyer",  		"QuestTribbleBuyerString", 			0, 3, false },
{ "Space Monster",  		"QuestSpaceMonsterString", 			0, 1, true },
{ "Dragonfly",      		"QuestDragonflyString", 				0, 1, true },
{ "Cargo For Sale", 		"QuestCargoForSaleString", 	 	 1000, 3, false },
{ "Lightning Shield", 		"QuestLightningShieldString",	 		0, 0, false },
{ "Japori Disease", 		"QuestJaporiDiseaseString", 			0, 1, false },
{ "Lottery Winner", 		"QuestLotteryWinnerString", 		-1000, 0, true },
{ "Artifact Delivery", 		"QuestArtifactDeliveryString",	-20000, 0, true },
{ "Alien Artifact", 		"QuestAlienArtifactString", 			0, 1, false },
{ "Ambassador Jarek", 		"QuestAmbassadorJarekString",		 	0, 1, false },
{ "Alien Invasion",			"QuestAlienInvasionString",		 	0, 0, true },
{ "Gemulon Invaded", 		"QuestGemulonInvadedString", 			0, 0, true },
{ "Fuel Compactor", 		"QuestFuelCompactorString", 			0, 0, false },
{ "Dangerous Experiment",   "QuestDangerousExperimentString",		0, 0, true },
{ "Jonathan Wild",  		"QuestJonathanWildString", 			0, 1, false },
{ "Morgan's Reactor",  		"QuestMorgansReactorString",	 		0, 0, false },
{ "Install Morgan's Laser", "QuestInstallMorgansLaserString",	 	0, 0, false },
{ "Scarab Stolen", 		"QuestScarabStolenString",		 	0, 1, true},
{ "Upgrade Hull", 			"QuestUpgradeHullString", 			0, 0, false},
{ "Scarab Destroyed", 	"QuestScarabDestroyedString",	 	0, 0, true},
{ "Reactor Delivered",  	"QuestReactorDeliveredString", 		0, 0, true },
{ "Jarek Gets Out",			"QuestJarekGetsOutString", 			0, 0, true },
{ "Gemulon Rescued", 		"QuestGemulonRescuedString",	 		0, 0, true },
{ "Disaster Averted",		"QuestDisasterAvertedString",			0, 0, true },
{ "Experiment Failed",		"QuestExperimentFailedString", 		0, 0, true },
{ "Wild Gets Out",			"QuestWildGetsOutString",				0, 0, true }

};


typedef struct {
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
} SHIP;

typedef struct  {
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
} SOLARSYSTEMSAVE;

typedef struct {
	char* Name;
	long  Price;
	Byte  TechLevel;
	Byte  Chance; // Chance that this is fitted in a slot
} GADGET;


typedef struct {
	char* Name;
	long  Power;
	long  Price;
	Byte  TechLevel;
	Byte  Chance; // Chance that this is fitted in a slot
} WEAPON;


typedef struct {
	char* Name;
	long  Power;
	long  Price;
	Byte  TechLevel;
	Byte  Chance; // Chance that this is fitted in a slot
} SHIELD;


const WEAPON Weapontype[MAXWEAPONTYPE+EXTRAWEAPONS] =
{
/*
 { "Pulse laser",	PULSELASERPOWER,     2000, 5, 50 },
 { "Beam laser",		BEAMLASERPOWER,     12500, 6, 35 },
 { "Military laser", MILITARYLASERPOWER, 35000, 7, 15 },
 // The weapons below cannot be bought
 { "Morgan's laser", MORGANLASERPOWER,   50000, 8, 0 }
 */
{ "Pulse Laser", PULSELASERPOWER, 2000, 5, 50 },
{ "Regolian Disrupters", BEAMLASERPOWER, 12500, 6, 35 },
{ "Justice Mk. V", MILITARYLASERPOWER, 35000, 7, 15 },
// The weapons below cannot be bought
{ "BOAKYAG Laser", MORGANLASERPOWER, 50000, 8, 0 }
};


const SHIELD Shieldtype[MAXSHIELDTYPE+EXTRASHIELDS] =
{
{ "Energy shield",      ESHIELDPOWER,  5000, 5, 70 },
{ "Reflective shield",  RSHIELDPOWER, 20000, 6, 30 },
// The shields below can't be bought
{ "Lightning shield",   LSHIELDPOWER, 45000, 8,  0 }
};


const GADGET Gadgettype[MAXGADGETTYPE+EXTRAGADGETS] =
{
{ "5 extra cargo bays", 	2500, 4, 35 }, // 5 extra holds
{ "Auto-repair system",     7500, 5, 20 }, // Increases engineer's effectivity
{ "Navigating system", 	   15000, 6, 20 }, // Increases pilot's effectivity
{ "Targeting system",	   25000, 6, 20 }, // Increases fighter's effectivity
{ "Cloaking device",      100000, 7, 5  }, // If you have a good engineer, nor pirates nor police will notice you
// The gadgets below can't be bought
{ "Fuel compactor",        30000, 8, 0  }
};

/*
 // Note that these initializations are overruled by the StartNewGame function
 SHIP Ship =
 { 
 1,                                     // Gnat
 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },      // No cargo 
 {  0, -1, -1 },                        // One pulse laser
 { -1, -1, -1 },{ 0,0,0 },              // No shields
 { -1, -1, -1 },                        // No gadgets
 {  0, -1, -1 },                        // Commander on board
 14,                                    // Full tank
 100,                                   // Full hull strength
 0,                                     // No tribbles on board
 { 0, 0, 0, 0 }                         // For future use
 };
 
 SHIP Opponent =
 { 
 1,                                     // Gnat
 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },      // No cargo 
 {  0, -1, -1 },                        // One pulse laser
 { -1, -1, -1 }, { 0, 0, 0 },           // No shields
 { -1, -1, -1 },                        // No gadgets
 {  1, -1, -1 },                        // Alyssa on board
 14,                                    // Full tank
 100,                                   // Full hull strength
 0,                                     // No tribbles on board
 { 0, 0, 0, 0 }                         // For future use
 };
 */

SHIP SpaceMonster =
{ 
MAXSHIPTYPE,                           // Space monster
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },      // No cargo 
{  2,  2,  2 },                        // Three military lasers
{ -1, -1, -1 }, { 0, 0, 0 },           // No shields
{ -1, -1, -1 },                        // No gadgets
{ MAXCREWMEMBER, -1, -1 },             // super stats
1,                                     // Full tank
500,                                   // Full hull strength
0,                                     // No tribbles on board
{ 0, 0, 0, 0 }                         // For future use
};

SHIP Scarab =
{ 
MAXSHIPTYPE+3,                         // Scarab
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },      // No cargo 
{  2,  2,  -1 },                       // Two military lasers
{ -1, -1, -1 }, { 0, 0, 0 },           // No shields
{ -1, -1, -1 },                        // No gadgets
{ MAXCREWMEMBER, -1, -1 },             // super stats
1,                                     // Full tank
400,                                   // Full hull strength
0,                                     // No tribbles on board
{ 0, 0, 0, 0 }                         // For future use
};

SHIP Dragonfly =
{ 
MAXSHIPTYPE+1,                         // Dragonfly
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },      // No cargo 
{  2,  0, -1 },                        // One military laser and one pulse laser
{  LIGHTNINGSHIELD,  LIGHTNINGSHIELD,  LIGHTNINGSHIELD }, // Three lightning shields
{  LSHIELDPOWER,    LSHIELDPOWER,    LSHIELDPOWER },     
{  AUTOREPAIRSYSTEM, TARGETINGSYSTEM, -1 }, // Gadgets
{  MAXCREWMEMBER, -1, -1 },             // super stats
1,                                      // Full tank
10,                                     // Full hull strength (though this isn't much)
0,                                      // No tribbles on board
{ 0, 0, 0, 0 }                          // For future use
};


const char* SpecialResources[MAXRESOURCES] =
{
"Nothing special",
"Mineral rich",
"Mineral poor",
"Desert",
"Sweetwater oceans",
"Rich soil",
"Poor soil",
"Rich fauna",
"Lifeless",
"Weird mushrooms",
"Special herbs",
"Artistic populace",
"Warlike populace"
};


const char* Status[MAXSTATUS] =
{
"under no particular pressure", 	  // Uneventful
"at war",						  // Ore and Weapons in demand
"ravaged by a plague",			  // Medicine in demand
"suffering from a drought",		  // Water in demand
"suffering from extreme boredom",  // Games and Narcotics in demand
"suffering from a cold spell",	  // Furs in demand
"suffering from a crop failure",	  // Food in demand
"lacking enough workers"			  // Machinery and Robots in demand
};


const char* Activity[MAXACTIVITY] =
{
"Absent",
"Minimal",
"Few",
"Some",
"Moderate",
"Many",
"Abundant",
"Swarms"
};

const char* SystemSize[MAXSIZE] =
{
"Tiny",
"Small",
"Medium",
"Large",
"Huge"
};


const char* TechLevel[MAXTECHLEVEL] =
{
"Pre-agricultural",
"Agricultural",
"Medieval",
"Renaissance",
"Early Industrial",
"Industrial",
"Post-industrial",
"Hi-tech"
};

// *************************************************************************
// Determine if there are any empty slots.
// *************************************************************************
-(bool) AnyEmptySlots:(struct SHIP *)Ship 
{
	int j;
	
	for (j=0; j<Shiptype[Ship->Type].WeaponSlots; ++j)
	{
		if (Ship->Weapon[j] < 0)
		{
			return true;
		}							
	}
	for (j=0; j<Shiptype[Ship->Type].ShieldSlots; ++j)
	{
		if (Ship->Shield[j] < 0)
		{
			return true;
		}							
	}
	for (j=0; j<Shiptype[Ship->Type].GadgetSlots; ++j)
	{
		if (Ship->Gadget[j] < 0)
		{
			return true;
		}							
	}
	
	return false;
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initEmpty {
	[super init];
	

	
	
	
	pilotName = @"Jameson";
	pilotSkill = 1;
	fighterSkill = 1;
	traderSkill = 1;
	engineerSkill = 1;
	gameDifficulty = 2; // 'Normal'
	totalSkillPoints = 16;
	
	credits = 1000;
	debt = 0;
	policeRecordScore = 0;
	reputationScore = 0;
	policeKills = 0;
	traderKills = 0;
	pirateKills = 0;
	insurance = FALSE;	
	noClaim = 0;
	
	currentSystem =1;
	
	days = 0;
	
	audioPlayerReleased = true;
	
	return self;
}

-(NSUInteger) currentWorth{
	NSUInteger i1 = credits - debt + [self CurrentShipPrice: false];
	NSUInteger i2 = moonBought ? COSTMOON : 0;
	return  i1 + i2;
}



-(void) payInterest{
	
	if (debt > 0) {
		unsigned int incDebt = max(1, debt /10);
		if (credits > incDebt)
			credits -= incDebt;
		else
			debt += (incDebt - credits);
	}
}


// *************************************************************************
// Maximum loan
// *************************************************************************
-(long) maxLoan
{
	return (policeRecordScore >= CLEANSCORE ? 
			min( 25000L, max( 1000L, (([self currentWorth] / 10L) / 500L) * 500L ) ) : 500L);
}

-(void) showDestroyedShipWindow
{
	endOfGameViewController * endGame = [[endOfGameViewController alloc] initWithNibName:@"endGame" bundle:nil];
	[endGame showShipDestroyedImage];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.window addSubview:[endGame view]];	

	
//	[endGame release];
//	[endGame release];
}

-(void) showUtopiaWindow
{
	endOfGameViewController * endGame = [[endOfGameViewController alloc] initWithNibName:@"endGame" bundle:nil];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.window addSubview:[endGame view]];	
	[endGame showHappyEndImage];	
//	[endGame release];	
}

-(void)showRetiredForm {
	endOfGameViewController * endGame = [[endOfGameViewController alloc] initWithNibName:@"endGame" bundle:nil];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.window addSubview:[endGame view]];	
	[endGame showPoorEndGameImage];	
//	[endGame release];
}

// *************************************************************************
// Lending money
// *************************************************************************
-(void) getLoan:(long) loan 
{
	long amount;
	
	
	amount = min( [self maxLoan] - debt, loan );
	credits += amount;
	debt += amount;
	[self playSound:eGetLoan];
}


// *************************************************************************
// Paying back
// *************************************************************************

-(void) payBack:(long) cash 
{
	long Amount;
	
	Amount = min( debt, cash );
	Amount = min( Amount, credits );
	credits -= Amount;
	debt -= Amount;
}

inline long BaseSellPrice(int Index, int Price)
{
	return (Index >= 0 ?(((float)Price * 3.0) /4.0) :0);
}

-(long) currentShipPriceWithoutCargo:(bool)forInsurance {
	int i;
	long CurPrice;
	
	CurPrice = 
	// Trade-in value is three-fourths the original price
	((Shiptype[ship.Type].Price * (ship.Tribbles > 0 && !forInsurance? 1 : 3)) / 4)
	// subtract repair costs
	- ([self GetHullStrength] - ship.Hull) * Shiptype[ship.Type].RepairCosts 
	// subtract costs to fill tank with fuel
	- (Shiptype[ship.Type].FuelTanks - [self getFuel]) * Shiptype[ship.Type].CostOfFuel;
	// Add 2/3 of the price of each item of equipment
	for (i=0; i<MAXWEAPON; ++i)
		if (ship.Weapon[i] >= 0)
			CurPrice += WEAPONSELLPRICE( i );
	for (i=0; i<MAXSHIELD; ++i)
		if (ship.Shield[i] >= 0)
			CurPrice += SHIELDSELLPRICE( i );
	for (i=0; i<MAXGADGET; ++i)
		if (ship.Gadget[i] >= 0)
			CurPrice += GADGETSELLPRICE( i );
	
	return CurPrice;
}

-(long) insuranceMoney {
	if (!insurance)
		return 0;
	return (max(1, (([self currentShipPriceWithoutCargo:true] * 5) / 2000) * (100 - min(noClaim, 90)) / 100));
}

// *************************************************************************
// What you owe the mercenaries daily
// *************************************************************************
-(int) mercenaryMoney
{
	int i, ToPay;
	
	ToPay = 0;
	for (i=1; i<MAXCREW; ++i)
		if (ship.Crew[i] >= 0)
			ToPay += MERCENARYHIREPRICE( ship.Crew[i] );
	
	return ToPay;	
}

// *************************************************************************
// Add a news event flag
// *************************************************************************
-(void) addNewsEvent:(int) eventFlag
{
	if (newsSpecialEventCount < MAXSPECIALNEWSEVENTS - 1)
		NewsEvents[newsSpecialEventCount++] = eventFlag;
}


// *************************************************************************
// replace a news event flag with another
// *************************************************************************
-(void) replaceNewsEvent:(int)originalEventFlag replacementEventFlag:(int)replacementEventFlag
{
	int i;
	
	if (originalEventFlag == -1)
	{
		[self addNewsEvent:replacementEventFlag];
	}
	else
	{
		for (i=0;i<newsSpecialEventCount; i++)
		{
			if (NewsEvents[i] == originalEventFlag)
				NewsEvents[i] = replacementEventFlag;
		}
	}
}

// *************************************************************************
// Reset news event flags
// *************************************************************************
-(void) resetNewsEvents
{
	newsSpecialEventCount = 0;
}

// *************************************************************************
// get most recently addded news event flag
// *************************************************************************
-(int) latestNewsEvent
{
	if (newsSpecialEventCount == 0)
		return -1;
	
	return NewsEvents[newsSpecialEventCount - 1];
}


// *************************************************************************
// Query news event flags
// *************************************************************************
-(bool) isNewsEvent:(int) eventFlag
{
	int i;
	
	for (i=0;i<newsSpecialEventCount; i++)
	{
		if (NewsEvents[i] == eventFlag)
			return true;
	}
	return false;
}

-(NSString*)getCurrentSystemName {
	/*
	 for (NSString *element in [self solarSystemName]) { 
	 NSLog(@"element: %@", element); 
	 } 
	 */
	
	return [[[self solarSystemName] objectAtIndex:CURSYSTEM.NameIndex] retain];
	
}

-(NSString*)getCurrentSystemSize {
//	return [[[self systemSize] objectAtIndex:CURSYSTEM.Size] retain];
	return [[self systemSize] objectAtIndex:CURSYSTEM.Size];
}

-(NSString*)getCurrentSystemTechLevel {
//	return [[[self techLevel] objectAtIndex:CURSYSTEM.TechLevel] retain];
	return [[self techLevel] objectAtIndex:CURSYSTEM.TechLevel];
}

-(NSString*)getSystemTechLevel:(int)index
{
	return [[self techLevel] objectAtIndex:solarSystem[index].TechLevel];	
//	return [[[self techLevel] objectAtIndex:solarSystem[index].TechLevel] retain];	
}

-(NSString*)getCurrentSystemPolitics {
	return [NSString stringWithCString:Politics[CURSYSTEM.Politics].Name];
//	return [[NSString stringWithCString:Politics[CURSYSTEM.Politics].Name] retain];
}

-(NSString*)getCurrentSystemPolice {
	return [NSString stringWithCString:Activity[Politics[CURSYSTEM.Politics].StrengthPolice]];
//	return [[NSString stringWithCString:Activity[Politics[CURSYSTEM.Politics].StrengthPolice]] retain];
	//		 Politics[currentSystemInfo.Police].Name] retain];
}

-(NSString*)getCurrentSystemPirates {
	return [NSString stringWithCString:Activity[Politics[CURSYSTEM.Politics].StrengthPirates]];
//	return [[NSString stringWithCString:Activity[Politics[CURSYSTEM.Politics].StrengthPirates]] retain];
	//		 Politics[currentSystemInfo.Police].Name] retain];
}

-(NSString*)getCurrentSystemSpecalResources {
	return [NSString stringWithCString:SpecialResources[CURSYSTEM.SpecialResources]];
//	return [[NSString stringWithCString:SpecialResources[CURSYSTEM.SpecialResources]] retain];
}



-(NSString*)getWarpSystemName {
	/*
	 for (NSString *element in [self solarSystemName]) { 
	 NSLog(@"element: %@", element); 
	 } 
	 */
	
	return [[self solarSystemName] objectAtIndex:solarSystem[warpSystem].NameIndex];
//	return [[[self solarSystemName] objectAtIndex:solarSystem[warpSystem].NameIndex] retain];
	
}

-(NSString*)getWarpSystemSize {
	return [[self systemSize] objectAtIndex:solarSystem[warpSystem].Size];
}

-(NSString*)getWarpSystemTechLevel {
	return [[self techLevel] objectAtIndex:solarSystem[warpSystem].TechLevel];
}

-(NSString*)getWarpSystemPolitics {
	return [NSString stringWithCString:Politics[solarSystem[warpSystem].Politics].Name];
//	return [[NSString stringWithCString:Politics[solarSystem[warpSystem].Politics].Name] retain];
}

-(NSString*)getWarpSystemPolice {
	return [NSString stringWithCString:Activity[Politics[solarSystem[warpSystem].Politics].StrengthPolice]];
//	return [[NSString stringWithCString:Activity[Politics[solarSystem[warpSystem].Politics].StrengthPolice]] retain];
	//		 Politics[currentSystemInfo.Police].Name] retain];
}

-(NSString*)getWarpSystemPirates {
	return [NSString stringWithCString:Activity[Politics[solarSystem[warpSystem].Politics].StrengthPirates]];
//	return [[NSString stringWithCString:Activity[Politics[solarSystem[warpSystem].Politics].StrengthPirates]] retain];
	//		 Politics[currentSystemInfo.Police].Name] retain];
}

-(NSString*)getWarpSystemSpecalResources {
	return [NSString stringWithCString:SpecialResources[solarSystem[warpSystem].SpecialResources]];
//	return [[NSString stringWithCString:SpecialResources[solarSystem[warpSystem].SpecialResources]] retain];
}






-(NSString*)getSolarSystemSpecalResources:(int)index {
	if (solarSystem[warpSystem].Visited)
		return [NSString stringWithCString:SpecialResources[solarSystem[index].SpecialResources]];
//		return [[NSString stringWithCString:SpecialResources[solarSystem[index].SpecialResources]] retain];
	else
		return @"Special resources unknown";
}

-(NSString*)currentPoliceRecord {
	NSUInteger i = 0;
	while (i < MAXPOLICERECORD && policeRecordScore >= PoliceRecord[i].MinScore)
		++i;
	--i;
	if (i < 0)
		i = 0;
	return [NSString stringWithCString:PoliceRecord[i].Name];	
//	return [[NSString stringWithCString:PoliceRecord[i].Name] retain];	
}

-(NSString*)currentReputation;
{
	NSUInteger i = 0;
	while (i < MAXREPUTATION && reputationScore >= Reputation[i].MinScore)
		++i;
	--i;
	if (i < 0)
		i = 0;
	
	return [NSString stringWithCString:Reputation[i].Name];	
//	return [[NSString stringWithCString:Reputation[i].Name] retain];	
	
}


// *************************************************************************
// Adapt a skill to the difficulty level
// *************************************************************************
-(char) AdaptDifficulty:( char) Level
{
	if (gameDifficulty == BEGINNER || gameDifficulty == EASY)
		return (Level+1);
	else if (gameDifficulty == IMPOSSIBLE)
		return max( 1, Level-1 );
	else
		return Level;
}
// *************************************************************************
// Trader skill
// *************************************************************************
-(char) TraderSkill:(struct SHIP*)Sh
{
	
	int i;
	char MaxSkill;
	
	MaxSkill = Mercenary[Sh->Crew[0]].Trader;
	
	for (i=1; i<MAXCREW; ++i)
	{
		if (Sh->Crew[i] < 0)
			break;
		if (Mercenary[Sh->Crew[i]].Trader > MaxSkill)
			MaxSkill = Mercenary[Sh->Crew[i]].Trader;
	}
	
	if (jarekStatus >= 2)
		++MaxSkill;			
	
	return [self AdaptDifficulty:MaxSkill];
	
	
	return traderSkill;
}

// *************************************************************************
// After changing the trader skill, buying prices must be recalculated.
// Revised to be callable on an arbitrary Solar System
// *************************************************************************
-(void) RecalculateBuyPrices:(Byte)SystemID
{
	int i;
	
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		if (solarSystem[SystemID].TechLevel < Tradeitem[i].TechProduction)
			BuyPrice[i] = 0;
		else if (((i == NARCOTICS) && (!Politics[solarSystem[SystemID].Politics].DrugsOK)) ||
				 ((i == FIREARMS) &&	(!Politics[solarSystem[SystemID].Politics].FirearmsOK)))
			BuyPrice[i] = 0;
		else
		{
			if (policeRecordScore < DUBIOUSSCORE)
				BuyPrice[i] = (SellPrice[i] * 100) / 90;
			else 
				BuyPrice[i] = SellPrice[i];
			// BuyPrice = SellPrice + 1 to 12% (depending on trader skill (minimum is 1, max 12))
			BuyPrice[i] = (BuyPrice[i] * (103 + (MAXSKILL - [self TraderSkill:&ship])) / 100);
			if (BuyPrice[i] <= SellPrice[i])
				BuyPrice[i] = SellPrice[i] + 1;
		}
	}
}
-(void)InitializeTradeItems:(int)Index {
	int i;
	
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		if (((i == NARCOTICS) &&
			 (!Politics[solarSystem[Index].Politics].DrugsOK)) ||
			((i == FIREARMS) &&
			 (!Politics[solarSystem[Index].Politics].FirearmsOK)) ||
			(solarSystem[Index].TechLevel < Tradeitem[i].TechProduction))
		{
			solarSystem[Index].Qty[i] = 0;
			continue;
		}
		
		solarSystem[Index].Qty[i] = 
		((9 + GetRandom( 5 )) - 
		 ABS( Tradeitem[i].TechTopProduction - solarSystem[Index].TechLevel )) * 
		(1 + solarSystem[i].Size);
		
		// Because of the enormous profits possible, there shouldn't be too many robots or narcotics available
		if (i == ROBOTS || i == NARCOTICS) 
			solarSystem[Index].Qty[i] = ((solarSystem[Index].Qty[i] * (5 - gameDifficulty)) / (6 - gameDifficulty)) + 1;
		
		if (Tradeitem[i].CheapResource >= 0)
			if (solarSystem[Index]. SpecialResources ==
				Tradeitem[i].CheapResource)
				solarSystem[Index].Qty[i] = (solarSystem[Index].Qty[i] * 4) / 3;
		
		if (Tradeitem[i].ExpensiveResource >= 0)
			if (solarSystem[Index].SpecialResources ==
				Tradeitem[i].ExpensiveResource)
				solarSystem[Index].Qty[i] = (solarSystem[Index].Qty[i] * 3) >> 2;
		
		if (Tradeitem[i].DoublePriceStatus >= 0)
			if (solarSystem[Index].Status == Tradeitem[i].DoublePriceStatus)
				solarSystem[Index].Qty[i] = solarSystem[Index].Qty[i] / 5;
		
		solarSystem[Index].Qty[i] = solarSystem[Index].Qty[i] - GetRandom( 10 ) +
		GetRandom( 10 );
		
		if (solarSystem[Index].Qty[i] < 0)
			solarSystem[Index].Qty[i] = 0;
	}
}

// *************************************************************************
// Standard price calculation
// *************************************************************************
-(long) StandardPrice:(char)Good size:(char)Size tech:(char)Tech goverment:(char)Government resources:(int)Resources
{
    long Price;
	
    if (((Good == NARCOTICS) && (!Politics[Government].DrugsOK)) ||
		((Good == FIREARMS) &&	(!Politics[Government].FirearmsOK)))
		return 0L ;
	
	// Determine base price on techlevel of system
	Price = Tradeitem[Good].PriceLowTech + (Tech * (int)Tradeitem[Good].PriceInc);
	
	// If a good is highly requested, increase the price
	if (Politics[Government].Wanted == Good)
		Price = (Price * 4) / 3;	
	
	// High trader activity decreases prices
	Price = (Price * (100 - (2 * Politics[Government].StrengthTraders))) / 100;
	
	// Large system = high production decreases prices
	Price = (Price * (100 - Size)) / 100;
	
	// Special resources price adaptation		
	if (Resources > 0)
	{
		if (Tradeitem[Good].CheapResource >= 0)
			if (Resources == Tradeitem[Good].CheapResource)
				Price = (Price * 3) / 4;
		if (Tradeitem[Good].ExpensiveResource >= 0)
			if (Resources == Tradeitem[Good].ExpensiveResource)
				Price = (Price * 4) / 3;
	}
	
	// If a system can't use something, its selling price is zero.
	if (Tech < Tradeitem[Good].TechUsage)
		return 0L;
	
	if (Price < 0)
		return 0L;
	
	return Price;
}

-(void) DeterminePrices:(Byte)SystemID 
{
	int i;
	
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		BuyPrice[i] = [self StandardPrice:i size:solarSystem[SystemID].Size tech:solarSystem[SystemID].TechLevel
								goverment:solarSystem[SystemID].Politics resources:solarSystem[SystemID].SpecialResources];
		
		if (BuyPrice[i] <= 0)
		{
			BuyPrice[i] = 0;
			SellPrice[i] = 0;
			continue;
		}
		
		// In case of a special status, adapt price accordingly
		if (Tradeitem[i].DoublePriceStatus >= 0)
			if (solarSystem[SystemID].Status == Tradeitem[i].DoublePriceStatus)
				BuyPrice[i] = (BuyPrice[i] * 3) >> 1;
		
		// Randomize price a bit
		BuyPrice[i] = BuyPrice[i] + GetRandom( Tradeitem[i].Variance ) -
		GetRandom( Tradeitem[i].Variance );
		
		// Should never happen
		if (BuyPrice[i] <= 0)
		{
			BuyPrice[i] = 0;
			SellPrice[i] = 0;
			continue;
		}
		
		SellPrice[i] = BuyPrice[i];
		if (policeRecordScore < DUBIOUSSCORE)
		{
			// Criminals have to pay off an intermediary
			SellPrice[i] = (SellPrice[i] * 90) / 100;
		}
	}
	
	[self RecalculateBuyPrices:SystemID];
}
/////////////////////////////////////////////////////////////////


















// *************************************************************************
// Square of the distance between two solar systems
// *************************************************************************
-(long) SqrDistance:(struct SOLARSYSTEM)a  b:(struct SOLARSYSTEM) b
{
	return (SQR( a.X - b.X ) + SQR( a.Y - b.Y ));
}


// *************************************************************************
// Distance between two solar systems
// *************************************************************************
-(long) RealDistance:(struct SOLARSYSTEM)a  b:(struct SOLARSYSTEM)b
{
	return (sqrt( [self SqrDistance:a  b:b] ));
}





// *************************************************************************
// Temporary implementation of square root
// *************************************************************************
/*
 inline int sqrt( int a )
 {
 int i;
 
 i = 0;
 while (SQR( i ) < a)
 ++i;
 if (i > 0)
 if ((SQR( i ) - a) > (a - SQR( i-1 )))
 --i;
 return( i );
 }
 */



// *************************************************************************
// Pieter's new random functions, tweaked a bit by SjG
// *************************************************************************

#define DEFSEEDX 521288629
#define DEFSEEDY 362436069

static UInt32 SeedX = DEFSEEDX;
static UInt32 SeedY = DEFSEEDY;



 UInt16 Rand()
{
	const UInt16 a = 18000;
	const UInt16 b = 30903;
	
	SeedX = a*(SeedX&MAX_WORD) + (SeedX>>16);
	SeedY = b*(SeedY&MAX_WORD) + (SeedY>>16);
	
	return ((SeedX<<16) + (SeedY&MAX_WORD));
}

int GetRandom2(int maxVal)
{
	return (int)(Rand() % maxVal);	
}


void RandSeed( UInt16 seed1, UInt16 seed2 )
{
	if (seed1)
		SeedX = seed1;   /* use default seeds if parameter is 0 */
	else
		SeedX = DEFSEEDX;
	
	if (seed2)
		SeedY = seed2;
	else
		SeedY = DEFSEEDY;
} 


//////////////////////////////////////////////////////////////////

// *************************************************************************
// Returns true if there exists a wormhole from a to b. 
// If b < 0, then return true if there exists a wormhole 
// at all from a.
// *************************************************************************
-(bool) wormholeExists:(int)a b:(int) b
{
	int i;
	
	i = 0;
	while (i<MAXWORMHOLE)
	{
		if (Wormhole[i] == a)
			break;
		++i;
	}
	
	if (i < MAXWORMHOLE)
	{
		if (b < 0)
			return true;
		else if (i < MAXWORMHOLE - 1)
		{
			if (Wormhole[i+1] == b)
				return true;
		}
		else if (Wormhole[0] == b)
			return true;
		
	}
	
	return false;
}

-(Byte)RandomSkill
{
	return 1 + GetRandom(5) + GetRandom(6);
	
}

// *************************************************************************
// Determines whether a certain gadget is on board
// *************************************************************************
-(bool) HasGadget:(struct SHIP*)Sh Gg:(Byte) Gg
//Boolean HasGadget( SHIP* Sh, char Gg )
{
    int i;
	
    for (i=0; i<MAXGADGET; ++i)
    {
	    if (Sh->Gadget[i] < 0)
	        continue;
        if (Sh->Gadget[i] == Gg)
	        return true;
    }
	
    return false;
}

// *************************************************************************
// Determines whether a certain shield type is on board
// *************************************************************************
-(bool) HasShield:( struct SHIP*) Sh Cg:(char) Gg 
{
    int i;
	
    for (i=0; i<MAXSHIELD; ++i)
    {
	    if (Sh->Shield[i] < 0)
	        continue;
        if (Sh->Shield[i] == Gg)
	        return true;
    }
	
    return false;
}

// *************************************************************************
// Determines whether a certain weapon type is on board. If exactCompare is
// false, then better weapons will also return TRUE
// *************************************************************************
-(bool) HasWeapon:( struct SHIP*)Sh  Cg:(char)Gg exactCompare:(bool)exactCompare
{
    int i;
	
    for (i=0; i<MAXWEAPON; ++i)
    {
	    if (Sh->Weapon[i] < 0)
	        continue;
        if ((Sh->Weapon[i] == Gg) || (Sh->Weapon[i] > Gg && !exactCompare))
	        return true;
    }
	
    return false;
}


// *************************************************************************
// Determine size of fueltanks
// *************************************************************************
-(Byte) GetFuelTanks
{
	return ([self HasGadget:&ship Gg:FUELCOMPACTOR ] ? 18 : Shiptype[ship.Type].FuelTanks);
}


// *************************************************************************
// Determine fuel in tank
// *************************************************************************
-(Byte) getFuel
{
	return min( ship.Fuel, [self GetFuelTanks]);
}


// *************************************************************************
// Buy Fuel for Amount credits
// *************************************************************************
-(void) BuyFuel:(int) Amount
{
	int MaxFuel;
	int Parsecs;
	
	MaxFuel = ([self GetFuelTanks] - [self getFuel]) * Shiptype[ship.Type].CostOfFuel;
	if (Amount > MaxFuel)
		Amount = MaxFuel;
	if (Amount > credits)
		Amount = credits;
	
	Parsecs = Amount / Shiptype[ship.Type].CostOfFuel;
	
	ship.Fuel += Parsecs;
	credits -= Parsecs * Shiptype[ship.Type].CostOfFuel;
	if (!autoFuel)
		[self playSound:eGetGas];
}

// *************************************************************************
// Start a new game
// *************************************************************************
-(bool) StartNewGame
{
	int i, j, k, d, x, y;
	bool Redo, CloseFound, FreeWormhole;
	
	// = false;
//	[self playMusic];

//	srandom(4);
	 
	// Initialize Galaxy
	i = 0;
	while (i < MAXSOLARSYSTEM)
	{
		if (i < MAXWORMHOLE)
		{
			// Place the first system somewhere in the centre
			solarSystem[i].X = (char)(((CLOSEDISTANCE>>1) - 
									   GetRandom( CLOSEDISTANCE )) + ((GALAXYWIDTH * (1 + 2*(i%3)))/6));		
			solarSystem[i].Y = (char)(((CLOSEDISTANCE>>1) - 
									   GetRandom( CLOSEDISTANCE )) + ((GALAXYHEIGHT * (i < 3 ? 1 : 3))/4));		
			Wormhole[i] = (char)i;
		}
		else
		{
			solarSystem[i].X = (char)(1 + GetRandom( GALAXYWIDTH - 2 ));		
			solarSystem[i].Y = (char)(1 + GetRandom( GALAXYHEIGHT - 2 ));		
		}
		
		CloseFound = false;
		Redo = false;
		if (i >= MAXWORMHOLE)
		{
			for (j=0; j<i; ++j)
			{
				//  Minimum distance between any two systems not to be accepted
				if ([self SqrDistance:solarSystem[j] b:solarSystem[i]]  <= SQR( MINDISTANCE + 1 ))
				{
					Redo = true;
					break;
				}
				
				// There should be at least one system which is closeby enough
				if ([self SqrDistance:solarSystem[j] b:solarSystem[i]] < SQR( CLOSEDISTANCE ))
					CloseFound = true;
			}
		}
		if (Redo)
			continue;
		if ((i >= MAXWORMHOLE) && !CloseFound)
			continue;
		
		solarSystem[i].TechLevel = (char)(GetRandom( MAXTECHLEVEL ));
		solarSystem[i].Politics = (char)(GetRandom( MAXPOLITICS ));
		if (Politics[solarSystem[i].Politics].MinTechLevel > solarSystem[i].TechLevel)
			continue;
		if (Politics[solarSystem[i].Politics].MaxTechLevel < solarSystem[i].TechLevel)
			continue;
		
		if (GetRandom( 5 ) >= 3)
			solarSystem[i].SpecialResources = (char)(1 + GetRandom( MAXRESOURCES - 1 ));
		else
			solarSystem[i].SpecialResources = 0;
		
		solarSystem[i].Size = (char)(GetRandom( MAXSIZE ));
		
		if (GetRandom( 100 ) < 15)
			solarSystem[i].Status = 1 + GetRandom( MAXSTATUS - 1 );
		else			
			solarSystem[i].Status = UNEVENTFUL;
		
		solarSystem[i].NameIndex = i;
		solarSystem[i].Special = -1;		
		solarSystem[i].CountDown = 0;
		solarSystem[i].Visited = false;
		
		[self InitializeTradeItems: i];
		
		++i;
	}
	
	// Randomize the system locations a bit more, otherwise the systems with the first
	// names in the alphabet are all in the centre
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		d = 0;
		while (d < MAXWORMHOLE)
		{
			if (Wormhole[d] == i)
				break;
			++d;
		}
		j = GetRandom( MAXSOLARSYSTEM );
		if ([self wormholeExists:j b:-1])
			continue;
		x = solarSystem[i].X;
		y = solarSystem[i].Y;		
		solarSystem[i].X = solarSystem[j].X;
		solarSystem[i].Y = solarSystem[j].Y;		
		solarSystem[j].X = x;
		solarSystem[j].Y = y;		
		if (d < MAXWORMHOLE)
			Wormhole[d] = j;
	}
	
	// Randomize wormhole order
	for (i=0; i<MAXWORMHOLE; ++i)
	{
		j = GetRandom( MAXWORMHOLE );
		x = Wormhole[i];
		Wormhole[i] = Wormhole[j];
		Wormhole[j] = x;
	}
	
	// Initialize mercenary list
	Mercenary[0].NameIndex = 0;
	Mercenary[0].Pilot = 1;
	Mercenary[0].Fighter = 1;
	Mercenary[0].Trader = 1;
	Mercenary[0].Engineer = 1;
	
	i = 1;
	while (i <= MAXCREWMEMBER)
	{
		Mercenary[i].CurSystem = GetRandom( MAXSOLARSYSTEM );
		
		Redo = false;
		for (j=1; j<i; ++j)
		{
			// Not more than one mercenary per system
			if (Mercenary[j].CurSystem == Mercenary[i].CurSystem)
			{
				Redo = true;
				break;
			}
		}
		// can't have another mercenary on Kravat, since Zeethibal could be there
		if (Mercenary[i].CurSystem == KRAVATSYSTEM)
			Redo = true;
		if (Redo)
			continue;
		
		Mercenary[i].NameIndex = i;		
		Mercenary[i].Pilot = [self RandomSkill];
		Mercenary[i].Fighter = [self RandomSkill];
		Mercenary[i].Trader = [self RandomSkill];
		Mercenary[i].Engineer = [self RandomSkill];
		
		++i;
	}
    
    // special individuals: Zeethibal, Jonathan Wild's Nephew
    Mercenary[MAXCREWMEMBER-1].CurSystem = 255;
	
	// Place special events
	solarSystem[ACAMARSYSTEM].Special  = MONSTERKILLED;
	solarSystem[BARATASSYSTEM].Special = FLYBARATAS;
	solarSystem[MELINASYSTEM].Special  = FLYMELINA;
	solarSystem[REGULASSYSTEM].Special = FLYREGULAS;
	solarSystem[ZALKONSYSTEM].Special  = DRAGONFLYDESTROYED;
	solarSystem[JAPORISYSTEM].Special  = MEDICINEDELIVERY;
	solarSystem[UTOPIASYSTEM].Special  = MOONBOUGHT;
	solarSystem[DEVIDIASYSTEM].Special = JAREKGETSOUT;
	solarSystem[KRAVATSYSTEM].Special  = WILDGETSOUT;
	
	// Assign a wormhole location endpoint for the Scarab.
	// It's possible that ALL wormhole destinations are already
	// taken. In that case, we don't offer the Scarab quest.
	FreeWormhole = false;
	k = 0;
	j = GetRandom( MAXWORMHOLE );
	while (solarSystem[Wormhole[j]].Special != -1 &&
		   Wormhole[j] != GEMULONSYSTEM && Wormhole[j] != DALEDSYSTEM && Wormhole[j] != NIXSYSTEM && k < 20)
	{
		j = GetRandom( MAXWORMHOLE );
		k++;
	}
    if (k < 20)
    {
    	FreeWormhole = true;
    	solarSystem[Wormhole[j]].Special = SCARABDESTROYED;
    }
	
	d = 999;
	k = -1;
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		j = [self RealDistance:solarSystem[NIXSYSTEM] b:solarSystem[i]];
		if (j >= 70 && j < d && solarSystem[i].Special < 0 &&
		    d != GEMULONSYSTEM && d!= DALEDSYSTEM)
		{
			k = i;
			d = j;
		}
	}
	if (k >= 0)
	{
		solarSystem[k].Special = GETREACTOR;
		solarSystem[NIXSYSTEM].Special = REACTORDELIVERED;
	}
	
	
	i = 0;
	while (i < MAXSOLARSYSTEM)
	{
		d = 1 + (GetRandom( MAXSOLARSYSTEM - 1 ));
		if (solarSystem[d].Special < 0 && solarSystem[d].TechLevel >= MAXTECHLEVEL-1 &&
		    d != GEMULONSYSTEM && d != DALEDSYSTEM)
		{
			solarSystem[d].Special = ARTIFACTDELIVERY;
			break;
		}
		++i;
	}
	if (i >= MAXSOLARSYSTEM)
		SpecialEvent[ALIENARTIFACT].Occurrence = 0;
	
	
	d = 999;
	k = -1;
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		j = [ self RealDistance:solarSystem[GEMULONSYSTEM] b:solarSystem[i]];
		if (j >= 70 && j < d && solarSystem[i].Special < 0 &&
		    k != DALEDSYSTEM && k!= GEMULONSYSTEM)
		{
			k = i;
			d = j;
		}
	}
	if (k >= 0)
	{
		solarSystem[k].Special = ALIENINVASION;
		solarSystem[GEMULONSYSTEM].Special = GEMULONRESCUED;
	}
	
	d = 999;
	k = -1;
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		j =  [self RealDistance:solarSystem[DALEDSYSTEM] b:solarSystem[i]];
		if (j >= 70 && j < d && solarSystem[i].Special < 0)
		{
			k = i;
			d = j;
		}
	}
	if (k >= 0)
	{
		solarSystem[k].Special = EXPERIMENT;
		solarSystem[DALEDSYSTEM].Special = EXPERIMENTSTOPPED;
	}
	
	
	for (i=MOONFORSALE; i<MAXSPECIALEVENT-ENDFIXED; ++i)
	{
		for (j=0; j<SpecialEvent[i].Occurrence; ++j)
		{
			Redo = true;
			while (Redo)
			{
				d = 1 + GetRandom( MAXSOLARSYSTEM - 1 );
				if (solarSystem[d].Special < 0) 
				{
					if (FreeWormhole || i != SCARAB)
						solarSystem[d].Special = i;
					Redo = false;
				}
			}
		}
	}
	
	// Initialize Commander
	for (i=0; i<200; ++i)
	{
		currentSystem = GetRandom( MAXSOLARSYSTEM );
		//COMMANDER.CurSystem = GetRandom( MAXSOLARSYSTEM );
		if (CURSYSTEM.Special >= 0)
			continue;
		
		// Seek at least an agricultural planet as startplanet (but not too hi-tech)
		if ((i < 100) && ((CURSYSTEM.TechLevel <= 0) ||
						  (CURSYSTEM.TechLevel >= 6)))
			continue;
		
		// Make sure at least three other systems can be reached
		d = 0;
		for (j=0; j<MAXSOLARSYSTEM; ++j)
		{
			if (j == currentSystem)//COMMANDER.CurSystem)
				continue;
			if ([ self SqrDistance:solarSystem[j] b:CURSYSTEM] <= SQR( Shiptype[1].FuelTanks ))
			{
				++d;
				if (d >= 3)
					break;
			}
		}
		if (d < 3)
			continue;
		
		break;
	}
	
	credits = 1000;
	debt = 0;
	days = 0;
	warpSystem = currentSystem;
	solarSystem[warpSystem].Visited = true;
	policeKills = 0; 
	traderKills = 0; 
	pirateKills = 0; 
	policeRecordScore = 0;
	reputationScore = 0;
	monsterStatus = 0;
	dragonflyStatus = 0;
	scarabStatus = 0;
	japoriDiseaseStatus = 0;
	moonBought = false;
	monsterHull = Shiptype[SpaceMonster.Type].HullStrength;
	escapePod = false;
	insurance = false;
	remindLoans = true;
	noClaim = 0;
	artifactOnBoard = false;
	for (i=0; i<MAXTRADEITEM; ++i)
		BuyingPrice[i] = 0;
	tribbleMessage = false;
	jarekStatus = 0;
	invasionStatus = 0;
	experimentStatus = 0;
	fabricRipProbability = 0;
	possibleToGoThroughRip = false;
	arrivedViaWormhole = false;
	veryRareEncounter = 0;
	[self resetNewsEvents];
	wildStatus = 0;
	reactorStatus = 0;
	trackedSystem = -1;
	showTrackedRange = true;
	justLootedMarie = false;
	chanceOfVeryRareEncounter = CHANCEOFVERYRAREENCOUNTER;
	alreadyPaidForNewspaper = false;
	canSuperWarp = false;
	gameLoaded = false;
	leaveEmpty = 0;
	reserveMoney = false;
	litterWarning= false;
	alwaysInfo = true;
	encounterType = 0;
	alwaysIgnorePolice = false;
	alwaysIgnorePirates = false;
	alwaysIgnoreTraders = false;
	alwaysIgnoreTradeInOrbit = false;
	trackAutoOff = false;
	ChanceOfTradeInOrbit = 10;
	autoFuel = false;
	autoRepair = false;
	playerShipNeedsUpdate = false;
	opponentShipNeedsUpdate = false;
	autoAttack = false;
	autoFlee = false;
	textualEncounters = true;
	continuous = false;
	encounterWindow = false;
	
	// Initialize Ship
	ship.Type =	0;
	for (i=0; i<MAXTRADEITEM; ++i)
		ship.Cargo[i] = 0;
	ship.Weapon[0] = -1;
	for (i=1; i<MAXWEAPON; ++i)
		ship.Weapon[i] = -1;
	for (i=0; i<MAXSHIELD; ++i)
	{
		ship.Shield[i] = -1;
		ship.ShieldStrength[i] = 0;
	}
	for (i=0; i<MAXGADGET; ++i)
		ship.Gadget[i] = -1;
	ship.Crew[0] = 0;
	for (i=1; i<MAXCREW; ++i)
		ship.Crew[i] = -1;
	ship.Fuel = [self GetFuelTanks];
	ship.Hull = Shiptype[ship.Type].HullStrength;
	ship.Tribbles = 0;
	
	[self DeterminePrices:currentSystem];
	
	[self SaveGame:@"Autosave"];
	[self playSound:eBeginGame];
	[self updateMercenary0Data];
	return true;
}

bool bDummyAlert;


-(void)FrmAlertWithState:(NSString *)MessageId state:(eAlertState)state {
	UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(MessageId, @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];	
//	[alert release];
	currentState = state;
	bLastMessage = false;
}


-(void)FrmAlert:(NSString *)MessageId{
	UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(MessageId, @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];	
	currentState = eDummy;	
	bLastMessage = false;
}

-(void)FrmAlertWithTitle:(NSString *)MessageId Title:(NSString*)Title{
	UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:Title message:NSLocalizedString(MessageId, @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];	
	currentState = eDummy;	
//	[alert release];	
	bLastMessage = false;
}


// *************************************************************************
// Increase Days (used in Encounter Module as well)
// *************************************************************************
-(void) IncDays:(int) Amount
{
	days += Amount;
	if (invasionStatus > 0 && invasionStatus < 8)
	{
		invasionStatus += Amount;
		if (invasionStatus >= 8)
		{
			solarSystem[GEMULONSYSTEM].Special = GEMULONINVADED;
			solarSystem[GEMULONSYSTEM].TechLevel = 0;
			solarSystem[GEMULONSYSTEM].Politics = ANARCHY;
		}
	}
	
	if (reactorStatus > 0 && reactorStatus < 21)
	{
		reactorStatus += Amount;
		if (reactorStatus > 20)
			reactorStatus = 20;
		
	}
	
	if (experimentStatus > 0 && experimentStatus < 12)
	{
		experimentStatus += Amount;
		if (experimentStatus > 11)
		{
			fabricRipProbability = FABRICRIPINITIALPROBABILITY;
			solarSystem[DALEDSYSTEM].Special = EXPERIMENTNOTSTOPPED;
			// in case Amount > 1
			experimentStatus = 12;
			
			// TODO:!!!!!!!!
			[self 	FrmAlert:@"ExperimentPerformedAlert"];
			[self addNewsEvent:EXPERIMENTPERFORMED];			
		}
	}
	else if (experimentStatus == 12 && fabricRipProbability > 0)
	{
		fabricRipProbability -= Amount;
	}
}

-(long)getSellPrice:(int)num {
	return SellPrice[num];
}

-(long)getBuyPrice:(int)num {
	return BuyPrice[num];
}

-(long)getBuyingPrice:(int)num {
	return BuyingPrice[num];
}

-(void) ShuffleStatus
{
	int i;
	
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		if (solarSystem[i].Status > 0)
		{
			if (GetRandom( 100 ) < 15)
				solarSystem[i].Status = UNEVENTFUL;
		}
		else if (GetRandom( 100 ) < 15)
			solarSystem[i].Status = 1 + GetRandom( MAXSTATUS - 1 );
	}
}

// *************************************************************************
// Calculate total cargo bays
// *************************************************************************
-(int) totalCargoBays
{
	int Bays;
	int i;
	
	Bays = Shiptype[ship.Type].CargoBays;
	for (i=0; i<MAXGADGET; ++i)
		if (ship.Gadget[i] == EXTRABAYS)
			Bays += 5;
	if (japoriDiseaseStatus == 1)
		Bays -= 10;
	// since the quest ends when the reactor
	if (reactorStatus > 0 && reactorStatus < 21)
		Bays -= (5 + 10 - (reactorStatus - 1)/2);
	
	return Bays;
}


-(long) WormholeTax:(int)a b:(int) b
{
	if ([self wormholeExists:a b:b])
		return( Shiptype[ship.Type].CostOfFuel * 25L );
	
	return 0L;
}


// *************************************************************************
// Standard handling of arrival
// *************************************************************************
-(void) Arrival
{
	currentSystem = warpSystem;
	CURSYSTEM.Visited = true;
	[self ShuffleStatus];
	//ChangeQuantities();
	[self DeterminePrices:currentSystem];
	alreadyPaidForNewspaper = false;
	[encounterViewControllerInstance.view removeFromSuperview];
	encounterWindow = false;	
	[self SaveGame:@"Autosave"];
	if (arrivedViaWormhole)
		[self playSound:eWormholeJump];

}


// *************************************************************************
// Calculate total filled cargo bays
// *************************************************************************
-(int) filledCargoBays
{
	int sum, i;
	
	sum = 0;
	for (i=0; i<MAXTRADEITEM; ++i)
		sum = sum + ship.Cargo[i];
	
	return sum;
}




-(void)FrmAlertOkCancel:(NSString *)MessageId state:(eAlertState)state {
	UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(MessageId, @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok"] autorelease];
	[alert show];	
	currentState = state;
	bLastMessage = false;
}

-(long) toSpend
{
	if (!reserveMoney)
		return credits;
	return max( 0,  credits - [self mercenaryMoney] - [self insuranceMoney] );
}


// *************************************************************************
// Buy amount of cargo
// *************************************************************************
-(void) buyCargo:(int)Index  Amount:(int)Amount  
{
	int ToBuy;
	
    if (debt > DEBTTOOLARGE)
    {
        [self FrmAlert:@"DebtTooLargeForBuyAlert"];
        return;
    }
	
	if (CURSYSTEM.Qty[Index] <= 0 || BuyPrice[Index] <= 0)
	{
		//		FrmAlert( NothingAvailableAlert );
		[self FrmAlert:@"NothingAvailableAlert" ];
		return;
	}
	
	if ([self totalCargoBays] - [self filledCargoBays] - leaveEmpty <= 0)
	{
		//FrmAlert( NoEmptyBaysAlert );
		[self FrmAlert: @"NoEmptyBaysAlert" ];
		return;
	}
	
	if ([self toSpend] < BuyPrice[Index] )
	{
		//FrmAlert( CantAffordAlert );
		[self FrmAlert:@"CantAffordAlert"];
		return;
	}
	
	ToBuy = min( Amount, CURSYSTEM.Qty[Index] );
	ToBuy = min( ToBuy, [self totalCargoBays] - [self filledCargoBays] - leaveEmpty );
	ToBuy = min( ToBuy, [self toSpend] / BuyPrice[Index] );
	
	ship.Cargo[Index] += ToBuy;
	credits -= ToBuy * BuyPrice[Index];
	BuyingPrice[Index] += ToBuy * BuyPrice[Index];
	CURSYSTEM.Qty[Index] -= ToBuy;
}

-(int)getAmountToBuy:(int)Index {
	
	if (BuyPrice[Index] <= 0 || CURSYSTEM.Qty[Index]  <= 0) {
		
		return 0;
	}
	long count = min([self toSpend] / BuyPrice[Index],  CURSYSTEM.Qty[Index]);
	
	return count;
}

-(int)getAmountToSell:(int)Index {
	return 	ship.Cargo[Index];
}

-(int)getOpponentAmountToSell:(int)Index {
	return 	Opponent.Cargo[Index];
}



-(void) sellCargo:(int)Index  Amount:(int)Amount Operation:(Byte)Operation {
	
	
	if (Operation == JETTISONCARGO) {
		if (policeRecordScore > DUBIOUSSCORE && !litterWarning) {
			
			litterWarning = true;
			// TODO!!!!!
			//if (FrmAlert(SpaceLitteringString) 
		}
	}
	
	int ToSell = min(Amount, ship.Cargo[Index]);
	
	if (Operation == DUMPCARGO) {
		
		ToSell = min(ToSell, [self toSpend] / 5 * (gameDifficulty + 1));
	}
	
	BuyingPrice[Index] = (BuyingPrice[Index] * (ship.Cargo[Index] - ToSell)) / ship.Cargo[Index];
	
	
	
	
	if (SellPrice[Index] > 0) {
		if(Operation== SELLCARGO)
			credits += ToSell * SellPrice[Index];
		else
			if (Operation == DUMPCARGO)
				credits -= ToSell * 5 *(gameDifficulty + 1);
			else {
				if (GetRandom(10) < gameDifficulty + 1) {
					if (policeRecordScore > DUBIOUSSCORE)
						policeRecordScore = DUBIOUSSCORE;
					else
						policeRecordScore -= 1;  
					[self addNewsEvent:CAUGHTLITTERING];
				}
			}
		ship.Cargo[Index] -= ToSell;
		//CURSYSTEM.Qty[Index] += ToSell;
	}
}

-(int) getSolarSystemX:(int)Index {
	return solarSystem[Index].X;
}

-(int) getSolarSystemY:(int)Index {
	return solarSystem[Index].Y;
}

-(bool) getSolarSystemVisited:(int)Index {
	
	return solarSystem[Index].Visited;
}

-(NSString*)getSolarSystemName:(int)Index {
	return [[self solarSystemName] objectAtIndex:Index/*solarSystem[Index].NameIndex*/];	
//	return [[[self solarSystemName] objectAtIndex:Index/*solarSystem[Index].NameIndex*/] retain];	
}
-(int)getCurrentSystemIndex {
	return currentSystem;
}

-(Byte)getCurrentSystemTechLevelInt {
	return solarSystem[currentSystem].TechLevel;
}

-(Byte)getCurrentShipTechLevel {
	
	return Shiptype[0].MinTechLevel;
}

-(long) realDistance:(int)a  b:(int)b
{
	return (sqrt( [self SqrDistance:solarSystem[a]  b:solarSystem[b]] ));
	//	return [RealDistance:solarSystem[a] b:solarSystem[b]];
}



-(void) doWarp:(bool)viaSingularity {
	int i, Distance;
	
	Distance = [self realDistance: currentSystem b:warpSystem] ;
	if (Distance > [self getFuel] && !viaSingularity &&![self wormholeExists:currentSystem b:warpSystem])
	{
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"No fuel!" message:NSLocalizedString(@"You have no fuel for this warp.", @"")  
															  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[myAlertView show];
		[myAlertView release];		
		bLastMessage = false;
		return;		
	}

	
	// if Wild is aboard, make sure ship is armed!
	if (wildStatus == 1)
	{	
		if (! [self HasWeapon:&ship Cg:BEAMLASERWEAPON exactCompare:false])
		{ 
			viaSingularitySaved = viaSingularity;
			
			currentState = eWildWeaponBuy;
			
			AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Alert" yoffset:90 message:NSLocalizedString(@"WildWontGoAlert", @"") 
																			delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Say Goodbye"  thirdButtonTitle:nil];
			
			[myAlertView show];
			[myAlertView release];					
		}
	}
	
    // Check for Large Debt
	if (debt > DEBTTOOLARGE)
	{
	    [self FrmAlert:@"DebtTooLargeForTravelAlert"];
			bLastMessage = false;
	    return;
	}
	
	// Check for enough money to pay Mercenaries    
	if ([self mercenaryMoney] > credits)
	{
		[self FrmAlert:@"MustPayMercenariesAlert"];
			bLastMessage = false;
		return; 
	}
	
    // Check for enough money to pay Insurance
	if (insurance)
	{
		if ([self insuranceMoney] + [self mercenaryMoney] > credits)
		{
			[self FrmAlert:@"CantPayInsuranceAlert"];
			return;
		}
	}
	
	// Check for enough money to pay Wormhole Tax 					
	if ([self insuranceMoney] + [self mercenaryMoney] + 
		[self WormholeTax:currentSystem  b:warpSystem] > credits)
	{
		[self FrmAlert:@"CantPayWormholeAlert"];
		return;
	}
	
	if (! viaSingularity)
	{
		credits -= [self WormholeTax:currentSystem b:warpSystem];
		credits -= [self mercenaryMoney];						
		credits -= [self insuranceMoney];
	}
	
	for (i=0; i<MAXSHIELD; ++i)
	{
		if (ship.Shield[i] < 0)
			break;
		ship.ShieldStrength[i] = Shieldtype[ship.Shield[i]].Power;
	}
	
	countDown = STARTCOUNTDOWN;
	if ([self wormholeExists:currentSystem b:warpSystem]  || viaSingularity)
	{
		//Distance = 0;
		arrivedViaWormhole = true;
	}
	else
	{
		Distance = [self realDistance: currentSystem b:warpSystem] ;
		ship.Fuel -= min( Distance, [self getFuel] );
		arrivedViaWormhole = false;
	}
	
	[self resetNewsEvents];
	if (!viaSingularity)
	{
		// normal warp.
		[self payInterest];
		[self IncDays:1];
		if (insurance)
			++noClaim;
	}
	else
	{
		// add the singularity news story
		[self addNewsEvent:ARRIVALVIASINGULARITY];
	}
	
	clicks = 21;
	raided = false;
	inspected = false;
	litterWarning = false;
	monsterHull = (monsterHull * 105) / 100;
	if (monsterHull > Shiptype[SpaceMonster.Type].HullStrength)
		monsterHull = Shiptype[SpaceMonster.Type].HullStrength;
	if (days%3 == 0)
	{
		if (policeRecordScore > CLEANSCORE)
			--policeRecordScore;
	}
	if (policeRecordScore < DUBIOUSSCORE)
		if (gameDifficulty <= NORMAL)
			++policeRecordScore;
		else if (days%gameDifficulty == 0)
			++policeRecordScore;
	
	possibleToGoThroughRip=true;
	
	[self DeterminePrices:warpSystem];
	[self Travel];
	//	[self Arrival];
}

-(Byte)getWormhole:(int)Index {
	return Wormhole[Index];
}

// *************************************************************************
// Engineer skill
// *************************************************************************
-(char) EngineerSkill:(struct  SHIP*) Sh 
{
	int i;
	char MaxSkill;
	
	MaxSkill = Mercenary[Sh->Crew[0]].Engineer;
	
	for (i=1; i<MAXCREW; ++i)
	{
		if (Sh->Crew[i] < 0)
			break;
		if (Mercenary[Sh->Crew[i]].Engineer > MaxSkill)
			MaxSkill = Mercenary[Sh->Crew[i]].Engineer;
	}
	
	if ([self HasGadget:Sh Gg:AUTOREPAIRSYSTEM])
		MaxSkill += SKILLBONUS;			
	
	return [self AdaptDifficulty:MaxSkill];
}


// *************************************************************************
// Generate an opposing ship
// *************************************************************************
-(void) GenerateOpponent:( char) Opp 
{
	bool Redo;
	int i, j, sum, Tries;
	long d, e, f, k, m;
	int Bays;
	
	[encounterViewControllerInstance SetLabelText:@""];
	Tries = 1;
	
	if (Opp == FAMOUSCAPTAIN)
	{
		// we just fudge for the Famous Captains' Ships...
		Opponent.Type = MAXSHIPTYPE - 1;
		for (i=0;i<MAXSHIELD;i++)
		{
			Opponent.Shield[i] = REFLECTIVESHIELD; 
			Opponent.ShieldStrength[i]= RSHIELDPOWER;
		}
		for (i=0;i<MAXWEAPON;i++)
		{
			Opponent.Weapon[i] = MILITARYLASERWEAPON; 
		}
		Opponent.Gadget[0]=TARGETINGSYSTEM;
		Opponent.Gadget[1]=NAVIGATINGSYSTEM;
		Opponent.Hull = Shiptype[MAXSHIPTYPE - 1].HullStrength;
		
		// these guys are bad-ass!
		Opponent.Crew[0] = MAXCREWMEMBER;
		Mercenary[Opponent.Crew[0]].Pilot = MAXSKILL;
		Mercenary[Opponent.Crew[0]].Fighter = MAXSKILL;
		Mercenary[Opponent.Crew[0]].Trader = MAXSKILL;
		Mercenary[Opponent.Crew[0]].Engineer = MAXSKILL;
		return;
	}
	
	if (Opp == MANTIS)
		Tries = 1+gameDifficulty;
	
	// The police will try to hunt you down with better ships if you are 
	// a villain, and they will try even harder when you are considered to
	// be a psychopath (or are transporting Jonathan Wild)
	
	if (Opp == POLICE)
	{
		if (policeRecordScore < VILLAINSCORE && wildStatus != 1)
			Tries = 3;
		else if (policeRecordScore < PSYCHOPATHSCORE || wildStatus == 1)
			Tries = 5;
		Tries = max( 1, Tries + gameDifficulty - NORMAL );
	}
	
	// Pirates become better when you get richer
	if (Opp == PIRATE)
	{
		Tries = 1 + ([self currentWorth] / 100000L);
		Tries = max( 1, Tries + gameDifficulty - NORMAL );
	}
	
	j = 0;
	if (Opp == TRADER)
		Opponent.Type = 0;
	else
		Opponent.Type = 1;
	
	k = (gameDifficulty >= NORMAL ? gameDifficulty - NORMAL : 0);
	
	while (j < Tries)
	{
		Redo = true;
		
		while (Redo)
		{
			d = GetRandom( 100 );
			i = 0;
			sum = Shiptype[0].Occurrence;
			
			while (sum < d)
			{
				if (i >= MAXSHIPTYPE-1)
					break;
				++i;
				sum += Shiptype[i].Occurrence;
			}
			
			if (Opp == POLICE && (Shiptype[i].Police < 0 || 
								  Politics[solarSystem[warpSystem].Politics].StrengthPolice + k < Shiptype[i].Police))
				continue;
			
			if (Opp == PIRATE && (Shiptype[i].Pirates < 0 || 
								  Politics[solarSystem[warpSystem].Politics].StrengthPirates + k < Shiptype[i].Pirates))
				continue;
			
			if (Opp == TRADER && (Shiptype[i].Traders < 0 || 
								  Politics[solarSystem[warpSystem].Politics].StrengthTraders + k < Shiptype[i].Traders))
				continue;
			
			Redo = false;
		}
		
		if (i > Opponent.Type)
			Opponent.Type = i;
		++j;
	}
	
	if (Opp == MANTIS)
		Opponent.Type = MANTISTYPE;
	else	
		Tries = max( 1, ([self currentWorth] / 150000L) + gameDifficulty - NORMAL );
	
	// Determine the gadgets
	if (Shiptype[Opponent.Type].GadgetSlots <= 0)
		d = 0;
	else if (gameDifficulty <= HARD)
	{
		d = GetRandom( Shiptype[Opponent.Type].GadgetSlots + 1 );
		if (d < Shiptype[Opponent.Type].GadgetSlots)
			if (Tries > 4)
				++d;
			else if (Tries > 2)
				d += GetRandom( 2 );
	}
	else
		d = Shiptype[Opponent.Type].GadgetSlots;
	for (i=0; i<d; ++i)
	{
		e = 0;
		f = 0;
		while (e < Tries)
		{
			k = GetRandom( 100 );
			j = 0;
			sum = Gadgettype[0].Chance;
			while (k < sum)
			{
				if (j >= MAXGADGETTYPE - 1)
					break;
				++j;
				sum += Gadgettype[j].Chance;
			}
			if (![self HasGadget:&Opponent Gg:j])
				if (j > f)
					f = j;
			++e;
		}
		Opponent.Gadget[i] = f;
	}
	for (i=d; i<MAXGADGET; ++i)
		Opponent.Gadget[i] = -1;
	
	// Determine the number of cargo bays
	Bays = Shiptype[Opponent.Type].CargoBays;
	for (i=0; i<MAXGADGET; ++i)
		if (Opponent.Gadget[i] == EXTRABAYS)
			Bays += 5;
	
	// Fill the cargo bays
	for (i=0; i<MAXTRADEITEM; ++i)
		Opponent.Cargo[i] = 0;
	
	if (Bays > 5)
	{
		if (gameDifficulty >= NORMAL)
		{
			m = 3 + GetRandom( Bays - 5 );
			sum = min( m, 15 );
		}
		else
			sum = Bays;
		if (Opp == POLICE)
			sum = 0;
		if (Opp == PIRATE)
		{
			if (gameDifficulty < NORMAL)
				sum = (sum * 4) / 5;
			else
				sum = sum / gameDifficulty;
		}
		if (sum < 1)
			sum = 1;
		
		i = 0;
		while (i < sum)
		{
			j = GetRandom( MAXTRADEITEM );
			k = 1 + GetRandom( 10 - j );
			if (i + k > sum)
				k = sum - i;
			Opponent.Cargo[j] += k;
			i += k;
		}
	}
	
	// Fill the fuel tanks
	Opponent.Fuel = Shiptype[Opponent.Type].FuelTanks;
	
	// No tribbles on board
	Opponent.Tribbles = 0;
	
	// Fill the weapon slots (if possible, at least one weapon)
	if (Shiptype[Opponent.Type].WeaponSlots <= 0)
		d = 0;
	else if (Shiptype[Opponent.Type].WeaponSlots <= 1)
		d = 1;
	else if (gameDifficulty <= HARD)
	{
		d = 1 + GetRandom( Shiptype[Opponent.Type].WeaponSlots );
		if (d < Shiptype[Opponent.Type].WeaponSlots)
			if (Tries > 4 && gameDifficulty >= HARD)
				++d;
			else if (Tries > 3 || gameDifficulty >= HARD)
				d += GetRandom( 2 );
	}
	else
		d = Shiptype[Opponent.Type].WeaponSlots;
	for (i=0; i<d; ++i)
	{
		e = 0;
		f = 0;
		while (e < Tries)
		{
			k = GetRandom( 100 );
			j = 0;
			sum = Weapontype[0].Chance;
			while (k < sum)
			{
				if (j >= MAXWEAPONTYPE - 1)
					break;
				++j;
				sum += Weapontype[j].Chance;
			}
			if (j > f)
				f = j;
			++e;
		}
		Opponent.Weapon[i] = f;
	}
	for (i=d; i<MAXWEAPON; ++i)
		Opponent.Weapon[i] = -1;
	
	// Fill the shield slots
	if (Shiptype[Opponent.Type].ShieldSlots <= 0)
		d = 0;
	else if (gameDifficulty <= HARD)
	{
		d = GetRandom( Shiptype[Opponent.Type].ShieldSlots + 1 );
		if (d < Shiptype[Opponent.Type].ShieldSlots)
			if (Tries > 3)
				++d;
			else if (Tries > 1)
				d += GetRandom( 2 );
	}
	else
		d = Shiptype[Opponent.Type].ShieldSlots;
	for (i=0; i<d; ++i)
	{
		e = 0;
		f = 0;
		
		while (e < Tries)
		{
			k = GetRandom( 100 );
			j = 0;
			sum = Shieldtype[0].Chance;
			while (k < sum)
			{
				if (j >= MAXSHIELDTYPE - 1)
					break;
				++j;
				sum += Shieldtype[j].Chance;
			}
			if (j > f)
				f = j;
			++e;
		}
		Opponent.Shield[i] = f;
		
		j = 0;
		k = 0;
		while (j < 5)
		{
			e = 1 + GetRandom( Shieldtype[Opponent.Shield[i]].Power );
			if (e > k)
				k = e;
			++j;
		}
		Opponent.ShieldStrength[i] = k;			
	}
	for (i=d; i<MAXSHIELD; ++i)
	{
		Opponent.Shield[i] = -1;
		Opponent.ShieldStrength[i] = 0;
	}
	
	// Set hull strength
	i = 0;
	k = 0;
	// If there are shields, the hull will probably be stronger
	if (Opponent.Shield[0] >= 0 && GetRandom( 10 ) <= 7)
		Opponent.Hull = Shiptype[Opponent.Type].HullStrength;
	else
	{
		while (i < 5)
		{
			d = 1 + GetRandom( Shiptype[Opponent.Type].HullStrength );
			if (d > k)
				k = d;
			++i;
		}
		Opponent.Hull = k;			
	}
	
	if (Opp == MANTIS || Opp == FAMOUSCAPTAIN)
		Opponent.Hull = Shiptype[Opponent.Type].HullStrength;
	
	
	// Set the crew. These may be duplicates, or even equal to someone aboard
	// the commander's ship, but who cares, it's just for the skills anyway.
	Opponent.Crew[0] = MAXCREWMEMBER;
	Mercenary[Opponent.Crew[0]].Pilot = 1 + GetRandom( MAXSKILL );
	Mercenary[Opponent.Crew[0]].Fighter = 1 + GetRandom( MAXSKILL );
	Mercenary[Opponent.Crew[0]].Trader = 1 + GetRandom( MAXSKILL );
	Mercenary[Opponent.Crew[0]].Engineer = 1 + GetRandom( MAXSKILL );
	if (warpSystem == KRAVATSYSTEM && wildStatus == 1 && (GetRandom(10)<gameDifficulty + 1))
	{
		Mercenary[Opponent.Crew[0]].Engineer = MAXSKILL;
	}
	if (gameDifficulty <= HARD)
	{
		d = 1 + GetRandom( Shiptype[Opponent.Type].CrewQuarters );
		if (gameDifficulty >= HARD && d < Shiptype[Opponent.Type].CrewQuarters)
			++d;
	}
	else
		d = Shiptype[Opponent.Type].CrewQuarters;
	for (i=1; i<d; ++i)
		Opponent.Crew[i] = GetRandom( MAXCREWMEMBER );
	for (i=d; i<MAXCREW; ++i)
		Opponent.Crew[i] = -1;
}

// *************************************************************************
// Determine if ship is cloaked
// *************************************************************************
-(bool) Cloaked:(struct SHIP*) Sh b:(struct SHIP*) Opp 
{
	return ([self HasGadget:Sh Gg:CLOAKINGDEVICE]  && ([self EngineerSkill:Sh] > [self EngineerSkill: Opp]));
}

// *************************************************************************
// Determine ship's hull strength
// *************************************************************************
-(long) GetHullStrength
{
	if (scarabStatus == 3)
		return Shiptype[ship.Type].HullStrength + UPGRADEDHULL;
	else
		return Shiptype[ship.Type].HullStrength;
}

-(long)getShipHull {
	return ship.Hull;
}

-(long)getShipOpponentHull {
	return Opponent.Hull;
}

// *************************************************************************
// Calculate total possible shield strength
// *************************************************************************
-(long) TotalShields:(struct SHIP*) Sh 
{
	int i;
	long j;
	
	j = 0;
	for (i=0; i<MAXSHIELD; ++i)
	{
		if (Sh->Shield[i] < 0)
			break;
		j += Shieldtype[Sh->Shield[i]].Power;
	}
	
	return j;
}


// *************************************************************************
// Calculate total shield strength
// *************************************************************************
-(long) TotalShieldStrength:(struct SHIP*) Sh 
{
	int i;
	long k;
	
	k = 0;
	for (i=0; i<MAXSHIELD; ++i)
	{
		if (Sh->Shield[i] < 0)
			break;
		k += Sh->ShieldStrength[i];
	}
	
	return k;
}

-(void) CreateShip:(int) Index 
{
	int i;
	
	ship.Type = Index;
	
	for (i=0; i<MAXWEAPON; ++i)
    {
		ship.Weapon[i] = -1;
    }
	
	for (i=0; i<MAXSHIELD; ++i)
    {
		ship.Shield[i] = -1;
		ship.ShieldStrength[i] = 0;
    }
	
	for (i=0; i<MAXGADGET; ++i)
    {
		ship.Gadget[i] = -1;
    }
	
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		ship.Cargo[i] = 0;
		BuyingPrice[i] = 0;
	}
	
	ship.Fuel = [self GetFuelTanks];
	ship.Hull = Shiptype[ship.Type].HullStrength;
}


// *************************************************************************
// Buy a new ship.
// *************************************************************************
-(void) BuyShip:(int) Index
{
	[self CreateShip:Index];
	credits -= ShipPrice[Index];
	if (scarabStatus == 3)
		scarabStatus = 0;
}

// *************************************************************************
// Determine value of current ship, including goods and equipment.
// *************************************************************************
-(long) CurrentShipPrice:(bool) ForInsurance
{
	int i;
	long CurPrice;
	
	CurPrice = [self currentShipPriceWithoutCargo:ForInsurance];
	for (i=0; i<MAXTRADEITEM; ++i)
		CurPrice += BuyingPrice[i];
	
	return CurPrice;
}	

// *************************************************************************
// Determine Ship Prices depending on tech level of current system.
// *************************************************************************
-(void) DetermineShipPrices
{
	int i;
	
	for (i=0; i<MAXSHIPTYPE; ++i)
	{
		if (Shiptype[i].MinTechLevel <= CURSYSTEM.TechLevel)
		{
			ShipPrice[i] = BASESHIPPRICE( i ) - [self CurrentShipPrice:false];
			if (ShipPrice[i] == 0) 
				ShipPrice[i] = 1;
		}
		else
			ShipPrice[i] = 0;
	}
}

// *************************************************************************
// You get a Flea
// *************************************************************************
-(void) CreateFlea
{
	int i;
	
	[self CreateShip:0];
	
	for (i=1; i<MAXCREW; ++i)
		ship.Crew[i] = -1;
	
	escapePod = false;
	insurance = false;
	noClaim = 0;
}

// *************************************************************************
// Your escape pod ejects you
// *************************************************************************
-(void) EscapeWithPod
{
	if (credits > 500)
		credits -= 500;
	else
	{
		debt += (500 - credits);
		credits = 0;
	}
	
	[self IncDays: 3 ];		
	[self CreateFlea];
	[self SaveGame:@"Autosave"];
	
	[self playSound:eYouAreDestroyed];
	[self FrmAlert:@"EscapePodActivatedAlert"];
	
	if (scarabStatus == 3)
		scarabStatus = 0;
	
	[self Arrival];
	
	if (reactorStatus > 0 && reactorStatus < 21)
	{
		[self FrmAlert:@"ReactorDestroyedAlert"];
		reactorStatus = 0;
	}
	
	if (japoriDiseaseStatus == 1)
	{
		[self FrmAlert:@"AntidoteDestroyedAlert"];
		japoriDiseaseStatus = 0;
	}
	
	if (artifactOnBoard)
	{
		[self FrmAlert:@"ArtifactNotSavedAlert"];
		artifactOnBoard = false;
	}
	
	if (jarekStatus == 1)
	{
		[self FrmAlert:@"JarekTakenHomeAlert"];
		jarekStatus = 0;
	}
	
	if (wildStatus == 1)
	{
		[self FrmAlert:@"WildArrestedAlert"];
		policeRecordScore += CAUGHTWITHWILDSCORE;
		[self addNewsEvent:WILDARRESTED];
		wildStatus = 0;
	}
	
	if (ship.Tribbles > 0)
	{
		[self FrmAlert:@"TribbleSurvivedAlert"];
		ship.Tribbles = 0;
	}
	
	if (insurance)
	{
		[self FrmAlert:@"InsurancePaysAlert"];
		credits += [self currentShipPriceWithoutCargo: true ];
	}
	
	[self FrmAlert:@"FleaBuiltAlert"];
	

	
	}

// *************************************************************************
// Calculate total possible weapon strength
// Modified to allow an upper and lower limit on which weapons work.
// Weapons equal to or between minWeapon and maxWeapon (e.g., PULSELASERWEAPON)
// will do damage. Use -1 to allow damage from any weapon, which is almost
// always what you want. SjG
// *************************************************************************
-(long) TotalWeapons:(struct SHIP*) Sh  minWeapon:(int) minWeapon  maxWeapon:(int) maxWeapon
{
    int i;
    long j;
	
    j = 0;
    for (i=0; i<MAXWEAPON; ++i)
    {
	    if (Sh->Weapon[i] < 0)
	        break;
		
		if ((minWeapon != -1 && Sh->Weapon[i] < minWeapon) ||
		    (maxWeapon != -1 && Sh->Weapon[i] > maxWeapon))
			continue;
		
	    j += Weapontype[Sh->Weapon[i]].Power;
    }
    
    return j;
}

// *************************************************************************
// You get arrested
// *************************************************************************
-(void) Arrested
{
	//TODO: FormPtr frm;
	long Fine, Imprisonment;
	int i;
	
	Fine = ((1 + ((([self currentWorth] * min( 80, -policeRecordScore )) / 100) / 500)) * 500);
	if (wildStatus == 1)
	{
		Fine *= 1.05;
	}
	Imprisonment = max( 30, -policeRecordScore );
	
	[self FrmAlert:@"ArrestedAlert"];
	
	//TODO: frm = FrmInitForm( ConvictionForm );
	
	//TODO: [header appendString:@"You are convicted to " );
	//TODO: StrIToA( SBuf2, Imprisonment );
	//TODO: StrCat( SBuf, SBuf2 );
	//TODO: StrCat( SBuf, " days in" );
	//TODO: setLabelText( frm, ConvictionImprisonmentLabel, SBuf );
	
	//TODO: [header appendString:@"prison and a fine of " );
	//TODO: StrIToA( SBuf2, Fine );
	//TODO: StrCat( SBuf, SBuf2 );
	//TODO: StrCat( SBuf, " credits." );
	//TODO: setLabelText( frm, ConvictionFineLabel, SBuf );
	
	//TODO: FrmDoDialog( frm );
	//TODO: FrmDeleteForm( frm );
	
	if (ship.Cargo[NARCOTICS] > 0 || ship.Cargo[FIREARMS] > 0)
	{
		[self FrmAlert:@"ImpoundAlert"];
		ship.Cargo[NARCOTICS] = 0;
		ship.Cargo[FIREARMS] = 0;
	}
	
	if (insurance)
	{
		[self FrmAlert:@"InsuranceLostAlert"];
		insurance = false;
		noClaim = 0;
	}
	
	if (ship.Crew[1] >= 0)
	{
		[self  FrmAlert:@"MercenariesLeaveAlert"];
		for (i=1; i<MAXCREW; ++i)
			ship.Crew[i] = -1;
	}
	
	if (japoriDiseaseStatus == 1)
	{
		[self FrmAlert:@"AntidoteRemovedAlert"];
		japoriDiseaseStatus = 2;
	}
	
	if (jarekStatus == 1)
	{
		[self FrmAlert:@"JarekTakenHomeAlert"];
		jarekStatus = 0;
	}
	
	if (wildStatus == 1)
	{
		[self FrmAlert:@"WildArrestedAlert"];
		[self addNewsEvent:WILDARRESTED];
		wildStatus = 0;
	}
	
	if (reactorStatus > 0 && reactorStatus < 21)
	{
		[self FrmAlert:@"PoliceConfiscateReactorAlert"];
		reactorStatus = 0; 
	}
	
	[self Arrival];
	
	[self IncDays:Imprisonment];
	
	if (credits >= Fine)
		credits -= Fine;
	else
	{
		credits += [self CurrentShipPrice: true];
		
		if (credits >= Fine)
			credits -= Fine;
		else
			credits = 0;
		
		[self FrmAlert:@"ShipSoldAlert"];
		
		if (ship.Tribbles > 0)
		{
			[self FrmAlert:@"TribblesSoldAlert"];
			ship.Tribbles = 0;
		}
		
		[self FrmAlert:@"FleaReceivedAlert"];
		
		[self CreateFlea];
	}
	
	policeRecordScore = DUBIOUSSCORE;
	
	if (debt > 0)
	{
		if (credits >= debt)
		{
			credits -= debt;
			debt = 0;
		}
		else
		{
			debt -= credits;
			credits = 0;
		}
	}
	
	for (i=0; i<Imprisonment; ++i)
		[self payInterest];
	
	[self Arrival];
	//TODO: CurForm = SystemInformationForm;
	//TODO: FrmGotoForm( CurForm );
}

// *************************************************************************
// Fighter skill
// *************************************************************************
-(char) FighterSkill:(struct SHIP*) Sh 
{
	int i;
	char MaxSkill;
	
	MaxSkill = Mercenary[Sh->Crew[0]].Fighter;
	
	for (i=1; i<MAXCREW; ++i)
	{
		if (Sh->Crew[i] < 0)
			break;
		if (Mercenary[Sh->Crew[i]].Fighter > MaxSkill)
			MaxSkill = Mercenary[Sh->Crew[i]].Fighter;
	}
	
	if ([self HasGadget:Sh Gg:TARGETINGSYSTEM])
		MaxSkill += SKILLBONUS;			
	
	return [self AdaptDifficulty:MaxSkill];
}

// *************************************************************************
// Pilot skill
// *************************************************************************
-(char) PilotSkill:(struct SHIP*) Sh
{
	int i;
	char MaxSkill;
	
	MaxSkill = Mercenary[Sh->Crew[0]].Pilot;
	
	for (i=1; i<MAXCREW; ++i)
	{
		if (Sh->Crew[i] < 0)
			break;
		if (Mercenary[Sh->Crew[i]].Pilot > MaxSkill)
			MaxSkill = Mercenary[Sh->Crew[i]].Pilot;
	}
	
	if ([self HasGadget:Sh Gg:NAVIGATINGSYSTEM])
		MaxSkill += SKILLBONUS;			
	if ([self HasGadget:Sh Gg:CLOAKINGDEVICE])
		MaxSkill += CLOAKBONUS;			
	
	return [self AdaptDifficulty:MaxSkill];
}
// *************************************************************************
// An attack: Attacker attacks Defender, Flees indicates if Defender is fleeing
// *************************************************************************
-(bool) ExecuteAttack:(struct SHIP*) Attacker Defender:(struct SHIP*) Defender Flees:(bool)Flees CommanderUnderAttack:(bool) CommanderUnderAttack
{
	long Damage, prevDamage;
	int i;
	
	// On beginner level, if you flee, you will escape unharmed.
	if (gameDifficulty == BEGINNER && CommanderUnderAttack && Flees)
		return false;
	
	// Fighterskill attacker is pitted against pilotskill defender; if defender
	// is fleeing the attacker has a free shot, but the chance to hit is smaller
	if (GetRandom([self FighterSkill: Attacker] + Shiptype[Defender->Type].Size ) < 
		(Flees ? 2 : 1) * GetRandom( 5 + ([self PilotSkill:Defender] >> 1) ))
		// Misses
		return false;
	
	if ([self TotalWeapons:Attacker minWeapon: -1 maxWeapon: -1] <= 0)
		Damage = 0L;
	else if (Defender->Type == SCARABTYPE)
	{
		if ([self TotalWeapons:Attacker minWeapon:PULSELASERWEAPON maxWeapon:PULSELASERWEAPON]  <= 0 &&
		    [self TotalWeapons:Attacker minWeapon: MORGANLASERWEAPON maxWeapon:MORGANLASERWEAPON]  <= 0)
			Damage = 0L;
		else 
			Damage =  GetRandom( (([self TotalWeapons:Attacker minWeapon:PULSELASERWEAPON maxWeapon:PULSELASERWEAPON]  +
								   [self TotalWeapons:Attacker  minWeapon:MORGANLASERWEAPON maxWeapon:MORGANLASERWEAPON] ) * (100 + 2*[self EngineerSkill:Attacker] ) / 100) );
	}
	else
		Damage = GetRandom( ([self TotalWeapons:Attacker minWeapon:-1 maxWeapon: -1] * (100 + 2*[self EngineerSkill:Attacker]) / 100) );
	
	if (Damage <= 0L)
		return false;
	
	// Reactor on board -- damage is boosted!
	if (CommanderUnderAttack && reactorStatus > 0 && reactorStatus < 21)
	{
		if (gameDifficulty < NORMAL)
			Damage *= 1 + (gameDifficulty + 1)*0.25;
		else
			Damage *= 1 + (gameDifficulty + 1)*0.33;
	}
	
	// First, shields are depleted
	for (i=0; i<MAXSHIELD; ++i)
	{
		if (Defender->Shield[i] < 0)
			break;
		if (Damage <= Defender->ShieldStrength[i])
		{
			Defender->ShieldStrength[i] -= Damage;
			Damage = 0;
			break;
		}
		Damage -= Defender->ShieldStrength[i];
		Defender->ShieldStrength[i] = 0;
	}
	
	prevDamage = Damage;
	
	// If there still is damage after the shields have been depleted, 
	// this is subtracted from the hull, modified by the engineering skill
	// of the defender.
	if (Damage > 0)
	{
		Damage -= GetRandom( [self EngineerSkill: Defender] );
		if (Damage <= 0)
			Damage = 1;
		// At least 2 shots on Normal level are needed to destroy the hull 
		// (3 on Easy, 4 on Beginner, 1 on Hard or Impossible). For opponents,
		// it is always 2.
		if (CommanderUnderAttack && scarabStatus == 3)
			Damage = min( Damage, ([self GetHullStrength]/
								   (CommanderUnderAttack ? max( 1, (IMPOSSIBLE-gameDifficulty) ) : 2)) );
		else
			Damage = min( Damage, (Shiptype[Defender->Type].HullStrength/
								   (CommanderUnderAttack ? max( 1, (IMPOSSIBLE-gameDifficulty) ) : 2)) );
		Defender->Hull -= Damage;
		if (Defender->Hull < 0)
			Defender->Hull = 0;
	}
	
	if (Damage != prevDamage)
	{
		if (CommanderUnderAttack)
		{
			playerShipNeedsUpdate = true;
		}
		else
		{
			opponentShipNeedsUpdate = true;
		}
	}
	
	return true;
}

// *************************************************************************
// Determine value of ship
// *************************************************************************
-(long) EnemyShipPrice:(struct SHIP*) Sh 
{
	int i;
	long CurPrice;
	
	CurPrice = Shiptype[Sh->Type].Price;
	for (i=0; i<MAXWEAPON; ++i)
		if (Sh->Weapon[i] >= 0)
			CurPrice += Weapontype[Sh->Weapon[i]].Price;
	for (i=0; i<MAXSHIELD; ++i)
		if (Sh->Shield[i] >= 0)
			CurPrice += Shieldtype[Sh->Shield[i]].Price;
	// Gadgets aren't counted in the price, because they are already taken into account in
	// the skill adjustment of the price.
	
	CurPrice = CurPrice * (2 * [self PilotSkill: Sh] + [self EngineerSkill: Sh] + 3 * [self FighterSkill: Sh])	/ 60;
	
	return CurPrice;
}	
// *************************************************************************
// Calculate Bounty
// *************************************************************************
-(long) GetBounty:(struct SHIP*) Sh
{
	long Bounty = [self EnemyShipPrice:Sh];
	
	Bounty /= 200;
	Bounty /= 25;	
	Bounty *= 25;
	if (Bounty <= 0)
		Bounty = 25;
	if (Bounty > 2500)
		Bounty = 2500;
	
	return Bounty;
}



typedef enum {
	ePickupCannister,
	ePlunderShip,
	ePickItUp,
	ePickFromShip
} ePlunderMode;

-(void)plunderItems:(int) index count:(int)count
{
	plunderItem = index;
	plunderCount = count;
}

-(void)finishPlunder
{
	if (ENCOUNTERPIRATE( encounterType ) && Opponent.Type != MANTISTYPE && policeRecordScore >= DUBIOUSSCORE)
	{
		NSString * str = [NSString stringWithFormat:@"You earned a bounty of %i cr.", [self GetBounty:&Opponent]];
		[self FrmAlert:str];
	}
	else
	{
		[self FrmAlert:@"OpponentDestroyedAlert"];
	}
	
	bWaitFinishPlunder = false;			
	[self Travel];
	[encounterViewControllerInstance showEncounterWindow];			
	
	
}

-(void) showPlunderForm:(ePlunderMode)pickup
{
	// TODO:!!!!!!!!!	
	if (clicks <= 0)
		return;
	bWaitFinishPlunder = true;
	if (pickup == ePickupCannister) {
		currentState = ePlunderForm;		
		plunderCount = 1;
		NSString * message;
		if (/*pickup == ePickupCannister*/true) {
			plunderItem = GetRandom(MAXTRADEITEM);
			message = [NSString stringWithFormat:@"A cannister from the destroyed ship, labelled %@, drifts within range of your scoops.", [NSString stringWithCString:Tradeitem[plunderItem].Name]];
		}
		else {
			
		}
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Scoop Canister" message: message
																		delegate:self cancelButtonTitle:0 otherButtonTitles:@"Let it go", @"Pick it up",0];
		
		[myAlertView show];
		[myAlertView release];				
		bLastMessage = false;
		
	}
	else    
		if (pickup == ePlunderShip) {
			currentState = ePlunderShipForm;
			UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Plunder Ship" message: @"Do you really want to plunder this ship?"
																  delegate:self cancelButtonTitle:0 otherButtonTitles:@"Let it go", @"Plunder it",0];
			
			[myAlertView show];
			[myAlertView release];				
			bLastMessage = false;
			
		}
	else 
	{
		if ([self totalCargoBays] -  [self filledCargoBays] >= plunderCount) {

			ship.Cargo[plunderItem] += plunderCount;
			[self finishPlunder];
		}
		else {
			currentState = ePlunderRemoveGoods;
			UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"No Room To Scoop" message: @"You don't have any room in your cargo holds. Do you wish to jettison goods to make room, or just let it go."
																			delegate:self cancelButtonTitle:@"Let it go" otherButtonTitles:@"Make Room", 0];
			
			[myAlertView show];
			[myAlertView release];				// free place
			bLastMessage = false;
		}
	}
}

-(void)continuePlunder {
	bWaitFinishPlunder = false;
	[self showPlunderForm:ePickItUp];	
}

// *************************************************************************
// You can pick up cannisters left by a destroyed ship
// *************************************************************************
-(void) Scoop
{
	[self showPlunderForm:ePickupCannister];
	//int d, ret;
	
	// Chance 50% to pick something up on Normal level, 33% on Hard level, 25% on
	// Impossible level, and 100% on Easy or Beginner
	//if (gameDifficulty >= NORMAL)
	//	if (GetRandom( gameDifficulty ) != 1)
	//		return;
	
	// More chance to pick up a cheap good
	//d = GetRandom( MAXTRADEITEM );
	//if (d >= 5)
	//	d = GetRandom( MAXTRADEITEM );
	
	//TODO: frm = FrmInitForm( PickCannisterForm );
	
	//TODO:[header appendString:@"ship, labeled " );
	//TODO:StrCat( SBuf, Tradeitem[d].Name );
	//TODO:StrCat( SBuf, ", drifts" );
	//TODO:setLabelText( frm, PickCannisterCannisterLabel, SBuf );
	
	//TODO:ret = FrmDoDialog( frm );
	//TODO:FrmDeleteForm( frm ); 
	
	//if (ret == /*PickCannisterPickItUpButton*/1)
	//{
	//	if ([self filledCargoBays] >= [self totalCargoBays])
	//	{
			//TODO:if (FrmAlert( NoRoomToScoopAlert ) == NoRoomToScoopLetitgo)
	//		return;
			
			//TODO:frm = FrmInitForm( DumpCargoForm );
			//TODO:FrmSetEventHandler( frm, DiscardCargoFormHandleEvent );
			//TODO:FrmDoDialog( frm );
			//TODO:FrmDeleteForm( frm ); 
	//	}
		
	//	if ([self filledCargoBays] < [self totalCargoBays])
	//		++ship.Cargo[d];
	//	else
			//TODO:FrmAlert( NoDumpNoScoopAlert );
	//		;
	//}
	
}

-(void) ShowShip:(struct SHIP*)Sh offset:(int)offset commandersShip:(bool)commandersShip {
	
	// shows ship window
}

// *************************************************************************
// Display on the encounter screen what the next action will be
// *************************************************************************
-(void) EncounterDisplayNextAction:(bool) FirstDisplay 
{
	//TODO :
	/*
	 if (encounterType == POLICEINSPECTION)
	 {
	 DrawChars( "The police summon you to submit", 6, 106 );
	 DrawChars( "to an inspection.", 6, 119 );
	 }
	 else if (encounterType == POSTMARIEPOLICEENCOUNTER)
	 {
	 DrawChars( "\"We know you removed illegal", 6, 93 );
	 DrawChars( "goods from the Marie Celeste.", 6,106 );
	 DrawChars( "You must give them up at once!\"", 6, 119 );
	 }
	 else if (FirstDisplay && encounterType == POLICEATTACK && 
	 PoliceRecordScore > CRIMINALSCORE)
	 {
	 DrawChars( "The police hail they want", 6, 106 );
	 DrawChars( "you to surrender.", 6, 119 );
	 }
	 else if (encounterType == POLICEFLEE || encounterType == TRADERFLEE ||
	 encounterType == PIRATEFLEE)
	 DrawChars( "Your opponent is fleeing.", 6, 106 );
	 else if (encounterType == PIRATEATTACK || encounterType == POLICEATTACK ||
	 encounterType == TRADERATTACK || encounterType == SPACEMONSTERATTACK ||
	 encounterType == DRAGONFLYATTACK || encounterType == SCARABATTACK ||
	 encounterType == FAMOUSCAPATTACK)
	 DrawChars( "Your opponent attacks.", 6, 106 );
	 else if (encounterType == TRADERIGNORE || encounterType == POLICEIGNORE ||
	 encounterType == SPACEMONSTERIGNORE || encounterType == DRAGONFLYIGNORE || 
	 encounterType == PIRATEIGNORE || encounterType == SCARABIGNORE)
	 {
	 if (Cloaked( &Ship, &Opponent ))
	 DrawChars( "It doesn't notice you.", 6, 106 );
	 else
	 DrawChars( "It ignores you.", 6, 106 );
	 }
	 else if (encounterType == TRADERSELL || encounterType == TRADERBUY)
	 {
	 DrawChars( "You are hailed with an offer", 6, 106 );
	 DrawChars( "to trade goods.", 6, 119 );
	 }
	 else if (encounterType == TRADERSURRENDER || encounterType == PIRATESURRENDER)
	 {
	 DrawChars( "Your opponent hails that he", 6, 106 );
	 DrawChars( "surrenders to you.", 6, 119 );
	 }
	 else if (encounterType == MARIECELESTEENCOUNTER)
	 {
	 DrawChars( "The Marie Celeste appears to", 6, 106 );
	 DrawChars( "be completely abandoned.", 6, 119 );
	 }
	 else if (ENCOUNTERFAMOUS(encounterType) && encounterType != FAMOUSCAPATTACK)
	 {
	 DrawChars( "The Captain requests a brief", 6, 106 );
	 DrawChars( "meeting with you.", 6, 119 );
	 }
	 else if (encounterType == BOTTLEOLDENCOUNTER ||
	 encounterType == BOTTLEGOODENCOUNTER)
	 {
	 DrawChars( "It appears to be a rare bottle", 6, 106);
	 DrawChars( "of Captain Marmoset's Skill Tonic!", 6, 119);
	 }
	 */
}


// *************************************************************************
// A fight round
// Return value indicates whether fight continues into another round
// *************************************************************************
-(int) ExecuteAction:(bool) CommanderFlees
{
	//FormPtr frmP;
	Boolean CommanderGotHit, OpponentGotHit;
	long OpponentHull, ShipHull;
	//int y, i, objindex;
	int PrevencounterType;
	//ControlPtr cp;
	
	CommanderGotHit = false;
	OpponentHull = Opponent.Hull;
	ShipHull = ship.Hull;
	
	// Fire shots
	if (encounterType == PIRATEATTACK || encounterType == POLICEATTACK ||
		encounterType == TRADERATTACK || encounterType == SPACEMONSTERATTACK ||
		encounterType == DRAGONFLYATTACK || encounterType == POSTMARIEPOLICEENCOUNTER ||
		encounterType == SCARABATTACK || encounterType == FAMOUSCAPATTACK)
	{
		CommanderGotHit = [self ExecuteAttack: &Opponent  Defender:&ship Flees:CommanderFlees CommanderUnderAttack:true];
	}
	
	OpponentGotHit = false;
	
	if (!CommanderFlees)
	{
		if (encounterType == POLICEFLEE || encounterType == TRADERFLEE ||
			encounterType == PIRATEFLEE)	
		{
			OpponentGotHit = [self ExecuteAttack:&ship Defender:&Opponent  Flees:true CommanderUnderAttack:false];
		}
		else
		{
			OpponentGotHit = [self ExecuteAttack:&ship Defender:&Opponent Flees:false CommanderUnderAttack:false];
		}
	}
	
	if (CommanderGotHit)
	{
		playerShipNeedsUpdate = true;
		[self playSound:eCommanderHit];		
	}
	if (OpponentGotHit)
	{
		opponentShipNeedsUpdate = true;
		[self playSound:eFireOpponent];
	}
	
	// Determine whether someone gets destroyed
	if (ship.Hull <= 0 && Opponent.Hull <= 0)
	{
		autoAttack = false;
		autoFlee = false;
		
		if (escapePod)
		{
			[self EscapeWithPod];
			return( true );
		}
		else
		{
			// TODO: 
			[self FrmAlert:@"BothDestroyedAlert"];
			[self showDestroyedShipWindow];
			//CurForm = DestroyedForm;
			//FrmGotoForm( CurForm );
		}
		return false;
	}
	else if (Opponent.Hull <= 0)
	{
		autoAttack = false;
		autoFlee = false;
		
		/*
		if (ENCOUNTERPIRATE( encounterType ) && Opponent.Type != MANTISTYPE && policeRecordScore >= DUBIOUSSCORE)
		{
			NSString * str = [NSString stringWithFormat:@"You earned a bounty of %i cr.", [self GetBounty:&Opponent]];
			[self FrmAlert:str];
		}
		else
		{
			[self FrmAlert:@"OpponentDestroyedAlert"];
		}
		 */
		
		if (ENCOUNTERPOLICE( encounterType ))
		{
			++policeKills;
			policeRecordScore += KILLPOLICESCORE;
		}
		else if (ENCOUNTERFAMOUS( encounterType))
		{
			if (reputationScore < DANGEROUSREP)
			{
				reputationScore = DANGEROUSREP;
			}
			else
			{
				reputationScore += 100;
			}
			// bump news flag from attacked to ship destroyed
			[self replaceNewsEvent:[self latestNewsEvent] replacementEventFlag:([self latestNewsEvent] + 10)];
			
		}
		else if (ENCOUNTERPIRATE( encounterType ))
		{
			if (Opponent.Type != MANTISTYPE)
			{
				//				Credits += Shiptype[Opponent.Type].Bounty;
				credits += [self GetBounty:&Opponent];
				policeRecordScore += KILLPIRATESCORE;
				[self Scoop];
				reputationScore += 1 + (Opponent.Type>>1);
				return true;				
			}
			++pirateKills;
		}
		else if (ENCOUNTERTRADER( encounterType ))
		{
			++traderKills;
			policeRecordScore += KILLTRADERSCORE;
			[self Scoop];
			reputationScore += 1 + (Opponent.Type>>1);
			return true;
		}
		else if (ENCOUNTERMONSTER( encounterType ))
		{
			++pirateKills;
			policeRecordScore += KILLPIRATESCORE;
			monsterStatus = 2;
		}
		else if (ENCOUNTERDRAGONFLY( encounterType ))
		{
			++pirateKills;
			policeRecordScore += KILLPIRATESCORE;
			dragonflyStatus = 5;
		}
		else if (ENCOUNTERSCARAB( encounterType ))
		{
			++pirateKills;
			policeRecordScore += KILLPIRATESCORE;
			scarabStatus = 2;
		}
		reputationScore += 1 + (Opponent.Type>>1);
		return false;
	}
	else if (ship.Hull <= 0)
	{
		autoAttack = false;
		autoFlee = false;
		
		if (escapePod)
		{
			[self EscapeWithPod];
			return( true );
		}
		else
		{
			[self FrmAlert:@"ShipDestroyedAlert"];
			[self showDestroyedShipWindow];

		}
		return false;
	}
	
	// Determine whether someone gets away.
	if (CommanderFlees)
	{
		if (gameDifficulty == BEGINNER)
		{
			autoAttack = false;
			autoFlee = false;
			
			[self FrmAlert: @"YouEscapedAlert"];

			if (ENCOUNTERMONSTER( encounterType ))
				monsterHull = Opponent.Hull;
			
			return false;
		}
		else if ((GetRandom( 7 ) + ([self PilotSkill: &ship] / 3)) * 2 >= 
				 GetRandom( [self PilotSkill: &Opponent ] ) * (2 + gameDifficulty))
		{
			autoAttack = false;
			autoFlee = false;
			if (CommanderGotHit)
			{
				[self ShowShip:&ship offset:6 commandersShip:true];
				// TODO: frmP = FrmGetActiveForm();
				//for (i=0; i<TRIBBLESONSCREEN; ++i)
				//{
				//	objindex = FrmGetObjectIndex( frmP, EncounterTribble0Button + i );
				//	cp = (ControlPtr)FrmGetObjectPtr( frmP, objindex );
				//	CtlDrawControl( cp );
				//}
				[self FrmAlert:@"YouEscapedWithDamageAlert"];

			}
			else

				[self FrmAlert:@"YouEscapedAlert"];
			;
			if (ENCOUNTERMONSTER( encounterType ))
				monsterHull = Opponent.Hull;
			
			return false;
		}
	}
	else if (encounterType == POLICEFLEE || encounterType == TRADERFLEE ||
			 encounterType == PIRATEFLEE || encounterType == TRADERSURRENDER ||
			 encounterType == PIRATESURRENDER)	
	{
		if (4*GetRandom( [self PilotSkill:&ship] ) <= 
			GetRandom( (07 + ([self PilotSkill:&Opponent] / 3))) * 2)
		{
			autoAttack = false;
			autoFlee = false;

			[self FrmAlert:@"OpponentEscapedAlert"];
			return false;
		}
	}
	
	// Determine whether the opponent's actions must be changed
	PrevencounterType = encounterType;
	
	if (Opponent.Hull < OpponentHull)
	{
		if (ENCOUNTERPOLICE( encounterType ))
		{
			if (Opponent.Hull < OpponentHull >> 1)
				if (ship.Hull < ShipHull >> 1)
				{
					if (GetRandom( 10 ) > 5)
						encounterType = POLICEFLEE;
				}	
				else
					encounterType = POLICEFLEE;
		}
		else if (encounterType == POSTMARIEPOLICEENCOUNTER)
		{
			encounterType = POLICEATTACK;
		}
		else if (ENCOUNTERPIRATE( encounterType ))
		{
			if (Opponent.Hull < (OpponentHull * 2) / 3)
			{
				if (ship.Hull < (ShipHull * 2) / 3)
				{
					if (GetRandom( 10 ) > 3)
						encounterType = PIRATEFLEE;
				}
				else
				{
					
					encounterType = PIRATEFLEE;
					if (GetRandom( 10 ) > 8 && Opponent.Type < MAXSHIPTYPE)
						encounterType = PIRATESURRENDER;
				}
			}
		}
		else if (ENCOUNTERTRADER( encounterType ))
		{
			if (Opponent.Hull < (OpponentHull * 2) / 3)
			{
				if (GetRandom( 10 ) > 3)
					encounterType = TRADERSURRENDER;
				else
					encounterType = TRADERFLEE;
			}
			else if (Opponent.Hull < (OpponentHull * 9) / 10)
			{
				if (ship.Hull < (ShipHull * 2) / 3)
				{
					// If you get damaged a lot, the trader tends to keep shooting
					if (GetRandom( 10 ) > 7)
						encounterType = TRADERFLEE;
				}
				else if (ship.Hull < (ShipHull * 9) / 10)
				{
					if (GetRandom( 10 ) > 3)
						encounterType = TRADERFLEE;
				}
				else
					encounterType = TRADERFLEE;
			}
		}
	}
	
	if (PrevencounterType != encounterType)
	{
		if (!(autoAttack &&
			  (encounterType == TRADERFLEE || encounterType == PIRATEFLEE || encounterType == POLICEFLEE)))
			autoAttack = false;
		autoFlee = false;
	}
	
	NSString * str = @"";
	if (ENCOUNTERPOLICE( PrevencounterType ))
	 	str =@"police ship";
	else if (ENCOUNTERPIRATE( PrevencounterType ))
	{
		if (Opponent.Type == MANTISTYPE)
	 		str =@"alien ship";
		else	
	 		str =@"pirate ship";
	}
	else if (ENCOUNTERTRADER( PrevencounterType ))
	 	str =@"trader ship";
	else if (ENCOUNTERMONSTER( PrevencounterType ))
	 	str =@"monster";
	else if (ENCOUNTERDRAGONFLY( PrevencounterType ))
	 	str =@"Dragonfly";
	else if (ENCOUNTERSCARAB( PrevencounterType ))
	 	str =@"Scarab";
	else if (ENCOUNTERFAMOUS( PrevencounterType))
	 	str =@"Captain";
	
	// TODO: y = 75;
	NSString * final, *final1, *final2;
	final =@"";
	final1 =@"";
	final2 =@"";	
	if (CommanderGotHit)
	{
		final1 = [NSString stringWithFormat:@"The %@ hits you.", str];
	} 
	
	if (!(PrevencounterType == POLICEFLEE || PrevencounterType == TRADERFLEE ||
		  PrevencounterType == PIRATEFLEE) && !CommanderGotHit)
	{
		final1 = [NSString stringWithFormat:@"The %@ missed you.", str];		
	}
	
	if (OpponentGotHit)
	{//TODO:
		final = [NSString stringWithFormat:@"You hit the %@.", str];
		
	}
	
	if (!CommanderFlees && !OpponentGotHit)
	{
		final = [NSString stringWithFormat:@"You missed the %@.", str];		
		
	}
	
	if (PrevencounterType == POLICEFLEE || PrevencounterType == TRADERFLEE ||
		PrevencounterType == PIRATEFLEE)	
	{
		final2 = [NSString stringWithFormat:@"The %@ didn't get away.", str];
		
	}
	
	if (CommanderFlees)
	{
		final2 = [NSString stringWithFormat:@"The %@ is still following you.", str];
		
	}
	
	final = [NSString stringWithFormat:@"%@\n%@\n%@.", final1, final, final2];
	
	[self EncounterDisplayNextAction: false];
	[encounterViewControllerInstance SetLabelText:final];

	return true;
}


// *************************************************************************
// Determines if a given ship is carrying items that can be bought or sold
// in a specified system.
// *************************************************************************
-(bool) HasTradeableItems: (struct SHIP*)sh  theSystem: (Byte) theSystem Operation:(Byte) Operation
{
	int i;
	Boolean ret = false, thisRet;
	for (i = 0; i< MAXTRADEITEM; i++)
	{
		// trade only if trader is selling and the item has a buy price on the
		// local system, or trader is buying, and there is a sell price on the
		// local system.
		thisRet = false;
		if (sh->Cargo[i] > 0 && Operation == TRADERSELL && BuyPrice[i] > 0)
			thisRet = true;
		else if (sh->Cargo[i] > 0 && Operation == TRADERBUY && SellPrice[i] > 0)
			thisRet = true;
		
		// Criminals can only buy or sell illegal goods, Noncriminals cannot buy
		// or sell such items.
		if (policeRecordScore < DUBIOUSSCORE && i != FIREARMS && i != NARCOTICS)
		    thisRet = false;
		else if (policeRecordScore >= DUBIOUSSCORE && (i == FIREARMS || i == NARCOTICS))
		    thisRet = false;
		
		if (thisRet)
			ret = true;
		
		
	}
	
	return ret;
}

// *************************************************************************
// Repair Ship for Amount credits
// *************************************************************************
-(void) buyRepairs:( int) Amount 
{
	int MaxRepairs;
	int Percentage;
	
	MaxRepairs = ([self GetHullStrength] - ship.Hull) * 
	Shiptype[ship.Type].RepairCosts;
	if (Amount > MaxRepairs)
		Amount = MaxRepairs;
	if (Amount > credits)
		Amount = credits;
	
	Percentage = Amount / Shiptype[ship.Type].RepairCosts;
	
	ship.Hull += Percentage;
	credits -= Percentage * Shiptype[ship.Type].RepairCosts;
}

sellCargoViewController * jettisonViewControllerInstance;
sellCargoViewController * opponentViewControllerInstance;

-(void) showJettisonForm
{
	if (jettisonViewControllerInstance == 0) {
		jettisonViewControllerInstance = [[sellCargoViewController alloc] initWithNibName:@"sellCargo" bundle:nil];
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[app.window addSubview:[jettisonViewControllerInstance view]];
		
		[jettisonViewControllerInstance setJettisonType];
	} else {
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[app.window addSubview:[jettisonViewControllerInstance view]];
		
	}
}

-(void) showOpponentForm
{
	if (opponentViewControllerInstance == 0) {
		opponentViewControllerInstance = [[sellCargoViewController alloc] initWithNibName:@"sellCargo" bundle:nil];
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[app.window addSubview:[opponentViewControllerInstance view]];
		
		[opponentViewControllerInstance setOpponentType];
	} else {
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[app.window addSubview:[opponentViewControllerInstance view]];
		
	}
}

-(void) showEncounteredWindow
{
	if (bWaitFinishPlunder) 
		return;
	// show encounter window
	if (!encounterWindow) {
		if (encounterViewControllerInstance == 0)
			encounterViewControllerInstance = [[encounterViewController alloc] initWithNibName:@"encounter" bundle:nil];
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		[app.window addSubview:[encounterViewControllerInstance view]];
		encounterWindow = true;
	}
}

// *************************************************************************
// Travelling to the target system
// *************************************************************************
-(void) Travel 
{
	int EncounterTest, StartClicks, i, j, Repairs, FirstEmptySlot, rareEncounter;
	Boolean Pirate, Trader, Police, Mantis, TryAutoRepair, FoodOnBoard, EasterEgg;
	Boolean HaveMilitaryLaser, HaveReflectiveShield;
	long previousTribbles;
	
	if (bWaitFinishPlunder)
		return;
	
	if (clicks < 0)
		return;
	//bLastMessage = true;
	Pirate = false;
	Trader = false;
	Police = false;
	Mantis = false;
	HaveMilitaryLaser = [self HasWeapon:&ship Cg:MILITARYLASERWEAPON exactCompare:true];
	HaveReflectiveShield = [self HasShield:&ship Cg:REFLECTIVESHIELD];
	
	// if timespace is ripped, we may switch the warp system here.
	if (possibleToGoThroughRip &&
	    experimentStatus == 12 && fabricRipProbability > 0 &&
	    (GetRandom(100) < fabricRipProbability || fabricRipProbability == 25))
	{
		[self FrmAlert:@"FlyInFabricRipAlert"];
		warpSystem = GetRandom(MAXSOLARSYSTEM);
	}
	
	possibleToGoThroughRip=false;
	
	StartClicks = clicks;
	--clicks;
	firstEncounter = true;
	
	
	while (clicks > 0)
	{
		// Engineer may do some repairs
		Repairs = GetRandom( [self EngineerSkill:&ship] ) >> 1;
		ship.Hull += Repairs;
		if (ship.Hull > [self GetHullStrength])
		{
			Repairs = ship.Hull - [self GetHullStrength];
			ship.Hull = [self GetHullStrength];
		}
		else
			Repairs = 0;
		
		// Shields are easier to repair
		Repairs = 2 * Repairs;
		for (i=0; i<MAXSHIELD; ++i)
		{
			if (ship.Shield[i] < 0)
				break;
			ship.ShieldStrength[i] += Repairs;
			if (ship.ShieldStrength[i] > Shieldtype[ship.Shield[i]].Power)
			{
				Repairs = ship.ShieldStrength[i] - Shieldtype[ship.Shield[i]].Power;
				ship.ShieldStrength[i] = Shieldtype[ship.Shield[i]].Power;
			}
			else
				Repairs = 0;
		}
		
		// Encounter with space monster
		if ((clicks == 1) && (warpSystem == ACAMARSYSTEM) && (monsterStatus == 1))
		{
			//MemMove( &Opponent, &SpaceMonster, sizeof( Opponent ) );
			memcpy(&Opponent, &SpaceMonster, sizeof(SHIP));
			//Opponent = SpaceMonster;
			Opponent.Hull = monsterHull;
			Mercenary[Opponent.Crew[0]].Pilot = 8 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Fighter = 8 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Trader = 1;
			Mercenary[Opponent.Crew[0]].Engineer = 1 + gameDifficulty;
			if ([self Cloaked:&ship  b:&Opponent])
				encounterType = SPACEMONSTERIGNORE;
			else
				encounterType = SPACEMONSTERATTACK;
			
			[self showEncounteredWindow];
			return;
		}
		
		// Encounter with the stolen Scarab
		if (clicks == 20 && solarSystem[warpSystem].Special == SCARABDESTROYED &&
			scarabStatus == 1 && arrivedViaWormhole)
 		{
			//MemMove( &Opponent, &Scarab, sizeof( Opponent ) );
			memcpy(&Opponent, &Scarab, sizeof( Opponent ) );
			Mercenary[Opponent.Crew[0]].Pilot = 5 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Fighter = 6 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Trader = 1;
			Mercenary[Opponent.Crew[0]].Engineer = 6 + gameDifficulty;
			if ([self Cloaked:&ship b:&Opponent])
				encounterType = SCARABIGNORE;
			else
				encounterType = SCARABATTACK;

			return;
		} 
		// Encounter with stolen Dragonfly
		if ((clicks == 1) && (warpSystem == ZALKONSYSTEM) && (dragonflyStatus == 4))
		{
			//MemMove( &Opponent, &Dragonfly, sizeof( Opponent ) );
			memcpy( &Opponent, &Dragonfly, sizeof( Opponent ) );
			
			Mercenary[Opponent.Crew[0]].Pilot = 4 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Fighter = 6 + gameDifficulty;
			Mercenary[Opponent.Crew[0]].Trader = 1;
			Mercenary[Opponent.Crew[0]].Engineer = 6 + gameDifficulty;
			if ([self Cloaked:&ship b:&Opponent])
				encounterType = DRAGONFLYIGNORE;
			else
				encounterType = DRAGONFLYATTACK;
			[self showEncounteredWindow];
			return;
		}
		
		if (warpSystem == GEMULONSYSTEM && invasionStatus > 7)
		{
			if (GetRandom( 10 ) > 4)
				Mantis = true;
		}
		else
		{
			// Check if it is time for an encounter
			EncounterTest = GetRandom( 44 - (2 * gameDifficulty) );
			
			// encounters are half as likely if you're in a flea.
			if (ship.Type == 0)
				EncounterTest *= 2;
			
			if (EncounterTest < Politics[solarSystem[warpSystem].Politics].StrengthPirates &&
				!raided) // When you are already raided, other pirates have little to gain
				Pirate = true;
			else if (EncounterTest < 
					 Politics[solarSystem[warpSystem].Politics].StrengthPirates +
					 STRENGTHPOLICE( warpSystem ))
				// StrengthPolice adapts itself to your criminal record: you'll
				// encounter more police if you are a hardened criminal.
				Police = true;
			else if (EncounterTest < 
					 Politics[solarSystem[warpSystem].Politics].StrengthPirates +
					 STRENGTHPOLICE( warpSystem ) +
					 Politics[solarSystem[warpSystem].Politics].StrengthTraders)
				Trader = true;
			else if (wildStatus == 1 && warpSystem == KRAVATSYSTEM)
			{
				// if you're coming in to Kravat & you have Wild onboard, there'll be swarms o' cops.
				rareEncounter = GetRandom(100);
				if (gameDifficulty <= EASY && rareEncounter < 25)
				{
					Police = true;
				}
				else if (gameDifficulty == NORMAL && rareEncounter < 33)
				{
					Police = true;
				}
				else if (gameDifficulty > NORMAL && rareEncounter < 50)
				{
					Police = true;
				}
			}	
			if (!(Trader || Police || Pirate))
				if (artifactOnBoard && GetRandom( 20 ) <= 3)
					Mantis = true;
		}
		
		// Encounter with police
		if (Police)
		{
			if (firstEncounter) {
				[self playSound:ePoliceEncounter];
				firstEncounter = false;
			}

			[self GenerateOpponent: POLICE ];
			encounterType = POLICEIGNORE;
			// If you are cloaked, they don't see you
			if ([self Cloaked:&ship b:&Opponent])
				encounterType = POLICEIGNORE;
			else if (policeRecordScore < DUBIOUSSCORE)
			{
				// If you're a criminal, the police will tend to attack
				if ([self TotalWeapons:&Opponent minWeapon:-1 maxWeapon:-1] <= 0)
				{
					if ([self Cloaked:&Opponent b:&ship])
						encounterType = POLICEIGNORE;
					else
						encounterType = POLICEFLEE;
				}
				if (reputationScore < AVERAGESCORE)
					encounterType = POLICEATTACK;
				else if (GetRandom( ELITESCORE ) > (reputationScore / (1 + Opponent.Type)))
					encounterType = POLICEATTACK;
				else if ([self Cloaked:&Opponent b:&ship])
					encounterType = POLICEIGNORE;
				else
					encounterType = POLICEFLEE;
			}
			else if (policeRecordScore >= DUBIOUSSCORE && 
					 policeRecordScore < CLEANSCORE && !inspected)
			{
				// If you're reputation is dubious, the police will inspect you
				encounterType = POLICEINSPECTION;
				inspected = true;
			}
			else if (policeRecordScore < LAWFULSCORE)
			{
				// If your record is clean, the police will inspect you with a chance of 10% on Normal
				if (GetRandom( 12 - gameDifficulty ) < 1 && !inspected)
				{
					encounterType = POLICEINSPECTION;
					inspected = true;
				}
			}
			else
			{
				// If your record indicates you are a lawful trader, the chance on inspection drops to 2.5%
				if (GetRandom( 40 ) == 1 && !inspected)
				{
					encounterType = POLICEINSPECTION;
					inspected = true;
				}
			}
			
			// if you're suddenly stuck in a lousy ship, Police won't flee even if you
			// have a fearsome reputation.
			if (encounterType == POLICEFLEE && Opponent.Type > ship.Type)
			{
				if (policeRecordScore < DUBIOUSSCORE)
				{
					encounterType = POLICEATTACK;
				}
				else
				{
					encounterType = POLICEINSPECTION;
				}
			}
			
			// If they ignore you and you can't see them, the encounter doesn't take place
			if (encounterType == POLICEIGNORE && [self Cloaked:&Opponent b:&ship])
			{
				--clicks;
				continue;
			}
			
			
			// If you automatically don't want to confront someone who ignores you, the
			// encounter may not take place
			if (alwaysIgnorePolice && (encounterType == POLICEIGNORE || 
									   encounterType == POLICEFLEE))
			{
				--clicks;
				continue;
			}
			
			[self showEncounteredWindow];
			return;
		}
		// Encounter with pirate
		else if (Pirate || Mantis)
		{
			if (Mantis)
				[self GenerateOpponent:MANTIS];
			else
				[self GenerateOpponent:PIRATE];
			
			// If you have a cloak, they don't see you
			if ([self Cloaked:&ship b:&Opponent])
				encounterType = PIRATEIGNORE;
			
			// Pirates will mostly attack, but they are cowardly: if your rep is too high, they tend to flee
			else if (Opponent.Type >= 7 ||
					 GetRandom( ELITESCORE ) > (reputationScore * 4) / (1 + Opponent.Type))
				encounterType = PIRATEATTACK;
			else
				encounterType = PIRATEFLEE;
			
			if (Mantis)
				encounterType = PIRATEATTACK;
			
			// if Pirates are in a better ship, they won't flee, even if you have a very scary
			// reputation.
			if (encounterType == PIRATEFLEE && Opponent.Type > ship.Type)
			{
				encounterType = PIRATEATTACK;
			}
			
			
			// If they ignore you or flee and you can't see them, the encounter doesn't take place
			if ((encounterType == PIRATEIGNORE || encounterType == PIRATEFLEE) && 
				[self Cloaked:&Opponent b:&ship])
			{
				--clicks;
				continue;
			}
			if (alwaysIgnorePirates && (encounterType == PIRATEIGNORE ||
										encounterType == PIRATEFLEE))
			{
				--clicks;
				continue;
			}
			[self showEncounteredWindow];
			return;
		}
		// Encounter with trader
		else if (Trader)
		{	
			[self GenerateOpponent: TRADER];
			encounterType = TRADERIGNORE;
			// If you are cloaked, they don't see you
			if ([self Cloaked:&ship b:&Opponent])
				encounterType = TRADERIGNORE;
			// If you're a criminal, traders tend to flee if you've got at least some reputation
			else if (policeRecordScore <= CRIMINALSCORE)
			{
				if (GetRandom( ELITESCORE ) <= (reputationScore * 10) / (1 + Opponent.Type))
				{
					if ([self Cloaked:&Opponent b:&ship])
						encounterType = TRADERIGNORE;
					else
						encounterType = TRADERFLEE;
				}
			}
			
			// Will there be trade in orbit?
			if (encounterType == TRADERIGNORE && (GetRandom(1000) < ChanceOfTradeInOrbit))
			{
				if ([self filledCargoBays] < [self totalCargoBays] &&
				    [self HasTradeableItems:&Opponent theSystem:warpSystem Operation:TRADERSELL])
					encounterType = TRADERSELL;
				
				// we fudge on whether the trader has capacity to carry the stuff he's buying.
				if ( [self HasTradeableItems:&Opponent theSystem:warpSystem Operation:TRADERBUY] && encounterType != TRADERSELL)
					encounterType = TRADERBUY;
			}
			
			// If they ignore you and you can't see them, the encounter doesn't take place
			if ((encounterType == TRADERIGNORE || encounterType == TRADERFLEE ||
				 encounterType == TRADERSELL || encounterType == TRADERBUY) && 
				[self Cloaked:&Opponent b:&ship])
			{
				--clicks;
				continue;
			}
			// pay attention to user's prefs with regard to ignoring traders
			if (alwaysIgnoreTraders && (encounterType == TRADERIGNORE ||
										encounterType == TRADERFLEE))
			{
				--clicks;
				continue;
			}
			// pay attention to user's prefs with regard to ignoring trade in orbit
			if (alwaysIgnoreTradeInOrbit && (encounterType == TRADERBUY ||
											 encounterType == TRADERSELL))
			{
				--clicks;
				continue;
			}
			
			[self showEncounteredWindow];
			return;
		}
		// Very Rare Random Events:
		// 1. Encounter the abandoned Marie Celeste, which you may loot.
		// 2. Captain Ahab will trade your Reflective Shield for skill points in Piloting.
		// 3. Captain Conrad will trade your Military Laser for skill points in Engineering.
		// 4. Captain Huie will trade your Military Laser for points in Trading.
		// 5. Encounter an out-of-date bottle of Captain Marmoset's Skill Tonic. This
		//    will affect skills depending on game difficulty level.
		// 6. Encounter a good bottle of Captain Marmoset's Skill Tonic, which will invoke
		//    IncreaseRandomSkill one or two times, depending on game difficulty.
		else if ((days > 10) && (GetRandom(1000) < chanceOfVeryRareEncounter ))
		{
			rareEncounter = GetRandom(MAXVERYRAREENCOUNTER);
			
			switch (rareEncounter)
			{
				case MARIECELESTE:
					if (!(veryRareEncounter & (Byte)ALREADYMARIE))
					{
						veryRareEncounter += ALREADYMARIE;
						encounterType = MARIECELESTEENCOUNTER;
						[self GenerateOpponent:TRADER];
						for (i=0;i<MAXTRADEITEM;i++)
						{
							Opponent.Cargo[i]=0;
						}
						Opponent.Cargo[NARCOTICS] = min(Shiptype[Opponent.Type].CargoBays,5);
						[self showEncounteredWindow];
						return;
					}
					break;
					
				case CAPTAINAHAB:
					if (HaveReflectiveShield && pilotSkill < 10 &&
					    policeRecordScore > CRIMINALSCORE &&
					    !(veryRareEncounter & (Byte)ALREADYAHAB))
					{
						veryRareEncounter += ALREADYAHAB;
						encounterType = CAPTAINAHABENCOUNTER;
						[self GenerateOpponent:FAMOUSCAPTAIN];
						[self showEncounteredWindow];
						return;
					}
					break;
					
				case CAPTAINCONRAD:
					if (HaveMilitaryLaser && engineerSkill < 10 &&
						policeRecordScore > CRIMINALSCORE &&
					    !(veryRareEncounter & (Byte)ALREADYCONRAD))
					{
						veryRareEncounter += ALREADYCONRAD;
						encounterType = CAPTAINCONRADENCOUNTER;
						[self GenerateOpponent:FAMOUSCAPTAIN];
						[self showEncounteredWindow];
						return;
					}
					break;
					
				case CAPTAINHUIE:
					if (HaveMilitaryLaser && traderSkill < 10 &&
						policeRecordScore > CRIMINALSCORE &&
					    !(veryRareEncounter & (Byte)ALREADYHUIE))
					{
						veryRareEncounter = veryRareEncounter | ALREADYHUIE;
						encounterType = CAPTAINHUIEENCOUNTER;
						[self GenerateOpponent:FAMOUSCAPTAIN];
						[self showEncounteredWindow];
						return;
					}
					break;
				case BOTTLEOLD:
					if  (!(veryRareEncounter & (Byte)ALREADYBOTTLEOLD))
					{
						veryRareEncounter = veryRareEncounter | ALREADYBOTTLEOLD;
						encounterType = BOTTLEOLDENCOUNTER;
						[self GenerateOpponent:TRADER];
						Opponent.Type = BOTTLETYPE;
						Opponent.Hull = 10;
						[self showEncounteredWindow];
						return;
					}
					break;
				case BOTTLEGOOD:
					if  (!(veryRareEncounter & (Byte)ALREADYBOTTLEGOOD))
					{
						veryRareEncounter = veryRareEncounter | ALREADYBOTTLEGOOD;
						encounterType = BOTTLEGOODENCOUNTER;
						[self GenerateOpponent:TRADER];
						Opponent.Type = BOTTLETYPE;
						Opponent.Hull = 10;
						[self showEncounteredWindow];
						return;
					}
					break;
			}
		}
		
		--clicks;
	}
	
	// ah, just when you thought you were gonna get away with it...
	if (justLootedMarie)
	{			
		[self GenerateOpponent:POLICE];
		encounterType = POSTMARIEPOLICEENCOUNTER;
		justLootedMarie = false;
		clicks++;
		[self showEncounteredWindow];
		return;
	}
	
	if(bLastMessage)
		[self FrmAlert: (StartClicks > 20) ? @"UneventfulTripAlert" : @"ArrivalAlert"];
	
	if (debt >= 75000 ) [self FrmAlert:@"DebtWarningAlert"];
	
	// Debt Reminder
	if (debt > 0 && remindLoans && days % 5 == 0)
	{
		//StrIToA(SBuf2, Debt);
		//TODO:FrmCustomAlert( LoanAmountAlert, SBuf2, " ", " ");
	}
	
	[self Arrival];
	
	// Reactor warnings:	
	// now they know the quest has a time constraint!
	if (reactorStatus == 2) [self FrmAlert:@"ReactorConsumeAlert"];
	// better deliver it soon!
	else if (reactorStatus == 16) [self FrmAlert:@"ReactorNoiseAlert"];
	// last warning!
	else if (reactorStatus == 18) [self FrmAlert:@"ReactorSmokeAlert"];
	
	if (reactorStatus == 20)
	{
		[self FrmAlert:@"ReactorMeltdownAlert"];
		reactorStatus = 0;
		if (escapePod)
		{
			[self EscapeWithPod];
			return;
		}
		else
		{
			[self FrmAlert:@"ShipDestroyedAlert"];
			[self showDestroyedShipWindow];

			return;
		}
		
	}
	
	if (trackAutoOff && trackedSystem == currentSystem)
	{
		trackedSystem = -1;
	}
	
	FoodOnBoard = false;
	previousTribbles = ship.Tribbles;
	
	if (ship.Tribbles > 0 && reactorStatus > 0 && reactorStatus < 21)
	{
		ship.Tribbles /= 2;
		if (ship.Tribbles < 10)
		{
			ship.Tribbles = 0;
			[self FrmAlert:@"TribblesAllIrradiatedAlert"];
		}
		else
		{
			[self FrmAlert:@"TribblesIrradiatedAlert"];
		}
	}
	else if (ship.Tribbles > 0 && ship.Cargo[NARCOTICS] > 0)
	{
		ship.Tribbles = 1 + GetRandom( 3 );
		j = 1 + GetRandom( 3 );
		i = min( j, ship.Cargo[NARCOTICS] );
		BuyingPrice[NARCOTICS] = (BuyingPrice[NARCOTICS] * 
								  (ship.Cargo[NARCOTICS] - i)) / ship.Cargo[NARCOTICS];
		ship.Cargo[NARCOTICS] -= i;
		ship.Cargo[FURS] += i;
		[self FrmAlert:@"TribblesAteNarcoticsAlert"];
	}
	else if (ship.Tribbles > 0 && ship.Cargo[FOOD] > 0)
	{
		ship.Tribbles += 100 + GetRandom( ship.Cargo[FOOD] * 100 );
		i = GetRandom( ship.Cargo[FOOD] );
		BuyingPrice[FOOD] = (BuyingPrice[FOOD] * i) / ship.Cargo[FOOD];
		ship.Cargo[FOOD] = i; 
		[self FrmAlert:@"TribblesAteFoodAlert"];
		FoodOnBoard = true;
	}
	
	if (ship.Tribbles > 0 && ship.Tribbles < MAXTRIBBLES)
		ship.Tribbles += 1 + GetRandom( max( 1, (ship.Tribbles >> (FoodOnBoard ? 0 : 1)) ) );
	
	if (ship.Tribbles > MAXTRIBBLES)
		ship.Tribbles = MAXTRIBBLES;
	
	if ((previousTribbles < 100 && ship.Tribbles >= 100) ||
		(previousTribbles < 1000 && ship.Tribbles >= 1000) ||
		(previousTribbles < 10000 && ship.Tribbles >= 10000) ||
		(previousTribbles < 50000 && ship.Tribbles >= 50000))
	{
		[self playSound:eTribble];
		//TODO:if (ship.Tribbles >= MAXTRIBBLES)
		//TODO:	[header appendString:@"a dangerous number of" );
		//TODO:else
		//TODO:	StrPrintF(SBuf, "%ld", Ship.Tribbles);
		//TODO:FrmCustomAlert( TribblesOnBoardAlert, SBuf, NULL, NULL);
	}
	
	tribbleMessage = false;
	
	ship.Hull += GetRandom([self  EngineerSkill: &ship] );
	if (ship.Hull > [self GetHullStrength])
		ship.Hull = [self GetHullStrength];
	
	TryAutoRepair = true;
	if (autoFuel)
	{
		[self BuyFuel:999];
		if ([self getFuel] < [self GetFuelTanks])
		{
			if (autoRepair && ship.Hull < [self GetHullStrength])
			{
				[self FrmAlert:@"NoFullTanksOrRepairsAlert"];
				TryAutoRepair = false;
			}
			else
				[self FrmAlert:@"NoFullTanksAlert"];
			;
		}
	}
	
	if (autoRepair && TryAutoRepair)
	{	
		[self buyRepairs:9999];
		if (ship.Hull < [self  GetHullStrength])
			[self FrmAlert:@"NoFullRepairsAlert"];
	}
	
    /* This Easter Egg gives the commander a Lighting Shield */
	if (currentSystem == OGSYSTEM)
	{
		i = 0;
		EasterEgg = false;
		while (i < MAXTRADEITEM)		
		{
			if (ship.Cargo[i] != 1)
				break;
			++i;
		}
		if (i >= MAXTRADEITEM)
	    {
 		    [self FrmAlert:@"EggAlert"];
			
		    FirstEmptySlot = [self GetFirstEmptySlot: Shiptype[ship.Type].ShieldSlots Item:ship.Shield];
			
            if (FirstEmptySlot >= 0)
            {
		      	ship.Shield[FirstEmptySlot] = LIGHTNINGSHIELD;  
			  	ship.ShieldStrength[FirstEmptySlot] = Shieldtype[LIGHTNINGSHIELD].Power;
		      	EasterEgg = true;
		    }
			
			
		    if (EasterEgg)
		    {
			  	for (i=0; i<MAXTRADEITEM; ++i)
			    {
				 	ship.Cargo[i] = 0;
				 	BuyingPrice[i] = 0;
				}
            }			
		}
	}
	
	
	// It seems a glitch may cause cargo bays to become negative - no idea how...
	//for (i=0; i<MAXTRADEITEM; ++i)
	//	if (ship.Cargo[i] < 0)
	//		ship.Cargo[i] = 0;
	
	//	if (clicks > 0) {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	UIViewController * targetViewController = [[SystemInfoViewController alloc] initWithNibName:@"systemInfo" bundle:nil];
	[[app navigationController] popViewControllerAnimated:NO];
	encounterWindow = false;	
	//[encounterViewControllerInstance release];
	[[app navigationController] pushViewController:targetViewController animated:NO];	
	
	// ADDED
	[targetViewController release];
	
	[self SaveGame:@"Autosave"];
	
	
	//	}
}

// *************************************************************************
// Standard handling of arrival
// *************************************************************************
//-(void) Arrival
//{/
//	currentSystem = warpSystem;
//	[self ShuffleStatus]
///	[self ChangeQuantities];
//	[self DeterminePrices:currentSystem];
// 
// 
// 	alreadyPaidForNewspaper = false;
//	
//}





// *************************************************************************
// Determine first empty slot, return -1 if none
// *************************************************************************
-(int) GetFirstEmptySlot:( char) Slots Item:( int*) Item 
{
	int FirstEmptySlot, j;
	
	FirstEmptySlot = -1;
	for (j=0; j<Slots; ++j)
	{
		if (Item[j] < 0)
		{
			FirstEmptySlot = j;
			break;
		}							
	}
	
	return FirstEmptySlot;
}

-(int)getFuelCost {
	return Shiptype[ship.Type].CostOfFuel;
}

-(int)getRepairCost {
	return Shiptype[ship.Type].RepairCosts;	
}

-(NSString*)getShipName:(Byte)index {
	return [NSString stringWithCString:Shiptype[index].Name];	
//	return [[NSString stringWithCString:Shiptype[index].Name] retain];	
}

-(NSString*)getShipImageName:(Byte)index {
//	return [[NSString stringWithCString:ShipImages[index]] retain];		
	return [NSString stringWithCString:ShipImages[index]];		
}

-(NSString*)getShipImageNameBg:(Byte)index {
	return [NSString stringWithCString:ShipImagesBg[index]];			
//	return [[NSString stringWithCString:ShipImagesBg[index]] retain];			
}

-(NSString*)getShipDamagedImageName:(Byte)index;{
//	return [[NSString stringWithCString:ShipImagesDamaged[index]] retain];			
	return [NSString stringWithCString:ShipImagesDamaged[index]];			
}

-(NSString*)getShipShieldImageName:(Byte)index {
//	return [[NSString stringWithCString:ShipImagesShield[index]] retain];			
	return [NSString stringWithCString:ShipImagesShield[index]];			
}

-(NSString*)getShipSize:(Byte)index {
	return [NSString stringWithCString:SystemSize[Shiptype[index].Size]];	
//	return [[NSString stringWithCString:SystemSize[Shiptype[index].Size]] retain];	
}

-(int)getShipCargoBays:(Byte)index {
	return Shiptype[index].CargoBays;
}

-(int)getShipRange:(Byte)index {
	return Shiptype[index].FuelTanks;	
}

-(int)getShipHullStrength:(Byte)index {
	return Shiptype[index].HullStrength;	
}

-(int)getShipWeaponSlots:(Byte)index {
	return Shiptype[index].WeaponSlots;	
}

-(int)getShipShieldSlots:(Byte)index {
	return Shiptype[index].ShieldSlots;	
}

-(int)getShipGadgetSlots:(Byte)index {
	return Shiptype[index].GadgetSlots;	
}

-(int)getShipCrewQuarters:(Byte)index {
	return Shiptype[index].CrewQuarters;	
}

// *************************************************************************
// Create a new ship.
// *************************************************************************
-(void)createShip:(int) Index 
{
	int i;
	
	ship.Type = Index;
	
	for (i=0; i<MAXWEAPON; ++i)
    {
		ship.Weapon[i] = -1;
    }
	
	for (i=0; i<MAXSHIELD; ++i)
    {
		ship.Shield[i] = -1;
		ship.ShieldStrength[i] = 0;
    }
	
	for (i=0; i<MAXGADGET; ++i)
    {
		ship.Gadget[i] = -1;
    }
	
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		ship.Cargo[i] = 0;
		BuyingPrice[i] = 0;
	}
	
	ship.Fuel = [self GetFuelTanks];
	ship.Hull = Shiptype[ship.Type].HullStrength;
}


// *************************************************************************
// Buy a new ship.
// *************************************************************************
-(void) buyShip:(int) Index 
{
	[self createShip:Index];
	credits -= ShipPrice[Index];
	if (scarabStatus == 3)
		scarabStatus = 0;
	[self playSound:eBuyNewShip];	
}

-(NSString*)getShipPriceStr:(int)index{
	if (ShipPrice[index] == 0 )
		return  [NSString stringWithCString:"not sold"];
//		return  [[NSString stringWithCString:"not sold"] retain];
	
	if (index == ship.Type )
		return  [NSString stringWithCString:"got one"];
//		return  [[NSString stringWithCString:"got one"] retain];
	
	return 	[NSString stringWithFormat:@"%i cr.", ShipPrice[index]];
	//return 	[[NSString stringWithFormat:@"%i cr.", ShipPrice[index]] retain];
	//ShipPrice[index];
}

-(int)getShipPriceInt:(int)index{
	return ShipPrice[index];
}

-(Byte)getCurrentShipType {
	return ship.Type;
}

-(bool)canBuyShip:(int)index {
	int j = 0;
	for (int i = 0; i < MAXCREW; ++i) 
		if (ship.Crew[i] >= 0)
			++j;
	if ((jarekStatus == 1) && (Shiptype[index].CrewQuarters < 2)) {
		
		[self FrmAlert:@"Ambassador Jarek needs Quarters"];
		return false;
	}
	
	if ((wildStatus == 1) && (Shiptype[index].CrewQuarters < 2)) {
		[self FrmAlert:@"Jonathan Wild needs Quarters"];		
		return false;
	}
	
	if (reactorStatus > 0 && reactorStatus < 21) {
		[self FrmAlert:@"Can't sell ship with reactor"];		
		return false;
	}
	
	
	long extra = 0;
	bool hasLightning = false;
	bool hasCompactor = false;
	bool hasMorganLaser = false;
	bool addLightning = false;
	bool addCompactor = false;
	bool addMorganLaser = false;
	
	if ([self HasShield:&ship Cg:LIGHTNINGSHIELD])
	{
		
		if (Shiptype[index].ShieldSlots == 0)
		{
			[self FrmAlert:@"Can't transfer the Lighting Shield"];		
		}
		hasLightning = true;
		extra += 30000;
	}
	
	if ([self HasGadget:&ship Gg:FUELCOMPACTOR])
	{
		if (Shiptype[index].GadgetSlots == 0)
		{
			[self FrmAlert:@"Can't transfer the Fuel Compactor"];					
		}
		hasCompactor = true;
		extra += 20000;
	}
	
	if ([self HasWeapon:&ship Cg:MORGANLASERWEAPON exactCompare:true])
	{
		if (Shiptype[index].WeaponSlots == 0)
		{
			[self FrmAlert:@"Can't transfer the Lighting Shield"];		
			//TODO: can't transfer the Laser
			//FrmCustomAlert(CantTransferSlotAlert, Shiptype[eventP->data.ctlSelect.controlID - 
			//											   BuyShipBuy0Button].Name, "Morgan's Laser", "Weapon");
		}
		extra += 33333;
		hasMorganLaser = true;
	}
	
	if (ShipPrice[index] + extra > [self toSpend])
		// TODO:FrmCustomAlert( CantBuyShipWithEquipmentAlert, SBuf, NULL, NULL );
		;
	
	extra = 0;
	
	if (hasLightning && Shiptype[index].ShieldSlots > 0)
	{
		if (ShipPrice[index] + extra <= [self toSpend])
		{
			// TODO: d = FrmAlert( TransferLightningShieldAlert );
			int d = 1;
			if (d == 0)
			{
				addLightning = true;
				extra += 30000;
			}
		}
		else
		{
			// TODO: FrmCustomAlert ( CantTransferAlert, "Lightning Shield", NULL, NULL );
		}
	}
	
	if (hasCompactor && Shiptype[index].GadgetSlots > 0)
	{
		if (ShipPrice[index] + extra <= [self toSpend])
		{
			// TODO: d = FrmAlert( TransferFuelCompactorAlert );
			int d = 1;
			if (d == 0)
			{
				addCompactor = true;
				extra += 20000;
			}
		}
		else
		{
			//TODO: FrmCustomAlert( CantTransferAlert, "Fuel Compactor", NULL, NULL);
		}
	}
	
	if (hasMorganLaser && Shiptype[index].WeaponSlots > 0)
	{
		if (ShipPrice[index] + extra <= [self toSpend])
		{
			//TODO: d = FrmAlert( TransferMorganLaserAlert );
			int d = 1;
			if (d == 0)
			{
				addMorganLaser = true;
				extra += 33333;
			}
		}
		else
		{
			//TODO: FrmCustomAlert( CantTransferAlert, "Morgan's Laser", NULL, NULL);
		}
	}
	
	
	/*
	 if (ShipPrice[index] + extra > ToSpend())
	 FrmCustomAlert( CantBuyShipWithEquipmentAlert, SBuf, NULL, NULL );
	 
	 */	
	if (j > Shiptype[index].CrewQuarters)
		[self FrmAlert:@"TooManyCrewmembersAlert"];
		
	else
	{
		/*
		 frmP = FrmInitForm( TradeInShipForm );
		 [header appendString:@Shiptype[Ship.Type].Name );
		 StrCat( SBuf, " for a new " );
		 StrCat( SBuf, Shiptype[eventP->data.ctlSelect.controlID - 
		 BuyShipBuy0Button].Name );
		 StrCat( SBuf, "?" );
		 setLabelText( frmP, TradeInShipTradeInShipLabel, SBuf );
		 
		 d = FrmDoDialog( frmP );
		 
		 FrmDeleteForm( frmP );
		 */
		if (addCompactor || addLightning || addMorganLaser)
		{
			//TODO: StrCopy(SBuf, ", and transfer your unique equipment to the new ship?");
		}
		else
		{
			//TODO: StrCopy(SBuf, "?");
		}
		
		//TODO: d = FrmCustomAlert( TradeShipAlert, Shiptype[Ship.Type].Name,
		//		   Shiptype[eventP->data.ctlSelect.controlID -  BuyShipBuy0Button].Name,
		//		   SBuf);
		
		/*
		 if (d == TradeShipYes)
		 {
		 BuyShip( index );
		 Credits -= extra;
		 if (addCompactor)
		 Ship.Gadget[0] = FUELCOMPACTOR;
		 if (addLightning)
		 Ship.Shield[0] = LIGHTNINGSHIELD;
		 if (addMorganLaser)
		 Ship.Weapon[0] = MORGANLASERWEAPON;
		 Ship.Tribbles = 0;
		 CurForm = BuyShipForm;
		 FrmGotoForm( CurForm );
		 }
		 */
	}
	

	
	
	return true;
}

-(bool)isShipCloaked {
	
	return [self Cloaked:&ship b:&Opponent];
}

-(int)getShipOpponentType{
	return Opponent.Type;
}

-(bool)attack
{
	
	
	if ([self TotalWeapons:&ship minWeapon:-1 maxWeapon:-1] <= 0)
	{
		[self FrmAlert: @"NoWeaponsAlert"];
		return true;
	}
	
	if (encounterType == POLICEINSPECTION && ship.Cargo[FIREARMS] <= 0 &&
		ship.Cargo[NARCOTICS] <= 0)
	{
		//TODO:!!!!!!!!!!!!
		//if (FrmAlert( SureToFleeOrBribeAlert ) == SureToFleeOrBribeOKIwont)
		//	return true;
	}
	
	if (ENCOUNTERPOLICE( encounterType ) || encounterType == POSTMARIEPOLICEENCOUNTER)
	{
		// TODO:!!!!!!
		if (policeRecordScore > CRIMINALSCORE)// &&
			[self FrmAlert:@"AttackByAccidentAlert"];// == AttackByAccidentNo)
		//return true;
		if (policeRecordScore > CRIMINALSCORE)
			policeRecordScore = CRIMINALSCORE;
		
		policeRecordScore += ATTACKPOLICESCORE;
		
		if (encounterType == POLICEIGNORE || encounterType == POLICEINSPECTION ||
			encounterType == POSTMARIEPOLICEENCOUNTER)
		{
			encounterType = POLICEATTACK;
		}
	}
	else if (ENCOUNTERPIRATE( encounterType ))
	{
		if (encounterType == PIRATEIGNORE)
			encounterType = PIRATEATTACK;
	}
	else if (ENCOUNTERTRADER( encounterType ))
	{
		if (encounterType == TRADERIGNORE || encounterType == TRADERBUY ||
			encounterType == TRADERSELL)
		{
			if (policeRecordScore >= CLEANSCORE)
			{
				//if (FrmAlert( AttackTraderAlert ) == AttackTraderNo)
				//	return true;
				policeRecordScore = DUBIOUSSCORE;
			}
			else
				policeRecordScore += ATTACKTRADERSCORE;
		}
		if (encounterType != TRADERFLEE)
		{
			if ([self TotalWeapons:&Opponent minWeapon:-1 maxWeapon:-1] <= 0)
				encounterType = TRADERFLEE;
			else if (GetRandom( ELITESCORE ) <= (reputationScore * 10) / (1 + Opponent.Type))
				encounterType = TRADERFLEE;
			else
				encounterType = TRADERATTACK;
		}
	}
	else if (ENCOUNTERMONSTER( encounterType ))
	{
		if (encounterType == SPACEMONSTERIGNORE)
			encounterType = SPACEMONSTERATTACK;
	}
	else if (ENCOUNTERDRAGONFLY( encounterType ))
	{
		if (encounterType == DRAGONFLYIGNORE)
			encounterType = DRAGONFLYATTACK;
	}
	else if (ENCOUNTERSCARAB( encounterType ))
	{
		if (encounterType == SCARABIGNORE)
			encounterType = SCARABATTACK;
	}
	else if (ENCOUNTERFAMOUS( encounterType ))
	{
		//if (encounterType != FAMOUSCAPATTACK &&
		//	FrmAlert( SureToAttackFamousAlert ) == SureToAttackFamousOKIWont)
		//	return true;
		if (policeRecordScore > VILLAINSCORE)
			policeRecordScore = VILLAINSCORE;
		policeRecordScore += ATTACKTRADERSCORE;
		if (encounterType == CAPTAINHUIEENCOUNTER)
			[self addNewsEvent:CAPTAINHUIEATTACKED];
		else if (encounterType == CAPTAINAHABENCOUNTER)
			[self addNewsEvent:CAPTAINAHABATTACKED];
		else if (encounterType == CAPTAINCONRADENCOUNTER)
			[self addNewsEvent:CAPTAINCONRADATTACKED];
		
		encounterType = FAMOUSCAPATTACK;
		
	}
	if (continuous)
		autoAttack = true;
	if ([self ExecuteAction:false])
		return true;
	if (ship.Hull <= 0)
		return true;
	[self Travel];
	
	return false;
}

-(bool) flee
{
	autoAttack = false;
	autoFlee = false;
	
	if (encounterType == POLICEINSPECTION && ship.Cargo[FIREARMS] <= 0 &&
		ship.Cargo[NARCOTICS] <= 0 && wildStatus != 1 && (reactorStatus == 0 || reactorStatus == 21))
	{
		// TODO:!!!
		//if (FrmAlert( SureToFleeOrBribeAlert ) == SureToFleeOrBribeOKIwont)
		//	return true;
	}
	
	if (encounterType == POLICEINSPECTION)
	{
		encounterType = POLICEATTACK;
		if (policeRecordScore > DUBIOUSSCORE)
			policeRecordScore = DUBIOUSSCORE - (gameDifficulty < NORMAL ? 0 : 1);
		else
			policeRecordScore += FLEEFROMINSPECTION;
	}
	else if (encounterType == POSTMARIEPOLICEENCOUNTER)
	{
		//TODO:!!!!
		//if (FrmAlert( SureToFleePostMarieAlert ) != SureToFleePostMarieOKIwont)
		{
			encounterType = POLICEATTACK;
			if (policeRecordScore >= CRIMINALSCORE)
				policeRecordScore = CRIMINALSCORE;
			else
				policeRecordScore += ATTACKPOLICESCORE;
		}
		//else
		//{
		//	return true;
		//}
	}
	
	if (continuous)
		autoFlee = true;
	if ([self ExecuteAction: true])
		return true;
	if (ship.Hull <= 0)
		return true;
	
	[self Travel];
	
	return false;
}

-(bool) ignore
{
	autoAttack = false;
	autoFlee = false;
	[self Travel];
	[encounterViewControllerInstance showEncounterWindow];
	
	return false;
}

// *************************************************************************
// Returns the index of a trade good that is on a given ship that can be
// sold in a given system.
// *************************************************************************
-(int) GetRandomTradeableItem:(struct SHIP *)sh Operation:(Byte) Operation
{
	Boolean looping = true;
	int i=0, j;
	
	while (looping && i < 10) 
	{
		j = GetRandom(MAXTRADEITEM);
		// It's not as ugly as it may look! If the ship has a particulat item, the following
		// conditions must be met for it to be tradeable:
		// if the trader is buying, there must be a valid sale price for that good on the local system
		// if the trader is selling, there must be a valid buy price for that good on the local system
		// if the player is criminal, the good must be illegal
		// if the player is not criminal, the good must be legal 
		if ( (sh->Cargo[j] > 0 && Operation == TRADERSELL && BuyPrice[j] > 0) &&
			((policeRecordScore < DUBIOUSSCORE && (j == FIREARMS || j == NARCOTICS)) ||
			 (policeRecordScore >= DUBIOUSSCORE && j != FIREARMS && j != NARCOTICS)) )
			looping = false;
		else if ( (sh->Cargo[j] > 0 && Operation == TRADERBUY &&  SellPrice[j] > 0)  &&
				 ((policeRecordScore < DUBIOUSSCORE && (j == FIREARMS || j == NARCOTICS)) ||
				  (policeRecordScore >= DUBIOUSSCORE && j != FIREARMS && j != NARCOTICS)) )
			looping = false;
		// alles klar?
		else
		{
			j = -1;
			i++;
		}
	}
	// if we didn't succeed in picking randomly, we'll pick sequentially. We can do this, because
	// this routine is only called if there are tradeable goods.
	if (j == -1)
	{
		j = 0;
		looping = true;
		while (looping)
		{
			// see lengthy comment above.
			if ( (((sh->Cargo[j] > 0) && (Operation == TRADERSELL) &&  (BuyPrice[j] > 0)) ||
				  ((sh->Cargo[j] > 0) && (Operation == TRADERBUY) &&  (SellPrice[j] > 0))) &&
		     	((policeRecordScore < DUBIOUSSCORE && (j == FIREARMS || j == NARCOTICS)) ||
				 (policeRecordScore >= DUBIOUSSCORE && j != FIREARMS && j != NARCOTICS)) )
			    
			{
				looping = false;
			}
			else
			{
				j++;
				if (j == MAXTRADEITEM)
				{
					// this should never happen!
					looping = false;
				}
			}
		}
	}
	return j;
}

// *************************************************************************
// Increase one of the skills of the commander
// *************************************************************************
-(void) IncreaseRandomSkill
{
	Boolean Redo;
	int d, oldtraderskill;
	
	if (pilotSkill >= MAXSKILL && traderSkill >= MAXSKILL &&
		fighterSkill >= MAXSKILL && engineerSkill >= MAXSKILL)
		return;
	
	oldtraderskill = [self TraderSkill:&ship];
	
	Redo = true;
	while (Redo)
	{
		d = (GetRandom( MAXSKILLTYPE ));
		if ((d == 0 && pilotSkill < MAXSKILL) ||
			(d == 1 && fighterSkill < MAXSKILL) ||
			(d == 2 && traderSkill < MAXSKILL) ||
			(d == 3 && engineerSkill < MAXSKILL))
			Redo = false;
	}
	if (d == 0)
		pilotSkill += 1;
	else if (d == 1)
		fighterSkill += 1;
	else if (d == 2)
	{
		traderSkill += 1;
		if (oldtraderskill != [self TraderSkill:&ship])
			[self RecalculateBuyPrices:currentSystem];
	}
	else 
		engineerSkill += 1;
	[self updateMercenary0Data];
}

// *************************************************************************
// Decrease one of the skills of the commander
// *************************************************************************
-(void) DecreaseRandomSkill:(int) amount 
{
	Boolean Redo;
	int d, oldtraderskill;
	
	if (pilotSkill >= MAXSKILL && traderSkill >= MAXSKILL &&
		fighterSkill >= MAXSKILL && engineerSkill >= MAXSKILL)
		return;
	
	oldtraderskill = [self TraderSkill:&ship];
	
	Redo = true;
	while (Redo)
	{
		d = (GetRandom( MAXSKILLTYPE ));
		if ((d == 0 && pilotSkill > amount) ||
			(d == 1 && fighterSkill > amount) ||
			(d == 2 && traderSkill > amount) ||
			(d == 3 && engineerSkill > amount))
			Redo = false;
	}
	if (d == 0)
		pilotSkill -= amount;
	else if (d == 1)
		fighterSkill -= amount;
	else if (d == 2)
	{
		traderSkill -= amount;
		if (oldtraderskill != [self TraderSkill:&ship])
			[self RecalculateBuyPrices:currentSystem];
	}
	else 
		engineerSkill -= amount;
	[self updateMercenary0Data];
}


// *************************************************************************
// Randomly tweak one of the skills of the commander
// *************************************************************************
-(void) TonicTweakRandomSkill
{
	int oldPilot, oldFighter, oldTrader, oldEngineer;
	oldPilot = pilotSkill;
	oldFighter = fighterSkill;
	oldTrader = traderSkill;
	oldEngineer = engineerSkill;
	
	if (gameDifficulty < HARD)
	{
		// add one to a random skill, subtract one from a random skill
		while (	oldPilot == pilotSkill &&
			   oldFighter == fighterSkill &&
			   oldTrader == traderSkill &&
			   oldEngineer == engineerSkill)
		{
			[self IncreaseRandomSkill];
			[self DecreaseRandomSkill:1];
		}
	}
	else
	{
		// add one to two random skills, subtract three from one random skill
		[self IncreaseRandomSkill];
		[self IncreaseRandomSkill];
		[self DecreaseRandomSkill:3];
	}
	[self updateMercenary0Data];
}

-(bool)yieldContinue 
{
	
	if (wildStatus == 1 || (reactorStatus > 0 && reactorStatus < 21))
	{
		[self Arrested];
	}
	else
	{					
		// Police Record becomes dubious, if it wasn't already.
		if (policeRecordScore > DUBIOUSSCORE)
			policeRecordScore = DUBIOUSSCORE;
		ship.Cargo[NARCOTICS]=0;
		ship.Cargo[FIREARMS]=0;
		
		[self FrmAlert:@"YieldNarcoticsAlert"];
	}
	
	[self Travel];
	[encounterViewControllerInstance showEncounterWindow];
	
	return false;
}


-(void) sellCheapestGood {
	int lowestPrice = 10000000;
	int index = 0;
	for (int i = 0; i < MAXTRADEITEM; ++i )
	{
		if (ship.Cargo[i] > 0 && SellPrice[i] < lowestPrice) {
			lowestPrice = SellPrice[i];
			index = i;
		}
	}
	
	ship.Cargo[index] -=1 ;
	[self showPlunderForm:ePickItUp];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	bLastMessage = true;
	int button = buttonIndex;
	
	if (currentState == eTradeInOrbit) {
		
		//		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
		int j = 0;
		if (button == 1) {
			// Ok.
			
			NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
			unsigned int val = value.intValue;
			j = max(0, min(ship.Cargo[activeTradeItem], val));
		} else if (button == 2) {
			
			j = ship.Cargo[activeTradeItem];
		}
		
		j = min( j, Shiptype[Opponent.Type].CargoBays );
		if (j > 0)
		{
			BuyingPrice[activeTradeItem] = BuyingPrice[activeTradeItem]*(ship.Cargo[activeTradeItem]-j)/ship.Cargo[activeTradeItem];
			ship.Cargo[activeTradeItem] -= j;
			Opponent.Cargo[activeTradeItem] = j;
			credits += j * SellPrice[activeTradeItem];
			//FrmCustomAlert(OrbitTradeCompletedAlert,"Thanks for selling us the", Tradeitem[i].Name, " ");
			[self FrmAlertWithTitle:[NSString stringWithFormat:@"Thanks for selling us the %@.", Tradeitem[activeTradeItem].Name ] Title:@"Trade Completed"];
			
		}
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		
	} else
		
		if (currentState == eSellInOrbit) {
			
			int i = activeTradeItem;
			int j = 0;
			if (button == 1) {
				// Ok
				
				NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
				unsigned int val = value.intValue;
				j = max(0, min(Opponent.Cargo[i], val));;
			} else if (button == 2) {
				
				j = min(Opponent.Cargo[i], ([self totalCargoBays]-[self filledCargoBays]));
			}
			
			j = min ( j, (credits / BuyPrice[i]));
			if (j > 0)
			{
				ship.Cargo[i] += j;
				Opponent.Cargo[i] -= j;
				BuyingPrice[i] += (j * BuyPrice[i]);
				credits -= (j * BuyPrice[i]);
				[self FrmAlertWithTitle:[NSString stringWithFormat:@"Thanks for buying the %@.", Tradeitem[activeTradeItem].Name ] Title:@"Trade Completed"];
			}
			
			[self Travel];
			[encounterViewControllerInstance showEncounterWindow];
		} else
			
			
			if (currentState == eYieldChoice) {
				
				if (button == 1) {
					[self yieldContinue];
				}
			}
	
	if (currentState == eSurrender) {
		
		if (button == 0) {
			[self Arrested];
		//	[self Travel];
		//	[encounterViewControllerInstance showEncounterWindow];			
		}
		
	}
	
	if (currentState == eSurrenderArtifact) {
		if (button == 1) {
			artifactOnBoard = 0;
			[self playSound:eAlienReturnArtifact];
		}
	
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
	}
	
	if (currentState == eBottleGood){
		
		if (button == 1)
		{
			// two points if you're on beginner-normal, one otherwise
			[self IncreaseRandomSkill];
			if (gameDifficulty < HARD)
				[self IncreaseRandomSkill];
			[self FrmAlert:@"GoodDrinkAlert"];

		}
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];		
	}
	
	if (currentState == eBottleStrange){
		
		currentState = eBottleStrange;		
		if (button == 1)
		{
			// two points if you're on beginner-normal, one otherwise
			[self TonicTweakRandomSkill];
			[self FrmAlert:@"StrangeDrinkAlert"];
			
		}
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];		
	}
	
	if (currentState == eBoard) {
		if (button == 1) {
			//currentState = ePlunderForm;
			[self showPlunderForm:ePlunderShip];
		}
		/*
		 if (FrmAlert( EngageMarieAlert ) == EngageMarieYesTakeCargo)
		 {
		 CurForm = PlunderForm;
		 FrmGotoForm( CurForm );
		 return true;
		 }
		 */
	}
	
	if (currentState == ePlunderForm) {
		//[self showJettisonForm];
		if (button == 0) {
			currentState = eDummy;
			bWaitFinishPlunder = false;
			[self finishPlunder];
		} else 
			if (button == 1) {
				currentState = eDummy;
				[self showPlunderForm:ePickItUp];				
			}
		
	}
	else
		if (currentState == ePlunderShipForm) {
			//[self showJettisonForm];
		
			if (button == 0) {
				currentState = eDummy;					
				bWaitFinishPlunder = false;
				[self finishPlunder];
			} else 
				if (button == 1) {
					currentState = eDummy;	
					bWaitFinishPlunder = true;
					[self showOpponentForm];
					//[self showPlunderForm:ePickFromShip];
				}
				//
			
		}
		else		
	if (currentState == ePlunderRemoveGoods) {
		currentState = eDummy;		
		if (button == 1) {
			bWaitFinishPlunder = true;
			[self showJettisonForm];
		}
		else //	[self sellCheapestGood]; 
		{
			bWaitFinishPlunder = false;
			[self finishPlunder];
		}
		
	}
	
	if (currentState == eBribePropsal && button == 1) {
		
		button = -1;
		[self bribeContinue];
	}
	
	if (currentState == eBribeOffer && button == 0) 
	{
		if (credits < Bribe)
		{
			[self FrmAlert:@"NoMoneyForBribeAlert"];
			return;
		}
		
		credits -= Bribe;
		
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		// DUKE Says:  Not used and making clang complain.
		//button = -1;
		return;
	}
	
	if (currentState == eSubmit && button == 1)
		[self submitContinue];
	if (currentState == eSubmit && button == 0)
	{
		policeRecordScore += TRAFFICKING; 
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
	}
	
	if (currentState == eEngageCaptainAhabAlert && button == 1)
	{
		// remove the last reflective shield
		int i=MAXSHIELD - 1;
		while (i >= 0)
		{
			if (ship.Shield[i] == REFLECTIVESHIELD)
			{
				for (int m=i+1; m<MAXSHIELD; ++m)
				{
					ship.Shield[m-1] = ship.Shield[m];
					ship.ShieldStrength[m-1] = ship.ShieldStrength[m];
				}
				ship.Shield[MAXSHIELD-1] = -1;
				ship.ShieldStrength[MAXSHIELD-1] = 0;
				i = -1;
			}
			i--;
		}
		// add points to piloting skill
		// two points if you're on beginner-normal, one otherwise
		if (gameDifficulty < HARD)
			pilotSkill += 2;
		else
			pilotSkill += 1;
		
		if (pilotSkill > MAXSKILL)
		{
			pilotSkill = MAXSKILL;
		}
		[self FrmAlert:@"TrainingCompletedAlert"];
		
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		[self updateMercenary0Data];
		return;
	}
	
	
	// Trade a military laser for skill points in engineering?
	if (currentState == eEngageCaptainConradAlert && button == 1)
	{
		// remove the last military laser
		int i=MAXWEAPON - 1;
		while (i>=0)
		{
			if (ship.Weapon[i] == MILITARYLASERWEAPON)
			{
				for (int m=i+1; m<MAXWEAPON; ++m)
				{
					ship.Weapon[m-1] = ship.Weapon[m];
				}
				ship.Weapon[MAXWEAPON-1] = -1;
				i = -1;
			}
			i--;
		}
		// add points to engineering skill
		// two points if you're on beginner-normal, one otherwise
		if (gameDifficulty < HARD)
			engineerSkill += 2;
		else
			engineerSkill += 1;
		
		if (engineerSkill > MAXSKILL)
		{
			engineerSkill = MAXSKILL;
		}
		[self FrmAlert:@"TrainingCompletedAlert"];
		
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		[self updateMercenary0Data];
		return;
		
	}
	
	if (currentState == eEngageCaptainHuieAlert && button == 1)
	{
		// remove the last military laser
		int i=MAXWEAPON - 1;
		while (i>=0)
		{
			if (ship.Weapon[i] == MILITARYLASERWEAPON)
			{
				for (int m=i+1; m<MAXWEAPON; ++m)
				{
					ship.Weapon[m-1] = ship.Weapon[m];
				}
				ship.Weapon[MAXWEAPON-1] = -1;
				i = -1;
			}
			i--;
		}
		// add points to trading skill
		// two points if you're on beginner-normal, one otherwise
		if (gameDifficulty < HARD)
			traderSkill += 2;
		else
			traderSkill += 1;
		
		if (traderSkill > MAXSKILL)
		{
			traderSkill = MAXSKILL;
		}
		[self RecalculateBuyPrices:currentSystem];
		[self FrmAlert:@"TrainingCompletedAlert"];
		
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		[self updateMercenary0Data];
		return;		
	}
	
	if (currentState == eBuyEquipment && button == 1) {
		saveItem[saveSlot] = saveItemIndex;
		credits -= savePrice;
		[self playSound:eBuyShipUpgardes];
		[buyController UpdateView];
	}
	
	if (currentState== eSpecialEvent && (button == 1 || SpecialEvent[CURSYSTEM.Special].JustAMessage)) {
				[systemInfoController UpdateView];
		[self specialEventFormHandleEvent];
				[systemInfoController UpdateView];
	}
	
	if (currentState== eWildWeaponBuy && button == 1) {
		wildStatus = 0;
		[self FrmAlert:@"WildLeavesShipAlert"];
		[self doWarp:viaSingularitySaved];
	}	
	
	if (currentState == eUpdateSpecial) {
		[systemInfoController UpdateView];
	}
}


-(bool)trade 
{
	if (encounterType == TRADERBUY)
	{				
		int i = [self  GetRandomTradeableItem:&ship Operation:TRADERBUY];
		
		if (i == NARCOTICS || i == FIREARMS)
		{
			if (GetRandom(100) <= 45)
				SellPrice[i] *= 0.8;
			else
				SellPrice[i] *= 1.1;
		}
		else
		{
			if (GetRandom(100) <= 10)
				SellPrice[i] *= 0.9;
			else
				SellPrice[i] *= 1.1;
		}
		
		SellPrice[i] /= Tradeitem[i].RoundOff;
		++SellPrice[i];
		SellPrice[i] *= Tradeitem[i].RoundOff;
		if (SellPrice[i] < Tradeitem[i].MinTradePrice)
			SellPrice[i] = Tradeitem[i].MinTradePrice;
		if (SellPrice[i] > Tradeitem[i].MaxTradePrice)
			SellPrice[i] = Tradeitem[i].MaxTradePrice;
		
		
		
		currentState = eTradeInOrbit;
		activeTradeItem = i;
		NSString * message = [NSString stringWithFormat:@"The trader wants to buy %@, and offers %i  cr. each. You have %i unit(s) available. \n \
							  You paid about %i  cr. per unit. How many do you wish to sell?\n\n", Tradeitem[i].Name,SellPrice[i], ship.Cargo[i],
							  BuyingPrice[i] / ship.Cargo[i]];
		
		
		AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Trade in Orbit" yoffset:90 message:message  
																		delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"All"];
		
		[myAlertView show];
		[myAlertView release];		
		
	}
	else if (encounterType == TRADERSELL)
	{				
		int i = [self GetRandomTradeableItem:&Opponent Operation:TRADERSELL];
		
		if (i == NARCOTICS || i == FIREARMS)
		{
			if (GetRandom(100) <= 45)
				BuyPrice[i] *= 1.1;
			else
				BuyPrice[i] *= 0.8;
		}
		else
		{
			if (GetRandom(100) <= 10)
				BuyPrice[i] *= 1.1;
			else
				BuyPrice[i] *= 0.9;
		}
		
		BuyPrice[i] /= Tradeitem[i].RoundOff;
		BuyPrice[i] *= Tradeitem[i].RoundOff;
		if (BuyPrice[i] < Tradeitem[i].MinTradePrice)
			BuyPrice[i] = Tradeitem[i].MinTradePrice;
		if (BuyPrice[i] > Tradeitem[i].MaxTradePrice)
			BuyPrice[i] = Tradeitem[i].MaxTradePrice;
		
		
		currentState = eSellInOrbit;
		activeTradeItem = i;
		NSString * message = [NSString stringWithFormat:@"The trader wants to sell %@, for the price of %i  cr. each. The trader has %i unit(s) for sale. \n \
							  You can afford %i unit(s). How many do you wish to buy?\n\n", Tradeitem[i].Name, BuyPrice[i],  Opponent.Cargo[i],
							  credits / BuyPrice[i]];
		
		
		AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Trade in Orbit" yoffset:90 message:message  
																		delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"All"];
		
		[myAlertView show];
		[myAlertView release];		
		
		
	}
	
	return false;
}

-(bool)yield {
	if (wildStatus == 1)
	{
		currentState = eYieldChoice;
		//if (FrmCustomAlert( WantToSurrenderAlert, "You have Jonathan Wild on board! ", "Wild will be arrested, too. ", NULL ) == WantToSurrenderNo)
		//	return true;
		AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"You have Jonathan Wild on board!" yoffset:90 message:@"Wild will be arrested, too."  
																		delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Yield"  thirdButtonTitle:nil];
		
		[myAlertView show];
		[myAlertView release];		
		return true;
		
	}
	else if (reactorStatus > 0 && reactorStatus < 21)
	{
		currentState = eYieldChoice;		
		//		currentState = eSellInOrbit;
		//		if (FrmCustomAlert( WantToSurrenderAlert, "You have an illegal Reactor on board! ", "They will destroy the reactor. ", NULL) == WantToSurrenderNo)
		//			return true;
		currentState = eYieldChoice;		
		AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"You have an illegal Reactor on board!" yoffset:90 message:@"They will destroy the reactor."  
																		delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Yeild"  thirdButtonTitle:nil];
		
		[myAlertView show];
		[myAlertView release];		
		return true;
		
	}
	
	return [self yieldContinue];
}


-(bool) surrender 
{
	autoAttack = false;
	autoFlee = false;
	
	
	if (Opponent.Type == MANTISTYPE)
	{
		if (artifactOnBoard)
		{
			/*
			 if (FrmAlert( WantToSurrenderToAliensAlert ) == WantToSurrenderToAliensNo)
			 return true;
			 else
			 {
			 [self FrmAlert( ArtifactStolenAlert );
			 ArtifactOnBoard = 0;
			 }
			 */
			currentState = eSurrenderArtifact;		
			UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Surrender!" message:NSLocalizedString(@"WantToSurrenderToAliensAlert", @"")  
																			delegate:self cancelButtonTitle:@"Surrender" otherButtonTitles:@"Cancel",nil];
			
			[myAlertView show];
			[myAlertView release];		
			bLastMessage = false;
		}
		else
		{
			[self FrmAlert:@"NoSurrenderAlert"];
			return true;
		}
	}
	else if (ENCOUNTERPOLICE( encounterType ))
	{
		if (policeRecordScore <= PSYCHOPATHSCORE)
		{
			[self FrmAlert:@"NoSurrenderAlert"];
			return true;
		}
		else
		{
			if (wildStatus == 1)
			{
				currentState = eSurrender;		
				
				UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"You have Jonathan Wild on board!" message:@"Wild will be arrested, too."  
																				delegate:self cancelButtonTitle:@"Surrender" otherButtonTitles:@"Cancel", nil];
				
				[myAlertView show];
				[myAlertView release];		
				bLastMessage = false;
				
				//				if (FrmCustomAlert( WantToSurrenderAlert, "You have Jonathan Wild on board! ", "Wild will be arrested, too. ", NULL ) == WantToSurrenderNo)
				return true;
			}
			else if (reactorStatus > 0 && reactorStatus < 21)
			{
				//				if (FrmCustomAlert( WantToSurrenderAlert, "You have an illegal Reactor on board! ", "They will destroy the reactor. ", NULL) == WantToSurrenderNo)
				currentState = eSurrender;		
				UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"You have an illegal Reactor on board!" message:@"They will destroy the reactor."  
																				delegate:self cancelButtonTitle:@"Surrender" otherButtonTitles:@"Cancel", nil];
				
				[myAlertView show];
				[myAlertView release];		
				bLastMessage = false;
				return true;
			}
			else
			{
				//	if (FrmCustomAlert( WantToSurrenderAlert, NULL, NULL, NULL ) == WantToSurrenderNo)
				currentState = eSurrender;						
				UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Surrender!" message:NSLocalizedString(@"WantToSurrenderAlert", @"")  
																				delegate:self cancelButtonTitle:@"Surrender" otherButtonTitles:@"Cancel", nil];
				
				[myAlertView show];
				[myAlertView release];		
				bLastMessage = false;
				return true;
			}
			
			[self Arrested];
			return true;
		}
	}
	else
	{
		raided = true;
		
		int TotalCargo = 0;
		int i;
		for (i=0; i<MAXTRADEITEM; ++i)
			TotalCargo += ship.Cargo[i];
		if (TotalCargo <= 0)
		{
			int Blackmail = min( 25000, max( 500, [self currentWorth] / 20 ) );
			[self FrmAlert:@"PiratesFindNoCargoAlert"];
			if (credits >= Blackmail)
				credits -= Blackmail;
			else
			{
				
				debt += (Blackmail - credits);
				credits = 0;
			}
		}		
		else
		{	
			
			[self FrmAlert:@"PiratesPlunderAlert"];									
			
			int Bays = Shiptype[Opponent.Type].CargoBays;
			for (i=0; i<MAXGADGET; ++i)
				if (Opponent.Gadget[i] == EXTRABAYS)
					Bays += 5;
			for (i=0; i<MAXTRADEITEM; ++i)
				Bays -= Opponent.Cargo[i];
			
			// Pirates steal everything					
			if (Bays >= TotalCargo)
			{
				for (i=0; i<MAXTRADEITEM; ++i)
				{
					ship.Cargo[i] = 0;
					BuyingPrice[i] = 0;
				}
			}		
			else
			{		
				// Pirates steal a lot
				while (Bays > 0)
				{
					i = GetRandom( MAXTRADEITEM );
					if (ship.Cargo[i] > 0)
					{
						BuyingPrice[i] = (BuyingPrice[i] * (ship.Cargo[i] - 1)) / ship.Cargo[i];
						--ship.Cargo[i];
						--Bays;
					}
				}
			}
		}
		if ((wildStatus == 1) && (Shiptype[Opponent.Type].CrewQuarters > 1))
		{
			// Wild hops onto Pirate Ship
			wildStatus = 0;
			[self FrmAlert:@"WildGoesWithPiratesAlert"];
		}
		else if (wildStatus == 1)
		{
			// no room on pirate ship
			[self FrmAlert:@"WildStaysAboardAlert"];
		}
		if (reactorStatus > 0 && reactorStatus < 21)
		{
			// pirates puzzled by reactor
			[self FrmAlert:@"PiratesDontStealReactorAlert"];
		}
	}
	
	[self Travel];
	[encounterViewControllerInstance showEncounterWindow];
	
	return false;
}

-(bool)bribeContinue
{
	// Bribe depends on how easy it is to bribe the police and commander's current worth
	Bribe = [self currentWorth] / 
	((10L + 5L * (IMPOSSIBLE - gameDifficulty)) * Politics[solarSystem[warpSystem].Politics].BribeLevel);
	if (Bribe % 100 != 0)
		Bribe += (100 - (Bribe % 100));
	if (wildStatus == 1 || (reactorStatus > 0 && reactorStatus < 21))
	{
		if (gameDifficulty <= NORMAL)
			Bribe *= 2;
		else
			Bribe *= 3;
	}
	Bribe = max( 100, min( Bribe, 10000 ) );
	
	
	NSString* str = [NSString stringWithFormat:@"The Police officers are willing to forego inspection for amount of %i credits.", Bribe];
	
	currentState = eBribeOffer;			
	// take the cargo of the Marie Celeste?
	UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Bribe" message:str
																	delegate:self cancelButtonTitle:@"Bribe" otherButtonTitles:@"Cancel",nil];
	
	[myAlertView show];
	[myAlertView release];		
	bLastMessage = false;
	return true;	
	
}


-(bool)bribe {
	autoAttack = false;
	autoFlee = false;
	
	if (Politics[solarSystem[warpSystem].Politics].BribeLevel <= 0)
	{
		[self FrmAlert:@"CantBeBribedAlert"];
		return true;
	}
	
	if (encounterType == POSTMARIEPOLICEENCOUNTER)
	{
		[self FrmAlert:@"MarieCantBeBribedAlert"];
		return true;
	}
	
	if (encounterType == POLICEINSPECTION && ship.Cargo[FIREARMS] <= 0 &&
		ship.Cargo[NARCOTICS] <= 0 && wildStatus != 1)
	{
		currentState = eBribePropsal;			
		// take the cargo of the Marie Celeste?
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Bribe" message:
										  NSLocalizedString(@"SureToFleeOrBribeAlert", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Bribe", nil];
		
		[myAlertView show];
		[myAlertView release];		
		bLastMessage = false;
		return true;
	}
	
	return [self bribeContinue];
	
}


-(bool)submit {
	
	autoAttack = false;
	autoFlee = false;
	
	NSString * str, * str2;
	
	if (encounterType == POLICEINSPECTION && (ship.Cargo[FIREARMS] > 0 ||
											  ship.Cargo[NARCOTICS] > 0 || wildStatus == 1 ||
											  (reactorStatus > 1 && reactorStatus < 21)))
	{
		if (wildStatus == 1)
		{
			if (ship.Cargo[FIREARMS] > 0 || ship.Cargo[NARCOTICS] > 0)
			{
				str = @"Jonathan Wild and illegal goods";
			}
			else
			{
				str = @"Jonathan Wild";
			}
			str2 =@"You will be arrested!";
		}
		else if (reactorStatus > 0 && reactorStatus < 21)
		{
			if (ship.Cargo[FIREARMS] > 0 || ship.Cargo[NARCOTICS] > 0)
			{
				str =@"an illegal Ion Reactor and other illegal goods";
			}
			else
			{
				str =@"an illegal Ion Reactor";
			}
			str2=@"You will be arrested!";
		}
		else
		{
			str=@"illegal goods";
		}
		// DUKE Says:  Since this is not being used maybe should take out all the stuff
		// setting it.  Don't know if there are plans for future use of the above stuff
		// so I just do a reassign to clear some warnings from clang.
		str = str;
		str2 = str2;
		currentState = eSubmit;			
		// take the cargo of the Marie Celeste?
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Encounter" message:
										  NSLocalizedString(@"SureToSubmitAlert", @"") delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Submit",nil];
		
		[myAlertView show];
		[myAlertView release];		
		bLastMessage = false;		
		//		if (FrmCustomAlert( SureToSubmitAlert, SBuf, SBuf2, NULL ) == SureToSubmitNo)
		return true;
		
	}
	return [self submitContinue];	
}

-(bool) submitContinue
{
	
	if ((ship.Cargo[FIREARMS] > 0) || (ship.Cargo[NARCOTICS] > 0))
	{
		// If you carry illegal goods, they are impounded and you are fined
		ship.Cargo[FIREARMS] = 0;
		BuyingPrice[FIREARMS] = 0;
		ship.Cargo[NARCOTICS] = 0;
		BuyingPrice[NARCOTICS] = 0;
		int Fine = [self currentWorth] / ((IMPOSSIBLE+2-gameDifficulty) * 10L);
		if (Fine % 50 != 0)
			Fine += (50 - (Fine % 50));
		Fine = max( 100, min( Fine, 10000 ) );
		if (credits >= Fine)
			credits -= Fine;
		else
		{
			debt += (Fine - credits);
			credits = 0;
		}
		
		
		
		NSString* str = [NSString stringWithFormat:@"The Police discovers illegal goods in your cargo holds. These goods will be impounded and you are fined of %i credits.", Fine];
		[self FrmAlert:str];		
		
		policeRecordScore += TRAFFICKING;
	}
	else if (wildStatus != 1)
	{
		// If you aren't carrying illegal goods, the police will increase your lawfulness record
		[self FrmAlert:@"NoIllegalGoodsAlert"];
		policeRecordScore -= TRAFFICKING;
	}
	if (wildStatus == 1)
	{
		// Jonathan Wild Captured, and your status damaged.
		[self Arrested];
		return true;
	}
	if (reactorStatus > 0 && reactorStatus < 21)
	{
		// Police confiscate the Reactor.
		// Of course, this can only happen if somehow your
		// Police Score gets repaired while you have the
		// reactor on board -- otherwise you'll be arrested
		// before we get to this point. (no longer true - 25 August 2002)
		[self FrmAlert:@"PoliceConfiscateReactorAlert"];
		reactorStatus = 0;
		
	}	
	
	
	
	[self Travel];
	[encounterViewControllerInstance showEncounterWindow];
	
	return false;
	
}

-(bool)plunder
{
	autoAttack = false;
	autoFlee = false;
	
	if (ENCOUNTERTRADER( encounterType ))
		policeRecordScore += PLUNDERTRADERSCORE;
	else
		policeRecordScore += PLUNDERPIRATESCORE;
	
	[self showPlunderForm:ePlunderShip];
	
	return true;
}

-(bool)interrupt 
{
	autoFlee = false;
	autoAttack = false;
	//[self Travel];
	//[encounterViewControllerInstance showEncounterWindow];
	
	return false;	
}

-(bool)meet {
	
	
	//"Meet Captain Ahab", "Captain Ahab is in need of a spare shield for an upcoming mission. He offsers to trade you some piloting lessons for ypur reflective shild. Do you wish to trade?", "YEs, Trdae shield", "No"
	
	if (encounterType == CAPTAINAHABENCOUNTER)
	{
		
		currentState = eEngageCaptainAhabAlert;
		[self FrmAlertWithState:@"EngageCaptainAhabAlert" state:eEngageCaptainAhabAlert];
		// Trade a reflective shield for skill points in piloting?
	}
	else if (encounterType == CAPTAINCONRADENCOUNTER)
	{
		
		currentState = eEngageCaptainConradAlert;
		[self FrmAlertWithState:@"EngageCaptainConradAlert"  state:eEngageCaptainConradAlert];
	}
	else if (encounterType == CAPTAINHUIEENCOUNTER)
	{
		currentState = eEngageCaptainHuieAlert;
		[self FrmAlertWithState:@"EngageCaptainHuieAlert" state:eEngageCaptainHuieAlert];
		// Trade a military laser for skill points in trading?
	}
	
	
	//[self Travel];
	//[encounterViewControllerInstance showEncounterWindow];
	
	return true;
}

-(bool)board {
	
	if (encounterType == MARIECELESTEENCOUNTER)
	{
		currentState = eBoard;			
		// take the cargo of the Marie Celeste?
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Encounter"  message:
										  NSLocalizedString(@"EngageMarieAlert", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Cargo",nil];
		
		[myAlertView show];
		[myAlertView release];		
		bLastMessage = false;
		return true;
		
	}
	else {
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		
		return false;			
	}	
}

-(bool)drink {
	
	if (encounterType == BOTTLEGOODENCOUNTER)
	{
		// Quaff the good bottle of Skill Tonic?
		[self playSound:eBottleEncounter];
		currentState = eBottleGood;		
	}
	else if (encounterType == BOTTLEOLDENCOUNTER)
	{
		// Quaff the out of date bottle of Skill Tonic?
		[self playSound:eBottleEncounter];		
		currentState = eBottleStrange;		
		
	} else {
		[self Travel];
		[encounterViewControllerInstance showEncounterWindow];
		
		return false;			
	}
	
	UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Encounter" message:NSLocalizedString(@"EngageBottleAlert", @"") 
														  delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	
	[myAlertView show];
	[myAlertView release];		
	bLastMessage = false;
	return true;
}


// Returns number of open quests.
-(int) OpenQuests
{
	int r = 0;
	
	if (monsterStatus == 1)
		++r;
	
	if (dragonflyStatus >= 1 && dragonflyStatus <= 4)
		++r;
	else if (solarSystem[ZALKONSYSTEM].Special == INSTALLLIGHTNINGSHIELD)
		++r;
	
	if (japoriDiseaseStatus == 1)
		++r;
	
	if (artifactOnBoard)
		++r;
	
	if (wildStatus == 1)
		++r;
	
	if (jarekStatus == 1)
		++r;
	
	if (invasionStatus >= 1 && invasionStatus < 7)
		++r;
	else if (solarSystem[GEMULONSYSTEM].Special == GETFUELCOMPACTOR)
		++r;
	
	if (experimentStatus >= 1 && experimentStatus < 11)
		++r;
	
	if (reactorStatus >= 1 && reactorStatus < 21)
		++r;
	
	if (solarSystem[NIXSYSTEM].Special == GETSPECIALLASER)
		++r;
	
	if (scarabStatus == 1)
		++r;
	
	if (ship.Tribbles > 0)
		++r;
	
	if (moonBought)
		++r;
	
	return r;
}




-(NSString*) drawQuestsForm
{

//	NSMutableString *header = [[[NSMutableString alloc] init] retain];
	NSMutableString *header = [[NSMutableString alloc] init];

	if([self OpenQuests])
		[header appendString:@"Quests:"]     ;
	else
		[header appendString:@"There are no open quests."];
	
	
	
	if (monsterStatus == 1)
	{
		[header appendString:@"Kill the space monster at Acamar.\n"];
		
	}
	
	if (dragonflyStatus >= 1 && dragonflyStatus <= 4)
	{
		[header appendString:@"Follow the Dragonfly to "];
		if (dragonflyStatus == 1)
			[header appendString:@ "Baratas.\n"];
		else if (dragonflyStatus == 2)
			[header appendString:@"Melina.\n"];
		else if (dragonflyStatus == 3)
			[header appendString:@"Regulas.\n"];
		else if (dragonflyStatus == 4)
			[header appendString:@"Zalkon.\n"];
		
	}
	else if (solarSystem[ZALKONSYSTEM].Special == INSTALLLIGHTNINGSHIELD)
	{
		[header appendString:@"Get your lightning shield at Zalkon.\n"];
		
	}
	
	if (japoriDiseaseStatus == 1)
	{
		[header appendString:@"Deliver antidote to Japori."];
	}
	
	if (artifactOnBoard)
	{
		[header appendString:@"Deliver the alien artifact to professor Berger at some hi-tech system.\n"];			
	}
	if (wildStatus == 1)
	{
		[header appendString:@"Smuggle Jonathan Wild to Kravat.\n"];
	}
	
	if (jarekStatus == 1)
	{
		[header appendString:@"Bring ambassador Jarek to Devidia."];
	}
	
	// I changed this, and the reused the code in the Experiment quest.
	// I think it makes more sense to display the time remaining in
	// this fashion. SjG 10 July 2002
	if (invasionStatus >= 1 && invasionStatus < 7)
	{
		[header appendString:@"Inform Gemulon about alien invasion"];
		if (invasionStatus == 6)
		    [header appendString:@" by tomorrow\n"];
		else
		{
		    [header appendString:@" within "];
			NSString * t = [NSString stringWithFormat:@"%i days.\n", 7 - invasionStatus];
			[header appendString:t];
		}
	}
	else if (solarSystem[GEMULONSYSTEM].Special == GETFUELCOMPACTOR)
	{
		[header appendString:@"Get your fuel compactor at Gemulon."];
		
	}
	
	if (experimentStatus >= 1 && experimentStatus < 11)
	{
		[header appendString:@"Stop Dr. Fehler's experiment at Daled"];
		if (experimentStatus == 10)
		    [header appendString:@"by tomorrow\n"];
		else
		{
		    [header appendString:@"within "];
			NSString * t = [NSString stringWithFormat:@"%i day.\n", 11 - experimentStatus];
			[header appendString:t];
			
			
		}
	}
	
	if (reactorStatus >= 1 && reactorStatus < 21)
	{
		[header appendString:@"Deliver the unstable reactor to Nix"];
		
		if (reactorStatus < 2)
		{
			[header appendString:@"for Henry Morgan.\n"];
		}
		else
		{
			[header appendString:@"before it consumes all its fuel.\n"];
		}
	}
	
	if (solarSystem[NIXSYSTEM].Special == GETSPECIALLASER)
	{
		[header appendString:@"Get your special laser at Nix.\n"];
		
	}
	
	if (scarabStatus == 1)
	{
		[header appendString:@"Find and destroy the Scarab (which is hiding at the exit to a wormhole).\n"];
	}
	
	if (ship.Tribbles > 0)
	{
		[header appendString:@"Get rid of those pesky tribbles.\n"];
	}
	
	if (moonBought)
	{ 
		[header appendString:@"Claim your moon at Utopia."];			
	}

	return [header autorelease];
	
}

-(NSString*) drawQuestsForm:(SystemInfoViewController*)controller
{
	systemInfoController = controller;
	return [self drawQuestsForm];
}

-(void) setInfoViewController:(SystemInfoViewController*)controller
{
	systemInfoController = controller;
}

-(NSString*) drawSpecialCargoForm
{
	
	//	NSMutableString * header=[NSString alloc];
	NSMutableString *header = [[[NSMutableString alloc] init] retain];
	bool bSpecialItem = false;
	
	if (ship.Tribbles > 0)
	{
		if (ship.Tribbles >= MAXTRIBBLES)
			[header appendString:@"An infestation of tribbles.\n"];
		else
		{
			NSString * t = [NSString stringWithFormat:@"%i cute, furry tribble.\n", ship.Tribbles];
			[header appendString:t];		
		}
		bSpecialItem = true;
	}
	
	if (japoriDiseaseStatus == 1)
	{
		bSpecialItem = true;	
		[header appendString:@"10 bays of antidote.\n"];
	}
	if (artifactOnBoard)
	{
		bSpecialItem = true;		
		[header appendString:@"An alien artifact.\n"];
	}
	if (jarekStatus == 2)
	{
		bSpecialItem = true;		
		[header appendString:@"A haggling computer.\n"];
	}
	if (reactorStatus > 0 && reactorStatus < 21)
	{
		bSpecialItem = true;		
		[header appendString:@"An unstable reactor taking up 5 bays."];
		NSString * t = [NSString stringWithFormat:@"%i bay of enriched fuel.\n", 10 - ((reactorStatus - 1) / 2)];
		[header appendString:t];
	}
	
	if (canSuperWarp)
	{
		bSpecialItem = true;
		[header appendString:@"A Portable Singularity.\n"];
	}
	
	
	if (!bSpecialItem)
	{
		[header appendString:@"No special items."];
	}
	
	return header;
}


-(NSString*) drawCurrentShipForm
{
	
	int i, j, k, FirstEmptySlot;
	
	
	NSMutableString *header = [[[NSMutableString alloc] init] retain];		
	
	
	
	for (i=0; i<MAXWEAPONTYPE+EXTRAWEAPONS; ++i)
	{
		j = 0;
		for (k=0; k<MAXWEAPON; ++k)
		{
			if (ship.Weapon[k] == i)
				++j;
		}
		if (j > 0)
		{
			//SBuf[0] = '\0';
			for (; j >0; --j) {
				
				
				[header appendString:[NSString stringWithCString:Weapontype[i].Name]];
				[header appendString:@"\n"];
			}
		}
	}
	
	for (i=0; i<MAXSHIELDTYPE+EXTRASHIELDS; ++i)
	{
		j = 0;
		for (k=0; k<MAXSHIELD; ++k)
		{
			if (ship.Shield[k] == i)
				++j;
		}
		if (j > 0)
		{ 
			for (; j >0; --j) {
				[header appendString:[NSString stringWithCString:Shieldtype[i].Name]];
				[header appendString:@"\n"];
			}
		}
		
		//			SBuf[0] = '\0';
		//			SBufMultiples( j, Shieldtype[i].Name );
		//			StrToLower( SBuf2, SBuf );
		//			DrawChars( SBuf2, 60, Line );		
		//			Line += 14;
	}
	
	for (i=0; i<MAXGADGETTYPE+EXTRAGADGETS; ++i)
	{
		j = 0;
		for (k=0; k<MAXGADGET; ++k)
		{
			if (ship.Gadget[k] == i)
				++j;
		}
		if (j > 0)
		{
			if (i == EXTRABAYS)
			{
				j = j*5;
				[header appendString:[NSString stringWithFormat:@"%i extra cargo bays\n", j]];
				
			}
			else
			{
				[header appendString:[NSString stringWithCString:Gadgettype[i].Name]];
				[header appendString:@"\n"];			
			}
		}
	}
	
	if (escapePod)
	{
		[header appendString:@"an escape pod\n"];			
	}
	
	if ([self AnyEmptySlots:&ship])
	{			
		[header appendString:@"Unfilled:\n"];			
		
		
		FirstEmptySlot = [self GetFirstEmptySlot:Shiptype[ship.Type].WeaponSlots Item: ship.Weapon];
		if (FirstEmptySlot >= 0)
		{
			[header appendString:[NSString stringWithFormat:@"%i weapon slot(s)\n",Shiptype[ship.Type].WeaponSlots - FirstEmptySlot]];
			
			
		}
		
		FirstEmptySlot = [self GetFirstEmptySlot:Shiptype[ship.Type].ShieldSlots Item:ship.Shield];
		if (FirstEmptySlot >= 0)
		{
			[header appendString:[NSString stringWithFormat:@"%i shield slot(s)\n",Shiptype[ship.Type].ShieldSlots - FirstEmptySlot]];
			
		}
		
		FirstEmptySlot = [self  GetFirstEmptySlot:Shiptype[ship.Type].GadgetSlots Item:ship.Gadget];
		if (FirstEmptySlot >= 0)
		{
			[header appendString:[NSString stringWithFormat:@"%i gadget slot(s)\n",Shiptype[ship.Type].GadgetSlots - FirstEmptySlot]];
		}
	}
	
	return header;
	
}

-(NSString*)getEquipmentName:(int)index {
	
	if (index < MAXWEAPONTYPE)
		return [[NSString stringWithCString:Weapontype[index].Name] retain];	
	else
		if (index < MAXWEAPONTYPE + MAXSHIELDTYPE) {
			return [[NSString stringWithCString:Shieldtype[index - MAXWEAPONTYPE].Name] retain];				
		} else {
			return [[NSString stringWithCString:Gadgettype[index - MAXWEAPONTYPE - MAXSHIELDTYPE].Name] retain];							
		}
}


-(NSString*)getShipEquipmentName:(int)index {
	
	if (index < MAXWEAPON && ship.Weapon[index] >= 0)
		return [[NSString stringWithCString:Weapontype[ship.Weapon[index]].Name] retain];	
	else
		if (index < MAXWEAPON + MAXSHIELD && ship.Shield[index - MAXWEAPON] >=0 ) {
			return [[NSString stringWithCString:Shieldtype[ship.Shield[index - MAXWEAPON]].Name] retain];				
		} else {
			if (ship.Gadget[index - MAXWEAPON - MAXSHIELD] >= 0)
			return [[NSString stringWithCString:Gadgettype[ship.Gadget[index - MAXWEAPON - MAXSHIELD]].Name] retain];							
		}
	return @"";
}



// *************************************************************************
// Determine base price of item
// *************************************************************************
-(long) BasePrice:(char) ItemTechLevel Price:( long) Price
{
	return ((ItemTechLevel > CURSYSTEM.TechLevel) ? 0 : 
			((Price * (100 - [self TraderSkill:&ship])) / 100));
}

-(int)getEquipmentPrice:(int)index
{
	if (index < MAXWEAPONTYPE)
		return BASEWEAPONPRICE(index);	
	else
		if (index < MAXWEAPONTYPE + MAXSHIELDTYPE) {
			return BASESHIELDPRICE(index - MAXWEAPONTYPE);				
		} else {
			return BASEGADGETPRICE(index - MAXWEAPONTYPE - MAXSHIELDTYPE);							
		}	
}


-(int)getSellEquipmentPrice:(int)index
{
	if (index < MAXWEAPON)
		return WEAPONSELLPRICE(index);	
	else
		if (index < MAXWEAPON + MAXSHIELD) {
			return SHIELDSELLPRICE(index - MAXWEAPON);				
		} else {
			return GADGETSELLPRICE(index - MAXWEAPON - MAXSHIELD);							
		}	
}



// *************************************************************************
// Buy an item: Slots is the number of slots, Item is the array in the
// Ship record which contains the item type, Price is the costs,
// Name is the name of the item and ItemIndex is the item type number
// *************************************************************************
-(void) BuyItem:(Byte) Slots  Item:(int*) Item  Price:(long) Price  Name:(char*) Name ItemIndex:(int) ItemIndex
{
	int FirstEmptySlot;
	
	FirstEmptySlot = [self GetFirstEmptySlot:Slots Item:Item];
	
	if (Price <= 0)
		[self FrmAlert:@"ItemNotSoldAlert"];
	else if (debt > 0)
		[self FrmAlert:@"YoureInDebtAlert"];
	else if (Price > [self toSpend])
		[self FrmAlert:@"CantBuyItemAlert"];
	else if (FirstEmptySlot < 0)
		[self FrmAlert:@"NotEnoughSlotsAlert"];
	else
	{
		currentState = eBuyEquipment;
		
		NSString* str = [NSString stringWithFormat:@"Do you wish to buy this item for %i credits?", Price];
		//[self FrmAlert:str];
		NSString* name = [NSString stringWithFormat:@"Buy %@", [NSString stringWithCString:Name]];
		
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:name message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];	
		[myAlertView show];
		[myAlertView release];		
		bLastMessage = false;
		
		saveItem = Item;
		saveItemIndex= ItemIndex;
		savePrice = Price;
		saveSlot = FirstEmptySlot;
		
		
		
	}
}



-(void)buyItem:(int)index controller:(buyEquipmentViewController*)controller
{
	if (index < MAXWEAPONTYPE)
		[self BuyItem:Shiptype[ship.Type].WeaponSlots Item:ship.Weapon Price:BASEWEAPONPRICE(index) Name:Weapontype[index].Name ItemIndex:index];	
	else
		if (index < MAXWEAPONTYPE + MAXSHIELDTYPE) {
			[self BuyItem:Shiptype[ship.Type].ShieldSlots Item:ship.Shield Price:BASESHIELDPRICE(index - MAXWEAPONTYPE) Name:Shieldtype[index- MAXWEAPONTYPE].Name ItemIndex:(index- MAXWEAPONTYPE)];				
		} else {
			[self BuyItem:Shiptype[ship.Type].GadgetSlots Item:ship.Gadget Price:BASEGADGETPRICE(index - MAXWEAPONTYPE - MAXSHIELDTYPE) Name:Gadgettype[index - MAXWEAPONTYPE - MAXSHIELDTYPE].Name ItemIndex:(index - MAXWEAPONTYPE - MAXSHIELDTYPE)];						
		}		
	buyController = controller;

}

-(void)sellEquipment:(int)index
{
	if (index < MAXWEAPON)
	{
		credits += WEAPONSELLPRICE(index);
		for (int i = index + 1; i < MAXWEAPON; ++i)
			ship.Weapon[i-1] = ship.Weapon[i];
		ship.Weapon[MAXWEAPON - 1] = -1;
	} else 
	if (index < MAXWEAPON + MAXSHIELD) 
	{
		index =index - MAXWEAPON;
		credits += WEAPONSELLPRICE(index);
		for (int i = index + 1; i < MAXSHIELD; ++i) {
			ship.Shield[i-1] = ship.Shield[i];
			ship.ShieldStrength[i-1] = ship.ShieldStrength[i];	
		}
		ship.Shield[MAXSHIELD - 1] = -1;
		ship.ShieldStrength[MAXSHIELD - 1] = -1;		
	}
	else
	{
		index = index - MAXWEAPON - MAXSHIELD;
		
		if ([self filledCargoBays] > [self totalCargoBays] - 5)
			[self FrmAlert:@"CargoBaysFullAlert"];
			else
		{
			credits += GADGETSELLPRICE(index);
			for (int i = index + 1; i < MAXGADGET; ++i)
				ship.Gadget[i-1] = ship.Gadget[i];
			ship.Gadget[MAXGADGET - 1] = -1;		
		}
	}	
}

-(void) DrawMercenary:(int)index controller:(personellRosterViewController*)controller  name:(UILabel*)name cost:(UILabel*)cost pilot:(UILabel*)pilot trader:(UILabel*)trader
			  fighter:(UILabel*)fighter engineer:(UILabel*)engineer
{
	[controller.view addSubview:name];
	[controller.view addSubview:cost];
	[controller.view addSubview:pilot];
	[controller.view addSubview:trader];
	[controller.view addSubview:fighter];
	[controller.view addSubview:engineer];
	

	name.text = [NSString stringWithCString:MercenaryName[Mercenary[index].NameIndex]];
	cost.text = [NSString stringWithFormat:@"Costs: %i cr. daily", MERCENARYHIREPRICE(index)];
	pilot.text = [NSString stringWithFormat:@"Pilot: %i", Mercenary[index].Pilot];
	trader.text = [NSString stringWithFormat:@"Trader: %i", Mercenary[index].Trader];
	fighter.text = [NSString stringWithFormat:@"Fighter: %i", Mercenary[index].Fighter];
	engineer.text = [NSString stringWithFormat:@"Engineer: %i", Mercenary[index].Engineer];	
}

// *************************************************************************
// Determine which mercenary is for hire in the current system
// *************************************************************************
-(int) GetForHire
{
	int ForHire = -1;
	int i;
	
	for (i=1; i<MAXCREWMEMBER; ++i)
	{
		if (i == ship.Crew[1] || i == ship.Crew[2])
			continue;
		if (Mercenary[i].CurSystem ==currentSystem)
		{
			ForHire = i;
			break;
		}
	}
	
	return ForHire;
}


-(void) updateRosterWindow:(personellRosterViewController*)controller 
{
	int i = 0;
	//for (i=0; i<2; ++i)
	{
		if (i == Shiptype[ship.Type].CrewQuarters-2 && (jarekStatus == 1 || wildStatus == 1))
		{
			if (jarekStatus == 1) {
				controller.Vacancy0.text = @"Jarek's quarters.";
				[controller.view addSubview:controller.Vacancy0];
			}
				//;DrawChars( "Jarek's quarters", 30, 30 + i*45 );
			else {
				controller.Vacancy0.text = @"Wild's quarters.";
				[controller.view addSubview:controller.Vacancy0];

			}
	//		continue;
		} else
		
		if (Shiptype[ship.Type].CrewQuarters <= i+1)
		{
			controller.Vacancy0.text = @"No quarters available.";
			[controller.view addSubview:controller.Vacancy0];

		} else
		
		if (ship.Crew[i+1] < 0)
		{
			controller.Vacancy0.text = @"Vacancy";
			[controller.view addSubview:controller.Vacancy0];

		}
		else {
			[self DrawMercenary:ship.Crew[i+1] controller:controller name:controller.PilotName0 cost:controller.Price0 pilot:controller.Pilot0 trader:controller.Trader0 fighter:controller.Fighter0
					   engineer:controller.Engineer0];
			[controller.view addSubview:controller.fire0];	
		}	
	}

	{
		int i = 1;
		if (i == Shiptype[ship.Type].CrewQuarters-2 && (jarekStatus == 1 || wildStatus == 1))
		{
			if (jarekStatus == 1) {
				controller.Vacancy0.text = @"Jarek's quarters.";
				[controller.view addSubview:controller.Vacancy0];
			}
			//;DrawChars( "Jarek's quarters", 30, 30 + i*45 );
			else {
				controller.Vacancy1.text = @"Wild's quarters.";
				[controller.view addSubview:controller.Vacancy0];
				
			}
			//		continue;
		} else
			
			if (Shiptype[ship.Type].CrewQuarters <= i+1)
			{
				controller.Vacancy1.text = @"No quarters available.";
				[controller.view addSubview:controller.Vacancy1];
				
			} else
				
				if (ship.Crew[i+1] < 0)
				{
					controller.Vacancy1.text = @"Vacancy";
					[controller.view addSubview:controller.Vacancy1];
					
				}
				else {
					[self DrawMercenary:ship.Crew[i+1] controller:controller name:controller.PilotName1 cost:controller.Price1 pilot:controller.Pilot1 trader:controller.Trader0 
								fighter:controller.Fighter1   engineer:controller.Engineer1];
					[controller.view addSubview:controller.fire1];	
				}	
	}

	
	
	
	int ForHire = [self GetForHire];
	if (ForHire < 0)
	{
		controller.Vacancy2.text = @"No one for hire";
		[controller.view addSubview:controller.Vacancy2];	

	}
	else
	{	
		[self DrawMercenary:ForHire controller:controller name:controller.PilotName2 cost:controller.Price2 pilot:controller.Pilot2 trader:controller.Trader2 fighter:controller.Fighter2
				   engineer:controller.Engineer2];
		[controller.view addSubview:controller.fire2];	
		
//		FrmShowObject( frmP, FrmGetObjectIndex( frmP, PersonnelRosterHire0Button ) );
//		DrawMercenary( ForHire, 107 );		
	}
	
}

-(void) fireMercenary:(int)index {
	int oldTraderSkill = [self TraderSkill:&ship];
	if (index == 1)
	{
		ship.Crew[1] = ship.Crew[2];
	}
//	else 
//		ship.Crew[1] = -1;
	
	ship.Crew[2] = -1;
	
	if (oldTraderSkill != [self TraderSkill:&ship])
		[self RecalculateBuyPrices:currentSystem];
	
	[self playSound:eFireMercenary];
}

-(int)AvailableQuarters
{
	return Shiptype[ship.Type].CrewQuarters - (jarekStatus == 1 ? 1 : 0) -
	(wildStatus == 1 ? 1 : 0);
}

-(void) hireMercenaryFromRoster {
	int oldTraderSkill = [self TraderSkill:&ship];
	int ForHire = [self GetForHire];
	
	int FirstFree = -1;
	if (ship.Crew[1] == -1)
		FirstFree = 1;
	else if (ship.Crew[2] == -1)
		FirstFree = 2;
	if (FirstFree < 0 || [self AvailableQuarters] <= FirstFree) {
		[self FrmAlert:@"NoFreeQuartersAlert"];
	} else {
		ship.Crew[FirstFree] = ForHire;
		if (oldTraderSkill != [self TraderSkill:&ship])
			[self RecalculateBuyPrices:currentSystem];
		
	}

}

-(NSString*)getPriceDifference:(int)itemIndex difference:(bool)difference realPrice:(int*)realPrice maxCount:(int*)maxCount isSmart:(int*)isSmart
{
	int price = [self StandardPrice:itemIndex size:solarSystem[warpSystem].Size tech:solarSystem[warpSystem].TechLevel goverment:solarSystem[warpSystem].Politics resources:solarSystem[warpSystem].Visited ? solarSystem[warpSystem].SpecialResources : -1];
	if (price > BuyPrice[itemIndex] && BuyPrice[itemIndex] > 0 && CURSYSTEM.Qty[itemIndex] > 0)
		*isSmart = 1;
	else
		*isSmart = 0;
	*realPrice = price;
	if (BuyPrice[itemIndex] > 0)
		*maxCount = credits / BuyPrice[itemIndex];
	else
		*maxCount = 0;
	if (price <= 0 || (difference && BuyPrice[itemIndex] <= 0))
		return @"---";// [[NSString stringWithFormat:@""] retain];
	if (difference) 
		return [NSString stringWithFormat:@"%@%i cr.", price > BuyPrice[itemIndex] ? @"+" : @"", price - BuyPrice[itemIndex]];
//		return [[NSString stringWithFormat:@"%@%i cr.", price > BuyPrice[itemIndex] ? @"+" : @"", price - BuyPrice[itemIndex]] retain];
	else
		return [NSString stringWithFormat:@"%i cr.", price];
//		return [[NSString stringWithFormat:@"%i cr.", price] retain];
}
		

// *************************************************************************
// Determine next system withing range
// *************************************************************************
-(int) nextSystemWithinRange:(int) Current Back:(Boolean) Back 
{
	int i = Current;
	
	(Back ? --i : ++i);
	
	while (true)
	{
		if (i < 0)
			i = MAXSOLARSYSTEM - 1;
		else if (i >= MAXSOLARSYSTEM)
			i = 0;
		if (i == Current)
			break;
		
		if ([self wormholeExists:currentSystem b:i])
			return i;
		else if ([self realDistance:currentSystem b:i]  <= [self getFuel] &&
			[self realDistance:currentSystem b:i]  > 0)
			return i;
		
		(Back ? --i : ++i);
	}
	
	return i;
}




typedef struct 
	{
		long CurrentSystem;
		long Credits;
		long Debt;
		int Days;
		int WarpSystem;
		int SelectedShipType;
		long BuyPrice[MAXTRADEITEM];
		long SellPrice[MAXTRADEITEM];
		long ShipPrice[MAXSHIPTYPE];
		int GalacticChartSystem;
		long PoliceKills;
		long TraderKills;
		long PirateKills;
		long PoliceRecordScore;
		long ReputationScore;
		Boolean AutoFuel;
		Boolean AutoRepair;
		Boolean Clicks;
		int EncounterType;
		Boolean Raided;
		Byte MonsterStatus;
		Byte DragonflyStatus;
		Byte JaporiDiseaseStatus;
		Boolean MoonBought;
		long MonsterHull;
		char NameCommander[NAMELEN+1];
		int CurForm;
		SHIP Ship;
		SHIP Opponent;
		CREWMEMBER Mercenary[MAXCREWMEMBER+1];
		SOLARSYSTEMSAVE SolarSystem[MAXSOLARSYSTEM];
		Boolean EscapePod;
		Boolean Insurance; 
		int NoClaim;
		Boolean Inspected;
		Boolean AlwaysIgnoreTraders;
		Byte Wormhole[MAXWORMHOLE];
		Byte Difficulty;
		Byte VersionMajor;
		Byte VersionMinor;
		Byte PilotSkill;
		Byte FighterSkill;
		Byte TraderSkill;
		Byte EngineerSkill;
		long BuyingPrice[MAXTRADEITEM];
		Boolean ArtifactOnBoard;
		Boolean ReserveMoney;
		Boolean PriceDifferences;
		Boolean APLscreen;
		int LeaveEmpty;
		Boolean TribbleMessage;
		Boolean AlwaysInfo;
		Boolean AlwaysIgnorePolice;
		Boolean AlwaysIgnorePirates;
		Boolean TextualEncounters;
		Byte JarekStatus;
		Byte InvasionStatus;
		Boolean Continuous;
		Boolean AttackFleeing;
		Byte ExperimentStatus;
		Byte WildStatus;
		Byte FabricRipProbability;
		Byte VeryRareEncounter;
		Byte BooleanCollection;
		Byte ReactorStatus;
		int TrackedSystem;
		Byte ScarabStatus;
		Boolean AlwaysIgnoreTradeInOrbit;
		Boolean AlreadyPaidForNewspaper;
		Boolean GameLoaded;
		int Shortcut1;
		int Shortcut2;
		int Shortcut3;
		int Shortcut4;
		Boolean LitterWarning;
		Boolean SharePreferences;
		Boolean IdentifyStartup;
		Boolean RectangularButtonsOn;
		Boolean newsAutoPay;
		Boolean showTrackedRange;
		Boolean justLootedMarie;
		Boolean arrivedViaWormhole;
		Boolean trackAutoOff;
		Boolean remindLoans;
		Boolean canSuperWarp;
		Boolean musicEnabled;
		Byte ForFutureUse[MAXFORFUTUREUSE]; // Make sure this is properly adapted or savegames won't work after an upgrade!
	} SAVEGAMETYPE;




-(void)LoadBinaryOptions:(NSString*)name 
{
	options.musicEnabled = 0;
	options.soundEnabled = 1;
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.opt", recordingDirectory, name];
	
	NSData* data;
	data =[[NSData alloc] initWithContentsOfFile:fileName];
	
	memcpy(&options, [data bytes], [data length]);
	[data release];	
}

-(void)SaveOptions:(NSString*)name{
	NSData* data;
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.opt", recordingDirectory, name];
	data = [[NSData alloc] initWithBytes:&options length:(NSUInteger)sizeof(options) ];
	[data writeToFile:fileName atomically:FALSE];	
	[data release];
	
}

-(void)LoadBinaryHighScore:(NSString*)name data:(HIGHSCORE*)sg
{
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.hscr", recordingDirectory, name];
	
	NSData* data;
	data =[[NSData alloc] initWithContentsOfFile:fileName];
	
	memcpy(sg, [data bytes], [data length]);
	[data release];
}

-(void)eraseAutoSave {
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/Autosave.save", recordingDirectory];	
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	[fileManager removeItemAtPath:fileName error:NULL];
}


-(void)SaveHighScore:(NSString*)name{
	NSData* data;
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.hscr", recordingDirectory, name];
	data = [[NSData alloc] initWithBytes:&Hscores length:(NSUInteger)sizeof(Hscores) ];
	[data writeToFile:fileName atomically:FALSE];	
	[data release];	
}


-(void)SaveGame:(NSString*)name{
	NSData* data;

	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.save", recordingDirectory, name];
	SAVEGAMETYPE saveGame, * sg = &saveGame;
	
	// Copying all members to the save game structure
	int i;
	sg->PilotSkill = pilotSkill;
	sg->FighterSkill = fighterSkill;
	sg->TraderSkill = traderSkill;
	sg->EngineerSkill = engineerSkill;
	
	sg->CurrentSystem = currentSystem;	
	sg->Credits = credits;
	sg->Debt = debt;
	sg->Days = days;
	sg->WarpSystem = warpSystem;
//	sg->SelectedShipType = selectedShipType;
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		sg->BuyPrice[i] = BuyPrice[i];
		sg->SellPrice[i] = SellPrice[i];
	}
	for (i=0; i<MAXSHIPTYPE; ++i)
		sg->ShipPrice[i] = ShipPrice[i];
	//sg->musicEnabled = musicEnabled;
   	sg->GalacticChartSystem = galacticChartSystem;
	sg->PoliceKills = policeKills;
	sg->TraderKills = traderKills;
	sg->PirateKills = pirateKills;
	sg->PoliceRecordScore = policeRecordScore;
	sg->ReputationScore = reputationScore;
	sg->AutoFuel = autoFuel;
	sg->AutoRepair = autoRepair;
	sg->Clicks = clicks;
	sg->EncounterType = encounterType;
	sg->Raided = raided;
	sg->MonsterStatus = monsterStatus;
	sg->DragonflyStatus = dragonflyStatus;
	sg->JaporiDiseaseStatus = japoriDiseaseStatus;
	sg->MoonBought = moonBought;
	sg->MonsterHull = monsterHull;
	[pilotName getCString:sg->NameCommander maxLength:(NAMELEN+1) encoding:NSUTF8StringEncoding];
//	sg->CurForm = CurForm;
	memmove( &(sg->Ship), &ship, sizeof( sg->Ship ) );
	
	
	memmove( &(sg->Opponent), &Opponent, sizeof( sg->Opponent ) );
	for (i=0; i<MAXCREWMEMBER+1; ++i)
		memmove( &(sg->Mercenary[i]), &Mercenary[i], sizeof( sg->Mercenary[i] ) );
	for (i=0; i<MAXSOLARSYSTEM; ++i)
		memmove( &(sg->SolarSystem[i]), &solarSystem[i], sizeof( sg->SolarSystem[i] ) );
	for (i=0; i<MAXFORFUTUREUSE; ++i)
		sg->ForFutureUse[i] = 0;
	sg->EscapePod = escapePod;
	sg->Insurance = insurance;
	sg->NoClaim = noClaim;
	sg->Inspected = inspected;
	sg->LitterWarning = litterWarning;
	sg->AlwaysIgnoreTraders = alwaysIgnoreTraders;
	sg->AlwaysIgnorePolice = alwaysIgnorePolice;
	sg->AlwaysIgnorePirates = alwaysIgnorePirates;
	sg->Difficulty = gameDifficulty;
	sg->VersionMajor = 1;
	// changed from 3 to 4. SjG
	sg->VersionMinor = 4;
	for (i=0; i<MAXWORMHOLE; ++i)
		sg->Wormhole[i] = Wormhole[i];
	for (i=0; i<MAXTRADEITEM; ++i)
		sg->BuyingPrice[i] = BuyingPrice[i];
	sg->ArtifactOnBoard = artifactOnBoard;
	sg->ReserveMoney = reserveMoney;
//	sg->PriceDifferences = priceDifferences;
//	sg->APLscreen = APLscreen;
	sg->TribbleMessage = tribbleMessage;
	sg->AlwaysInfo = alwaysInfo;
	sg->LeaveEmpty = leaveEmpty;
	sg->TextualEncounters = textualEncounters;
	sg->JarekStatus = jarekStatus;
	sg->InvasionStatus = invasionStatus;
	sg->Continuous = continuous;
//	sg->AttackFleeing = attackFleeing;
	sg->ExperimentStatus =experimentStatus;
	sg->WildStatus = wildStatus;
	sg->FabricRipProbability = fabricRipProbability;
	sg->VeryRareEncounter = veryRareEncounter;
	sg->newsAutoPay = newsAutoPay;
	sg->showTrackedRange = showTrackedRange;
	sg->justLootedMarie = justLootedMarie;
	sg->arrivedViaWormhole = arrivedViaWormhole;
	sg->trackAutoOff = trackAutoOff;
	sg->remindLoans = remindLoans;
	sg->canSuperWarp = canSuperWarp;
    sg->ReactorStatus = reactorStatus;
    sg->TrackedSystem = trackedSystem;
    sg->ScarabStatus = scarabStatus;
 	sg->AlwaysIgnoreTradeInOrbit = alwaysIgnoreTradeInOrbit;
	sg->AlreadyPaidForNewspaper = alreadyPaidForNewspaper;
	sg->GameLoaded = gameLoaded;
//	sg->SharePreferences = sharePreferences;
//	sg->IdentifyStartup = identifyStartup;
//	sg->Shortcut1 = Shortcut1;
//	sg->Shortcut2 = Shortcut2;
//	sg->Shortcut3 = Shortcut3;
//	sg->Shortcut4 = Shortcut4;
	
	
	
	
	data = [[NSData alloc] initWithBytes:&saveGame length:(NSUInteger)sizeof(saveGame) ];
	[data writeToFile:fileName atomically:FALSE];		
	[data dealloc];	
}

- (NSString*) convertDateLocaleString:(NSDate*) theDate
{
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString *dateStr = [dateFormatter stringFromDate:theDate];
	[dateFormatter release];
	return dateStr;
}

-(void)LoadBinaryData:(NSString*)name  time:(NSString**)time data:(SAVEGAMETYPE*)sg
{
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSString* fileName = [NSString stringWithFormat:@"%@/%@.save", recordingDirectory, name];
	
	NSData* data;
	data =[[NSData alloc] initWithContentsOfFile:fileName];

	memcpy(sg, [data bytes], [data length]);
	[data dealloc];
	
	if (time != nil) {
		NSFileManager *fileManager = [NSFileManager defaultManager];		
		NSDictionary *fsAttributes =
        [fileManager fileAttributesAtPath:fileName traverseLink:NO];
		//*time = [[fsAttributes objectForKey:NSFileModificationDate] retain];
		*time = [self convertDateLocaleString:[fsAttributes objectForKey:NSFileModificationDate]];
		
		
	}
	
}


-(void)LoadGame:(NSString*)name
{
	
	SAVEGAMETYPE   saveGame, * sg = &saveGame;
	[self LoadBinaryData:name time:nil data:&saveGame];
	// restore all members frm save game
	int i;
	currentSystem = sg->CurrentSystem;
	credits = sg->Credits;
	debt = sg->Debt;
	days = sg->Days;
	warpSystem = sg->WarpSystem;
	pilotSkill = sg->PilotSkill;
	fighterSkill = sg->FighterSkill;
	traderSkill = sg->TraderSkill;
	engineerSkill = sg->EngineerSkill;
	
	//	sg->SelectedShipType = selectedShipType;
	for (i=0; i<MAXTRADEITEM; ++i)
	{
		BuyPrice[i] = sg->BuyPrice[i];
		SellPrice[i] = sg->SellPrice[i];
	}
	for (i=0; i<MAXSHIPTYPE; ++i)
		ShipPrice[i] = sg->ShipPrice[i];
	//musicEnabled = sg->musicEnabled;
	galacticChartSystem= sg->GalacticChartSystem ;
	policeKills = sg->PoliceKills;
	traderKills = sg->TraderKills;
	pirateKills = sg->PirateKills;
	policeRecordScore = sg->PoliceRecordScore;
	reputationScore = sg->ReputationScore;
	autoFuel = sg->AutoFuel;
	autoRepair = sg->AutoRepair;
	clicks = sg->Clicks;
	encounterType = sg->EncounterType;
	raided = sg->Raided;
	monsterStatus= sg->MonsterStatus ;
	dragonflyStatus = sg->DragonflyStatus;
	japoriDiseaseStatus = sg->JaporiDiseaseStatus;
	moonBought = sg->MoonBought;
	monsterHull= sg->MonsterHull ;
	pilotName = [[NSString stringWithCString:sg->NameCommander length:strlen(sg->NameCommander)] retain];	//	sg->CurForm = CurForm;
	memmove(&ship, &(sg->Ship),  sizeof( sg->Ship ) );
	
	
	memmove( &Opponent,&(sg->Opponent),  sizeof( sg->Opponent ) );
	for (i=0; i<MAXCREWMEMBER+1; ++i)
		memmove(&Mercenary[i], &(sg->Mercenary[i]),  sizeof( sg->Mercenary[i] ) );
	for (i=0; i<MAXSOLARSYSTEM; ++i)
		memmove(&solarSystem[i], &(sg->SolarSystem[i]),  sizeof( sg->SolarSystem[i] ) );
	
//	for (i=0; i<MAXFORFUTUREUSE; ++i)
//		sg->ForFutureUse[i] = 0;
	escapePod = sg->EscapePod;
	insurance= sg->Insurance ;
	noClaim = sg->NoClaim;
	inspected = sg->Inspected;
	litterWarning = sg->LitterWarning;
	alwaysIgnoreTraders = sg->AlwaysIgnoreTraders;
	alwaysIgnorePolice = sg->AlwaysIgnorePolice;
	alwaysIgnorePirates = sg->AlwaysIgnorePirates;
	gameDifficulty = sg->Difficulty;
//	sg->VersionMajor = 1;
	// changed from 3 to 4. SjG
//	sg->VersionMinor = 4;
	for (i=0; i<MAXWORMHOLE; ++i)
		Wormhole[i] = sg->Wormhole[i];
	for (i=0; i<MAXTRADEITEM; ++i)
		BuyingPrice[i] = sg->BuyingPrice[i];
	artifactOnBoard = sg->ArtifactOnBoard;
	reserveMoney = sg->ReserveMoney;
	//	sg->PriceDifferences = priceDifferences;
	//	sg->APLscreen = APLscreen;
	tribbleMessage = sg->TribbleMessage;
	alwaysInfo = sg->AlwaysInfo;
	leaveEmpty = sg->LeaveEmpty;
	textualEncounters = sg->TextualEncounters;
	jarekStatus = sg->JarekStatus;
	invasionStatus = sg->InvasionStatus;
	continuous = sg->Continuous;
	//	sg->AttackFleeing = attackFleeing;
	experimentStatus = sg->ExperimentStatus;
	wildStatus = sg->WildStatus;
	fabricRipProbability = sg->FabricRipProbability;
	veryRareEncounter = sg->VeryRareEncounter;
	newsAutoPay = sg->newsAutoPay;
	showTrackedRange = sg->showTrackedRange;
	justLootedMarie = sg->justLootedMarie;
	arrivedViaWormhole = sg->arrivedViaWormhole;
	trackAutoOff = sg->trackAutoOff;
	remindLoans = sg->remindLoans;
	canSuperWarp = sg->canSuperWarp;
    reactorStatus = sg->ReactorStatus;
    trackedSystem = sg->TrackedSystem;
    scarabStatus = sg->ScarabStatus;
 	alwaysIgnoreTradeInOrbit = sg->AlwaysIgnoreTradeInOrbit;
	alreadyPaidForNewspaper = sg->AlreadyPaidForNewspaper;
	gameLoaded = sg->GameLoaded ;	
	
	
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app switchBarToGame];
	[app commandCommand];
	[self updateMercenary0Data];
//	if (musicEnabled)
//		[self playMusic];
	
	//[self showJettisonForm];
}
		

-(void)ShowSaveGames:(NSMutableArray*)array name:(NSMutableArray*)name additional:(NSMutableArray*)additional
{
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
									  enumeratorAtPath:recordingDirectory];
	NSString *pname;
	while (pname = [direnum nextObject])
	{
		if ([[pname pathExtension] isEqualToString:@"rtfd"])
		{
			/* don’t enumerate this directory */
			[direnum skipDescendents];
		}
		else
		{
			if ([[pname pathExtension] isEqualToString:@"save"]) {
				NSString * nameFile = [[pname stringByDeletingPathExtension] retain]; 
				[array addObject:nameFile];
				SAVEGAMETYPE save;
				NSString * time;
				[self LoadBinaryData:nameFile time:&time data:&save ];

				[name addObject:[[NSString stringWithFormat:@"%@ (%@)", [NSString stringWithCString:save.NameCommander], nameFile] retain]];
				[nameFile release];
				[additional addObject:[[NSString stringWithFormat:@"Time:%@\n System:%@ Credits:%i", time, [self getSolarSystemName:save.CurrentSystem], save.Credits] retain ]];				
			}
			/* ...process file here... */
		}
	}	
}

-(long)getShipShield
{
	return [self TotalShieldStrength:&ship];
}

-(long)getShipOpponentShield
{
	return [self TotalShieldStrength:&Opponent];
}

-(long)getShipShieldMax
{
	return [self TotalShields:&ship];
}

-(long)getShipOpponentShieldMax
{
	return [self TotalShields:&Opponent];
}

-(long)getShipHullMax
{
	return [self GetHullStrength];
}

-(long)getShipOpponentHullMax
{
	return Shiptype[Opponent.Type].HullStrength;
}

-(bool)IsNewsExist
{
	alreadyPaidForNewspaper = false;
	if (CURSYSTEM.Special > -1)
	{
		if (CURSYSTEM.Special == MONSTERKILLED && monsterStatus == 2)
			[self addNewsEvent:MONSTERKILLED];
		else if (CURSYSTEM.Special == DRAGONFLY)
			[self addNewsEvent:DRAGONFLY];
		else if (CURSYSTEM.Special == SCARAB)
			 [self addNewsEvent:SCARAB];
		else if (CURSYSTEM.Special == SCARABDESTROYED && scarabStatus == 2)
			 [self addNewsEvent:SCARABDESTROYED];
		else if (CURSYSTEM.Special == FLYBARATAS && dragonflyStatus == 1)
			 [self addNewsEvent:FLYBARATAS];
		else if (CURSYSTEM.Special == FLYMELINA && dragonflyStatus == 2)
			 [self addNewsEvent:FLYMELINA];
		else if (CURSYSTEM.Special == FLYREGULAS && dragonflyStatus == 3)
			 [self addNewsEvent:FLYREGULAS];
		else if (CURSYSTEM.Special == DRAGONFLYDESTROYED && dragonflyStatus == 5)
			 [self addNewsEvent:DRAGONFLYDESTROYED];
		else if (CURSYSTEM.Special == MEDICINEDELIVERY && japoriDiseaseStatus == 1)
			 [self addNewsEvent:MEDICINEDELIVERY];
		else if (CURSYSTEM.Special == ARTIFACTDELIVERY && artifactOnBoard)
			 [self addNewsEvent:ARTIFACTDELIVERY];
		else if (CURSYSTEM.Special == JAPORIDISEASE && japoriDiseaseStatus == 0)
			[self addNewsEvent:JAPORIDISEASE];
		else if (CURSYSTEM.Special == JAREKGETSOUT && jarekStatus == 1)
			 [self addNewsEvent:JAREKGETSOUT];
		else if (CURSYSTEM.Special == WILDGETSOUT && wildStatus == 1)
			 [self addNewsEvent:WILDGETSOUT];
		else if (CURSYSTEM.Special == GEMULONRESCUED && invasionStatus > 0 && invasionStatus < 8)
			 [self addNewsEvent:GEMULONRESCUED];
		else if (CURSYSTEM.Special == ALIENINVASION)
			 [self addNewsEvent:ALIENINVASION];
		else if (CURSYSTEM.Special == EXPERIMENTSTOPPED && experimentStatus > 0 && experimentStatus < 12) {
			experimentStatus = 13;
		
			 [self addNewsEvent:EXPERIMENTSTOPPED];
		}
		else if (CURSYSTEM.Special == EXPERIMENTNOTSTOPPED)
			 [self addNewsEvent:EXPERIMENTNOTSTOPPED];
		
	}

	return true;
}
			
-(void)payForNewsPaper:(int)sum
{
	sum = gameDifficulty + 1;
	credits -= sum;
	alreadyPaidForNewspaper = true;
}

			
-(bool)IsHireExist
{
		
	
	
	return [self GetForHire] >= 0;
}

-(bool)IsSpecialExist
{
	int OpenQ = [self OpenQuests];

	if  ((CURSYSTEM.Special < 0) || 
		 (CURSYSTEM.Special == BUYTRIBBLE && ship.Tribbles <= 0) ||
		 (CURSYSTEM.Special == ERASERECORD && policeRecordScore >= DUBIOUSSCORE) ||
		 (CURSYSTEM.Special == CARGOFORSALE && ([self filledCargoBays] > [self totalCargoBays] - 3)) ||
		 ((CURSYSTEM.Special == DRAGONFLY || CURSYSTEM.Special == JAPORIDISEASE ||
		   CURSYSTEM.Special == ALIENARTIFACT || CURSYSTEM.Special == AMBASSADORJAREK ||
		   CURSYSTEM.Special == EXPERIMENT) && (policeRecordScore < DUBIOUSSCORE)) ||
		 (CURSYSTEM.Special == TRANSPORTWILD && (policeRecordScore >= DUBIOUSSCORE)) ||
		 (CURSYSTEM.Special == GETREACTOR && (policeRecordScore >= DUBIOUSSCORE || reputationScore < AVERAGESCORE || reactorStatus != 0)) ||
		 (CURSYSTEM.Special == REACTORDELIVERED && !(reactorStatus > 0 && reactorStatus < 21)) ||
		 (CURSYSTEM.Special == MONSTERKILLED && monsterStatus < 2) ||
		 (CURSYSTEM.Special == EXPERIMENTSTOPPED && !(experimentStatus >= 1 && experimentStatus < 12)) ||
		 (CURSYSTEM.Special == FLYBARATAS && dragonflyStatus < 1) ||
		 (CURSYSTEM.Special == FLYMELINA && dragonflyStatus < 2) ||
		 (CURSYSTEM.Special == FLYREGULAS && dragonflyStatus < 3) ||
		 (CURSYSTEM.Special == DRAGONFLYDESTROYED && dragonflyStatus < 5) ||
		 (CURSYSTEM.Special == SCARAB && (reputationScore < AVERAGESCORE || scarabStatus != 0)) ||
		 (CURSYSTEM.Special == SCARABDESTROYED && scarabStatus != 2) ||
		 (CURSYSTEM.Special == GETHULLUPGRADED && scarabStatus != 2) ||
		 (CURSYSTEM.Special == MEDICINEDELIVERY && japoriDiseaseStatus != 1) ||
		 (CURSYSTEM.Special == JAPORIDISEASE && (japoriDiseaseStatus != 0)) ||
		 (CURSYSTEM.Special == ARTIFACTDELIVERY && !artifactOnBoard) ||
		 (CURSYSTEM.Special == JAREKGETSOUT && jarekStatus != 1) ||
		 (CURSYSTEM.Special == WILDGETSOUT && wildStatus != 1) ||
		 (CURSYSTEM.Special == GEMULONRESCUED && !(invasionStatus >= 1 && invasionStatus <= 7)) ||
		 (CURSYSTEM.Special == MOONFORSALE && (moonBought || [self currentWorth] < (COSTMOON * 4) / 5)) ||
		 (CURSYSTEM.Special == MOONBOUGHT && moonBought != true)) 
		return false;
	else if  (OpenQ > 3 &&
	 (CURSYSTEM.Special == TRIBBLE ||
	  CURSYSTEM.Special == SPACEMONSTER ||
	  CURSYSTEM.Special == DRAGONFLY ||
	  CURSYSTEM.Special == JAPORIDISEASE ||
	  CURSYSTEM.Special == ALIENARTIFACT ||
	  CURSYSTEM.Special == AMBASSADORJAREK ||
	  CURSYSTEM.Special == ALIENINVASION ||
	  CURSYSTEM.Special == EXPERIMENT ||
	  CURSYSTEM.Special == TRANSPORTWILD ||
	  CURSYSTEM.Special == GETREACTOR ||
	  CURSYSTEM.Special == SCARAB)) 
		return false;
	else
		return true;
}


-(void)playMusic
{
	
	[self LoadBinaryOptions:@"options"];
	
//	options.musicEnabled = 0;
	
	NSString* songFile1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithCString:"Resonance"] ofType:@"m4a"];
	
	//audioPlayer = nil;
	
	if (audioPlayerReleased && options.musicEnabled == 1) {
		
		// before instantiating the playback audio queue object, 
		//        set the audio session category
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,
								 sizeof (sessionCategory),
								 &sessionCategory
								 );
		audioPlayerReleased = false;
		
		audioPlayer = [[AudioPlayer alloc] initWithURL: [NSURL fileURLWithPath: songFile1]];
		
		if (audioPlayer) {
			[audioPlayer setNotificationDelegate: self];        // sets up the playback object to receive property change notifications from the playback audio queue object
			
			// activate the audio session immmediately before playback starts
			AudioSessionSetActive (true);
			NSLog (@"sending play message to play object.");
			[audioPlayer play];
		}
	}
	
}

-(void)stopMusic
{
	if (!audioPlayerReleased) {
		[audioPlayer stop];
		[audioPlayer release];	
		audioPlayerReleased = true;
		//audioPlayer = 0;
	}
}

-(void)startStopMusic: (NSTimer *) timer {
	
	//[timer release];
	[self stopMusic];
	[self playMusic];
}


-(void)restartMusic {
	/*NSTimer * timer =*/ [NSTimer scheduledTimerWithTimeInterval:	1.0		// seconds
														  target:		self
													 selector:	@selector (startStopMusic:)
														userInfo:	0		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
														 repeats:	NO];	
//	[timer release];
}

-(void)disableMusic
{
	options.musicEnabled = 0;
	[self SaveOptions:@"options"];
	[self stopMusic];
}

-(void)enableMusic
{
	options.musicEnabled = 1;
	[self SaveOptions:@"options"];
	[self playMusic];
}
-(void)disableSound {
	options.soundEnabled = 0;
	[self SaveOptions:@"options"];

}

-(void)enableSound
{
	options.soundEnabled = 1;
	[self SaveOptions:@"options"];

}

-(bool)isSoundEnabled
{
	return options.soundEnabled  == 1;
}

/*
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
 eYouRetirePoorly
 };	
 
 */
NSString * SoundsList[] = {
@"alien_encounter",
@"alien_return_artifact",
@"begin_game_welcome_aboard_captain",
@"bottle_encounter",
@"buy_insurance",
@"buy_new_ship",
@"buy_ship_upgrades",
@"cant_select_anything",
@"fire_mercenary",
@"fire_on_opponent",
@"get_gas",
@"get_loan",
@"hire_mercenary",
@"police_encounter",
@"st_tribble",
@"wormhole_jump",
@"you_are_destroyed",
@"you_lose",
@"you_retire_lavishly",
@"you_retire_poorly"
};

-(void) initSounds
{
	for (int i =0; i < 19; ++i)
	{
		id sndpath = [[NSBundle mainBundle] pathForResource:SoundsList[i] ofType:@"caf" inDirectory:@"/"];
		CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
		AudioServicesCreateSystemSoundID (baseURL, &sound[i]);				

		[(NSURL*)baseURL release];
	}
	sound[19] = kSystemSoundID_Vibrate;

}

-(void)playSound:(enum eSystemSound)soundType
{
	if (options.soundEnabled)
	AudioServicesPlaySystemSound (sound[(int)soundType]);
}

-(NSString*)drawNewspaperForm
{
    //Boolean shown[MAXSTORIES];
    Boolean realNews = false;
	NSMutableString* headLine = [[[NSMutableString alloc] init] retain];
	/*
	i = warpSystem % MAXMASTHEADS;
	SysStringByIndex(AnarchyMastheadsStringList + CURSYSTEM.Politics * 100,i,SBuf2,50);
	if (StrNCompare(SBuf2,"*",1) == 0)
	{
		StrCopy(SBuf,"The ");
		StrCat(SBuf, SolarSystemName[CURSYSTEM.NameIndex]);
		StrCat(SBuf, SBuf2 + 1);
		//DrawCharsCentered(SBuf, line, true);
		setCurrentWinTitle(SBuf);
		
	}
	else if (StrNCompare(SBuf2,"+",1) == 0)
	{
		StrCopy(SBuf, SolarSystemName[CURSYSTEM.NameIndex]);
		StrCat(SBuf, SBuf2 + 1);
		//DrawCharsCentered(SBuf, line, true);
		setCurrentWinTitle(SBuf);
		
	}
	else
	{
		//DrawCharsCentered(SBuf2, line, true);
		setCurrentWinTitle(SBuf2);
	}
	 */
	
	RandSeed( warpSystem, days );
	
	// Special Events get to go first, crowding out other news
	if  ([self isNewsEvent:CAPTAINHUIEATTACKED])
	{
		[headLine appendString:@"Famed Captain Huie Attacked by Brigand!\n"];
	}
	if  ([self isNewsEvent:EXPERIMENTPERFORMED])
	{
		[headLine appendString:@"Travelers Report Timespace Damage, Warp Problems!\n"];
	}
	if  ([self isNewsEvent:CAPTAINHUIEDESTROYED])
	{
		[headLine appendString:@"Citizens Mourn Destruction of Captain Huie's Ship!\n"];
	}
	if  ([self isNewsEvent:CAPTAINAHABATTACKED])
	{
		[headLine appendString:@"Thug Assaults Captain Ahab!\n"];
	}
	if  ([self isNewsEvent:CAPTAINAHABDESTROYED])
	{
		[headLine appendString:@"Destruction of Captain Ahab's Ship Causes Anger!\n"];
	}
	if  ([self isNewsEvent:CAPTAINCONRADATTACKED])
	{
		[headLine appendString:@"Captain Conrad Comes Under Attack By Criminal!\n"];
	}
	if  ([self isNewsEvent:CAPTAINCONRADDESTROYED])
	{
		[headLine appendString:@"Captain Conrad's Ship Destroyed by Villain!\n"];
	}
	if  ([self isNewsEvent:MONSTERKILLED])
	{
		[headLine appendString:@"Hero Slays Space Monster! Parade, Honors Planned for Today.\n"];
	}
	if  ([self isNewsEvent:WILDARRESTED])
	{
		[headLine appendString:@"Notorious Criminal Jonathan Wild Arrested!\n"];
	}
	if  (CURSYSTEM.Special == MONSTERKILLED &&  monsterStatus == 1)
	{
		[headLine appendString:@"Space Monster Threatens Homeworld!\n"];
	}
	if  (CURSYSTEM.Special == SCARABDESTROYED &&  scarabStatus == 1)
	{
		[headLine appendString:@"Wormhole Travelers Harassed by Unusual Ship!\n"];
	}
	if ([self isNewsEvent:EXPERIMENTSTOPPED])
	{
		[headLine appendString:@"Scientists Cancel High-profile Test! Committee to Investigate Design.\n"];
	}
	if ([self isNewsEvent:EXPERIMENTNOTSTOPPED])
	{
		[headLine appendString:@"Huge Explosion Reported at Research Facility.\n"];
	}
	if ([self isNewsEvent:DRAGONFLY])
	{
		[headLine appendString:@"Experimental Craft Stolen! Critics Demand Security Review.\n"];
	}
	if ([self isNewsEvent:SCARAB])
	{
		[headLine appendString:@"Security Scandal: Test Craft Confirmed Stolen.\n"];
	}
	if ([self isNewsEvent:FLYBARATAS])
	{
		[headLine appendString:@"Investigators Report Strange Craft.\n"];
	}
	if ([self isNewsEvent:FLYMELINA])
	{
		[headLine appendString:@"Rumors Continue: Melina Orbitted by Odd Starcraft.\n"];
	}
	if ([self isNewsEvent:FLYREGULAS])
	{
		[headLine appendString:@"Strange Ship Observed in Regulas Orbit.\n"];
	}
	if (CURSYSTEM.Special == DRAGONFLYDESTROYED && dragonflyStatus == 4 &&
	    ![self isNewsEvent:DRAGONFLYDESTROYED])
	{
		[headLine appendString:@"Unidentified Ship: A Threat to Zalkon?\n"];
	}
	if ([self isNewsEvent:DRAGONFLYDESTROYED])
	{
		[headLine appendString:@"Spectacular Display as Stolen Ship Destroyed in Fierce Space Battle.\n"];
	}
	if ([self isNewsEvent:SCARABDESTROYED])
	{
		[headLine appendString:@"Wormhole Traffic Delayed as Stolen Craft Destroyed.\n"];
	}
	if ([self isNewsEvent:MEDICINEDELIVERY])
	{
		[headLine appendString:@"Disease Antidotes Arrive! Health Officials Optimistic.\n"];
	}
	if ([self isNewsEvent:JAPORIDISEASE])
	{
		[headLine appendString:@"Editorial: We Must Help Japori!\n"];
	}
	if ([self isNewsEvent:ARTIFACTDELIVERY])
	{
		[headLine appendString:@"Scientist Adds Alien Artifact to Museum Collection.\n"];
	}
	if ([self isNewsEvent:JAREKGETSOUT])
	{
		[headLine appendString:@"Ambassador Jarek Returns from Crisis.\n"];
	} 
	if ([self isNewsEvent:WILDGETSOUT])
	{
		[headLine appendString:@"Rumors Suggest Known Criminal J. Wild May Come to Kravat!\n"];
	} 
	if ([self isNewsEvent:GEMULONRESCUED])
	{
		[headLine appendString:@"Invasion Imminent! Plans in Place to Repel Hostile Invaders.\n"];
	}
	if (CURSYSTEM.Special == GEMULONRESCUED && ![self isNewsEvent:GEMULONRESCUED])
	{
		[headLine appendString:@"Alien Invasion Devastates Planet!\n"];
	}
	if ([self isNewsEvent:ALIENINVASION])
	{
		[headLine appendString:@"Editorial: Who Will Warn Gemulon?\n"];
	}
	if ([self isNewsEvent:ARRIVALVIASINGULARITY])
	{
		[headLine appendString:@"Travelers Claim Sighting of Ship Materializing in Orbit!\n"];
	}
	
	
	// local system status information
	if (CURSYSTEM.Status > 0)
	{
		switch (CURSYSTEM.Status)
		{
			case WAR:
				[headLine appendString:@"War News: Offensives Continue!\n"];
				break;
			case PLAGUE:
				[headLine appendString:@"Plague Spreads! Outlook Grim.\n"];
				break;
			case DROUGHT:
				[headLine appendString:@"No Rain in Sight!\n"];
				break;
			case BOREDOM:
				[headLine appendString:@"Editors: Won't Someone Entertain Us?\n"];
				break;
			case COLD:
				[headLine appendString:@"Cold Snap Continues!\n"];
				break;
			case CROPFAILURE:
				[headLine appendString:@"Serious Crop Failure! Must We Ration?\n"];
				break;
			case LACKOFWORKERS:
				[headLine appendString:@"Jobless Rate at All-Time Low!\n"];
				break;
		}
	}
	
	// character-specific news.
	if (policeRecordScore <= VILLAINSCORE)
	{
		int j = GetRandom2(4);
		switch (j)
		{
			case 0:
				[headLine appendString:[NSString stringWithFormat:@"Police Warning: %@ Will Dock At %@!\n", pilotName, [self getSolarSystemName:CURSYSTEM.NameIndex]]];
				break;
			case 1:
				[headLine appendString:[NSString stringWithFormat:@"Notorious Criminal %@ Sighted in %@!\n", pilotName, [self getSolarSystemName:CURSYSTEM.NameIndex]]];
					break;
			case 2:
				[headLine appendString:[NSString stringWithFormat:@"Locals Rally to Deny Spaceport Access to %@!\n", pilotName]];


				break;
			case 3:
				[headLine appendString:[NSString stringWithFormat:@"Terror Strikes Locals on Arrival of %@!\n", pilotName]];

				break;
		}
	}
	
	if (policeRecordScore == HEROSCORE)
	{
		int j = GetRandom2(3);
		switch (j)
		{
			case 0:
				[headLine appendString:[NSString stringWithFormat:@"Locals Welcome Visiting Hero %@!\n", pilotName]];
				break;
			case 1:
				[headLine appendString:[NSString stringWithFormat:@"Famed Hero %@ to Visit System!\n", pilotName]];				
			
				break;
			case 2:
				[headLine appendString:[NSString stringWithFormat:@"Large Turnout At Spaceport to Welcome %@!\n", pilotName]];
				break;
		}
	}
	
	// caught littering?
	if  ([self isNewsEvent:CAUGHTLITTERING])
	{
		[headLine appendString:[NSString stringWithFormat:@"Police Trace Orbiting Space Litter to %@!\n", pilotName]];		

	}
	
	
	// and now, finally, useful news (if any)
	// base probability of a story showing up is (50 / MAXTECHLEVEL) * Current Tech Level
	// This is then modified by adding 10% for every level of play less than Impossible
	for (int i=0; i < MAXSOLARSYSTEM; i++)
	{
		if (i != currentSystem &&
		    (([self realDistance:currentSystem b:i] <= Shiptype[ship.Type].FuelTanks)
			 ||
			[self wormholeExists:currentSystem b:i])
		    &&
		    solarSystem[i].Status > 0)
		    
		{
			// Special stories that always get shown: moon, millionaire
			if (solarSystem[i].Special == MOONFORSALE)
			{
				[headLine appendString:[NSString stringWithFormat:@"Seller in %@ System has Utopian Moon available.\n", [self getSolarSystemName:i]]];				

			}
			if (solarSystem[i].Special == BUYTRIBBLE)
			{
				[headLine appendString:[NSString stringWithFormat:@"Collector in %@ System seeks to purchase Tribbles.\n", [self getSolarSystemName:i]]];						
			}
			
			// And not-always-shown stories
			if (GetRandom2(100) <= STORYPROBABILITY * CURSYSTEM.TechLevel + 10 * (5 - gameDifficulty))
			{
				int j = GetRandom2(6);
				switch (j)
				{
					case 0:
						[headLine appendString:@"Reports of "];
						break; 
					case 1:
						[headLine appendString:@"News of "];
						break;
					case 2:
						[headLine appendString:@"New Rumors of "];
						break;
					case 3:
						[headLine appendString:@"Sources say "];
						break;
					case 4:
						[headLine appendString:@"Notice: "];
						break;
					case 5:
						[headLine appendString:@"Evidence Suggests "];
						break;
				}

				switch (solarSystem[i].Status)
				{
					case WAR:
						[headLine appendString:@"Strife and War"];
						break;
					case PLAGUE:
						[headLine appendString:@"Plague Outbreaks"];
						break;
					case DROUGHT:
						[headLine appendString:@"Severe Drought"];
						break;
					case BOREDOM:
						[headLine appendString:@"Terrible Boredom"];
						break;
					case COLD:
						[headLine appendString:@"Cold Weather"];
						break;
					case CROPFAILURE:
						[headLine appendString:@"Crop Failures"];
						break;
					case LACKOFWORKERS:
						[headLine appendString:@"Labor Shortages"];
						break;
				}
				[headLine appendString:[NSString stringWithFormat:@" in the %@ System.\n ", [self getSolarSystemName:i]]];
				realNews = true;
			}
		}
	}
	
	// if there's no useful news, we throw up at least one
	// headline from our canned news list.
	//int count = 0 ;
	if (! realNews)
	{
		[headLine appendString:[NSString stringWithFormat:@"No news in the %@ System.\n ", [self getSolarSystemName:currentSystem]]];
		
	}
	/*
		for (int i=0; i< MAXSTORIES; i++)
		{
			shown[i]= false;
		}
		for (int i=0; i <=GetRandom2(MAXSTORIES); i++)
		{
			int j = GetRandom2(MAXSTORIES);
			if (!shown[j] && line <= 150) 
			{
				SysStringByIndex(AnarchyHeadlinesStringList + CURSYSTEM.Politics * 100,j,SBuf,63);
				[headLine appendString:@SBuf;
				shown[j] = true;
			}
		}
	}
	*/
	
	return headLine;
}


-(void)showSpecialEvent
{
	
	NSString * title = [NSString stringWithCString:SpecialEvent[CURSYSTEM.Special].Title];
	NSString * text = NSLocalizedString([NSString stringWithCString:SpecialEvent[CURSYSTEM.Special].QuestStringID], @"")	;

	AlertModalWindow * myAlertView;
	if (SpecialEvent[CURSYSTEM.Special].JustAMessage)
	{
		myAlertView = [[UIAlertView alloc] initWithTitle:title message:
										  text delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];	
		
	} else 
	{
		myAlertView = [[UIAlertView alloc] initWithTitle:title  message:
					   text delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];	
				
	}
	
	bLastMessage = false;
	[myAlertView show];
	[myAlertView release];		
	currentState = eSpecialEvent;
	
}

// *************************************************************************
// After erasure of police record, selling prices must be recalculated
// *************************************************************************
-(void) RecalculateSellPrices
{
	int i;
	
	for (i=0; i<MAXTRADEITEM; ++i)
		SellPrice[i] = (SellPrice[i] * 100) / 90;
}

// *************************************************************************
// NthLowest Skill. Returns skill with the nth lowest score
// (i.e., 2 is the second worst skill). If there is a tie, it will return
// in the order of Pilot, Fighter, Trader, Engineer.
// *************************************************************************

-(Byte) NthLowestSkill:(struct SHIP*)Sh  n:(Byte)n 
{
	Byte i = 0, lower = 1, retVal;
	Boolean looping = true;
	while (looping)
	{
		retVal = 0;
		if (Mercenary[Sh->Crew[0]].Pilot == i)
		{
			if (lower == n)
			{
				looping = false;
				retVal = PILOTSKILL;
			}
			
			lower++;
		}
		if (Mercenary[Sh->Crew[0]].Fighter == i)
		{
			if (lower == n)
			{
				looping = false;
				retVal = FIGHTERSKILL;
			}
			
			lower++;
		}
		if (Mercenary[Sh->Crew[0]].Trader == i)
		{
			if (lower == n)
			{
				looping = false;
				retVal = TRADERSKILL;
			}
			
			lower++;
		}
		if (Mercenary[Sh->Crew[0]].Engineer == i)
		{
			if (lower == n)
			{
				looping = false;
				retVal = ENGINEERSKILL;
			}
			
			lower++;
		}
		i++;
	}
	return retVal;
}


-(void) specialEventFormHandleEvent
{
	
	Boolean handled = false;
	int i, FirstEmptySlot;
	
	
	if ([self toSpend] < SpecialEvent[CURSYSTEM.Special].Price)
	{
		[self FrmAlert:@"NotEnoughForEventAlert"];
		//Changed
		//handled = true;
		[systemInfoController UpdateView];
		return;
	}
	
	credits -= SpecialEvent[CURSYSTEM.Special].Price;
	
	switch (CURSYSTEM.Special)
	{
			
		case GETREACTOR:
			currentState = eUpdateSpecial;
			if ([self filledCargoBays] > [self totalCargoBays] - 15)
			{
				[self FrmAlert:@"NotEnoughBaysAlert"];
				handled = true;
				break;
			}
			else if (wildStatus == 1)
			{
	//			if (FrmCustomAlert(WildWontStayOnboardAlert, SolarSystemName[CURSYSTEM.NameIndex],
	//							   NULL, NULL) == WildWontStayOnboardSayGoodbyetoWild)
	//			{
					wildStatus = 0;
				[self FrmAlert:@"WildLeavesShipAlert"];
					//FrmCustomAlert( WildLeavesShipAlert,SolarSystemName[CURSYSTEM.NameIndex],
					//			   NULL, NULL);
	//			}
	//			else
	//			{
	//				handled = true;
	//				break;
	//			}
				
			}
			[self FrmAlert:@"ReactorAlert"];
			reactorStatus = 1;
			break;
			
		case REACTORDELIVERED:
			CURSYSTEM.Special = GETSPECIALLASER;
			reactorStatus = 21;
			handled = true;
			currentState = eUpdateSpecial;			
			break;	
			
		case MONSTERKILLED:
			if (monsterStatus == 2) {
				CURSYSTEM.Special = 0;
				monsterStatus = 0;
			}
			return;
			break;
			
		case SCARAB:
			scarabStatus = 1;
			break;
			
		case SCARABDESTROYED:
			scarabStatus = 2;
			CURSYSTEM.Special = GETHULLUPGRADED;
			handled = true;
			break;	
			
		case GETHULLUPGRADED:
			[self FrmAlert:@"HullUpgradeAlert"];
			currentState = eUpdateSpecial;			
			ship.Hull += UPGRADEDHULL;
			scarabStatus = 3;
			handled = true;
			break;	
			
		case EXPERIMENT:
			experimentStatus = 1;
			break;
			
		case EXPERIMENTSTOPPED:
			experimentStatus = 13;
			canSuperWarp = true;
			break;
			
		case EXPERIMENTNOTSTOPPED:
			break;
			
		case ARTIFACTDELIVERY:
			artifactOnBoard = false;
			break;
			
		case ALIENARTIFACT:
			artifactOnBoard = true;
			break;
			
		case FLYBARATAS:
			++dragonflyStatus;
			break;
			
		case FLYMELINA:
			++dragonflyStatus;
			break;
			
		case FLYREGULAS:
			++dragonflyStatus;
			break;
			
		case DRAGONFLYDESTROYED:
			/*CURSYSTEM.Special*/solarSystem[ZALKONSYSTEM].Special = INSTALLLIGHTNINGSHIELD;
			handled = true;
			break;
			
		case GEMULONRESCUED:
			/*CURSYSTEM.Special*/solarSystem[GEMULONSYSTEM].Special = GETFUELCOMPACTOR;
			invasionStatus = 0;
			handled = true;
			break;
			
		case MEDICINEDELIVERY:
			japoriDiseaseStatus = 2;
			[self IncreaseRandomSkill];
			[self IncreaseRandomSkill];
			break;
			
		case MOONFORSALE:
			[self FrmAlert:@"BoughtMoonAlert"];
			currentState = eUpdateSpecial;			
			moonBought = true;
			break;
			
		case MOONBOUGHT:
			// TODO:!!!
			//EraseRectangle( 0, 0, 160, 160 );
			//CurForm = UtopiaForm;
			//FrmGotoForm( UtopiaForm );
			[self showUtopiaWindow];
			return ;
			break;
			
		case SKILLINCREASE:
			[self FrmAlert:@"SkillIncreaseAlert"];
			currentState = eUpdateSpecial;			
			[self IncreaseRandomSkill];
			break;
			
		case TRIBBLE:
			[self FrmAlert:@"YouHaveATribbleAlert"];	
			currentState = eUpdateSpecial;			
			ship.Tribbles = 1;
			break;
			
		case BUYTRIBBLE:
			[self FrmAlert:@"BeamOverTribblesAlert"];
			currentState = eUpdateSpecial;			
			credits += (ship.Tribbles >> 1);
			ship.Tribbles = 0;
			break;
			
		case ERASERECORD:
			[self FrmAlert:@"CleanRecordAlert"];
			currentState = eUpdateSpecial;			
			policeRecordScore = CLEANSCORE;
			[self RecalculateSellPrices];
			break;
			
		case SPACEMONSTER:
			monsterStatus = 1;
			for (i=0; i<MAXSOLARSYSTEM; ++i)
				if (solarSystem[i].Special == SPACEMONSTER)
					solarSystem[i].Special = -1;
			break;
			
		case DRAGONFLY:
			dragonflyStatus = 1;
			for (i=0; i<MAXSOLARSYSTEM; ++i)
				if (solarSystem[i].Special == DRAGONFLY)
					solarSystem[i].Special = -1;
			break;
			
		case AMBASSADORJAREK:
			if (ship.Crew[Shiptype[ship.Type].CrewQuarters-1] >= 0)
			{
				//FrmCustomAlert( NoQuartersAvailableAlert, "Ambassador Jarek", NULL, NULL );
				[self FrmAlert:@"NoQuartersAvailableAlert"];
				currentState = eUpdateSpecial;				
				handled = true;
				break;
			}
			//FrmCustomAlert( PassengerTakenOnBoardAlert, "Ambassador Jarek", NULL, NULL );
			[self FrmAlert:@"PassengerTakenOnBoardAlert"];
			currentState = eUpdateSpecial;
			jarekStatus = 1;
			break;
			
		case TRANSPORTWILD:
			
			if (ship.Crew[Shiptype[ship.Type].CrewQuarters-1] >= 0)
			{
				//FrmCustomAlert( NoQuartersAvailableAlert, "Jonathan Wild", NULL, NULL );
				[self FrmAlert:@"NoQuartersAvailableAlert"];
				currentState = eUpdateSpecial;
				handled = true;
				break;
			}
			if (![self HasWeapon:&ship Cg:BEAMLASERWEAPON exactCompare:false])
			{
				[self FrmAlert:@"WildWontGetAboardAlert"];
				currentState = eUpdateSpecial;
				handled = true;
				break;
			}
			if (reactorStatus > 0 && reactorStatus < 21)
			{
				[self FrmAlert:@"WildAfraidOfReactorAlert"];
				currentState = eUpdateSpecial;
				handled = true;
				break;
			}
//			FrmCustomAlert( PassengerTakenOnBoardAlert, "Jonathan Wild", NULL, NULL );
			[self FrmAlert:@"PassengerTakenOnBoardAlert"];
			currentState = eUpdateSpecial;
			wildStatus = 1;
			break;
			
			
		case ALIENINVASION:
			invasionStatus = 1;
			break;
			
		case JAREKGETSOUT:
			jarekStatus = 2;
			[self RecalculateBuyPrices:currentSystem];
			break;
			
		case WILDGETSOUT:
			wildStatus = 2;
			Mercenary[MAXCREWMEMBER-1].CurSystem = KRAVATSYSTEM;
			// Zeethibal has a 10 in player's lowest score, an 8
			// in the next lowest score, and 5 elsewhere.
			Mercenary[MAXCREWMEMBER-1].Pilot = 5;
			Mercenary[MAXCREWMEMBER-1].Fighter = 5;
			Mercenary[MAXCREWMEMBER-1].Trader = 5;
			Mercenary[MAXCREWMEMBER-1].Engineer = 5;
			switch ([self NthLowestSkill:&ship n:1])
		{
			case PILOTSKILL:
				Mercenary[MAXCREWMEMBER-1].Pilot = 10;
				break;
			case FIGHTERSKILL:
				Mercenary[MAXCREWMEMBER-1].Fighter = 10;
				break;
			case TRADERSKILL:
				Mercenary[MAXCREWMEMBER-1].Trader = 10;
				break;
			case ENGINEERSKILL:
				Mercenary[MAXCREWMEMBER-1].Engineer = 10;
				break;
		}
			switch ([self NthLowestSkill:&ship n:2])
		{
			case PILOTSKILL:
				Mercenary[MAXCREWMEMBER-1].Pilot = 8;
				break;
			case FIGHTERSKILL:
				Mercenary[MAXCREWMEMBER-1].Fighter = 8;
				break;
			case TRADERSKILL:
				Mercenary[MAXCREWMEMBER-1].Trader = 8;
				break;
			case ENGINEERSKILL:
				Mercenary[MAXCREWMEMBER-1].Engineer = 8;
				break;
		}
			
			if (policeRecordScore < CLEANSCORE)
				policeRecordScore = CLEANSCORE;
			break;
			
			
		case CARGOFORSALE:
			[self FrmAlert:@"SealedCannistersAlert"];
			currentState = eUpdateSpecial;
			i = GetRandom( MAXTRADEITEM );
			ship.Cargo[i] += 3;
			BuyingPrice[i] += SpecialEvent[CURSYSTEM.Special].Price;
			break;
			
		case INSTALLLIGHTNINGSHIELD:
			FirstEmptySlot = [self GetFirstEmptySlot:Shiptype[ship.Type].ShieldSlots Item:ship.Shield];
			currentState = eUpdateSpecial;
			if (FirstEmptySlot < 0)
			{
				[self FrmAlert:@"NotEnoughSlotsAlert"];
				handled = true;
			}
			else
			{
				[self FrmAlert:@"LightningShieldAlert"];
				ship.Shield[FirstEmptySlot] = LIGHTNINGSHIELD;
				ship.ShieldStrength[FirstEmptySlot] = Shieldtype[LIGHTNINGSHIELD].Power;
			}
			break;
			
		case GETSPECIALLASER:
			FirstEmptySlot =[self  GetFirstEmptySlot:Shiptype[ship.Type].WeaponSlots Item:ship.Weapon ];
			if (FirstEmptySlot < 0)
			{
				[self FrmAlert:@"NotEnoughSlotsAlert"];
				handled = true;
			}
			else
			{
				[self FrmAlert:@"MorganLaserAlert"];
				ship.Weapon[FirstEmptySlot] = MORGANLASERWEAPON;
			}
			currentState = eUpdateSpecial;
			break;
			
		case GETFUELCOMPACTOR:
			currentState = eUpdateSpecial;
			FirstEmptySlot = [self GetFirstEmptySlot:Shiptype[ship.Type].GadgetSlots Item:ship.Gadget];
			if (FirstEmptySlot < 0)
			{
			[self FrmAlert:@"NotEnoughSlotsAlert"];
				handled = true;
			}
			else
			{
				[self FrmAlert:@"FuelCompactorAlert"];
				ship.Gadget[FirstEmptySlot] = FUELCOMPACTOR;
				ship.Fuel = [self GetFuelTanks];
			}
			break;
			
		case JAPORIDISEASE:
			currentState = eUpdateSpecial;
			if ([self filledCargoBays] > [self totalCargoBays] - 10)
			{
				[self FrmAlert:@"NotEnoughBaysAlert"];
				handled = true;
			}
			else
			{
				[self FrmAlert:@"AntidoteAlert"];
				japoriDiseaseStatus = 1;
			}
			break;
			
	}
	if (!handled)				
		CURSYSTEM.Special = -1;
	
	[systemInfoController UpdateView];	
//	return handled;
}

// *************************************************************************
// Calculate the score
// *************************************************************************
long GetScore( char EndStatus, int Days, long Worth, char Level )
{
	long d;
	
	Worth = (Worth < 1000000 ? Worth : 1000000 + ((Worth - 1000000) / 10) );
	
	if (EndStatus == KILLED)
		return (Level+1L)*(long)((Worth * 90) / 50000);
	else if (EndStatus == RETIRED)
		return (Level+1L)*(long)((Worth * 95) / 50000);
	else
	{
		d = ((Level+1L)*100) - Days;
		if (d < 0)
			d = 0;
		return (Level+1L)*(long)((Worth + (d * 1000)) / 500);
	}
} 

// *************************************************************************
// Initializing the high score table
// *************************************************************************
 void InitHighScores (void)
{
 	int i;
 	
	for (i=0; i<MAXHIGHSCORE; ++i)
	{
		Hscores[i].Name[0] = '\0';
		Hscores[i].Status = 0;
		Hscores[i].Days = 0;
		Hscores[i].Worth = 0;
		Hscores[i].Difficulty = 0;
		Hscores[i].ForFutureUse = 0;
	}
}

-(void)clearHighScores {
	InitHighScores();
}

NSString* DifficultyLevel[MAXDIFFICULTY] =
{
@"Beginner",
@"Easy",
@"Normal",
@"Hard",
@"Impossible"
};


-(void)fillHighScores:(NSMutableArray*)array 
{
	[self LoadBinaryHighScore:@"scores" data:Hscores];
	int i;
	long Percentage;
	
	for (i=0; i<MAXHIGHSCORE; ++i)
	{
		if (Hscores[i].Name[0] == '\0')
		{
			continue;
		}

		Percentage = GetScore( Hscores[i].Status, Hscores[i].Days, Hscores[i].Worth,
							  Hscores[i].Difficulty );

		NSString * type, *level= DifficultyLevel[Hscores[i].Difficulty];
		if (Hscores[i].Status == MOON)
			type =@"Claimed moon";
		else if (Hscores[i].Status == RETIRED)
			type =@"Retired";
		else
			type=@"Was killed";

		
		[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [NSString stringWithFormat:@"%@    Finished:%i.%i%%", [NSString stringWithCString:Hscores[i].Name], (Percentage / 50L), ((Percentage%50L) / 5)], @"title",
							 [NSString stringWithFormat:@"%@ in %i days, worth %i credits on %@ level", type, Hscores[i].Days, Hscores[i].Worth, level ], @"line",
							 nil]];	

	}
}
// *************************************************************************
// Handling of endgame: highscore table
// *************************************************************************
-(bool) EndOfGame:( char) EndStatus
{
	int i, j;
	Boolean Scored;
	long a, b;

	
	Scored = false;
	i = 0;
	while (i<MAXHIGHSCORE)
	{
		a = GetScore( EndStatus, days, [self currentWorth], gameDifficulty );
		
		b =	GetScore( Hscores[i].Status, Hscores[i].Days, Hscores[i].Worth,
					 Hscores[i].Difficulty );
		
		if ((a > b) || (a == b && [self currentWorth] > Hscores[i].Worth) ||
			(a == b && [self currentWorth] == Hscores[i].Worth && days > Hscores[i].Days) ||
			Hscores[i].Name[0] == '\0')
		{
			for (j=MAXHIGHSCORE-1; j>i; --j)
			{
				strcpy( Hscores[j].Name, Hscores[j-1].Name );
				Hscores[j].Status = Hscores[j-1].Status;
				Hscores[j].Days = Hscores[j-1].Days;
				Hscores[j].Worth = Hscores[j-1].Worth;
				Hscores[j].Difficulty = Hscores[j-1].Difficulty;
			}
			[pilotName getCString:Hscores[i].Name maxLength:(NAMELEN+1) encoding:NSUTF8StringEncoding];

			Hscores[i].Status = EndStatus;
			Hscores[i].Days = days;
			Hscores[i].Worth = [self currentWorth];
			Hscores[i].Difficulty = gameDifficulty;
			[self SaveHighScore:@"scores"];
			Scored = true;
			break;
		}
		
		++i;
	}
	
	long Percentage = GetScore( Hscores[i].Status, Hscores[i].Days, Hscores[i].Worth,
						  Hscores[i].Difficulty );	
	NSString * fs;
	if (Scored)
		fs = @"Congratulations! You have made the high-score list!";
	else
		fs =@"Alas! This is not enough to enter the high-score list.";
	NSString * final = [NSString stringWithFormat:@"%@\nYou achieved a score of %i.%i%%.", fs,  (Percentage / 50L), ((Percentage%50L) / 5)];
	[self FrmAlert:final];

	return Scored;
}

-(bool)isMusicEnabled
{
	return options.musicEnabled != 0;
}

-(void)updateMercenary0Data {
	
	Mercenary[0].Trader = traderSkill;
	Mercenary[0].Engineer = engineerSkill;
	Mercenary[0].Fighter = fighterSkill;
	Mercenary[0].Pilot = pilotSkill;
	

}


-(NSUInteger)adaptPilotSkill {
	return [self PilotSkill:&ship];
	//	return pilotSkill;
}

-(NSUInteger)adaptTraderSkill {
	return [self TraderSkill:&ship];
//	return traderSkill;
}

-(NSUInteger)adaptFighterSkill {
	return [self FighterSkill:&ship];
//	return fighterSkill;
}

-(NSUInteger)adaptEngineerSkill {
	return [self EngineerSkill:&ship];
//	return engineerSkill;
}

@end
