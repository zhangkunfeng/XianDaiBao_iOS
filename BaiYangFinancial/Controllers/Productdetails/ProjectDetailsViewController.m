//
//  ProjectDetailsViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/12/2.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "YiRefreshHeader.h"

#define ProjectDetailText @"项目详情"

@interface ProjectDetailsViewController ()

@property(nonatomic ,copy)NSDictionary * projectDetailDict;

@property (nonatomic, strong) YiRefreshHeader *yiRefreshHeader;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *BackgroundBigView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundBigViewHeight;//507.5
@property (weak, nonatomic) IBOutlet UILabel *projectIntroduction;//项目介绍view

//宽度适配  UIScrollView 下属view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenViewWidthNSLayout;

//项目介绍
@property (weak, nonatomic) IBOutlet UILabel *projectDescriptionLabel;

//借款人信息
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *NativePlaceLabel;//籍贯
@property (weak, nonatomic) IBOutlet UILabel *isMarriedLabel;  //婚配

//借款车辆信息
@property (weak, nonatomic) IBOutlet UIView *BorrowerCarInformationView;//173+7.5(space)
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel; //品牌
@property (weak, nonatomic) IBOutlet UILabel *carID;
@property (weak, nonatomic) IBOutlet UILabel *drivingKMLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedLabel;//估价

//信用标 标题
@property (weak, nonatomic) IBOutlet UILabel *creditMainTitle;

@property (weak, nonatomic) IBOutlet UILabel *creditScaleTitle_education;   //教育
@property (weak, nonatomic) IBOutlet UILabel *creditScaleTitle_occupation;  //职业
@property (weak, nonatomic) IBOutlet UILabel *creditScaleTitle_annualIncome;//年收入

//信用标适配
@property (weak, nonatomic) IBOutlet UILabel *lastTitleHidden;
@property (weak, nonatomic) IBOutlet UILabel *lastDescHidden;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHeight; // 147 原始173

@end

@implementation ProjectDetailsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:ProjectDetailText];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:ProjectDetailText];
    [self hideMDErrorShowView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contenViewWidthNSLayout.constant = iPhone6 ? 375 : iPhone6_ ? 414 : 320;
    self.backgroundBigViewHeight.constant = self.projectIntroduction.frame.size.height+7.5*4+173+147+15/*+15不知*/;
    
    [self setupHeaderRefresh];//实现下拉释放
    [self loadProjectDeatilData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    self.contentScrollView.frame = CGRectMake(0, 0, iPhoneWidth, iPhoneHeight-64-44-49);
    self.contentScrollView.contentSize = CGSizeMake(iPhoneWidth, self.backgroundBigViewHeight.constant + (iPhone6?15:iPhone6_?80:0));
}

#pragma mark - YiRefreshHeader
- (void)setupHeaderRefresh
{
    // YiRefreshHeader  头部刷新按钮的使用
    _yiRefreshHeader=[[YiRefreshHeader alloc] init];
    _yiRefreshHeader.scrollView = self.contentScrollView;
    [_yiRefreshHeader header];
    typeof(_yiRefreshHeader) __weak weakRefreshHeader = _yiRefreshHeader;
    _yiRefreshHeader.beginRefreshingBlock=^(){
        typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
        [[NSNotificationCenter defaultCenter] postNotificationName:changeDetailContentScrollView object:nil];
        [strongRefreshHeader endRefreshing];
    };
    //    // 是否在进入该界面的时候就开始进入刷新状态
    //    [_refreshHeader beginRefreshing];
}


/**
 * typeId 抵押物类型 1 ：车贷   2：房贷   3：银行汇票    4：贸易通
 */
- (void)loadProjectDeatilData
{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"bid": _bidString,
                                  };

    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/productDetail",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf loadProjectDeatilData];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([self isLegalObject:responseObject[@"item"]]) {
                    _projectDetailDict = [responseObject[@"item"] copy];
//                    NSLog(@"--> %@",_projectDetailDict);
                    [self setValueToView];
                }
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//                [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
            }
        }else{
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
//            [self showMDErrorShowViewForError:self MDErrorShowViewFram:self.view.bounds contentShowString:responseObject[@"msg"] MDErrorShowViewType:NoData];
        }
    }
                              fail:^{
                                  [self dismissWithDataRequestStatus];
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
//                                [self initWithWDprojectErrorview:nil contentView:self MDErrorShowViewFram:self.view.bounds];
                              }];
}

/*
 <<<<<>>>>>>>>productdetail = {
	vArea2 = <null>,
	appraisement = 30000,
	plateNumber = 黑E*****,
	carName = 现代瑞纳,
	marriage = 已婚,
	education = ,
	annualIncome = ,
	occupation = ,
	sex = 男,
	productTypeId = 1,
	mileage = 170000
 }
  **/

