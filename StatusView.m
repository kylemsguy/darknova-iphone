/*
    Dark Nova © Copyright 2009 Dead Jim Studios
    This file is part of Dark Nova.

    Dark Nova is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Dark Nova is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dark Nova.  If not, see <http://www.gnu.org/licenses/>
*/

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
