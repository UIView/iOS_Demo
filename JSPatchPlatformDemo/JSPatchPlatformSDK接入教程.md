## JSPatchPlatform SDK 接入教程

#### 1、通过cocoapods 集成 JSPatch

```
nimo-pc:~ mac$ cd /Users/mac/xxxxx/JSPatchPlatformDemo 
# 搜索 JSPatch
nimo-pc:~ mac$ pod search jspatch
-> JSPatchPlatform (1.6.6)
   jspatch.com SDK
   pod 'JSPatchPlatform', '~> 1.6.6'
   - Homepage: http://jspatch.com
   - Source:   https://github.com/bang590/JSPatchPlatform.git
   - Versions: 1.6.6, 1.6.5, 1.6.4, 1.6.3, 1.6.2, 1.6.1, 1.6 [master repo]
   - Subspecs:
     - JSPatchPlatform/Core (1.6.6)
# 退出 输入q字母退出搜索界面。
# 用Xcode 打开 Podfile 文件 输入 pod 'JSPatchPlatform', '~> 1.6.6'，
# 若没有 Podfile 文件请执行 pod init
# 如果有Podfile文件，修改之后执行 pod install。

nimo-pc:JSPatchPlatformDemo mac$ pod init
nimo-pc:JSPatchPlatformDemo mac$ pod install
nimo-pc:<<!
>JSPatch 通过扩展实现 C 函数调用 / GCD / 锁 等功能,若要使用这些功能，需要另外接入
> pod 'JSPatch/JPCFunction'
> pod 'JSPatch/Extensions'
> !
```

#### 2、生成证书

```
nimo-pc:JSPatchPlatformDemo mac$ openssl
# 输出私钥 ，生成成功后，上传js脚本时要用。生成了长度为 1024 的私钥，长度可选 1024 / 2048 / 3072 / 4096 ...。
OpenSSL> genrsa -out rsa_private_key.pem 1024

Generating RSA private key, 1024 bit long modulus

............++++++

......++++++

e is 65537 (0x10001)

OpenSSL> pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM –nocrypt

Enter Encryption Password:

Verifying - Enter Encryption Password:

-----BEGIN ENCRYPTED PRIVATE KEY-----

MIICoTAbBgkqhkiG9w0BBQMwDgQIBLH5dM8GzsICAggABIICgEw0UDr/
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
5obLClWZd+7/OoQ5gcyzpVWpC47

UhHsnFk=

-----END ENCRYPTED PRIVATE KEY-----
# 输出公钥 ，生成成功后，代码里需要用。
OpenSSL> rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem

writing RSA key
# 退出
OpenSSL> q
```

#### 3、SDK接入

- 在平台上注册帐号，可以任意添加新 App，每一个 App 都有一个唯一的 AppKey 作为标识。

#### 4、编写js脚本布丁，上传

- JSPatchPlatform 提供了oc->js代码工具http://jspatch.com/Tools/convertor
- 最后用文本编辑生成一个main.js 的文件。
- 添加版本号，这个版本号要与 app 上版本号保持一致。
- 上传main.js 时，勾选使用自定义RSA Key 。
- 使用开发预览，在自己的机器上测试。测试通过即可发布了。


#### 5、编码

- 在 AppDelegate.m 里载入文件，并调用 +startWithAppKey: 方法，参数为第一步获得的 AppKey。接着调用 +sync 方法检查更新。例子：

```
#import <JSPatchPlatform/JSPatch.h>
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [JSPatch startWithAppKey:@"你的AppKey"];
    NSString *jsRsaPubKey =@"手动换行后 rsa_public_key 字符串";
    [JSPatch setupRSAPublicKey:jsRsaPubKey];
    ...
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
}
@end
```



⚠️注意事项:

Public Key 以字符串的方式传入，注意换行处要手动加换行符\n，

```
// 用文本编辑 打开相应目录下 rsa_public_key.pem ，可以得到如下内容：

-----BEGIN PUBLIC KEY-----

MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApgeqKYKPVFk1dk2JGrKv
EaSqqXxU2S1x32xn2M2jWK/lz7YOPRFcPhH8UgBgpUQGqbW2ooOrtlE0Ur6WHOgZ
xxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsss
1rYQOcoCJlMUK4GDkK6bdKAPfVcD5vy2PAxDA84P2txcSkFozmZABcVvSyASB6Bn
MQIDAQAB

-----END PUBLIC KEY-----

// 换行后的效果

\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApgeqKYKPVFk1dk2JGrKv\n
EaSqqXxU2S1x32xn2M2jWK/lz7YOPRFcPhH8UgBgpUQGqbW2ooOrtlE0Ur6WHOgZ\n
xxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsssxxxxxsss\n
1rYQOcoCJlMUK4GDkK6bdKAPfVcD5vy2PAxDA84P2txcSkFozmZABcVvSyASB6Bn\n
MQIDAQAB\n

```

其他问题可以参考：

 jspatch使用文档：http://jspatch.com/Docs/intro

jspatch常见问题:https://github.com/bang590/JSPatch/wiki