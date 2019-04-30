
#import <Foundation/Foundation.h>

@interface DESHelper : NSObject

+(NSString *)encrypt:(NSString *)text;
+(NSString *)deCrypt:(NSString *)text;

+(NSString *)encrypt:(NSString *)text key:(NSString *)key;
+(NSString *)deCrypt:(NSString *)text key:(NSString *)key;

@end
