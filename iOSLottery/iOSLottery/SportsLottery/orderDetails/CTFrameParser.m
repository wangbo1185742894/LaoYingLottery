//
//  CTFrameParser.m
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser



CGFloat CTContextHeight(NSArray<__kindof CTUnit*> * units, CTFrameParserConfig *config)
{
    NSMutableAttributedString* attributes = CTCreatAttribute(units, config , nil);
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attributes);
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    attributes = nil;
    return coreTextSize.height;
}

NSMutableAttributedString* CTCreatAttribute(NSArray<__kindof CTUnit*> * units, CTFrameParserConfig *config ,NSMutableArray <__kindof CoreTextImageData*> * imageArray)
{
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    for (CTUnit* unit in units) {
        if (CTUnitTxtType == unit.type) {
            [result appendAttributedString:[CTFrameParser parserTxtAttributedFromUnit:unit config:config]];
        } else if (CTUnitImgType == unit.type) {
            CoreTextImageData *imgData = [[CoreTextImageData alloc] init];
            if (imageArray) {
                imgData.imgName = unit.content;
                imgData.position = result.length;
                [imageArray addObject:imgData];
            }
            [result appendAttributedString:[CTFrameParser parserImgAttributedFromUnit:unit config:config]];
        }
    }
    return result;
}

+ (CoreTextData*)parserCTUnits:(NSArray<__kindof CTUnit*> *)units config:(CTFrameParserConfig*)config
{
    if (units.count == 0 ) return nil;
    
    NSMutableArray* imageArray = [NSMutableArray array];
//    NSMutableAttributedString* result  = CTCreatAttribute(units, config , imageArray);
    
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    for (CTUnit* unit in units) {
        if (CTUnitTxtType == unit.type) {
            [result appendAttributedString:[self parserTxtAttributedFromUnit:unit config:config]];
        } else if (CTUnitImgType == unit.type) {
        
            
            CoreTextImageData *imgData = [[CoreTextImageData alloc] init];
            imgData.imgName = unit.imageName;
            imgData.position = 0;
            imgData.imagePosition = unit.imageRect;
            [imageArray addObject:imgData];
            
            
            
            [result appendAttributedString:[self parserTxtAttributedFromUnit:unit config:config]];
        }
        
        
        //洪利添加注释 增加关键字颜色改变
        //有效性校验
        if (nil != unit.keyWordsArray && unit.keyWordsArray.count>0) {
            if (unit.keyWordsColor!=nil) {
                
                for (NSString *keyword in unit.keyWordsArray)
                {
                    
                    //计算关键字位置，长度
                    NSRange rangeOfKeyWord = [unit.content rangeOfString:keyword];
                    
                    //添加关键字颜色
                    [result addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                                       value:(id)unit.keyWordsColor.CGColor
                                       range:rangeOfKeyWord];
                }
            }
            
           
        }
    }

    CoreTextData* data = [self parserContent:result config:config];
    data.imageArray = imageArray;
    return data;
}







+ (NSAttributedString*)parserTxtAttributedFromUnit:(CTUnit*)unit config:(CTFrameParserConfig*)config
{
    NSMutableDictionary* attributes = [self attributesWithConfig:config];
    if (unit.color)
        attributes[(id)kCTForegroundColorAttributeName] = (id)unit.color.CGColor;
    
    
    if (unit.fontSize > 0){
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", unit.fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString* content = unit.content;
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}


+ (NSAttributedString*)parserImgAttributedFromUnit:(CTUnit*)unit config:(CTFrameParserConfig*)config
{
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent = descentCallBack;
    callBacks.getWidth = widthCallBack;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void*)unit);
    
    unichar objectReplacementChar = 0xFFFC;
    
    NSString* content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSDictionary* attributes = [self attributesWithConfig:config];
    
    NSMutableAttributedString* space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

static CGFloat ascentCallBack(void * ref)
{
    return [[(__bridge CTUnit*)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBack(void * ref)
{
    return 0;
}

static CGFloat widthCallBack(void * ref)
{
    return [[(__bridge CTUnit*)ref valueForKey:@"width"] floatValue];
}



+ (NSMutableDictionary*)attributesWithConfig:(CTFrameParserConfig*)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)@"ArialMT", fontSize, NULL);
    
    CGFloat lineSpace = config.lineSpace;
    
    const CFIndex kNumberOfSettings = 6;
    
    CTTextAlignment alignment =  NSTextAlignmentToCTTextAlignment(config.textAlignment);
    CTLineBreakMode breakMode = kCTLineBreakByCharWrapping;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = { {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat) , &lineSpace},{kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpace},{kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpace} ,{kCTParagraphStyleSpecifierAlignment , sizeof(alignment),&alignment} ,{kCTParagraphStyleSpecifierLineBreakMode ,sizeof(CTLineBreakMode),&breakMode},
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat),&lineSpace}};
        
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor* textColor = config.textColor;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    
    return dict;
}


+ (CoreTextData*)parserContent:(NSMutableAttributedString*)attributes config:(CTFrameParserConfig*)config
{

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)attributes);
    attributes = nil;
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    
    CGFloat textHeight = coreTextSize.height;
    
//    if (config.textVerAlignment == CTTextVerticalAlignmentDefalut ||
//        config.textVerAlignment == CTTextVerticalAlignmentCenter) {
//        textHeight = config.height - (config.height - coreTextSize.height ) / 2.f;
//    } else if (config.textVerAlignment == CTTextVerticalAlignmentTop) {
//        textHeight = config.height - config.lineSpace / 2.f;
//    } else if (config.textVerAlignment == CTTextVerticalAlignmentBottom) {
//        textHeight = coreTextSize.height + config.lineSpace / 2.f;
//    }

    CTFrameRef frameRef = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    CoreTextData* data = [[CoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    
    CFRelease(framesetter);
    CFRelease(frameRef);
    
    return data;
    
}


+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framestter config:(CTFrameParserConfig*)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framestter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    
    return frame;
    
}





@end
