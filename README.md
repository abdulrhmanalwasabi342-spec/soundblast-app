# SoundBlast — Android app (Flutter)

The native Android client for **SoundBlast**, a music streaming platform.
It mirrors the SoundBlast website
([https://soundblast.onrender.com](https://soundblast.onrender.com)) — same
screens, same flows, same dark design — as a native Flutter app.

- **Package:** `com.soundblast.app`
- **Version:** 1.0.0+1
- **Min SDK:** 24 (Android 7.0). Tested target: Android 11 (API 30).
- **License:** MIT (see `LICENSE`). The website repo declares MIT in its
  `package.json` but ships no `LICENSE` file of its own — this app adds one.
- **Open source:** no secrets, keys, passwords or email addresses are
  hardcoded anywhere in this repo. All configuration is the public backend
  URL plus runtime environment variables on the server (see below).

## Run it

```bash
# Flutter 3.35.7 is required (~/workspace/.flutter-3.35.7). The 3.47.9 SDK
# in ~/workspace/.flutter breaks the test suite — do not use it.
export PATH=~/workspace/.flutter-3.35.7/bin:$PATH
flutter pub get
flutter run
```

Release APK:

```bash
export JAVA_HOME=~/workspace/.jdk17
export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"
export GRADLE_OPTS="-Djava.net.preferIPv4Stack=true"
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

(The IPv4 flags are required in this environment: the Gradle daemon binds
an IPv4-mapped IPv6 socket while the client resolves `localhost` to `::1`,
so the build cannot connect to its own daemon without them.)

## Backend

The app reuses the **live** SoundBlast backend — it does not rebuild the
server. Base URL: `https://soundblast.onrender.com` (Render free tier: the
service sleeps after 15 minutes idle, so the first request after a pause
can take ~30 s; the app shows a loading state and a retry).

### tRPC over HTTP (v11 + superjson)

- Query: `GET /api/trpc/<router>.<procedure>?batch=1&input={"0":{"json":{...}}}`
  (no-input queries use `input={"0":{}}`)
- Mutation: `POST /api/trpc/<router>.<procedure>?batch=1`
  with body `{"0":{"json":{...}}}`
- Response: `[{"result":{"data":{"json": <value>}}}]` (dates arrive as ISO
  strings inside `json`; the superjson `meta` is ignored)
- Error: `[{"error":{"json":{"message": "...", "code": -32603, ...}}}]`

Session: two cookies are stored in secure storage and sent on every
request — `sound_local_session` (localAuth email/password login, HS256 JWT,
1-year expiry) and `app_session_id` (OAuth session). Implemented in
`lib/api/trpc_client.dart` (`TrpcClient`, `importCookie` for the GitHub
WebView flow).

### Procedures used

See `lib/api/api.dart` — it wraps everything the screens need, including
the full admin router (`songs.admin.*`): overview, hero action order,
artist activation, library integrity/cleanup, song update/publish, bulk
delete (comments/playlists/accounts), platform wipe, OAuth + local user
management, `setUserAdmin`, reset password, delete user, audit log, and
more. The Admin screen (`lib/screens/admin_screen.dart`) exposes all of
them, grouped: Users / Content / Artists / Home & platform / Analytics /
System & safety.

## What is in v1

- **Auth:** email + password signup/login (`localAuth`), roles
  listener/artist/admin, avatar upload on signup, logout, session restore.
  **GitHub:** "Continue with GitHub" opens the backend's GitHub OAuth flow
  (`GET /api/auth/github`) in an in-app WebView and imports the
  `sound_local_session` cookie when the flow returns to the site. The start
  endpoint was verified live (302 to github.com with a live client ID),
  but a full round-trip on a phone is still unverified — see "Not yet
  verified".
- **Home / Discover / Trending / Genres / Albums / Artists / Search:**
  hero, release radar, weekly top, popular artists, moods & genres, numbered
  trending list, genre and album detail, artist pages with follow.
- **Player:** just_audio queue with play/pause/seek/volume, play-next,
  previous/next, shuffle/repeat, position persistence (`likes.savePosition`),
  lyrics, comments, mini-player across navigation, full player screen.
- **Background playback + media notification:** `just_audio_background`
  (audio_service) — playback continues when the app is minimised or closed,
  with a media notification in the shade (play/pause, next, previous,
  title/artist, cover art) and lock-screen controls. The Stop button in the
  player screen (and stopping playback) dismisses the notification.
  Android audio focus / interruptions (calls, other apps) are handled by
  just_audio + audio_session.
- **Offline:** a **Downloaded** tab in Library. "Download for offline" in a
  song's menu saves the audio to the app's documents folder and plays it
  with no network. **On-device songs:** the same tab scans audio files
  already on the device (a first-party MediaStore MethodChannel in
  `MainActivity.kt` — `on_audio_query` 2.9.0 is unmaintained and its
  Android plugin has no namespace, which AGP 8 refuses) and plays them
  through the same player/queue.
- **Library:** Liked, Favorites, Playlists (create/rename/delete/add/remove
  songs, draft), Downloaded.
- **Artist studio:** stats, performance charts, activation status, songs
  (incl. delete), posts (create/delete), albums (create).
- **Upload:** artist-only; audio + artwork pick, duration probe, base64
  upload (`songs.uploadFile` → `songs.upload`).
- **Admin:** full surface (see above). Destructive bulk actions
  (delete-all, platform wipe, library cleanup, rollup) need their
  confirmation phrase typed in.
- **Notifications:** inbox + mark read; push preferences screen.
- **About / Contact / Policy / Feedback:** real feedback submission
  (`feedback.submit`); Policy/About text mirrors the website.
- **Design:** exact website palette read from `client/src/index.css` and
  the Tailwind theme — brand pink `#ee0faf`, page `#050508`, surfaces
  `#0d0d1a` / `#151020`, gold `#f4c778`, purple `#9b0fee`, Vazirmatn UI
  font + Playfair Display headings, same radius/spacing, same layout
  structure per screen.

## Permissions — asked once, at the point of need

- **Media/audio** (`READ_MEDIA_AUDIO` on Android 13+, `READ_EXTERNAL_STORAGE`
  on older): asked only the first time the user opens the on-device songs
  section, with a short in-app explanation before the system dialog. If
  granted, never asked again. If denied once, the explanation may be shown
  and it may be asked one more time at most. If denied twice / permanently,
  it is **never** re-prompted — the screen shows a calm note with a button
  that opens app settings. Never asked on every launch, never nagging.
  Implemented in `lib/services/permission_flow.dart` (counters in
  SharedPreferences: `sb_perm_media_asked`, `sb_perm_notif_asked`).
- **Notifications** (`POST_NOTIFICATIONS`, Android 13+): same once-only
  rule, asked on first playback. If denied, audio still plays — only the
  player controls in the notification shade will not show.

## Site owner (super admin) — `ADMIN_EMAIL`

The owner's account is seeded server-side, **not in this repo** (the app
is going open source — the owner's email must never appear in code).
Implemented in the website repo (`~/workspace/sound-blast`, uncommitted):

- `server/_core/env.ts` — `adminEmail: process.env.ADMIN_EMAIL ?? ""`
- `server/db.ts` — `getOwnerEmail` / `isOwnerEmail` / `ensureOwnerAdmin`;
  on localAuth signup/login, if the account email equals `ADMIN_EMAIL`
  (case-insensitive), `isAdmin` is set to `1` automatically. Owner
  protection: the owner can never be demoted, suspended or deleted by
  another admin, and only the owner can grant admin to others. See
  `docs/ADMIN_SEED.md` in the website repo for the full table.
- `server/routers.ts` — seed on signup/login; owner guards on the OAuth
  role panel, `setUserAdmin`, `setUserStatus`.
- `render.yaml` — `ADMIN_EMAIL` env key (`sync: false`, set manually).

**To activate it live (Shadow's / deployer's click — not done by the agent):**

1. Render dashboard → select the **`soundblast`** web service.
2. Left sidebar → **Environment**.
3. **Add Environment Variable** — Key: `ADMIN_EMAIL`, Value: the owner's
   email address.
4. **Save Changes** — Render redeploys automatically.
5. The owner signs up or logs in with that email; `isAdmin` is set on that
   first login/signup. If no account exists yet for that email, the seed
   activates it automatically the first time the owner signs up/logs in
   with it.

## Known live-backend defects (not app bugs)

- `songs.homeSummary` and `songs.publicPostsFeed` return HTTP 500 on the
  live backend (`Failed query: select artistPosts... inner join
  artistProfiles...`). Home falls back to `songs.list` + `songs.trending`;
  the artist-posts feed shows an honest error notice.
- The live database is currently **empty** (0 songs, 0 users, 0 plays as of
  2026-11-17), so lists show honest empty states until content exists.

## Gated / disabled features (shown disabled with the reason, never fake)

| Feature | State | Reason |
|---|---|---|
| Sign in with Google | Disabled | No Google OAuth route exists on the server (only a decorative button on the website with no handler). Needs a new `server/_core/googleAuth.ts` + `GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` + a Google Cloud OAuth client — see gap below. |
| Web Push notifications | Disabled | Browser-only; the app uses the in-app notification inbox + local media notification instead. |
| Password reset email | Honest notice | No reset procedure exists server-side; the app mirrors the website's own text ("Password-reset email is not configured for SoundBlast yet"). |
| Contact-messages inbox (admin) | Disabled | No contact-messages endpoint exists server-side; contact currently goes through Feedback. |
| Scheduled maintenance mode (admin) | Disabled | No maintenance-mode endpoint exists; use Render to stop the service if needed. |
| GitHub sign-in | Implemented, round-trip unverified | Start endpoint verified live (302), but a full login on a phone has not been tested. |

## Named gaps (need a new server procedure — not invented in the app)

1. **Google sign-in** — new `server/_core/googleAuth.ts` mirroring
   `githubAuth.ts` (`GET /api/auth/google` → Google authorize, callback →
   token exchange → profile → find/create + `signLocalSession`), env
   `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET`, Google Cloud OAuth client
   with callback `https://soundblast.onrender.com/api/auth/google/callback`.
2. **Contact-messages inbox** — no endpoint; admin sees feedback only.
3. **Maintenance mode flag** — no endpoint; would need a server setting +
   a check in the tRPC context.
4. **Artist payout / earnings** (SoundCloud/Spotify for Artists style) —
   no endpoint and no payments data model on the server.
5. **Content moderation queue with reports** (report-a-song/comment) — no
   report endpoint; moderation today is direct admin delete.
6. **Scheduled / draft artist posts** — posts are published immediately;
   no scheduling fields exist.

Clearly-labelled **NEW** admin capabilities in the app UI that *are* backed
by existing procedures: artist suspend (via `setUserStatus`), clear
favorites (via `clearFavorites`), recompress legacy audio
(via `recompressLegacyBatch`), delete-all-comments-on-a-song
(via `deleteCommentsBySong`).

## Not yet verified (needs a real phone)

- Install/launch on a real device or emulator (none available in the build
  environment) — APK structure verified instead (see below).
- Background playback after the app is closed, and the media notification
  in the shade — implemented with `just_audio_background` and wired
  correctly, but only a phone test proves it end to end.
- On-device song scanning on a real phone (permission flow + the
  MediaStore channel are implemented; the download-cache path is verified
  by code inspection).
- GitHub OAuth full round-trip on a phone.
- Login with a real account (only anonymous/public endpoints and a
  failed-login probe were used; no accounts were created with anyone's
  credentials).
- The `ADMIN_EMAIL` seed has **not** been deployed: the server changes are
  uncommitted in `~/workspace/sound-blast` and Render has no `ADMIN_EMAIL`
  set yet. It activates on the owner's first login after deploy.

## Verification (build environment)

- `flutter analyze`: **0 errors, 0 warnings**, 63 info-level lints
  (35 `use_build_context_synchronously`, all guarded by mounted checks;
  22 `deprecated_member_use` for `withOpacity` → `withValues`;
  6 `unintended_html_in_doc_comment`).
- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
  (56.4 MB, also copied to `~/workspace/soundblast-1.0.0.apk`) — verified
  with `aapt2 dump badging` (package `com.soundblast.app`, versionCode 1,
  versionName 1.0.0, launchable-activity `com.soundblast.app.MainActivity`)
  and merged-manifest inspection (`aapt2 dump xmltree`): the audio_service
  foreground service (`AudioService`,
  `foregroundServiceType="mediaPlayback"`, 0x2) and the media-button
  receiver are present — the library does not declare them itself, so the
  app's `AndroidManifest.xml` does.
- DEX / launch check: `build/app/outputs/mapping/release/mapping.txt`
  contains `com.soundblast.app.MainActivity ->
  com.soundblast.app.MainActivity:` and `strings classes.dex` contains
  `media_store` and `querySongs` — the launcher activity survives R8.
- Signing: the APK is signed with the stable release keystore
  `android/soundblast-release.keystore` (alias `soundblast`, RSA 2048,
  10,000-day, CN=SoundBlast, O=SoundBlast, C=YE); `apksigner verify
  --print-certs` shows that certificate (SHA-256
  `242a091bd1f4a66cf74b14e987b26621cdcc302355b9585e8503b6bf1e733c78`),
  not the Android Debug key. Passwords live ONLY in
  `android/key.properties` (gitignored, never written into docs);
  `android/app/build.gradle.kts` wires `signingConfigs.release` to it.
  The keystore and `key.properties` are excluded by `.gitignore`
  (`*.jks`, `*.keystore`, `key.properties`).

> **Rejected build — v1.0.0 build 1 (17:20 +03, 54 MB):** never ship it.
> Its `MainActivity.kt` declared `package com.soundblast.soundblast`
> while the manifest resolved `.MainActivity` against applicationId
> `com.soundblast.app`, so the APK referenced
> `com.soundblast.app.MainActivity`, a class that did not exist; R8 then
> tree-shook the real activity away (no `MainActivity` in `classes.dex`,
> no `soundblast` entries in `mapping.txt`) and the app would have crashed
> on launch with `ClassNotFoundException`. It was also signed with the
> Android Debug keystore. Fixed by moving `MainActivity.kt` to
> `android/app/src/main/kotlin/com/soundblast/app/` with package
> `com.soundblast.app` (MethodChannel `com.soundblast.app/media_store` +
> `querySongs` unchanged), creating the release keystore above, and
> rebuilding; the fixed APK passes every check in this section.

> **Build-environment note:** in this VM the Gradle daemon must run with
> a capped heap — `android/gradle.properties` sets
> `org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=512m` (down from 4G/1G);
> with 4G the daemon was killed by the cell's memory limit mid-build
> ("Gradle build daemon disappeared unexpectedly"). Keep the IPv4 flags
> (`JAVA_TOOL_OPTIONS` / `GRADLE_OPTS`) from the build section above.
