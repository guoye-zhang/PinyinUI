#define TRANSFORM \
NSString *chinese = [NSString stringWithCharacters:originalPointer - length length:length];\
NSMutableString *to = [chinese mutableCopy];\
CFStringTransform((__bridge CFMutableStringRef)to, NULL, kCFStringTransformMandarinLatin, NO);\
NSArray *parts = [to componentsSeparatedByString:@" "];\
to = [NSMutableString new];\
NSUInteger chineseLength = [chinese length];\
unichar *chinesePointer = malloc(sizeof(unichar) * chineseLength);\
[chinese getCharacters:chinesePointer range:NSMakeRange(0, chineseLength)];\
for (NSString *each in parts) {\
    [to appendString:[NSString stringWithCharacters:chinesePointer length:1]];\
    [to appendString:each];\
    chinesePointer++;\
}\
[result appendString:to];
#define KEEP [result appendString:[NSString stringWithCharacters:originalPointer - length length:length]];

%hook NSBundle

- (id)localizedStringForKey:(id)key value:(id)value table:(id)table {
    id original = %orig(key, value, table);
    if ([original isKindOfClass:[NSString class]]) {
        NSMutableString *result = [NSMutableString new];
        NSUInteger stringLength = [original length], length = 0;
        BOOL isChinese = NO;
        unichar *originalPointer = malloc(sizeof(unichar) * stringLength);
        [original getCharacters:originalPointer range:NSMakeRange(0, stringLength)];
        for (NSInteger i = 0; i < stringLength; i++) {
            if (0x4e00 <= *originalPointer && *originalPointer <= 0x9fcc) {
                if (!isChinese) {
                    isChinese = YES;
                    if (length) {
                        KEEP;
                        length = 0;
                    }
                }
            } else if (isChinese) {
                isChinese = NO;
                TRANSFORM
                length = 0;
            }
            length++;
            originalPointer++;
        }
        if (isChinese) {
            TRANSFORM
        } else
            KEEP
        return result;
    } else
        return original;
}

%end
