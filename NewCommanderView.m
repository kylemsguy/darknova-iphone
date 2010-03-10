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

#import "NewCommanderView.h"
#import "S1AppDelegate.h"
#import "Player.h"
@implementation NewCommanderView

/*
- (IBAction)decDifficulty {
  difficultyLevel.text = @"Normal";   
}
*/

@synthesize pilotName;

-(void) showCurrentPlayerData {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
//	if (app.isGameLoaded)
//	{
//		[self removeFromSuperview];
//		return;
//	}
	
	difficultyLevel.text =@"Normal";
	//player * p = app.gamePlayer;
	
	//NSUInteger pi = [p getpilotSkill];
	pilotPointsLabel.text = [NSString stringWithFormat:@"%i", app.gamePlayer.pilotSkill];
	traderPointsLabel.text = [NSString stringWithFormat:@"%i", app.gamePlayer.traderSkill];
	engineerPointsLabel.text = [NSString stringWithFormat:@"%i", app.gamePlayer.engineerSkill];
	fighterPointsLabel.text = [NSString stringWithFormat:@"%i", app.gamePlayer.fighterSkill];
	skillPoints.text = [NSString stringWithFormat:@"%i", app.gamePlayer.totalSkillPoints];	
	pilotName.text = app.gamePlayer.pilotName;
	
	NSArray * names = [NSArray arrayWithObjects: @"Beginner", @"Easy", @"Normal", @"Hard", @"Impossible", nil];
	difficultyLevel.text = [names objectAtIndex:app.gamePlayer.gameDifficulty];
	
		
}

- (IBAction)decDifficulty {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.gameDifficulty > 0) 
		--app.gamePlayer.gameDifficulty;
	[self showCurrentPlayerData];
}

- (IBAction)addDifficulty {
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.gameDifficulty < 4)
		++app.gamePlayer.gameDifficulty;	
	[self showCurrentPlayerData];	
}

- (IBAction)decPilotSkill {
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.pilotSkill > 1) {
		--app.gamePlayer.pilotSkill;	
		app.gamePlayer.totalSkillPoints++;
	}
	[self showCurrentPlayerData];	
}

- (IBAction)addPilotSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.pilotSkill < 10 && app.gamePlayer.totalSkillPoints > 0) {
		++app.gamePlayer.pilotSkill;	
		app.gamePlayer.totalSkillPoints--;
	}
	 
	[self showCurrentPlayerData];
}

- (IBAction)decFighterSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.fighterSkill > 1) {
		--app.gamePlayer.fighterSkill;	
		app.gamePlayer.totalSkillPoints++;	
	}
	[self showCurrentPlayerData];	
}
- (IBAction)addFighterSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.fighterSkill <10 && app.gamePlayer.totalSkillPoints > 0) {
		++app.gamePlayer.fighterSkill;	
		app.gamePlayer.totalSkillPoints--;
	}
	
	[self showCurrentPlayerData];	
}

- (IBAction)decTraderSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.traderSkill > 1) {
		--app.gamePlayer.traderSkill;	
		app.gamePlayer.totalSkillPoints++;	
	}
	[self showCurrentPlayerData];
}

- (IBAction)addTraderSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.traderSkill <10 && app.gamePlayer.totalSkillPoints > 0) {
		++app.gamePlayer.traderSkill;
		app.gamePlayer.totalSkillPoints--;
	}
	[self showCurrentPlayerData];	
}

- (IBAction)decEngineerSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.engineerSkill > 1) {
		--app.gamePlayer.engineerSkill;	
		app.gamePlayer.totalSkillPoints++;	
	}
	
	[self showCurrentPlayerData];
}

- (IBAction)addEngineerSkill {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (app.gamePlayer.engineerSkill <10 && app.gamePlayer.totalSkillPoints > 0) {
		++app.gamePlayer.engineerSkill;		
		app.gamePlayer.totalSkillPoints--;
	}
	[self showCurrentPlayerData];	
}

-(IBAction)finishInputName {
	[self.pilotName resignFirstResponder];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.pilotName = pilotName.text;//placeholder;
	//[[[self pilotName] view] resignFirstResponder];
}

- (void)awakeFromNib
{
	[self showCurrentPlayerData];
}

- (void)didMoveToSuperview
{
	
}

@end
