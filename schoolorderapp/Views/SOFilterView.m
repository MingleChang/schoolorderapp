//
//  SOFilterView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOFilterView.h"
#import "SOCommon.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define WHOLE_STR @"全部"

#define SCHOOL_CELL_ID @"SCHOOL_CELL_ID"

@interface SOFilterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UILabel *homeTearcherLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeKemuLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeOkButton;
@property (weak, nonatomic) IBOutlet UIButton *homeClearButton;
- (IBAction)homeTearcherButtonClick:(UIButton *)sender;
- (IBAction)homeSchoolButtonClick:(UIButton *)sender;
- (IBAction)homeKemuButtonClick:(UIButton *)sender;
- (IBAction)homeTypeButtonClick:(UIButton *)sender;
- (IBAction)homeOkButtonClick:(UIButton *)sender;
- (IBAction)homeClearButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UITextField *tearchInputText;
@property (weak, nonatomic) IBOutlet UIButton *teacherOkButton;
@property (weak, nonatomic) IBOutlet UIButton *tearcherCancelButton;
- (IBAction)teacherOkButtonClick:(UIButton *)sender;
- (IBAction)teacherCancelButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *schoolView;
@property (weak, nonatomic) IBOutlet UISearchBar *schoolSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *schoolTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolTableViewBottomConstraint;
@property(nonatomic,copy)NSDictionary *schoolDic;


@property (weak, nonatomic) IBOutlet UIView *kemuView;
- (IBAction)kemuWholeButtonClick:(UIButton *)sender;
- (IBAction)kemuTwoButtonClick:(UIButton *)sender;
- (IBAction)kemuThreeButtonClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *typeView;
- (IBAction)typeWholeButtonClick:(UIButton *)sender;
- (IBAction)typeC1ButtonClick:(UIButton *)sender;
- (IBAction)typeC2ButtonClick:(UIButton *)sender;

@property(nonatomic,copy)NSString *filterTeacherName;
@property(nonatomic,strong)SOSchoolListModel *filterSchool;
@property(nonatomic,copy)NSString *filterKemu;
@property(nonatomic,copy)NSString *filterType;


-(IBAction)dismissButtonClick:(UIButton *)sender;
@end

@implementation SOFilterView
+(void)showWith:(id<SOFilterViewDelegate>)delegate{
    SOFilterView *lView=[[NSBundle mainBundle]loadNibNamed:@"SOFilterView" owner:nil options:nil][0];
    lView.delegate=delegate;
    lView.frame=[MCDevice screenBounds];
    [lView show];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self configure];
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.lineHeightConstraint.constant=ONE_PIXEL;
    [self configureHomeView];
    [self configureSchoolView];
}
-(void)configureData{
    
}
#pragma mark - Private Motheds
-(void)show{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setKeyboardManagerEnable:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)dismiss{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self setKeyboardManagerEnable:YES];
    [self removeFromSuperview];
}
-(IBAction)dismissButtonClick:(UIButton *)sender{
    [self dismiss];
}
-(void)setKeyboardManagerEnable:(BOOL)enable{
    [[IQKeyboardManager sharedManager]setEnable:enable];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:enable];
}

#pragma mark -
#pragma mark - Home
-(void)configureHomeView{
    self.filterTeacherName=[SOManager manager].filterTeacherName;
    self.filterSchool=[SOManager manager].filterSchool;
    self.filterKemu=[SOManager manager].filterKemu;
    self.filterType=[SOManager manager].filterType;
    self.homeTearcherLabel.text=self.filterTeacherName.length==0?WHOLE_STR:self.filterTeacherName;
    self.homeSchoolLabel.text=self.filterSchool.schoolName.length==0?WHOLE_STR:self.filterSchool.schoolName;
    if ([self.filterKemu isEqualToString:@"km1"]) {
        self.homeKemuLabel.text=@"科目一";
    }else if ([self.filterKemu isEqualToString:@"km2"]) {
        self.homeKemuLabel.text=@"科目二";
    }else if ([self.filterKemu isEqualToString:@"km3"]) {
        self.homeKemuLabel.text=@"科目三";
    }else if ([self.filterKemu isEqualToString:@"km4"]) {
        self.homeKemuLabel.text=@"科目四";
    }else{
        self.homeKemuLabel.text=WHOLE_STR;
    }
    if ([self.filterType isEqualToString:@"C1"]) {
        self.homeTypeLabel.text=@"C1(手动档)";
    }else if ([self.filterType isEqualToString:@"C2"]) {
        self.homeTypeLabel.text=@"C2(自动档)";
    }else{
        self.homeTypeLabel.text=WHOLE_STR;
    }
//    self.homeKemuLabel.text=self.filterKemu.length==0?WHOLE_STR:self.filterKemu;
//    self.homeTypeLabel.text=self.filterType.length==0?WHOLE_STR:self.filterType;
}
- (IBAction)homeTearcherButtonClick:(UIButton *)sender {
    self.homeView.hidden=YES;
    self.teacherView.hidden=NO;
}

