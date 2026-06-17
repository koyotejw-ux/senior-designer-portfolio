'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/images/promotion.jpg": "59b38bc1384823c4e2b99862d168b62d",
"assets/assets/images/soulark_1.jpg": "a9ee347573859988b02b86e30b5bd1e3",
"assets/assets/images/hthome_01.jpg": "a34870d9d96932f2a492b3edd759dc08",
"assets/assets/images/project_detail_aia.png": "5255a4b9c9a73061a37f7535ee603475",
"assets/assets/images/ht_01.jpg": "7cf5cec85cb1fba59276991bf84927ba",
"assets/assets/images/closers.jpg": "7e8dc174f0d8c4f8b654e21cec2e98c7",
"assets/assets/images/hthome_01_1.jpg": "40a4e42e479266ae45df8ca67c8fed99",
"assets/assets/images/farm_2.jpg": "a2f217195bf410059c1ee3bb59833a0d",
"assets/assets/images/soulark_2.jpg": "1b26e853d3bcffac0313d9010237efd1",
"assets/assets/images/closers_2.jpg": "807bdb680c92f1aa127f1c499416b235",
"assets/assets/images/project_detail_aia.jpg": "1da36c6b1948f760081785f7cca2d6a9",
"assets/assets/images/ht_02_1.jpg": "b3eabcb83500dc3bd66f5e5e2af7f420",
"assets/assets/images/soulark.jpg": "d5f3502c418e255bddbf23e381cd9795",
"assets/assets/images/promotion_2.jpg": "b1831cfd7080f46d27ecb1e17fc8021c",
"assets/assets/images/ht_03.jpg": "fdb64e7fcf17924f221ddd2e1a37630c",
"assets/assets/images/hthome_01_2.jpg": "2e7bb7f08168a3833dc656c0574bf4af",
"assets/assets/images/hthome_01_3.jpg": "1c3c567e1d07b4196fb99b8e9a8343f3",
"assets/assets/images/closers_3.jpg": "8483422c33594604acd6df64bacf8351",
"assets/assets/images/promotion_1.jpg": "7e5621894086ecb8d68a405294a2622c",
"assets/assets/images/ht_02.jpg": "2624663f9027f8eeac5d0418cbb5ed6a",
"assets/assets/images/farm.jpg": "ba839255ecfcbe9c55c5311b9f0d1a59",
"assets/assets/images/farm_1.jpg": "96d54658138f1269c83d3953406f3d53",
"assets/assets/images/farm_3.jpg": "96ed4202f06ad2e65771726fff54167e",
"assets/assets/images/ht_03_1.jpg": "78fa184e5f95cacd75ac1b77279c19ef",
"assets/assets/images/ht_02_2.jpg": "1f52874855a5f9ea3e66df4f7346644b",
"assets/assets/images/closers_1.jpg": "8ae8a9114bf380353e1e96ebd1a0ef95",
"assets/assets/images/logo.svg": "e9d6cbdf7ff40d91b2409a45494f9688",
"assets/assets/images/ht_03_2.jpg": "d8c00eaef7e98e0722f3e377c0f00420",
"assets/assets/images/soulark_3.jpg": "1f217cee175e9eef96c43da8f3b95d71",
"assets/AssetManifest.bin.json": "59a3696219c78d6fd57bfe238c6c7e61",
"assets/fonts/MaterialIcons-Regular.otf": "ed9ea38bf31d3dabac6309362f89ab46",
"assets/AssetManifest.bin": "63eee9e91bd3f5fac264c16b6b5e0b8c",
"assets/NOTICES": "ca0e82528db3f6b7ad8b4ab712b88b6b",
"assets/AssetManifest.json": "7c0214ac120f1aaffb3f1917ba622c00",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"flutter_bootstrap.js": "cfe10180a914df7e6321ba7c9a9a8ea3",
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
"index.html": "92a3f4c40a71aa524cb793390c541dbb",
"/": "92a3f4c40a71aa524cb793390c541dbb",
"main.dart.js": "2073b5f3d4a1285487e4a68c4ab69e61",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "021b3a1d792e786dd89d6e9fc792900e",
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
