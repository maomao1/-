//
//  CRFUserInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/6.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUserInfo.h"

@implementation CRFUserInfo

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userId"     :@"uuid",
             @"userName"   :@"realName",
             @"headUrl"    :@"headImgUrl",
             @"bankCardNo" :@"bankcard_no",
             @"emailNo"    :@"email",
             @"phoneNo"    :@"mobilePhone",
             @"accountSigned":@"signed",
             };
}

- (id)initWithCoder:(NSCoder *)decoder {
    self =[super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}
-(NSString *)accountSigned{
    if (!_accountSigned) {
        _accountSigned = @"2";
    }
//    return @"1";
    return _accountSigned;
}
-(NSString *)refreshToken{
    if (!_refreshToken) {
        _refreshToken = @"";
    }
    return _refreshToken;
}
- (NSString *)address {
    if (!_address) {
        _address = @"";
    }
    return _address;
}

- (NSString *)userId {
    if (!_userId) {
        _userId= @"";
    }
    return _userId;
}

- (NSString *)accessToken{
    if (!_accessToken) {
        _accessToken = @"";
    }
    return _accessToken;
}

- (NSString *)userName{
    if (!_userName) {
        _userName = @"";
    }
    return _userName;
}

- (NSString *)idNo{
    if (!_idNo) {
        _idNo = @"";
    }
    return _idNo;
}

- (NSString *)headUrl{
    if (!_headUrl) {
        _headUrl = @"";
    }
    return _headUrl;
}

- (NSString *)emailNo{
    if (!_emailNo) {
        _emailNo = @"";
    }
    return _emailNo;
}

- (NSString *)phoneNo{
    if (!_phoneNo) {
        _phoneNo = @"";
    }
    return _phoneNo;
}

- (NSString *)customerUid{
    if (!_customerUid) {
        _customerUid = @"";
    }
    return _customerUid;
}
-(NSString *)financialName{
    if (!_financialName) {
        _financialName = @"";
    }
    return _financialName;
}
-(NSString *)financialPhone{
    if (!_financialPhone) {
        _financialPhone = @"";
    }
    return _financialPhone;
}
- (NSString *)formatMobilePhone {
    if (self.phoneNo.length <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@******%@",[self.phoneNo substringToIndex:3],[self.phoneNo substringFromIndex:self.phoneNo.length - 2]];
}

- (NSString *)formatIdNo {
    return self.idNo;
}

- (NSString *)formatBankCardNo {
    return self.openBankCardNo;
}

- (NSString *)openAccountIdno {
    if (!_openAccountIdno) {
        _openAccountIdno = @"";
    }
    return _openAccountIdno;
}

- (NSString *)openBankCardNo {
    if (!_openBankCardNo) {
        _openBankCardNo = @"";
    }
    return _openBankCardNo;
}

- (NSString *)formatUserName {
    //4 *** 2
    if (self.userName.length > 6) {
        return [NSString stringWithFormat:@"%@...%@",[self.userName substringToIndex:4],[self.userName substringFromIndex:self.userName.length - 2]];
    }
    return _userName;;
}


- (NSString *)riskLevel {
    if (!_riskLevel) {
        _riskLevel = @"";
    }
    return _riskLevel;
}
-(NSString *)protocolValidation{
    if (!_protocolValidation) {
        _protocolValidation = @"";
    }
    return _protocolValidation;
}
- (NSString *)riskConfirm {
    if (!_riskConfirm) {
        _riskConfirm = @"3";
    }
    return _riskConfirm;
}

- (NSString *)formatChangeBankCardUserName {
    return [NSString stringWithFormat:@"**%@",[self.userName substringFromIndex:self.userName.length - 1]];
}

@end
