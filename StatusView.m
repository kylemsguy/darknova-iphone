#import "StatusView.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation StatusView

@synthesize pilotName, pilotSkill, traderSkill, fighterSkill, engineerSkill, kills, time, cash, debt, newWorth, reputation, policeRecord, difficulty;


-(void)UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	pilotName.text = app.gamePlayer.pilotName;
	pilotSkill.text = 	[NSString stringWithFormat:@"%i[%i]", app.gamePlayer.pilotSkill, [app.gamePlayer adaptPilotSkill]];
	traderSkill.text = 	[NSString stringWithFormat:@"%i[%i]", app.gamePlayer.traderSkill, [app.gamePlayer adaptTraderSkill]];
	fighterSkill.text = 	[NSString stringWithFormat:@"%i[%i]", app.gamePlayer.fighterSkill, [app.gamePlayer adaptFighterSkill]];
	engineerSkill.text = 	[NSString stringWithFormat:@"%i[%i]", app.gamePlayer.engineerSkill, [app.gamePlayer adaptEngineerSkill]];						 
	cash.text = [NSString stringWithFormat:@"%i cr.", app.gamePlayer.credits];
	debt.text = [NSString stringWithFormat:@"%i cr.", app.gamePlayer.debt];
	kills.text = [NSString stringWithFormat:@"%i", app.gamePlayer.policeKills + app.gamePlayer.traderKills + app.gamePlayer.pirateKills];
	time.text = [NSString stringWithFormat:@"%i days", app.gamePlayer.days];						 
	NSArray * names = [NSArray arrayWithObjects: @"Beginner", @"Easy", @"Normal", @"Hard", @"Impossible", nil];
	difficulty.text = [names objectAtIndex:app.gamePlayer.gameDifficulty];
	newWorth.text = [NSString stringWithFormat:@"%i cr.", [app.gamePlayer currentWorth]];
	reputation.text = [app.gamePlayer currentReputation];							 
	policeRecord.text = [app.gamePlayer currentPoliceRecord];							 
}


-(void)viewDidAppear {
	[self UpdateView];
	
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self UpdateView];
}
@end
