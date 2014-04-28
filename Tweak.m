#import "NSString+Japanese.h"

%hook NSBundle

- (id)localizedStringForKey:(id)key value:(id)value table:(id)table {
    id string = %orig;
    if ([string isKindOfClass:[NSString class]])
        return [string stringByTransliteratingJapaneseToRomaji];
    else
        return string;
}

%end
