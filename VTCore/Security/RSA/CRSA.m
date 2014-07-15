#import "CRSA.h"

#define BUFFSIZE  1024
#import "NSData+Base64.h"
#import "NSString+VT.h"
#import "Base64.h"

#define PADDING RSA_PADDING_TYPE_PKCS1
@implementation CRSA

+ (id)shareInstance
{
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}
- (BOOL)importRSAKeyWithType:(KeyType)type
{
    FILE *file;
    NSString *keyName = type == KeyTypePublic ? @"rsa_public_key" : @"private_key";
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:keyName ofType:@"pem"];
    
    file = fopen([keyPath UTF8String], "rb");
    
    if (NULL != file)
    {
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        
        fclose(file);
        
        return (_rsa != NULL) ? YES : NO;
    }
    
    return NO;
}

- (NSString *) encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
         return nil;
    
    int status;
    int length  = (int)[content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [content characterAtIndex:i];
    }
    
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
        NSString *ret = [returnData base64EncodedString];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;

    NSData *data = [content base64DecodedData];
    int length = [data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type
{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

+ (NSString *)RSAEncryptData:(NSString *)data
{
    //一般情况这两个字符是被base64加密过的
    NSString *modulus = @"+fsdfdjfksdjfksjfkjskdssjdfkdjfksdlkfjlskjdfksjfiejjksjksdfmsllskd;kfosioekfsd//fefef+fdafgadfg=";//通过这个可以得到其中     的N
    NSString *exponent = @"sfaa";//通过这个其中的e,(e也可以是一个很大的数)
    
    NSData *m = [NSData dataWithBase64EncodedString:modulus];
    NSData *e = [NSData dataWithBase64EncodedString:exponent];
    
    RSA *r;
    BIGNUM *bne, *bnn;//rsa算法中的 e和N
    int blockLen;//每次最大加密字节数
    unsigned char *encodeData;//加密后的数据
    
    bnn = BN_new();
    bne = BN_new();
    
    r = RSA_new();
    //看到网上有人用BN_hex2bn这个函数来转化的，但我用这个转化总是失败，最后选择了BN_bin2bn
    r->e = BN_bin2bn([e bytes], [e length], bne);
    r->n = BN_bin2bn([m bytes], [m length], bnn);
    
    blockLen = RSA_size(r) - 11;// 公钥长度/8 - 11
    
    encodeData = (unsigned char *)malloc(blockLen);
    bzero(encodeData, blockLen);
    
    //由于需要加密的内容都在最大加密长度内，所以我没有分块，如果你的文本内容长度超过了blockLen，请分块处理，然后拼接起来
    
    int ret = RSA_public_encrypt([data length], (unsigned char *)[data UTF8String], encodeData, r, RSA_PKCS1_PADDING);
    //这里的 RSA_PKCS1_PADDING选择的不同，对应的最大加密长度就不一样，当时在网上看到过，现在找不到了，你们自己上网找找吧
    
    
    RSA_free(r);
    if(ret < 0)
    {
        NSLog(@"encrypt failed !");
        return @"";
    }
    else
    {
        NSData *result = [Base64 encodeBytes:encodeData length:ret];
        free(encodeData);
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
}
@end
