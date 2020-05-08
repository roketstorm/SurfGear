'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "55250834554073a26052ace43ba128d4",
"assets/assets/icons/ic_feature_1.png": "7c367d5ed4f604a341042b2a4fefd3f5",
"assets/assets/icons/ic_feature_2.png": "1e1fdb8965208ae6848481c1c39affe3",
"assets/assets/icons/ic_feature_3.png": "28e12685ad00d2431cef1404e4a02e29",
"assets/assets/icons/Ic_lib_1.png": "a73eb96b6af95ddfc7c60e97a12d000d",
"assets/assets/icons/ic_lib_2.png": "ba95947c61bc5dfa365adf1d679f878b",
"assets/assets/icons/ic_lib_3.png": "dc73cd6cd892580570bdc2444ff1a8d4",
"assets/assets/icons/ic_lib_4.png": "fed0959479d0311b06374193ced1c4d3",
"assets/assets/icons/ic_lib_5.png": "8503ceacc1f2fa4f43a5b9bd9d8e63f6",
"assets/assets/icons/ic_lib_6.png": "b68f1eb07f3dd8c5ceebf14fd0f136f8",
"assets/assets/images/img_body_background.png": "55d894fa7ccb74e67be1357e74ada45c",
"assets/assets/images/img_footer_background.jpg": "857b84607c5bb3610666abeddd0dfa01",
"assets/assets/images/img_header_background.jpg": "920f6b029eb99332656b9a423688bb6a",
"assets/assets/images/img_logo.png": "d74a78acbe9a02342841b3e8ed251e3b",
"assets/assets/images/img_logo_blue.png": "3569c41c5d1a55214295af6cd485d09d",
"assets/assets/libraries_config.json": "7d11458b3acafc4e3084d03947876e49",
"assets/FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/LICENSE": "396bde069d194f1b636d00fa5c910fb8",
"favicon.png": "cb1416745b91e21c24d20be423fe0f9c",
"icons/Icon-192.png": "2b03cc6c062700319bcf3baa0afb4eee",
"icons/Icon-512.png": "a23f2a905e02bdf5e125f1c2f6177c97",
"index.html": "7af99cbc8e4b21e6c7435697f6bc9415",
"/": "7af99cbc8e4b21e6c7435697f6bc9415",
"main.dart.js": "3a4c7a25ac3d1cde01e0b5db85b0061a",
"manifest.json": "67194a0fd14c9ebd01a76ce4f8775e52"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
