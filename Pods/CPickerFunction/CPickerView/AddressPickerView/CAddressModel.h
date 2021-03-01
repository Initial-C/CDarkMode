//
//  CAddressModel.h
//  CPickerViewDemo
//
//  Created by InitialC on 2017/8/11.
//  Copyright © 2017年 InitialC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CProvinceModel, CCityModel, CTownModel;

@interface CProvinceModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *city;

@end

@interface CCityModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *town;

@end


@interface CTownModel : NSObject

@property (nonatomic, copy) NSString *name;

@end
