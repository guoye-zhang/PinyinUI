%hook NSBundle

- (id)localizedStringForKey:(id)key value:(id)value table:(id)table {
    id string = %orig(key, value, table);
    if ([string isKindOfClass:[NSString class]]) {
        string = [string mutableCopy];
        CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    }
    return string;
}

%end
