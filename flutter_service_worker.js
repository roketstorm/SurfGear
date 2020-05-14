'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/icons/ic_feature_1.png": "7c367d5ed4f604a341042b2a4fefd3f5",
"assets/icons/ic_feature_2.png": "1e1fdb8965208ae6848481c1c39affe3",
"assets/icons/ic_feature_3.png": "28e12685ad00d2431cef1404e4a02e29",
"assets/icons/Ic_lib_1.png": "a73eb96b6af95ddfc7c60e97a12d000d",
"assets/icons/ic_lib_2.png": "ba95947c61bc5dfa365adf1d679f878b",
"assets/icons/ic_lib_3.png": "dc73cd6cd892580570bdc2444ff1a8d4",
"assets/icons/ic_lib_4.png": "fed0959479d0311b06374193ced1c4d3",
"assets/icons/ic_lib_5.png": "8503ceacc1f2fa4f43a5b9bd9d8e63f6",
"assets/icons/ic_lib_6.png": "b68f1eb07f3dd8c5ceebf14fd0f136f8",
"assets/images/img_body_background.png": "55d894fa7ccb74e67be1357e74ada45c",
"assets/images/img_footer_background.jpg": "857b84607c5bb3610666abeddd0dfa01",
"assets/images/img_header_background.jpg": "9ad4df3c541ad82d3ee825bd6466ce4b",
"assets/images/img_logo.png": "d74a78acbe9a02342841b3e8ed251e3b",
"assets/images/img_logo_blue.png": "3569c41c5d1a55214295af6cd485d09d",
"assets/libraries_config.json": "7d11458b3acafc4e3084d03947876e49",
"assets/LICENSE": "4de3be09689ca8733f2f70af0294e401",
"favicon.png": "cb1416745b91e21c24d20be423fe0f9c",
"icons/Icon-192.png": "2b03cc6c062700319bcf3baa0afb4eee",
"icons/Icon-512.png": "a23f2a905e02bdf5e125f1c2f6177c97",
"index.html": "7af99cbc8e4b21e6c7435697f6bc9415",
"/": "7af99cbc8e4b21e6c7435697f6bc9415",
"main.dart.js": "8746fcc0f318b7aed9ab5b4fad3b1fdf",
"manifest.json": "67194a0fd14c9ebd01a76ce4f8775e52"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"/",
"index.html",
"assets/LICENSE",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(CORE);
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
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
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
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // If the URL is not the the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