- (IBAction)homeSchoolButtonClick:(UIButton *)sender {
    self.homeView.hidden=YES;
    self.schoolView.hidden=NO;
}

- (IBAction)homeKemuButtonClick:(UIButton *)sender {
    self.homeView.hidden=YES;
    self.kemuView.hidden=NO;
}

- (IBAction)homeTypeButtonClick:(UIButton *)sender {
    self.homeView.hidden=YES;
    self.typeView.hidden=NO;
}

- (IBAction)homeOkButtonClick:(UIButton *)sender {
    [SOManager manager].filterTeacherName=self.filterTeacherName;
    [SOManager manager].filterSchool=self.filterSchool;
    [SOManager manager].filterKemu=self.filterKemu;
    [SOManager manager].filterType=self.filterType;
    if ([self.delegate respondsToSelector:@selector(fileViewOkClick:)]) {
        [self.delegate fileViewOkClick:self];
    }
    [self dismiss];
}

- (IBAction)homeClearButtonClick:(UIButton *)sender {
    self.filterTeacherName=nil;
    self.filterSchool=nil;
    self.filterKemu=nil;
    self.filterType=nil;
    self.homeTearcherLabel.text=self.filterTeacherName.length==0?WHOLE_STR:self.filterTeacherName;
    self.homeSchoolLabel.text=self.filterSchool.schoolName.length==0?WHOLE_STR:self.filterSchool.schoolName;
    self.homeKemuLabel.text=self.filterKemu.length==0?WHOLE_STR:self.filterKemu;
    self.homeTypeLabel.text=self.filterType.length==0?WHOLE_STR:self.filterType;
}

#pragma mark - Teacher
- (IBAction)teacherOkButtonClick:(UIButton *)sender {
    NSString *lStr=[self.tearchInputText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.filterTeacherName=lStr;
    self.homeTearcherLabel.text=self.filterTeacherName.length==0?WHOLE_STR:self.filterTeacherName;
    [self teacherViewDismiss];
}

- (IBAction)teacherCancelButtonClick:(UIButton *)sender {
    [self teacherViewDismiss];
}
-(void)teacherViewDismiss{
    [self.tearchInputText resignFirstResponder];
    self.teacherView.hidden=YES;
    self.homeView.hidden=NO;
}

#pragma mark -
#pragma mark - School
-(void)configureSchoolView{
    [self.schoolTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SCHOOL_CELL_ID];
    [self analysisTopAreaWith:nil];
}
-(void)schoolViewDismiss{
    self.homeSchoolLabel.text=self.filterSchool.schoolName.length==0?WHOLE_STR:self.filterSchool.schoolName;
    [self.schoolSearchBar resignFirstResponder];
    self.schoolView.hidden=YES;
    self.homeView.hidden=NO;
}
-(void)analysisTopAreaWith:(NSString *)key{
    NSArray *lArray=nil;
    if (key.length==0) {
        lArray=[SOManager manager].schoolArray;
    }else{
        NSString *lPredicateStr=[NSString stringWithFormat:@"schoolName CONTAINS '%@'",key];
        NSPredicate *lPredicate=[NSPredicate predicateWithFormat:lPredicateStr];
        lArray=[[SOManager manager].schoolArray filteredArrayUsingPredicate:lPredicate];
    }
    NSMutableDictionary *lDic=[NSMutableDictionary dictionary];
    for (SOSchoolListModel *school in lArray) {
        NSString *lHeaderAlphabet=[SOCommon getHeaderAlphabet:school.schoolName];
        if ([lDic.allKeys containsObject:lHeaderAlphabet]) {
            NSMutableArray *lArray=[lDic objectForKey:lHeaderAlphabet];
            [lArray addObject:school];
        }else{
            NSMutableArray *lArray=[NSMutableArray array];
            [lArray addObject:school];
            [lDic setObject:lArray forKey:lHeaderAlphabet];
        }
    }
    self.schoolDic=lDic;
    [self.schoolTableView reloadData];
}
-(SOSchoolListModel *)getAreaWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section]-1;
    NSArray *lKeys=[self getSchoolKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section];
    NSArray *lArray=[self.schoolDic objectForKey:lKey];
    SOSchoolListModel *lSchool=lArray[row];
    return lSchool;
}
-(NSArray *)getSchoolKeyArray{
    NSArray *lKeys=[[self.schoolDic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    return lKeys;
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.schoolDic.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    NSArray *lKeys=[self getSchoolKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section-1];
    NSArray *lArray=[self.schoolDic objectForKey:lKey];
    return lArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *lCell=[tableView dequeueReusableCellWithIdentifier:SCHOOL_CELL_ID forIndexPath:indexPath];
    if (indexPath.section==0) {
        lCell.textLabel.text=WHOLE_STR;
    }else{
        SOSchoolListModel *lSchool=[self getAreaWithIndexPath:indexPath];
        lCell.textLabel.text=lSchool.schoolName;
    }
    
    return lCell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"";
    }
    NSArray *lKeys=[self getSchoolKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section-1];
    return lKey;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [@[@""] arrayByAddingObjectsFromArray:[self getSchoolKeyArray]];
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        self.filterSchool=nil;
    }else{
        SOSchoolListModel *lSchool=[self getAreaWithIndexPath:indexPath];
        self.filterSchool=lSchool;
    }
    [self schoolViewDismiss];
}
#pragma mark - UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self analysisTopAreaWith:searchText];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
#pragma mark - UIKeyboardWillChangeFrame Notification
-(void)keyboardChangeFrame:(NSNotification *)notification{
    CGRect lFrame=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat lHeight=[MCDevice screenHeight]-lFrame.origin.y;
    self.schoolTableViewBottomConstraint.constant=lHeight;
}

