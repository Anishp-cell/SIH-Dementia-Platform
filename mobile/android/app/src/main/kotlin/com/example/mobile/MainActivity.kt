package com.example.mobile

import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val CHANNEL = "com.example.mobile/tts"
    private var tts: TextToSpeech? = null
    private var isTtsReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        tts = TextToSpeech(this, this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text") ?: ""
                    val rate = call.argument<Double>("rate") ?: 0.85
                    val lang = call.argument<String>("language") ?: "en"

                    if (isTtsReady && text.isNotEmpty()) {
                        when (lang) {
                            "hi" -> tts?.language = Locale("hi", "IN")
                            "as" -> {
                                val setLangResult = tts?.setLanguage(Locale("as", "IN"))
                                if (setLangResult == TextToSpeech.LANG_MISSING_DATA || setLangResult == TextToSpeech.LANG_NOT_SUPPORTED) {
                                    tts?.language = Locale("hi", "IN")
                                }
                            }
                            else -> tts?.language = Locale.ENGLISH
                        }
                        tts?.setSpeechRate(rate.toFloat())
                        tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "smriti_tts_id")
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "stop" -> {
                    tts?.stop()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            tts?.language = Locale.ENGLISH
            isTtsReady = true
        }
    }

    override fun onDestroy() {
        tts?.stop()
        tts?.shutdown()
        super.onDestroy()
    }
}
