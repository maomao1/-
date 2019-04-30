//
//  CRFRSAConst.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#ifndef CRFRSAConst_h
#define CRFRSAConst_h

#include <stdio.h>

#ifdef CI
/*
 加密公钥
 */
static NSString *const crfPubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRzeepPk6cG9vfEd/fHoVfZM4tweBEUaZpyKmYDplOmupXFe1LTdfixaBsBq+Bxwr8Tn0KaLD4K1DcxqxM3TMm03e5dMLgBHA4ePBujPmrzWmabHjwN1iv5rukgXz/pGADaDq9+rWbZbAXrW51mxPCvFn8IgcKYuSb4QbxoJ+IKQIDAQAB-----END PUBLIC KEY-----";
/*
 解密私钥
 */
static NSString *const privkey = @"-----BEGIN PRIVATE KEY-----MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJHN56k+Tpwb298R398ehV9kzi3B4ERRpmnIqZgOmU6a6lcV7UtN1+LFoGwGr4HHCvxOfQposPgrUNzGrEzdMybTd7l0wuAEcDh48G6M+avNaZpsePA3WK/mu6SBfP+kYANoOr36tZtlsBetbnWbE8K8WfwiBwpi5JvhBvGgn4gpAgMBAAECgYAHg1WpmeVRE/prby9a/uaeeMJLB094FcD+eHGMvUvXChKDNEUK+VLjg411o46NoGUHhT/aNnTQBONgzPf56fgFtyeLD01JF1l9DNL5821/oegP60knC/1JmK0mj6BFrt0CYrYrUQ4+RJP7dS0jmy8TETyjgkaJDgDsy9I/+pX9xQJBANOfu7N2QeFSQws/Y9pHTExN6ZwEdc/WXcHJSSNRJmwR3o8REMo3+CYcRm7XxrIEQzAvwLL+2nrozs9NdOCuCrsCQQCwYOHer6rmgNtAW2WivkUrKo/jP+sxvJJubDyIB4N41xuyYiaKDVfVgSqIdILEKrGh3jeS9gtTjh+kaFAwEGRrAkAy6AjJ+deNMTGpgf0uI9qJvHBGtJf2gBWbqSTr1viMJJxKBAvq6R3LZR/YSBWm+vmCnOoY5M9/o4MkQPitl5BDAkEAlDIC9hFRnfUcw1lH71LBWUCcv0sgeZzAyEjnH0B45dqPafVv/kSxzTGHJDoI+XwJ3kCRH0jeQWlECuaeoZPUWwJAV1TwOV2FDGUk+uyqReCF9l99cxkJGEBDSKMaEbXbbdbQNt4KnifWX/jAHME24tTdpQSj2GriCbRkxOm5qhvCag==-----END PRIVATE KEY-----";

/*
 沙子
 */
static NSString *const kCrfSand = @"crfchina123456crfchina";
/*
 商户号
 */
static NSString *const kMchntNo = @"CRFCHINA_FINANCIAL_WEBP2P";

#elif UAT

/*
 加密公钥
 */
static NSString *const crfPubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaaoYZOlSRF7KPR+yi5b7Wbd9c1enKeZet6+DZwK5tyGMnTMgrK+08Li62OxC0Cnni8rNhqQ5U/6aXf7CWmKaG+ffn8qDgNW6LdtOoXkmG2Koq1JZVa1J9Qrgl5LSDfLYQaVt9rH51gQ0XZkKn7KS8+H9iBUbuiwuYHssFXQoCawIDAQAB-----END PUBLIC KEY-----";

/*
 解密私钥
 */
static NSString *const privkey = @"-----BEGIN PRIVATE KEY-----MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJpqhhk6VJEXso9H7KLlvtZt31zV6cp5l63r4NnArm3IYydMyCsr7TwuLrY7ELQKeeLys2GpDlT/ppd/sJaYpob59+fyoOA1bot206heSYbYqirUllVrUn1CuCXktIN8thBpW32sfnWBDRdmQqfspLz4f2IFRu6LC5geywVdCgJrAgMBAAECgYBjHBwV9SpyNhOVg0SPCYcDemHy5Bm6q3B/YPZgzRsnu4Zoow+XJgqOpdW1gROne1HgKIaaGDfqtmvmsT5WaoP2/fwEBBsbjgm/5J8OU7ve9Ga87J8VbNEK4zfc7OmbR41FMzcc1JA2ffhYFh7d/hul1ZH27/Qiw3P9eIDTx1jLgQJBANqFZoz+rSxfKE60GqxXU5cnjTKE7fobOMW9Ka1f0EMAIDhzkD/Tx99E5Mz9Im27JoDQaBjRrhntiBIKNt7jfT8CQQC05neoohqiyJuk9wcCBiVUXcy+Cf23rSRs/n1nfe/7C9fYHzyFB0/3xYgaizedIzXELFHXjWJhNEI4MWUuIPPVAkEAn2x1veXL57RgztKdJyDqzjs/yxyqFi8oAzOXpXJimY8M8sJ0+ewDRQOZPWhsZswEMjRZzcmkECx4eljTYVdstwJAHVHVRxGu+39EKsKW8i8I0dm6G3sHEkQPyVKeBK4WvTu4KiE17+G1hlUPsC2sP927EyaTxTn3HgYYTX9EBOv2WQJANtelkphpvuyhWyNy44GfOV1/9Q9zWuszoEO5DvP4Im5jUVwCkMniRP1X0VxyE+EBjrNSJCAXyPJaSlK7nuttCQ==-----END PRIVATE KEY-----";
/*
 沙子
 */
static NSString *const kCrfSand = @"crfchina123456crfchina";
/*
 商户号
 */
