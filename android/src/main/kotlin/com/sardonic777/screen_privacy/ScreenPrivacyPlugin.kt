package com.sardonic777.screen_privacy

import android.app.Activity
import android.os.Build
import android.view.WindowManager

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenPrivacyPlugin */
class ScreenPrivacyPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    var isSecureFlagSet = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "screen_privacy")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "enableScreenshot" -> {
                val isFlagRemoved = removeSecureFlag()
                result.success("Method channel call [enableScreenshot] | isFlagRemoved = $isFlagRemoved")
            }

            "disableScreenshot" -> {
                val isFlagSet = setSecureFlag()
                result.success("Method channel call [disableScreenshot] | isFlagSet = $isFlagSet")
            }

            "isScreenshotDisabled" -> {
                result.success(isScreenshotDisabled())
            }

            "enablePrivacyScreen" -> {
                val isFlagSet = setSecureFlag()
                result.success("Method channel call [enablePrivacyScreen] | isFlagSet = $isFlagSet")
            }

            "disablePrivacyScreen" -> {
                val isFlagRemoved = removeSecureFlag()
                result.success("Method channel call [disablePrivacyScreen] | isFlagRemoved = $isFlagRemoved")
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        onAttachedToActivity(activityPluginBinding)
    }

    override fun onDetachedFromActivity() {}


    private fun setSecureFlag(): Boolean {
        try {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//                setRecentsScreenshotEnabled(false)
//            }

            activity.window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE,
            )
            isSecureFlagSet = true
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun removeSecureFlag(): Boolean {
        try {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//                setRecentsScreenshotEnabled(true)
//            }
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            isSecureFlagSet = false
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun isScreenshotDisabled(): Boolean {
        return isSecureFlagSet
    }

}
