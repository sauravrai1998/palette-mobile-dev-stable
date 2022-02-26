package com.webknot.paletteMobile

import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import java.util.logging.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink


private const val MESSAGES_CHANNEL = "receive_sharing_intent/messages"
private const val EVENTS_CHANNEL_MEDIA = "receive_sharing_intent/events-media"
private const val EVENTS_CHANNEL_TEXT = "receive_sharing_intent/events-text"

class MainActivity : FlutterActivity() {
    private var initialMedia: JSONArray? = null
    private var latestMedia: JSONArray? = null

    private var initialText: String? = null
    private var latestText: String? = null

    private var eventSinkMedia: EventChannel.EventSink? = null
    private var eventSinkText: EventChannel.EventSink? = null

    private var binding: ActivityPluginBinding? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
            this.finish()
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        handleIntent(activity.intent, true)
        val eChannelText =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENTS_CHANNEL_TEXT)
        eChannelText.setStreamHandler(object : StreamHandler(), EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                when (arguments) {
                    "media" -> eventSinkMedia = events
                    "text" -> eventSinkText = events
                }
            }

            override fun onCancel(arguments: Any?) {
                when (arguments) {
                    "media" -> eventSinkMedia = null
                    "text" -> eventSinkText = null
                }
            }
        }
        )
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MESSAGES_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialMedia" -> result.success(initialMedia?.toString())
                "getInitialText" -> result.success(initialText)
                "reset" -> {
                    initialMedia = null
                    latestMedia = null
                    initialText = null
                    latestText = null
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun handleIntent(intent: Intent, initial: Boolean) {
        when {
            (intent.type == null || intent.type?.startsWith("text") == true)
                    && intent.action == Intent.ACTION_SEND -> { // Sharing text
                val value = intent.getStringExtra(Intent.EXTRA_TEXT)
                if (initial) initialText = value
                latestText = value
                eventSinkText?.success(latestText)
            }
            intent.action == Intent.ACTION_VIEW -> { // Opening URL
                val value = intent.dataString
                if (initial) initialText = value
                latestText = value
                eventSinkText?.success(latestText)
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("Android", "Got New Intent:${intent.action} ")
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(activity.intent, initial = false)
    }

    override fun onResume() {
        super.onResume()
        Log.d("Android", "onResume :${intent.action}")
//        handleIntent(intent, false)
    }

    override fun onPause() {
        super.onPause()
        Log.d("Android", "onPause ")
    }

    override fun onRestart() {
        super.onRestart()
        Log.d("Android", "onRestart ")

    }
}
