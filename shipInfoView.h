#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface shipInfoView : UIView  {
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * sizeLabel;
	IBOutlet UILabel * cargoBaysLabel;
	IBOutlet UILabel * rangeLabel;
	IBOutlet UILabel * hullStrengthLabel;
	IBOutlet UILabel * weaponSlotsLabel;
	IBOutlet UILabel * shieldSlotsLabel;
	IBOutlet UILabel * gadgetSlotsLabel;
	IBOutlet UILabel * crewQuartersLabel;
	IBOutlet UIButton * doneButton;
	IBOutlet UIImageView * shipImage;
	int ship;
}
@property int ship;

-(IBAction) done;
@end
