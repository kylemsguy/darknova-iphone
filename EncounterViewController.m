#import "EncounterViewController.h"
#import "SystemInfoViewController.h"
#import "S1AppDelegate.h"
#import "PlayerRENAME.h"

#import "math.h"

#define PI 3.14159265

#define ROTATE_VIEW_TAG	999

@implementation EncounterViewController

-(IBAction) close {
	[[self view] removeFromSuperview];
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer Travel];
}

-(UIImage*) drawShip:(bool)player
{

	long hull, shield, maxShield, hullMax;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (player) {
		hull = [app.gamePlayer getShipHull];
		shield = [app.gamePlayer getShipShield] ;
		maxShield = [app.gamePlayer getShipShieldMax] ;
		hullMax = [app.gamePlayer getShipHullMax];
	}
	else {
		hull = [app.gamePlayer getShipOpponentHull];
		shield = [app.gamePlayer getShipOpponentShield];		
		maxShield = [app.gamePlayer getShipShieldMax] 	;
		hullMax = [app.gamePlayer getShipOpponentHullMax];
	}

	
	float currentHullAspect = (float)hull/(float)hullMax;
	float currentShieldAspect = 0.0f;
	if (maxShield > 0)
		currentShieldAspect =  (float)shield/(float)maxShield;

	UIImage * fullHull, * fullDamage ;

	NSString * tmp;
	float aspect;
	if (currentShieldAspect > 0.0f)
	{
		aspect = currentShieldAspect;
		if (player)
		{
			tmp = [app.gamePlayer getShipImageName:[app.gamePlayer getCurrentShipType]];
			fullDamage = [UIImage imageNamed: tmp];
			//[tmp release];
			tmp = [app.gamePlayer getShipShieldImageName:[app.gamePlayer getCurrentShipType]];
			fullHull = [UIImage imageNamed:tmp];
			//[tmp release];
			
		}
		else
		{
			tmp = [app.gamePlayer getShipImageName:[app.gamePlayer getShipOpponentType]];
			fullDamage = [UIImage imageNamed:tmp];
			//[tmp release];
			tmp = [app.gamePlayer getShipShieldImageName:[app.gamePlayer getShipOpponentType]];
			fullHull = [UIImage imageNamed:tmp];
			//[tmp release];
		}
		
	}
	else
	{
		aspect = currentHullAspect;
		if (player)
		{
			tmp = [app.gamePlayer getShipImageName:[app.gamePlayer getCurrentShipType]];
			fullHull = [UIImage imageNamed:tmp];
			//[tmp release];			
			tmp = [app.gamePlayer getShipDamagedImageName:[app.gamePlayer getCurrentShipType]];
			fullDamage = [UIImage imageNamed:tmp];
			//[tmp release];			
		}
		else
		{
			tmp = [app.gamePlayer getShipImageName:[app.gamePlayer getShipOpponentType]];
			fullHull = [UIImage imageNamed:tmp];
			//[tmp release];			
			tmp = [app.gamePlayer getShipDamagedImageName:[app.gamePlayer getShipOpponentType]];
			fullDamage = [UIImage imageNamed:tmp];
			//[tmp release];	
		}
		
	}
	

	if (aspect > 1.0f)
		aspect = 1.0f;

	CGSize size = CGSizeMake(fullHull.size.width, fullHull.size.height);;
	
	UIGraphicsBeginImageContext(size);
	
	
	int startfullHullPos = aspect * fullHull.size.width;

	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	CGRect myImageArea = CGRectMake (fullHull.size.width - startfullHullPos, 0,
							  startfullHullPos, fullHull.size.height);
	
	CGImageRef img = CGImageRetain(fullHull.CGImage);
	CGImageRef mySubimage = CGImageCreateWithImageInRect (img, myImageArea);
	CGContextDrawImage(context, myImageArea, mySubimage);

	CGRect myImageArea2 = CGRectMake (0, 0,
									 fullDamage.size.width - startfullHullPos, fullHull.size.height);
	
	CGImageRef img2 = CGImageRetain(fullDamage.CGImage);
	CGImageRef mySubimage2 = CGImageCreateWithImageInRect (img2, myImageArea2);
	CGContextDrawImage(context, myImageArea2, mySubimage2);
	

	UIImage * destImage;	
	destImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGImageRelease(mySubimage);
	CGImageRelease(mySubimage2);
	CGImageRelease(img);
	CGImageRelease(img2);
	
//	[fullHull release];
//	[fullDamage release];
	
	return destImage;
}


