//
//  CAddressModel.m
//  CPickerViewDemo
//
//  Created by InitialC on 2017/8/11.
//  Copyright © 2017年 InitialC. All rights reserved.
//

#import "CAddressModel.h"

@implementation CProvinceModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name": @"v",
             @"city": @"n"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"city": [CCityModel class]
             };
}

@end


@implementation CCityModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name": @"v",
             @"town": @"n"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"town": [CTownModel class]
             };
}

@end


@implementation CTownModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name": @"v"
             };
}

@end
