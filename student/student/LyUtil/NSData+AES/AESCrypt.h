

////.h


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES)
//- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES256EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES256DecryptWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)replaceNoUtf8;//:(NSData *)data;
@end