-(void) dealloc 
{
	
	//[attackImage.image release];
	//[attackImage2.image release];  
	[super dealloc];
	
}


-(void)drawShips {
	
	/*for (int i = 0; i < 100; ++i) */{
		
	
	UIImage * i1 = [self drawShip:true];
	//[att
	attackImage.image = i1;
	//[i1 release];
	UIImage * i2 = [self drawShip:false];	
	attackImage2.image = i2;
	//[i2 release];	
	attackImage2.tag = ROTATE_VIEW_TAG;
	}

	CGAffineTransform transform = CGAffineTransformMakeRotation(PI);	
	
	[self.view addSubview:attackImage];
	[self.view addSubview:attackImage2];	
	
	[[self.view viewWithTag:ROTATE_VIEW_TAG] setTransform:transform];	
}

-(void)encounterButtons {
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	
	
	[attackImage removeFromSuperview];
	[attackButton  removeFromSuperview];
	[surrenderButton  removeFromSuperview];
	[ignoreButton  removeFromSuperview];
	[fleeButton  removeFromSuperview];
	[submitButton  removeFromSuperview];
	[bribeButton  removeFromSuperview];
	[plunderButton  removeFromSuperview];
	[interruptButton  removeFromSuperview];
	[drinkButton  removeFromSuperview];
	[boardButton  removeFromSuperview];
	[meetButton  removeFromSuperview];
	[yieldButton  removeFromSuperview];
	[tradeButton  removeFromSuperview];
//	if (attackImage.image)
//		[attackImage.image release];
//	if (attackImage2.image)
//		[attackImage2.image release];
	[attackImage  removeFromSuperview];
	[attackImage2  removeFromSuperview];
	[encounterTypeImage  removeFromSuperview];
	
	[self drawShips];
	
	if (pPlayer.autoAttack || pPlayer.autoFlee) {
		[self.view addSubview:interruptButton];
		pPlayer.attackIconStatus = !pPlayer.attackIconStatus;
		if (pPlayer.attackIconStatus) 
			[self.view addSubview:attackImage];
		else
			[self.view addSubview:attackImage2];
	}
	
	int encounterType = pPlayer.encounterType;
	if (encounterType == POLICEINSPECTION) {
		[self.view addSubview:attackButton];		
		[self.view addSubview:fleeButton];
		[self.view addSubview:submitButton];
		[self.view addSubview:bribeButton];
	} else 
		if (encounterType == POSTMARIEPOLICEENCOUNTER) {
			[self.view addSubview:attackButton];		
			[self.view addSubview:fleeButton];
			[self.view addSubview:yieldButton];
			[self.view addSubview:bribeButton];
		}else 
			if (encounterType == POLICEFLEE || encounterType == TRADERFLEE || encounterType == PIRATEFLEE ) {
				[self.view addSubview:attackButton];		
				[self.view addSubview:ignoreButton];
			}else 
				if (encounterType == POLICEATTACK || encounterType == PIRATEATTACK || encounterType == SCARABATTACK ) {
					[self.view addSubview:attackButton];		
					[self.view addSubview:fleeButton];
					[self.view addSubview:surrenderButton];
				}else 
					if (encounterType ==FAMOUSCAPATTACK ) {
						[self.view addSubview:attackButton];		
						[self.view addSubview:fleeButton];
					}else 
						if (encounterType == TRADERATTACK || encounterType == SPACEMONSTERATTACK || encounterType == DRAGONFLYATTACK ) {
							[self.view addSubview:attackButton];		
							[self.view addSubview:fleeButton];
						}else 
							if (encounterType == TRADERIGNORE || encounterType == POLICEIGNORE || encounterType == PIRATEIGNORE  ||
								encounterType == SPACEMONSTERIGNORE || encounterType == DRAGONFLYIGNORE || encounterType == SCARABIGNORE) {
								[self.view addSubview:attackButton];		
								[self.view addSubview:ignoreButton];
							}else 
								if (encounterType == TRADERSURRENDER || encounterType == PIRATESURRENDER ) {
									[self.view addSubview:attackButton];		
									[self.view addSubview:plunderButton];
									//[self.view addSubview:ignoreButton];
								}else 
									if (encounterType == MARIECELESTEENCOUNTER ) {
										[self.view addSubview:boardButton];		
										[self.view addSubview:ignoreButton];
									}else 
										if (ENCOUNTERFAMOUS(encounterType)) {
											[self.view addSubview:attackButton];		
											[self.view addSubview:ignoreButton];
											[self.view addSubview:meetButton];
										}else 
											if (encounterType == BOTTLEGOODENCOUNTER || encounterType == BOTTLEOLDENCOUNTER) {
												[self.view addSubview:drinkButton];		
												[self.view addSubview:ignoreButton];
											}else 
												if (encounterType == TRADERSELL || encounterType == TRADERBUY) {
													[self.view addSubview:attackButton];		
													[self.view addSubview:ignoreButton];
													[self.view addSubview:tradeButton];
												}
	if (!pPlayer.textualEncounters) {
		
		[message1Labe2 removeFromSuperview];
		[message1Label removeFromSuperview]; 
	}
	
	
}


