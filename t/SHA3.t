 #!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "sha3";
zci is_cached   => 1;

sub build_test {
    my ($text, $input, $operation) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => "$operation: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::SHA3 )],
    'SHA3 this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash'
    ),
    'sha3 this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash'
    ),
    'sha3sum this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash'
    ),
    'sha3-224 this string' => build_test(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        'this string',
        'SHA3-224 hex hash'
    ),
    'sha3-224 hash this string' => build_test(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        'this string',
        'SHA3-224 hex hash'
    ),
    'sha3-224 hash of this string' => build_test(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        'this string',
        'SHA3-224 hex hash'
    ),
    'sha3-224 hex this string' => build_test(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        'this string',
        'SHA3-224 hex hash'
    ),
    'sha3-224 "this and "that" string"' => build_test(
        '7e4853cb83a37406b72cdc3c2b7e00aad303fc4b9704b96845454412',
        'this and "that" string',
        'SHA3-224 hex hash'
    ),
    'sha3-224 base64 this string' => build_test(
        'oovEediRulkgMchBD3Nfwke+ysXRgHCgc2hNcw==',
        'this string',
        'SHA3-224 base64 hash',
    ),
    'sha3-224 <script>alert("ddg")</script>' => build_test(
        '398384e7527c292fa4e07dab5dc85ae04d49c78e0a08847702df1a40',
        '<script>alert("ddg")</script>',
        'SHA3-224 hex hash'
    ),
    'sha3-224 \& / " \\\' ; < >' => build_test(
        'e11c539bc9f76958d0810986ef889effb1b59fda8020f576fbd6d430',
        '\& / " \\\' ; < >',
        'SHA3-224 hex hash'
    ),
    'sha3-256 this string' => build_test(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        'this string',
        'SHA3-256 hex hash'
    ),
    'sha3-256 hash this string' => build_test(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        'this string',
        'SHA3-256 hex hash'
    ),
    'sha3-256 hash of this string' => build_test(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        'this string',
        'SHA3-256 hex hash'
    ),
    'sha3-256 hex this string' => build_test(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        'this string',
        'SHA3-256 hex hash'
    ),
    'sha3-256 "this and "that" string"' => build_test(
        '4bdb8c2f14fc9ce4070d89b2455ac8df75ed28f68b88b87499e9043759daa632',
        'this and "that" string',
        'SHA3-256 hex hash'
    ),
    'sha3-256 base64 this string' => build_test(
        'qd2vb97+bmo8fHYwCx0xVPzTo5Pd1rG8vUrHAdQQeLM=',
        'this string',
        'SHA3-256 base64 hash'
    ),
    'sha3-256 <script>alert("ddg")</script>' => build_test(
        '179a7f546ab90db6451c410946cb875ae0ea88328f031daf183979c925db985b',
        '<script>alert("ddg")</script>',
        'SHA3-256 hex hash'
    ),
    'sha3-256 \& / " \\\' ; < >' => build_test(
        'e9730f230c2ddf52c1c290844205560c5745e6bd2063be6fe20225f2c20303d6',
        '\& / " \\\' ; < >',
        'SHA3-256 hex hash'
    ),
    'sha3-384 this string' => build_test(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        'this string',
        'SHA3-384 hex hash'
    ),
    'sha3-384 hash this string' => build_test(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        'this string',
        'SHA3-384 hex hash'
    ),
    'sha3-384 hash of this string' => build_test(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        'this string',
        'SHA3-384 hex hash'
    ),
    'sha3-384 hex this string' => build_test(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        'this string',
        'SHA3-384 hex hash'
    ),
    'sha3-384 "this and "that" string"' => build_test(
        '1d95f744b30dc0a3c2d452364590c899b7f53264f9be6576358ec761737cea67cc487f49f1f99a5e2b9bdf053ad5c3fa',
        'this and "that" string',
        'SHA3-384 hex hash'
    ),
    'sha3-384 base64 this string' => build_test(
        '2EzAoSodgKaMZiapAupSbZlCiwsC1MhLTiFTYOO8XJjxrqi1XbLx5Jjpuxixz4iY',
        'this string',
        'SHA3-384 base64 hash'
    ),
    'sha3-384 <script>alert("ddg")</script>' => build_test(
        'd2b7f1dabed8447b06420bbf01d5004fda94361d2e1d8096bc0fe1a00d31e3e9e0ef70b6c69fcafbbae24555f9b7af4d',
        '<script>alert("ddg")</script>',
        'SHA3-384 hex hash'
    ),
    'sha3-384 \& / " \\\' ; < >' => build_test(
        '4ba1fcc979da75ef47a4f4fbe439a87fe1f7379f4f4ce4bdc83a7474394ed4cd50b450feb6aa139858e65e691f78d377',
        '\& / " \\\' ; < >',
        'SHA3-384 hex hash',
    ),
    'sha3-512 this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash',
    ),
    'sha3-512 hash this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash'
    ),
    'sha3-512 hash of this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash'
    ),
    'sha3-512 hex this string' => build_test(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        'this string',
        'SHA3-512 hex hash',
    ),
    'sha3-512 "this and "that" string"' => build_test(
        'da2a4a495974be154c09951f76beac47a41f8e48dcd35ae04efd0dfa525ba82151587cd14ce82533b834106f42f58aa6ed517a2cdb5106584d92aa748f4b445b',
        'this and "that" string',
        'SHA3-512 hex hash'
    ),
    'sha3-512 base64 this string' => build_test(
        'YQfn36Gtz/HesxP437N57juuAUN9bgkZj1VsTIGjwk7bGwQXlypXM+WFCFtClsAoL+QuuJ2mpNpSAF+hOV4W2w==',
        'this string',
        'SHA3-512 base64 hash'
    ),
    'sha3-512 <script>alert("ddg")</script>' => build_test(
        'b8d157e78f7b40565da31d547bb269ae08784d44bdf508759583fdc8c4aacddef53f45af7f272444d040e92b286501c60337665ae1a1e0d4326049b3a5d6ae5e',
        '<script>alert("ddg")</script>',
        'SHA3-512 hex hash'
    ),
    'sha3-512 \& / " \\\' ; < >' => build_test(
        '68d152a9a3086f9701b390afd1bd612fd2e5140e596e5f2228dd7b7392b5e722da419ba2232c660541ffede65ab8a6a54e78a040ad9ed3136e18ca253a28dfaf',
        '\& / " \\\' ; < >',
        'SHA3-512 hex hash'
    ),
    'shake128 this string' => build_test(      
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        'this string',
        'SHAKE-128 hex hash'
    ),
    'shake-128 this string' => build_test(
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        'this string',
        'SHAKE-128 hex hash'
    ),
    'shake128 hash of this string' => build_test(
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        'this string',
        'SHAKE-128 hex hash'
    ),
    'shake256 this string' => build_test(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        'this string',
        'SHAKE-256 hex hash'
    ),
    'shake-256 this string' => build_test(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        'this string',
        'SHAKE-256 hex hash'
    ),
    'shake256 hash of this string' => build_test(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        'this string',
        'SHAKE-256 hex hash'
    ),
    'sha-3 hello' => build_test(
        '75d527c368f2efe848ecf6b073a36767800805e9eef2b1857d5f984f036eb6df891d75f72d9b154518c1cd58835286d1da9a38deba3de98b5a53e5ed78a84976',
        'hello',
        'SHA3-512 hex hash'
    ),
    'sha3224 this string' => undef,
    'sha-3-224 this string' => undef,
    'sha this string' => undef,
    'sha3-128 this string' => undef,
    'shake224 this string' => undef,
    'shake384 this string' => undef,
    'shake512 this string' => undef,
    'shake-512 this string' => undef
);

done_testing;