- (void)setValueToView
{
    self.sexLabel.text = [self isLegalObject:_projectDetailDict[@"sex"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"sex"]] : @"-";
    self.NativePlaceLabel.text = [self isLegalObject:_projectDetailDict[@"vArea2"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"vArea2"]] : @"-";
    self.isMarriedLabel.text = [self isLegalObject:_projectDetailDict[@"marriage"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"marriage"]] : @"-";
    
    /**
     *  标的区分   默认标&信用标
     */
    if ([self isLegalObject:_projectDetailDict[@"productTypeId"]] && [[_projectDetailDict[@"productTypeId"] stringValue] isEqualToString:@"1"]) {
        /**
         * typeId 抵押物类型 1 ：车贷  2：房贷   3：银行汇票（票据富产品） 4：贸易通
         */
        switch ([self isLegalObject:_projectDetailDict[@"typeId"]] ? [_projectDetailDict[@"typeId"] integerValue] : 0) {
            case 1:
            {
                self.projectDescriptionLabel.text = @"本产品为个人资金周转借款，借款人以车辆为抵押物。每个借款人经过风控人员的多层风控考察筛选。通过车辆抵质押保障还款来源，稳健可靠。";
                
                self.carBrandLabel.text = [self isLegalObject:_projectDetailDict[@"carName"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"carName"]] : @"-";
                self.carID.text = [self isLegalObject:_projectDetailDict[@"plateNumber"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"plateNumber"]] : @"-";
                self.drivingKMLabel.text = [self isLegalObject:_projectDetailDict[@"mileage"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"mileage"]] : @"-";
                self.estimatedLabel.text = [self isLegalObject:_projectDetailDict[@"appraisement"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"appraisement"]] : @"-";
                
            }
                break;
            case 2:
            {
                self.BorrowerCarInformationView.hidden = YES;
//                self.backgroundBigViewHeight.constant -= (173+7.5);
                self.projectDescriptionLabel.text = @"本产品为个人资金周转借款，借款人以房产为抵押物。每个借款人经过风控人员的多层风控考察筛选。通过房屋质押保障还款来源，稳健可靠。";
            }
                break;
            case 3:
            {
                self.BorrowerCarInformationView.hidden = YES;
//                self.backgroundBigViewHeight.constant -= (173+7.5);
                self.projectDescriptionLabel.text = @"该产品是基于银行商业汇票所衍生的一个产品，企业通过其所在的开户银行开立票据，以此商业汇票作为质押，在贤钱宝网平台经过一系列审查之后，发起借款需求，筹集款项，到期后由出票银行无条件完成兑付，具有“低门槛”、“高收益”、“低风险-银行承诺兑付”等一系列优点。";
            }
                break;
                
            case 4:
            {
                self.BorrowerCarInformationView.hidden = YES;
                self.backgroundBigViewHeight.constant -= (173+7.5);
                self.projectDescriptionLabel.text = @"该产品是在贤钱宝网的平台多重风险保障体系下，经过严格的理论论证和实际操作证明，精心设计推出的。资金主要用于大型国有企业、上市公司、贸易企业等在国际、国内采购并销售原料，物产等适宜销售流通物资。借款人以此为抵押物资通过本平台筹集款项，资金需求合理，经营利润率较高，且平台风控团队对借款人的资产规模和负债结构严格审核，做到对物权和资金的双重掌控，将风险控制在可控范围。";
            }
                break;
            default:
                break;
        }
        
    }else{ //2 信用标   消费金融
    
        self.projectDescriptionLabel.text = @"该产品是为面向小额贷款公司的消费金融类贷款产品，是借款人根据其自身的资金周转需求进行流动资金借款的一款产品。平台受借款人委托，利用其在平台注册登记的小额借款公司进行借款信息发布，向投资人融资，并由该借款公司为借款人承担连带责任担保。";
        
        self.creditMainTitle.text = @"借款人收入信息";
        
        self.creditScaleTitle_education.text = @"教育程度";
        self.creditScaleTitle_occupation.text = @"职        业";
        self.creditScaleTitle_annualIncome.text = @"年  收  入";

        self.lastTitleHidden.hidden = YES;
        self.lastDescHidden.hidden  = YES;
        self.lastViewHeight.constant = 143;
        
        //教育程度
        self.carBrandLabel.text = [self isLegalObject:_projectDetailDict[@"education"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"education"]] : @"-";
        //职业
        self.carID.text = [self isLegalObject:_projectDetailDict[@"occupation"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"occupation"]] : @"-";
        //年收入
        self.drivingKMLabel.text = [self isLegalObject:_projectDetailDict[@"annualIncome"]] ? [NSString stringWithFormat:@"%@", _projectDetailDict[@"annualIncome"]] : @"-";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
