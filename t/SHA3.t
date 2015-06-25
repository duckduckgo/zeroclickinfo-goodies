#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "sha3";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SHA3 )],
    'SHA3 this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3 this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3sum this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3-224 this string' => test_zci(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-224 hex hash',
            result    => 'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73'
        }
    ),
    'sha3-224 hash this string' => test_zci(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-224 hex hash',
            result    => 'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73'
        }
    ),
    'sha3-224 hash of this string' => test_zci(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-224 hex hash',
            result    => 'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73'
        }
    ),
    'sha3-224 hex this string' => test_zci(
        'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-224 hex hash',
            result    => 'a28bc479d891ba592031c8410f735fc247becac5d18070a073684d73'
        }
    ),
    'sha3-224 "this and "that" string"' => test_zci(
        '7e4853cb83a37406b72cdc3c2b7e00aad303fc4b9704b96845454412',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'SHA3-224 hex hash',
            result    => '7e4853cb83a37406b72cdc3c2b7e00aad303fc4b9704b96845454412'
        }
    ),
    'sha3-224 base64 this string' => test_zci(
        'oovEediRulkgMchBD3Nfwke+ysXRgHCgc2hNcw==',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-224 base64 hash',
            result    => 'oovEediRulkgMchBD3Nfwke+ysXRgHCgc2hNcw=='
        }
    ),
    'sha3-224 <script>alert("ddg")</script>' => test_zci(
        '398384e7527c292fa4e07dab5dc85ae04d49c78e0a08847702df1a40',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'SHA3-224 hex hash',
            result    => '398384e7527c292fa4e07dab5dc85ae04d49c78e0a08847702df1a40'
        }
    ),
    'sha3-224 & / " \\\' ; < >' => test_zci(
        '7c5deb70175f99dd6b1edcd0b6e75b34be47f9fb385c48f8612e3e7c',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'SHA3-224 hex hash',
            result    => '7c5deb70175f99dd6b1edcd0b6e75b34be47f9fb385c48f8612e3e7c'
        }
    ),
    'sha3-256 this string' => test_zci(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-256 hex hash',
            result    => 'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3'
        }
    ),
    'sha3-256 hash this string' => test_zci(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-256 hex hash',
            result    => 'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3'
        }
    ),
    'sha3-256 hash of this string' => test_zci(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-256 hex hash',
            result    => 'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3'
        }
    ),
    'sha3-256 hex this string' => test_zci(
        'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-256 hex hash',
            result    => 'a9ddaf6fdefe6e6a3c7c76300b1d3154fcd3a393ddd6b1bcbd4ac701d41078b3'
        }
    ),
    'sha3-256 "this and "that" string"' => test_zci(
        '4bdb8c2f14fc9ce4070d89b2455ac8df75ed28f68b88b87499e9043759daa632',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'SHA3-256 hex hash',
            result    => '4bdb8c2f14fc9ce4070d89b2455ac8df75ed28f68b88b87499e9043759daa632'
        }
    ),
    'sha3-256 base64 this string' => test_zci(
        'qd2vb97+bmo8fHYwCx0xVPzTo5Pd1rG8vUrHAdQQeLM=',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-256 base64 hash',
            result    => 'qd2vb97+bmo8fHYwCx0xVPzTo5Pd1rG8vUrHAdQQeLM='
        }
    ),
    'sha3-256 <script>alert("ddg")</script>' => test_zci(
        '179a7f546ab90db6451c410946cb875ae0ea88328f031daf183979c925db985b',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'SHA3-256 hex hash',
            result    => '179a7f546ab90db6451c410946cb875ae0ea88328f031daf183979c925db985b'
        }
    ),
    'sha3-256 & / " \\\' ; < >' => test_zci(
        '5377039d3dc15ca9f2b0ee7f3c15a03bd8514a717b7f48dab89074ea60e1c1d1',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'SHA3-256 hex hash',
            result    => '5377039d3dc15ca9f2b0ee7f3c15a03bd8514a717b7f48dab89074ea60e1c1d1'
        }
    ),
    'sha3-384 this string' => test_zci(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-384 hex hash',
            result    => 'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898'
        }
    ),
    'sha3-384 hash this string' => test_zci(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-384 hex hash',
            result    => 'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898'
        }
    ),
    'sha3-384 hash of this string' => test_zci(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-384 hex hash',
            result    => 'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898'
        }
    ),
    'sha3-384 hex this string' => test_zci(
        'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-384 hex hash',
            result    => 'd84cc0a12a1d80a68c6626a902ea526d99428b0b02d4c84b4e215360e3bc5c98f1aea8b55db2f1e498e9bb18b1cf8898'
        }
    ),
    'sha3-384 "this and "that" string"' => test_zci(
        '1d95f744b30dc0a3c2d452364590c899b7f53264f9be6576358ec761737cea67cc487f49f1f99a5e2b9bdf053ad5c3fa',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'SHA3-384 hex hash',
            result    => '1d95f744b30dc0a3c2d452364590c899b7f53264f9be6576358ec761737cea67cc487f49f1f99a5e2b9bdf053ad5c3fa'
        }
    ),
    'sha3-384 base64 this string' => test_zci(
        '2EzAoSodgKaMZiapAupSbZlCiwsC1MhLTiFTYOO8XJjxrqi1XbLx5Jjpuxixz4iY',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-384 base64 hash',
            result    => '2EzAoSodgKaMZiapAupSbZlCiwsC1MhLTiFTYOO8XJjxrqi1XbLx5Jjpuxixz4iY'
        }
    ),
    'sha3-384 <script>alert("ddg")</script>' => test_zci(
        'd2b7f1dabed8447b06420bbf01d5004fda94361d2e1d8096bc0fe1a00d31e3e9e0ef70b6c69fcafbbae24555f9b7af4d',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'SHA3-384 hex hash',
            result    => 'd2b7f1dabed8447b06420bbf01d5004fda94361d2e1d8096bc0fe1a00d31e3e9e0ef70b6c69fcafbbae24555f9b7af4d'
        }
    ),
    'sha3-384 & / " \\\' ; < >' => test_zci(
        '4f3207229172a936045a7705b0c3e4257553dd6c9688ecbcb75dd7306fe90e082a0547302b6131b40079fb613d73f888',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'SHA3-384 hex hash',
            result    => '4f3207229172a936045a7705b0c3e4257553dd6c9688ecbcb75dd7306fe90e082a0547302b6131b40079fb613d73f888'
        }
    ),
    'sha3-512 this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3-512 hash this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3-512 hash of this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3-512 hex this string' => test_zci(
        '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 hex hash',
            result    => '6107e7dfa1adcff1deb313f8dfb379ee3bae01437d6e09198f556c4c81a3c24edb1b0417972a5733e585085b4296c0282fe42eb89da6a4da52005fa1395e16db'
        }
    ),
    'sha3-512 "this and "that" string"' => test_zci(
        'da2a4a495974be154c09951f76beac47a41f8e48dcd35ae04efd0dfa525ba82151587cd14ce82533b834106f42f58aa6ed517a2cdb5106584d92aa748f4b445b',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'SHA3-512 hex hash',
            result    => 'da2a4a495974be154c09951f76beac47a41f8e48dcd35ae04efd0dfa525ba82151587cd14ce82533b834106f42f58aa6ed517a2cdb5106584d92aa748f4b445b'
        }
    ),
    'sha3-512 base64 this string' => test_zci(
        'YQfn36Gtz/HesxP437N57juuAUN9bgkZj1VsTIGjwk7bGwQXlypXM+WFCFtClsAoL+QuuJ2mpNpSAF+hOV4W2w==',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHA3-512 base64 hash',
            result    => 'YQfn36Gtz/HesxP437N57juuAUN9bgkZj1VsTIGjwk7bGwQXlypXM+WFCFtClsAoL+QuuJ2mpNpSAF+hOV4W2w=='
        }
    ),
    'sha3-512 <script>alert("ddg")</script>' => test_zci(
        'b8d157e78f7b40565da31d547bb269ae08784d44bdf508759583fdc8c4aacddef53f45af7f272444d040e92b286501c60337665ae1a1e0d4326049b3a5d6ae5e',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'SHA3-512 hex hash',
            result    => 'b8d157e78f7b40565da31d547bb269ae08784d44bdf508759583fdc8c4aacddef53f45af7f272444d040e92b286501c60337665ae1a1e0d4326049b3a5d6ae5e'
        }
    ),
    'sha3-512 & / " \\\' ; < >' => test_zci(
        '5fd58e6c60e027e8fc237098bac75c5fbddd33ee4a3b95868fb902ce555ae6b873783ee08fdfd90fbf4232d00ac755a0abd0d6fa1a25b277589846dfdba0c64b',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'SHA3-512 hex hash',
            result    => '5fd58e6c60e027e8fc237098bac75c5fbddd33ee4a3b95868fb902ce555ae6b873783ee08fdfd90fbf4232d00ac755a0abd0d6fa1a25b277589846dfdba0c64b'
        }
    ),
    'shake128 this string' => test_zci(
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-128 hex hash',
            result    => '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067'
        }
    ),
    'shake-128 this string' => test_zci(
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-128 hex hash',
            result    => '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067'
        }
    ),
    'shake128 hash of this string' => test_zci(
        '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-128 hex hash',
            result    => '6fb7de092c66591cca6d119284d7fddd8f78352a90a65ee7da5c40cd48e59c9c28a8b2fab15b176f1c5f2d242dd44cc17fed7e9656f5e9215973f273ebba3fc8ae24adb04c591feb66a4bfdaf9dcdc4bae5ce6944cc88a9b3b9edb15c4950772ac973b310c5a2c6d7d83ffa3d1a6d64d664af3ab4b1ddc5ff42e1ca301c46566fd4efc51f083837dd8c08553e63248cd8f920d54a2d54abcbaa6a228b4c556694713e5b2ffb69067'
        }
    ),
    'shake256 this string' => test_zci(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-256 hex hash',
            result    => '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c'
        }
    ),
    'shake-256 this string' => test_zci(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-256 hex hash',
            result    => '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c'
        }
    ),
    'shake256 hash of this string' => test_zci(
        '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c',
        structured_answer => {
            input     => ['this string'],
            operation => 'SHAKE-256 hex hash',
            result    => '841294b912e09c446978db0ac7ba61e74a819005c7487ea9d9792f4181fe834607c84457b232b1e0d742983a385129fab598e415f593a805f01a13cd67cbaf9e4fc992e3502f7a3393dd1e4b5ad2c6e7e6a0d7ea6605dcdc9fd6009e450400f34e48e9a3969267b21d577b75e99012d1c7d9069d5fe314cacf2e975a9536b5c05b41c151cb1dd95c'
        }
    ),
    'sha3224 this string' => undef,
    'sha-3-224 this string' => undef,
    'sha this string' => undef,
    'sha3-128 this string' => undef,
    'shake224 this string' => undef,
    'shake384 this string' => undef,
    'shake512 this string' => undef,
    'shake-512 this string' => undef,
);

done_testing;

