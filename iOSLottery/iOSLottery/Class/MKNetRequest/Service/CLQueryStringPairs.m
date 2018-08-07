//
//  CLQueryStringPairs.m
//  caiqr
//
//  Created by 彩球 on 17/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CLQueryStringPairs.h"

NSString * CLPercentEscapedStringFromString(NSString *string);

@interface CLStringPair : NSObject

@property (nonatomic, strong) id field;
@property (nonatomic, strong) id value;

@end

@implementation CLStringPair

- (instancetype) initWithField:(NSString*)key value:(id)value {
    
    self = [super init];
    if (self) {
        self.field = key;
        self.value = value;
    }
    return self;
}


- (NSString*) assemblePairUseUrlEncode:(BOOL)useEncode{
    
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return [self.field description];
    } else {
        if (useEncode) {
            return [NSString stringWithFormat:@"%@=%@", CLPercentEscapedStringFromString([self.field description]), CLPercentEscapedStringFromString([self.value description])];
        } else {
            return [NSString stringWithFormat:@"%@=%@", [self.field description], [self.value description]];
        }
        
    }
}

@end
@implementation CLQueryStringPairs

NSString * CLQueryStringFromParameters(NSDictionary *parameters ,BOOL useEncode) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (CLStringPair *pair in CLQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair assemblePairUseUrlEncode:useEncode]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * CLQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return CLQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * CLQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:CLQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:CLQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:CLQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[CLStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

NSString * CLPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

@end
