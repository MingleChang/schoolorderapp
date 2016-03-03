//
//  SOIntroductionViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOIntroductionViewController.h"
#import "SONetwork.h"

@interface SOIntroductionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SOIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
}

-(void)getData{
    [SONetwork getWithProtocol:GET_INTRODUTION_PROTOCOL(self.schoolModel.school_id) andParam:nil success:^(id data) {
        NSDictionary *item =data;
        self.contentTextView.text = [item objectForKey:@"content"];
    } failed:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
