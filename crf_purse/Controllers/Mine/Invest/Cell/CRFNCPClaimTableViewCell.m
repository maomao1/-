//
//  CRFNCPClaimTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNCPClaimTableViewCell.h"

@interface CRFNCPClaimTableViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, strong) UILabel *claimNoLabel;

@property (nonatomic, strong) UILabel *claimerLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation CRFNCPClaimTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _indexLabel = [UILabel new];
    _claimNoLabel = [UILabel new];
    _claimerLabel = [UILabel new];
    _claimerLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel = [UILabel new];
    _amountLabel.textAlignment = NSTextAlignmentRight;
    _protocolLabel = [UILabel new];
    _claimerLabel.userInteractionEnabled = YES;
    _protocolLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClaimer)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [_claimerLabel addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tap.cancelsTouchesInView = NO;
    [_protocolLabel addGestureRecognizer:tap];
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    _protocolLabel.text = @"查看";
    [self addSubview:self.indexLabel];
    [self addSubview:self.claimNoLabel];
    [self addSubview:self.claimerLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.protocolLabel];
//    self.claimNoLabel.adjustsFontSizeToFitWidth = YES;
//    self.claimNoLabel.minimumScaleFactor = 10.0;
    self.amountLabel.font = [CRFUtils fontWithSize:12.0];
    self.indexLabel.font = self.claimerLabel.font = self.claimNoLabel.font = self.protocolLabel.font = [UIFont systemFontOfSize:12.0];
    self.claimerLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    self.claimNoLabel.textColor = self.claimNoLabel.textColor = self.amountLabel.textColor = UIColorFromRGBValue(0x333333);
    self.indexLabel.textColor = UIColorFromRGBValue(0x666666);
    self.protocolLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(10 * kWidthRatio);
        make.width.mas_equalTo(28 * kWidthRatio);
    }];
    [self.claimNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.indexLabel);
        make.left.equalTo(self.indexLabel.mas_right);
        make.width.mas_equalTo(113 * kWidthRatio);
    }];
    [self.claimerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.indexLabel);
        make.left.equalTo(self.claimNoLabel.mas_right);
        make.width.mas_equalTo(60 * kWidthRatio);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.claimerLabel);
        make.left.equalTo(self.claimerLabel.mas_right);
        make.width.mas_equalTo(85 * kWidthRatio);
    }];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.claimerLabel);
        make.left.equalTo(self.amountLabel.mas_right).with.offset(10 * kWidthRatio);
        make.right.equalTo(self);
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSInteger index = _indexPath.row + 1;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",index];
}

- (void)setClaimer:(CRFClaimer *)claimer {
    _claimer = claimer;
    self.claimNoLabel.text = _claimer.rightsNo;
    self.claimerLabel.text = _claimer.loanerName;
    self.amountLabel.text = [NSString stringWithFormat:@"%@元",[_claimer.rightsBalance formatBeginMoney]];
}

- (void)tapGesture {
    if (self.lookupProtocolContent) {
        self.lookupProtocolContent(self.indexPath);
    }
}

- (void)tapClaimer{
    if (self.showClaimerDetail) {
        self.showClaimerDetail(self.indexPath);
    }
}


- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
