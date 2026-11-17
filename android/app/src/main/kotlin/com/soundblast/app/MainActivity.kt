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
                else -> result.notImplemented()
            }
        }
    }

    /// Audio files on the device via MediaStore — the same source
    /// on_audio_query used, without that (unmaintained, AGP-8-incompatible)
    /// plugin. Only real music files: duration > 0 and IS_MUSIC.
    private fun querySongs(): List<Map<String, Any?>> {
        val out = mutableListOf<Map<String, Any?>>()
        val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
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
            val durCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val dataCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val sizeCol =
                it.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE)
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
}
