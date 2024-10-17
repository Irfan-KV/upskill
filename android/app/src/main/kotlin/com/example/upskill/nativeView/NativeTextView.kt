package com.example.upskill.nativeView

import android.content.Context
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

class NativeTextView(context: Context?, id: Int, params: Map<String, Any>) : PlatformView {
    private val textView: TextView = TextView(context)

    init {
        val text = params["text"] as? String ?: "Default Text"
        textView.text = text
        textView.textSize = 20f
    }

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}
}