#pragma mark -
#pragma mark - Kemu
- (IBAction)kemuWholeButtonClick:(UIButton *)sender {
    self.filterKemu=nil;
    [self kemuViewDismiss];
}

- (IBAction)kemuTwoButtonClick:(UIButton *)sender {
    self.filterKemu=@"km2";
    [self kemuViewDismiss];
}

- (IBAction)kemuThreeButtonClick:(UIButton *)sender {
    self.filterKemu=@"km3";
    [self kemuViewDismiss];
}
-(void)kemuViewDismiss{
//    self.homeKemuLabel.text=self.filterKemu.length==0?WHOLE_STR:self.filterKemu;
    if ([self.filterKemu isEqualToString:@"km1"]) {
        self.homeKemuLabel.text=@"科目一";
    }else if ([self.filterKemu isEqualToString:@"km2"]) {
        self.homeKemuLabel.text=@"科目二";
    }else if ([self.filterKemu isEqualToString:@"km3"]) {
        self.homeKemuLabel.text=@"科目三";
    }else if ([self.filterKemu isEqualToString:@"km4"]) {
        self.homeKemuLabel.text=@"科目四";
    }else{
        self.homeKemuLabel.text=WHOLE_STR;
    }
    self.kemuView.hidden=YES;
    self.homeView.hidden=NO;
}
#pragma mark -
#pragma mark - Type
- (IBAction)typeWholeButtonClick:(UIButton *)sender {
    self.filterType=nil;
    [self typeViewDismiss];
}

- (IBAction)typeC1ButtonClick:(UIButton *)sender {
    self.filterType=@"C1";
    [self typeViewDismiss];
}

- (IBAction)typeC2ButtonClick:(UIButton *)sender {
    self.filterType=@"C2";
    [self typeViewDismiss];
}
-(void)typeViewDismiss{
//    self.homeTypeLabel.text=self.filterType.length==0?WHOLE_STR:self.filterType;
    if ([self.filterType isEqualToString:@"C1"]) {
        self.homeTypeLabel.text=@"C1(手动档)";
    }else if ([self.filterType isEqualToString:@"C2"]) {
        self.homeTypeLabel.text=@"C2(自动档)";
    }else{
        self.homeTypeLabel.text=WHOLE_STR;
    }
    self.typeView.hidden=YES;
    self.homeView.hidden=NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/





@end
