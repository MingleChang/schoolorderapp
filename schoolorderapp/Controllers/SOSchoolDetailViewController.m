//
//  SOSchoolDetailViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSchoolDetailViewController.h"
#import "SOClassViewController.h"
#import "SODiscussViewController.h"
#import "SOIntroductionViewController.h"
#import "SOGroundViewController.h"
#import "SOCoachViewController.h"
#import "SONetwork.h"
#import <Masonry.h>
#import "SOApplyViewController.h"
#import "SOSchoolImageModel.h"
#import "TDImageShow.h"
#import "SOMapViewController.h"
#import "MBProgressHUD+HUDSHOW.h"

@interface SOSchoolDetailViewController ()<UIScrollViewDelegate,MCChooseViewDelegate>{
    NSArray *imagesList;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UIView *classView;
@property (weak, nonatomic) IBOutlet UIView *discussView;
@property (weak, nonatomic) IBOutlet UIView *introductionView;
@property (weak, nonatomic) IBOutlet UIView *groundView;
@property (weak, nonatomic) IBOutlet UIView *coachView;
@property (weak, nonatomic) IBOutlet UIImageView *schoolImage;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *haopingLab;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLab;
@property (weak, nonatomic) IBOutlet UILabel *cheliangLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starSpace;
@property (weak, nonatomic) IBOutlet UILabel *picNumber;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTopSpace;

@end

@implementation SOSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
}


-(void)configuration{
    [self setNav];
    [self.chooseView setAllTitiles:@[@"课程",@"评论",@"简介",@"场地",@"教练"]];
    [self getImageData];
    [self setInformation];
    [self addSubViewController];
}

-(void)setNav{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIButton *showBtn = [[UIButton alloc]initWithFrame:rightView.frame];
    [showBtn setTitle:@"展开" forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [showBtn addTarget:self action:@selector(showTableAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:showBtn];
    
    UIBarButtonItem *showBar = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = showBar;
}

-(void)addSubViewController{
    SOClassViewController *clas = [SOClassViewController new];
    clas.schoolModel = self.schoolModel;
    [self.classView addSubview:clas.view];
    [self addChildViewController:clas];
    [clas.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.classView);
    }];
    
    SODiscussViewController *dis = [SODiscussViewController new];
    dis.discussType = @"0";
    dis.schoolModel = self.schoolModel;
    [self.discussView addSubview:dis.view];
    [self addChildViewController:dis];
    [dis.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.discussView);
    }];
    
    SOIntroductionViewController *intro = [SOIntroductionViewController new];
    intro.schoolModel = self.schoolModel;
    [self.introductionView addSubview:intro.view];
    [self addChildViewController:intro];
    [intro.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.introductionView);
    }];
    
    SOGroundViewController *ground = [SOGroundViewController new];
    [self.groundView addSubview:ground.view];
    ground.schoolModel = self.schoolModel;
    [self addChildViewController:ground];
    [ground.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.groundView);
    }];
    
    SOCoachViewController *coach = [SOCoachViewController new];
    coach.schoolModel = self.schoolModel;
    [self.coachView addSubview:coach.view];
    [self addChildViewController:coach];
    [coach.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coachView);
    }];
}

-(void)getImageData{
    [SONetwork getWithProtocol:GET_SCHOOL_IMAGE_LIST(self.schoolModel.school_id) andParam:nil success:^(id data) {
        imagesList = [SOSchoolImageModel mj_objectArrayWithKeyValuesArray:data];
        SOSchoolImageModel *model = [imagesList firstObject];
        if (model) {
             [self.schoolImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:DefaultImage];
        }else{
             [self.schoolImage setImageWithURL:[NSURL URLWithString:self.schoolModel.imgUrl] placeholderImage:DefaultImage];
        }
    } failed:^{
        
    }];
}

-(void)showTableAction:(UIButton*)sender{
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"展开"]) {
        self.chooseTopSpace.constant = -272;
        [sender setTitle:@"还原" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }else{
        self.chooseTopSpace.constant = 5;
        [sender setTitle:@"展开" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    
}

-(void)setInformation{
    if (self.schoolModel) {
        self.schoolImage.image = DefaultImage;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapShowAllImage:)];
        [self.schoolImage addGestureRecognizer:tap];
        self.schoolName.text = self.schoolModel.schoolName;
        self.phoneLab.text = [NSString stringWithFormat:@"电话:%@",self.schoolModel.tel];
        float ratio = self.schoolModel.highRate/100;
        float space = 85-85*ratio;
        self.starSpace.constant = space;
        self.haopingLab.text = [NSString stringWithFormat:@"好评率:%d",(int)self.schoolModel.highRate];
        self.guanzhuLab.text = [NSString stringWithFormat:@"关注:%d",self.schoolModel.followNum];
        self.cheliangLab.text = [NSString stringWithFormat:@"车辆:%d",self.schoolModel.carNum];
        self.addressLab.text = self.schoolModel.schoolAddr;
        self.picNumber.text = [NSString stringWithFormat:@"%d",self.schoolModel.imgShowNum];
    }
}

-(void)imageTapShowAllImage:(UIGestureRecognizer*)gesture{
    if (imagesList.count!=0) {
        NSMutableArray *imgViews =[NSMutableArray new];
        NSMutableArray *imgUrls = [NSMutableArray new];
        for (SOSchoolImageModel *model in imagesList) {
            UIImageView *view = [[UIImageView alloc]initWithImage:DefaultImage];
            [imgViews addObject:view];
            [imgUrls addObject:model.imgUrl];
        }
        [[[TDImageShow alloc]init]showUrlImageWithImageViewArry:imgViews urls:imgUrls indexOfArry:0];
    }
}

-(void)MCChooseViewSelectIndex:(NSInteger)index{
    [self.mainScroll setContentOffset:CGPointMake(index*self.mainScroll.frame.size.width, 0) animated:YES];
}

- (IBAction)gotoApply:(id)sender {
    SOApplyViewController *apply = [SOApplyViewController new];
    apply.schoolModel = self.schoolModel;
    [self.navigationController pushViewController:apply animated:YES];
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.chooseView selectIndex:scrollView.contentOffset.x/scrollView.frame.size.width withAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goMapAction:(id)sender{
    if (self.schoolModel.schoolName.length==0||self.schoolModel.latitude==0||self.schoolModel.longitude==0) {
        [MBProgressHUD show:@"未获得地图信息" view:self.view];
        return;
    }
    SOMapViewController *map = [SOMapViewController new];
    [self.navigationController pushViewController:map animated:YES];
}

@end
