package com.soundblast.app

import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.soundblast.app/media_store"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "querySongs" -> {
                    try {
                        result.success(querySongs())
                    } catch (e: SecurityException) {
                        result.error(
                            "PERMISSION_DENIED",
                            "Media permission not granted: ${e.message}",
                            null,
                        )
                    } catch (e: Exception) {
                        result.error("QUERY_FAILED", e.message, null)
                    }
                }
                "albumArt" -> {
                    // Embedded cover for one album, as JPEG/PNG bytes (or
                    // null when the album has no art). Used for the on-device
                    // song covers — MediaStore keeps art per album id.
                    try {
                        val albumId = (call.argument<Number>("albumId")
                            ?: 0).toLong()
                        result.success(albumArt(albumId))
                    } catch (e: Exception) {
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    /// Audio files on the device via MediaStore — the same source
    /// on_audio_query used, without that (unmaintained, AGP-8-incompatible)
    /// plugin. Only real music files: duration > 0 and IS_MUSIC.
    /// Composer comes from the same row; genre lives in MediaStore's
    /// separate genres table, so it is resolved per audio id below.
    private fun querySongs(): List<Map<String, Any?>> {
        val out = mutableListOf<Map<String, Any?>>()
        val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.COMPOSER,
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.SIZE,
        )
        val selection =
            "${MediaStore.Audio.Media.DURATION} > 0 AND " +
                "${MediaStore.Audio.Media.IS_MUSIC} != 0"
        val cursor: Cursor? = contentResolver.query(
            uri,
            projection,
            selection,
            null,
            "${MediaStore.Audio.Media.TITLE} ASC",
        )
        cursor?.use {
            val idCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val composerCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.COMPOSER)
            val albumIdCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM_ID)
            val durCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val dataCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val sizeCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE)
            val genreByAudioId = queryGenreByAudioId()
            while (it.moveToNext()) {
                val id = it.getLong(idCol)
                val path = it.getString(dataCol) ?: continue
                if (path.isEmpty()) continue
                // Prefer the content URI: it stays valid under scoped
                // storage even when the raw path is not directly readable.
                val contentUri =
                    ContentUris.withAppendedId(uri, id).toString()
                out.add(
                    mapOf<String, Any?>(
                        "id" to id,
                        "title" to (it.getString(titleCol) ?: ""),
                        "artist" to (it.getString(artistCol) ?: ""),
                        "album" to (it.getString(albumCol) ?: ""),
                        "composer" to (it.getString(composerCol) ?: ""),
                        "albumId" to it.getLong(albumIdCol),
                        "genre" to (genreByAudioId[id] ?: ""),
                        "durationMs" to it.getLong(durCol),
                        "path" to path,
                        "contentUri" to contentUri,
                        "sizeBytes" to it.getLong(sizeCol),
                    ),
                )
            }
        }
        return out
    }

    /// Cover art bytes for one album id, or null when the album has none.
    /// Reads the album-art content URI straight from the provider.
    private fun albumArt(albumId: Long): ByteArray? {
        if (albumId <= 0) return null
        val artUri = ContentUris.withAppendedId(
            Uri.parse("content://media/external/audio/albumart"),
            albumId,
        )
        return try {
            contentResolver.openInputStream(artUri)?.use { it.readBytes() }
        } catch (e: Exception) {
            null
        }
    }

    /// Genre per audio id. Genres live in their own MediaStore table, so
    /// each genre's member list is scanned once and the first genre wins
    /// for a song that belongs to several.
    private fun queryGenreByAudioId(): Map<Long, String> {
        val map = mutableMapOf<Long, String>()
        val genresUri = MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
        val gCursor = contentResolver.query(
            genresUri,
            arrayOf(
                MediaStore.Audio.Genres._ID,
                MediaStore.Audio.Genres.NAME,
            ),
            null,
            null,
            null,
        )
        gCursor?.use {
            val idCol = it.getColumnIndexOrThrow(MediaStore.Audio.Genres._ID)
            val nameCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Genres.NAME)
            while (it.moveToNext()) {
                val genreId = it.getLong(idCol)
                val name = it.getString(nameCol) ?: continue
                if (name.isEmpty()) continue
                val membersUri =
                    MediaStore.Audio.Genres.Members.getContentUri(
                        "external",
                        genreId,
                    )
                val mCursor = contentResolver.query(
                    membersUri,
                    arrayOf(MediaStore.Audio.Genres.Members.AUDIO_ID),
                    null,
                    null,
                    null,
                )
                mCursor?.use { mc ->
                    val audioCol = mc.getColumnIndexOrThrow(
                        MediaStore.Audio.Genres.Members.AUDIO_ID,
                    )
                    while (mc.moveToNext()) {
                        val audioId = mc.getLong(audioCol)
                        if (!map.containsKey(audioId)) map[audioId] = name
                    }
                }
            }
        }
        return map
    }
}
