//
//  SOSubAreaCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/11.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSubAreaCell.h"
#import "SOArea.h"

@interface SOSubAreaCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property(nonatomic,strong)SOArea *area;
@end
@implementation SOSubAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}


#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.layer.borderColor=RGBColor(0, 0, 0, 0.2).CGColor;
    self.layer.borderWidth=ONE_PIXEL;
}
-(void)configureData{
}

-(void)setupArea:(SOArea *)area{
    self.area=area;
    self.cityNameLabel.text=area.area_name;
    if ([[SOManager manager].selectedSubArea.area_code isEqualToString:area.area_code]) {
        self.backgroundColor=[UIColor lightGrayColor];
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}
@end
