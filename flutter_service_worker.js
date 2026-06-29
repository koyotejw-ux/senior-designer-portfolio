'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/images/promotion.jpg": "59b38bc1384823c4e2b99862d168b62d",
"assets/assets/images/sam_mes_final_final.jpg": "8f4db81cf40c361390a3e31fdf6c0d41",
"assets/assets/images/sam_mes_f4_6.jpg": "e0c35acbf72eb3abc368ffc706459aee",
"assets/assets/images/hthome_01_2_slice_2.jpg": "5b05a8b99e2b246d181517031b3469d5",
"assets/assets/images/ht_02_1_slice_2.jpg": "5075e0d6f8a75a0d88f4831557cd2d22",
"assets/assets/images/aia_thumbnail.jpg": "336d4e6368961002ed70e84524dd2cc0",
"assets/assets/images/sam_mes_f4_4.jpg": "f6eb7b2f534bf152ed5202cfe856ca8d",
"assets/assets/images/int_03_blank.jpg": "103916cc47de8031ef9c1bb1b623de2b",
"assets/assets/images/soulark_1.jpg": "a9ee347573859988b02b86e30b5bd1e3",
"assets/assets/images/hthome_01.jpg": "a34870d9d96932f2a492b3edd759dc08",
"assets/assets/images/sam_mes_7.jpg": "5207e3843e1744e46325494249dbe1ba",
"assets/assets/images/aia_3.jpg": "df8c30a89b4f2a8543035fe77debe65f",
"assets/assets/images/project_detail_aia.png": "5255a4b9c9a73061a37f7535ee603475",
"assets/assets/images/sam_mes_f3_7.jpg": "2421db5d8e1c922ec034c284f7e61360",
"assets/assets/images/ht_01_slice_1.jpg": "aef245c09527deecbfcd8da1224eadaa",
"assets/assets/images/aia_6.jpg": "bc9dcdf106e267843062123fb68567e8",
"assets/assets/images/sam_mes.jpg": "e5d19fc470a4844e18d301744de28e0f",
"assets/assets/images/hthome_01_3_slice_1.jpg": "fd5d37578f1d3c7f951ff0b6e47f4186",
"assets/assets/images/hthome_01_3_slice_4.jpg": "0e71fb96b10dc1eb8d57423c563da86c",
"assets/assets/images/ht_01.jpg": "7cf5cec85cb1fba59276991bf84927ba",
"assets/assets/images/int_03_temp.jpg": "07ec3c62c530be8a76101f31b131db1b",
"assets/assets/images/ht_02_1_slice_1.jpg": "98d57d23fb3dbf76aa002322ec19e020",
"assets/assets/images/closers.jpg": "7e8dc174f0d8c4f8b654e21cec2e98c7",
"assets/assets/images/hthome_01_1.jpg": "40a4e42e479266ae45df8ca67c8fed99",
"assets/assets/images/ht_03_2_slice_1.jpg": "2f43554636a4f0b62cb77a8e812c5106",
"assets/assets/images/sam_mes_3.jpg": "e29735b192a2b3ca458469141f2db77a",
"assets/assets/images/ht_02_2_slice_1.jpg": "bd54f87681963e020b27dcbc81a78c5f",
"assets/assets/images/aia_4.jpg": "3b0fda756da92726dbeddc333954bde2",
"assets/assets/images/sam_mes_4.jpg": "f7df8ddd97f2b8e38373db0029ee26e7",
"assets/assets/images/hthome_01_1_slice_2.jpg": "6a9faa6d971af362409d4cbd8d736397",
"assets/assets/images/sam_mes_final.jpg": "72a20e41313262dc4198feffc0c160e9",
"assets/assets/images/sam_mes_8.jpg": "bc69c0503242f141e3750695f4abc95a",
"assets/assets/images/ht_03_2_slice_4.jpg": "dcca4c4d924e8a4635466c821713a87c",
"assets/assets/images/hthome_01_2_slice_3.jpg": "730b8ac78b3b1049b9eba4dad15393ff",
"assets/assets/images/farm_2.jpg": "a2f217195bf410059c1ee3bb59833a0d",
"assets/assets/images/int_01.jpg": "4da88a615140cb809f0d833cb8fc6ef6",
"assets/assets/images/sam_mes_final4.jpg": "a7b1e5bd6d5d57415676980cc233100e",
"assets/assets/images/hthome_01_3_slice_3.jpg": "7e1dbc4b780ef4b6108fa9628848f30d",
"assets/assets/images/sam_mes_final3.jpg": "8f4db81cf40c361390a3e31fdf6c0d41",
"assets/assets/images/sam_mes_finalf.jpg": "59a0f5d84f3ecdf50630700b291095c9",
"assets/assets/images/sam_mes_5.jpg": "30d2a75f7eb0d5a6d735c70e474691ec",
"assets/assets/images/ht_02_2_slice_2.jpg": "4dbaaac5a865404467eec2ef16dd8ab9",
"assets/assets/images/soulark_2.jpg": "1b26e853d3bcffac0313d9010237efd1",
"assets/assets/images/ht_03_1_slice_4.jpg": "433e719d6a259b79706ab02bf32222c6",
"assets/assets/images/closers_2.jpg": "807bdb680c92f1aa127f1c499416b235",
"assets/assets/images/sam_mes_f3_5.jpg": "8504aefe7e14cd5d8d9ff536393292cd",
"assets/assets/images/sam_mes_f3_2.jpg": "014c2b358b2cb9ec490f6476d1a72510",
"assets/assets/images/hthome_thumbnail.jpg": "8a5bf4fc8029180cf18e3d5af3129496",
"assets/assets/images/ht_02_2_slice_4.jpg": "07f2cccfdb9a6085686c05e329a7389d",
"assets/assets/images/hthome_01_1_slice_4.jpg": "e33816fdebbac6c7212e72d36644bc76",
"assets/assets/images/project_detail_aia.jpg": "1da36c6b1948f760081785f7cca2d6a9",
"assets/assets/images/ht_02_1_slice_4.jpg": "169605ff065eaeff435c1d13fbcb68f4",
"assets/assets/images/ht_02_2_slice_3.jpg": "c868d6e539bc244ee808fd4fe6590481",
"assets/assets/images/sam_mes_1.jpg": "a9ec262d6fb7bf9575c27def51584953",
"assets/assets/images/sam_mes_f3_3.jpg": "ee0278caf0ee0c9d9c854dc1f9ec388b",
"assets/assets/images/hthome_01_1_slice_3.jpg": "b4fb401b25d230602d4a103debb5a621",
"assets/assets/images/ht_01_slice_2.jpg": "f8ff4854731332fd5a655c555d3bca37",
"assets/assets/images/sam_mes_finalff.jpg": "a1a8a71077baf52c0bfd9bd5e44d08fb",
"assets/assets/images/sam_mes_f4_2.jpg": "014c2b358b2cb9ec490f6476d1a72510",
"assets/assets/images/sam_mes_f4_7.jpg": "2421db5d8e1c922ec034c284f7e61360",
"assets/assets/images/sam_mes_2.jpg": "b70aae73cf69c679be6959db15069376",
"assets/assets/images/sam_mes_f3_4.jpg": "f6eb7b2f534bf152ed5202cfe856ca8d",
"assets/assets/images/int_02.png": "581beb038e252aa67e0fe8ba80efc2d3",
"assets/assets/images/hthome_01_1_slice_1.jpg": "a084cca7c5b3bd33ddc968c3016a6e6b",
"assets/assets/images/ht_02_1.jpg": "b3eabcb83500dc3bd66f5e5e2af7f420",
"assets/assets/images/soulark.jpg": "d5f3502c418e255bddbf23e381cd9795",
"assets/assets/images/promotion_2.jpg": "b1831cfd7080f46d27ecb1e17fc8021c",
"assets/assets/images/ht_02_1_slice_3.jpg": "9eeb7e08553a44628336e406a3892200",
"assets/assets/images/hthome_01_3_slice_2.jpg": "f9fe59b779d3840a8a1d2f47d0b537ca",
"assets/assets/images/ht_03.jpg": "fdb64e7fcf17924f221ddd2e1a37630c",
"assets/assets/images/aia_5.jpg": "0ab4964dc5f5d76161f3561a4856be01",
"assets/assets/images/aia.jpg": "7ec697acee9e9165240f79e5ffbd84f6",
"assets/assets/images/hthome_01_2.jpg": "2e7bb7f08168a3833dc656c0574bf4af",
"assets/assets/images/hthome_01_3.jpg": "1c3c567e1d07b4196fb99b8e9a8343f3",
"assets/assets/images/closers_3.jpg": "8483422c33594604acd6df64bacf8351",
"assets/assets/images/promotion_1.jpg": "7e5621894086ecb8d68a405294a2622c",
"assets/assets/images/ht_01_slice_3.jpg": "3b0474ddc9f8d251797dafbb1332a13e",
"assets/assets/images/ht_03_1_slice_1.jpg": "99c8ee2501df3efd9f475f3d56eb396f",
"assets/assets/images/ht_02.jpg": "2624663f9027f8eeac5d0418cbb5ed6a",
"assets/assets/images/ht_03_1_slice_2.jpg": "da10f7c215d53b8441edb3ac765f5f90",
"assets/assets/images/ht_03_1_slice_3.jpg": "d8297b5ae5a0e840e4e64a70543fa5a5",
"assets/assets/images/farm.jpg": "ba839255ecfcbe9c55c5311b9f0d1a59",
"assets/assets/images/sam_mes_f4_5.jpg": "3f3fbbc567eb448fae8e94e6da1871f4",
"assets/assets/images/farm_1.jpg": "96d54658138f1269c83d3953406f3d53",
"assets/assets/images/farm_3.jpg": "96ed4202f06ad2e65771726fff54167e",
"assets/assets/images/ht_thumbnail.jpg": "97a26fa7b94a21c4f5bd03c3198a6f4d",
"assets/assets/images/sam_mes_6.jpg": "88e362d6732240a02272ae93cf4a928a",
"assets/assets/images/sam_mes_f3_8.jpg": "b4952fd88ff57f138203ad264af1b763",
"assets/assets/images/int_03.jpg": "a9e395f5245f24afdc4aaac79b839cf6",
"assets/assets/images/sam_mes_f3_1.jpg": "7c10640b0534d6d8460ad2dd854a97c7",
"assets/assets/images/sam_mes_f4_8.jpg": "0025c2ca9bb02d7ec2f797ce07981769",
"assets/assets/images/ht_03_2_slice_3.jpg": "10b97edb431a5e6de64986b2434036a7",
"assets/assets/images/aia_2.jpg": "905580f769056f05ab8a3009eeb28a8a",
"assets/assets/images/ht_03_1.jpg": "78fa184e5f95cacd75ac1b77279c19ef",
"assets/assets/images/sam_mes_f3_6.jpg": "37ea28d73d2c3d99a6e77443b8f85ae8",
"assets/assets/images/hthome_01_2_slice_4.jpg": "fe11dcb5c30400958ca6e854d556f96a",
"assets/assets/images/ht_02_2.jpg": "1f52874855a5f9ea3e66df4f7346644b",
"assets/assets/images/ht_01_slice_5.jpg": "929dc07d56977ad61e00bf5d2bc9992e",
"assets/assets/images/closers_1.jpg": "8ae8a9114bf380353e1e96ebd1a0ef95",
"assets/assets/images/sam_mes_f4_1.jpg": "3a99c16230479c63e42cbcbbdf59cfca",
"assets/assets/images/logo.svg": "e9d6cbdf7ff40d91b2409a45494f9688",
"assets/assets/images/ht_01_slice_4.jpg": "6663ce728a82e516a78d8d3829fc0c33",
"assets/assets/images/ht_01_slice_6.jpg": "786fa60fca58befbcb10edc3d3f4f744",
"assets/assets/images/hthome_01_2_slice_1.jpg": "9aa11dd1162fcca01898e79a906224d6",
"assets/assets/images/sam_mes_thumbnail.jpg": "5668e31a628f06e3534b96c4647704b9",
"assets/assets/images/ht_03_2.jpg": "d8c00eaef7e98e0722f3e377c0f00420",
"assets/assets/images/sam_mes_f4_3.jpg": "fee622e780aa2a9304ac44dc8541ec22",
"assets/assets/images/soulark_3.jpg": "1f217cee175e9eef96c43da8f3b95d71",
"assets/assets/images/aia_1.jpg": "d2b2bc82448752f52a2eac8ab2887ecb",
"assets/assets/images/ht_03_2_slice_2.jpg": "4c95f8d3ea43dbb1f4444153f7631d9c",
"assets/assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/AssetManifest.bin.json": "bea6e2469a9446b669ee80bb863bc712",
"assets/fonts/MaterialIcons-Regular.otf": "7746e36bba7ba6742447fb3950217407",
"assets/AssetManifest.bin": "ddf1a6132b4828b5884ce0a42960284c",
"assets/NOTICES": "ca0e82528db3f6b7ad8b4ab712b88b6b",
"assets/AssetManifest.json": "5be7bd013e6cd827d6ff3ad8b69450fa",
"icons/Icon-512.png": "625d040d87272a1bd25831f469029aff",
"icons/Icon-maskable-512.png": "625d040d87272a1bd25831f469029aff",
"icons/Icon-maskable-192.png": "625d040d87272a1bd25831f469029aff",
"icons/Icon-192.png": "625d040d87272a1bd25831f469029aff",
"404.html": "a9d56a50d3fee2b4018638fdb10065ec",
"flutter_bootstrap.js": "008d5094c49d7228fd3573a0dc591818",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"index.html": "667c058738f5caa291878f8dabc8257d",
"/": "667c058738f5caa291878f8dabc8257d",
"main.dart.js": "0a260ba445f750d64034040956901194",
"favicon.png": "625d040d87272a1bd25831f469029aff",
"manifest.json": "468b65e7a0579b14695df28f14bd2ef0",
"version.json": "d284a6587e9dfd1b71860e4baed542f6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