static NSString *const kMchntNo = @"CRFCHINA_FINANCIAL_WEBP2P";


#elif PRE

/*
 加密公钥
 */
static NSString *const crfPubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaaoYZOlSRF7KPR+yi5b7Wbd9c1enKeZet6+DZwK5tyGMnTMgrK+08Li62OxC0Cnni8rNhqQ5U/6aXf7CWmKaG+ffn8qDgNW6LdtOoXkmG2Koq1JZVa1J9Qrgl5LSDfLYQaVt9rH51gQ0XZkKn7KS8+H9iBUbuiwuYHssFXQoCawIDAQAB-----END PUBLIC KEY-----";

/*
 解密私钥
 */
static NSString *const privkey = @"-----BEGIN PRIVATE KEY-----MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJpqhhk6VJEXso9H7KLlvtZt31zV6cp5l63r4NnArm3IYydMyCsr7TwuLrY7ELQKeeLys2GpDlT/ppd/sJaYpob59+fyoOA1bot206heSYbYqirUllVrUn1CuCXktIN8thBpW32sfnWBDRdmQqfspLz4f2IFRu6LC5geywVdCgJrAgMBAAECgYBjHBwV9SpyNhOVg0SPCYcDemHy5Bm6q3B/YPZgzRsnu4Zoow+XJgqOpdW1gROne1HgKIaaGDfqtmvmsT5WaoP2/fwEBBsbjgm/5J8OU7ve9Ga87J8VbNEK4zfc7OmbR41FMzcc1JA2ffhYFh7d/hul1ZH27/Qiw3P9eIDTx1jLgQJBANqFZoz+rSxfKE60GqxXU5cnjTKE7fobOMW9Ka1f0EMAIDhzkD/Tx99E5Mz9Im27JoDQaBjRrhntiBIKNt7jfT8CQQC05neoohqiyJuk9wcCBiVUXcy+Cf23rSRs/n1nfe/7C9fYHzyFB0/3xYgaizedIzXELFHXjWJhNEI4MWUuIPPVAkEAn2x1veXL57RgztKdJyDqzjs/yxyqFi8oAzOXpXJimY8M8sJ0+ewDRQOZPWhsZswEMjRZzcmkECx4eljTYVdstwJAHVHVRxGu+39EKsKW8i8I0dm6G3sHEkQPyVKeBK4WvTu4KiE17+G1hlUPsC2sP927EyaTxTn3HgYYTX9EBOv2WQJANtelkphpvuyhWyNy44GfOV1/9Q9zWuszoEO5DvP4Im5jUVwCkMniRP1X0VxyE+EBjrNSJCAXyPJaSlK7nuttCQ==-----END PRIVATE KEY-----";

/*
 沙子
 */
static NSString *const kCrfSand = @"crfchina123456crfchina";
/*
 商户号
 */
static NSString *const kMchntNo = @"CRFCHINA_FINANCIAL_WEBP2P";


#else

/*
 加密公钥
 */
static NSString *const crfPubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDWxomxOecuq6JgflJeVERCz1MLUWq+bUkBn7O1au1SiPsXG//ApwDgIATR0mVeZKjq/oX5P/A+c3qTrqRyIL4DWierxQ7cpW7st3f1TghaslFBFuSWW7frdAfxGCQvX8Wcno0Tv0R7E8DthVrCK/luCdiEafhsoJ2onSb5tYWxEQIDAQAB-----END PUBLIC KEY-----";
/*
 解密私钥
 */
static NSString *const privkey = @"-----BEGIN PRIVATE KEY-----MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJHN56k+Tpwb298R398ehV9kzi3B4ERRpmnIqZgOmU6a6lcV7UtN1+LFoGwGr4HHCvxOfQposPgrUNzGrEzdMybTd7l0wuAEcDh48G6M+avNaZpsePA3WK/mu6SBfP+kYANoOr36tZtlsBetbnWbE8K8WfwiBwpi5JvhBvGgn4gpAgMBAAECgYAHg1WpmeVRE/prby9a/uaeeMJLB094FcD+eHGMvUvXChKDNEUK+VLjg411o46NoGUHhT/aNnTQBONgzPf56fgFtyeLD01JF1l9DNL5821/oegP60knC/1JmK0mj6BFrt0CYrYrUQ4+RJP7dS0jmy8TETyjgkaJDgDsy9I/+pX9xQJBANOfu7N2QeFSQws/Y9pHTExN6ZwEdc/WXcHJSSNRJmwR3o8REMo3+CYcRm7XxrIEQzAvwLL+2nrozs9NdOCuCrsCQQCwYOHer6rmgNtAW2WivkUrKo/jP+sxvJJubDyIB4N41xuyYiaKDVfVgSqIdILEKrGh3jeS9gtTjh+kaFAwEGRrAkAy6AjJ+deNMTGpgf0uI9qJvHBGtJf2gBWbqSTr1viMJJxKBAvq6R3LZR/YSBWm+vmCnOoY5M9/o4MkQPitl5BDAkEAlDIC9hFRnfUcw1lH71LBWUCcv0sgeZzAyEjnH0B45dqPafVv/kSxzTGHJDoI+XwJ3kCRH0jeQWlECuaeoZPUWwJAV1TwOV2FDGUk+uyqReCF9l99cxkJGEBDSKMaEbXbbdbQNt4KnifWX/jAHME24tTdpQSj2GriCbRkxOm5qhvCag==-----END PRIVATE KEY-----";

/*
 沙子
 */
static NSString *const kCrfSand = @"crfchina123456crfchina";
/*
 商户号
 */
static NSString *const kMchntNo = @"CRFCHINA_FINANCIAL_WEBP2P";


#endif





#endif /* CRFRSAConst_h */