// *************************************************************************
// Display on the encounter screen what the next action will be
// *************************************************************************
-(void) encounterDisplayNextAction:(bool) FirstDisplay
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	int EncounterType = pPlayer.encounterType;
	
	if (EncounterType == POLICEINSPECTION)
	{
		message1Labe2.text = @"The police summon you to submit to an inspection";
	}
	else if (EncounterType == POSTMARIEPOLICEENCOUNTER)
	{
		message1Labe2.text = @"We know you removed illegal goods from the Marie Celeste. You must give them up at once!";
	}
	else if (FirstDisplay && EncounterType == POLICEATTACK && 
			 pPlayer.policeRecordScore > CRIMINALSCORE)
	{
		message1Labe2.text = @"The police hail they want you to surrender.";
	}
	else if (EncounterType == POLICEFLEE || EncounterType == TRADERFLEE ||
			 EncounterType == PIRATEFLEE)
		message1Labe2.text = @"Your opponent is fleeing.";
	else if (EncounterType == PIRATEATTACK || EncounterType == POLICEATTACK ||
			 EncounterType == TRADERATTACK || EncounterType == SPACEMONSTERATTACK ||
			 EncounterType == DRAGONFLYATTACK || EncounterType == SCARABATTACK ||
			 EncounterType == FAMOUSCAPATTACK)
		message1Labe2.text = @ "Your opponent attacks.";
	else if (EncounterType == TRADERIGNORE || EncounterType == POLICEIGNORE ||
			 EncounterType == SPACEMONSTERIGNORE || EncounterType == DRAGONFLYIGNORE || 
			 EncounterType == PIRATEIGNORE || EncounterType == SCARABIGNORE)
	{
		if ([pPlayer isShipCloaked])
			message1Labe2.text = @"It doesn't notice you.";
		else
			message1Labe2.text = @"It ignores you.";
	}
	else if (EncounterType == TRADERSELL || EncounterType == TRADERBUY)
	{
	//	[self.view addSubview:encounterTypeImage];
	//	encounterTypeImage.image = [UIImage imageNamed:@"trader.png"];
		message1Labe2.text = @"You are hailed with an offer to trade goods.";
	}
	else if (EncounterType == TRADERSURRENDER || EncounterType == PIRATESURRENDER)
	{
		[self.view addSubview:encounterTypeImage];
		encounterTypeImage.image = [UIImage imageNamed:@"trader.png"];		
		message1Labe2.text = @"Your opponent hails that he surrenders to you.";
	}
	else if (EncounterType == MARIECELESTEENCOUNTER)
	{
		message1Labe2.text = @ "The Marie Celeste appears to be completely abandoned.";
	}
	else if (ENCOUNTERFAMOUS(EncounterType) && EncounterType != FAMOUSCAPATTACK)
	{
		message1Labe2.text = @"The Captain requests a brief meeting with you.";
	}
	else if (EncounterType == BOTTLEOLDENCOUNTER ||
	         EncounterType == BOTTLEGOODENCOUNTER)
	{
		message1Labe2.text = @"It appears to be a rare bottle of Captain Marmoset's Skill Tonic!";
    }
	
}
-(void) showEncounterWindow {
	[self encounterButtons];
	[self encounterDisplayNextAction:TRUE];
	

	//EncounterDisplayShips();
	//EncounterDisplayNextAction( true );
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	int EncounterType = pPlayer.encounterType;
	
	if (EncounterType == POSTMARIEPOLICEENCOUNTER)
	{
		message1Label.text = @"You encounter the Customs Police.";
	}
	else
	{
		NSString * shipType;
		NSString * shipName = [pPlayer getShipName:[pPlayer getShipOpponentType]];
		
		if (ENCOUNTERPOLICE( EncounterType )) {
			
			[self.view addSubview:encounterTypeImage];
			encounterTypeImage.image = [UIImage imageNamed:@"Police.png"];		
			shipType =@"a police";
		}
		else if (ENCOUNTERPIRATE( EncounterType ))
		{
			[self.view addSubview:encounterTypeImage];
			encounterTypeImage.image = [UIImage imageNamed:@"Pirate.png"];			
			if ([pPlayer getShipOpponentType] == MANTISTYPE)
				shipType =@"an alien";
			else
				shipType =@"a pirate";
		}
		else if (ENCOUNTERTRADER( EncounterType )){
			
			[self.view addSubview:encounterTypeImage];
			encounterTypeImage.image = [UIImage imageNamed:@"trader.png"];		
			shipType =@"a trader";
		}
		else if (ENCOUNTERMONSTER( EncounterType ))
			shipType =@" ";
		else if (EncounterType == MARIECELESTEENCOUNTER)
			shipType =@"a drifting ship";
		else if (EncounterType == CAPTAINAHABENCOUNTER)
			shipType =@"the famous Captain Ahab";
		else if (EncounterType == CAPTAINCONRADENCOUNTER)
			shipType =@"Captain Conrad";
		else if (EncounterType == CAPTAINHUIEENCOUNTER)
			shipType =@"Captain Huie";
		else if (EncounterType == BOTTLEOLDENCOUNTER || EncounterType == BOTTLEGOODENCOUNTER)
			shipType =@"a floating bottle.";
		else
			shipType =@"a stolen";
		if (message1Label.text.length == 0)
		message1Label.text = [NSString  stringWithFormat:@"At %i clicks from %@ you encounter %@ %@.", pPlayer.clicks, [pPlayer getSolarSystemName:pPlayer.warpSystem],
		shipType, shipName]; 
		
	
	}			

}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self SetLabelText:@""];
	[self showEncounterWindow];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = NSLocalizedString(@"Encounter", @"");//
	}
	return self;
}

-(IBAction) attack
{
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer attack];
	[self showEncounterWindow];
}

-(IBAction) flee
{
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer flee];
	[self showEncounterWindow];
}

-(IBAction) ignore
{
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer ignore];
	[self showEncounterWindow];
}

-(void) SetLabelText:(NSString*)text
{
	message1Label.text = text;
	//[self.view 
}
-(void) SetLabel2Text:(NSString*)text
{
	message1Labe2.text = text;
}

-(IBAction) trade {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer trade];	
}

-(IBAction)yield {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer yield];		
}

-(IBAction)surrender 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer surrender];		
	
}


-(IBAction)bribe 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer bribe];		
}

-(IBAction)submit 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer submit];		
}

-(IBAction)plunder 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer plunder];		
}

-(IBAction)interrupt 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer interrupt];		
}

-(IBAction)meet 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer meet];		
}

-(IBAction)board 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer board];		
}

-(IBAction)drink 
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	PlayerRENAME * pPlayer = app.gamePlayer;
	[pPlayer drink];		
}


@end
