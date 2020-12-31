package com.numberly.sdk.reactnative

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.numberly.Numberly
import com.numberly.push.NLPushCallback
import com.numberly.push.NLTokenCallback
import androidx.core.app.NotificationManagerCompat
import org.json.JSONObject
import org.json.JSONException
import android.util.Log

public class NumberlyPluginModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), NLPushCallback {

    override fun initialize() {
      Log.d("[Numberly RN]", "initialized")
      super.initialize()

      NumberlyEventEmitter.setReactContext(getReactApplicationContext())
      Numberly.init(getReactApplicationContext())
      Numberly.setPushActionCallback(this)

      Numberly.getPushToken(object : NLTokenCallback {
        override fun onTokenReceived(token: String) {
          var params: WritableMap = Arguments.createMap()
          if (token != null) {
            params.putString("token", token)
          }
          NumberlyEventEmitter.sendEvent("numberly.push.token", params)
        }
      })
    }

    override fun getName(): String {
        return "NumberlyModule"
    }

    @ReactMethod
    public fun userInstallationID(promise: Promise) {
      promise.resolve(Numberly.getNLID(getReactApplicationContext()))
    }

    @ReactMethod
    public fun pushDeviceToken(promise: Promise) {
      Numberly.getPushToken(object : NLTokenCallback {
        override fun onTokenReceived(token: String) {
          promise.resolve(token)
        }
      })
    }

    @ReactMethod
    public fun pushAreNotificationsEnabled(promise: Promise) {
      promise.resolve(NotificationManagerCompat.from(getReactApplicationContext()).areNotificationsEnabled())
    }

    override fun pushOpenedWithData(data: JSONObject) {
      NumberlyEventEmitter.sendEvent("numberly.push.notification.response", wrappedNotification(data))
    }

    private fun wrappedNotification(data: JSONObject): WritableMap {

      var wrapped: WritableMap = Arguments.createMap()
      wrapped.putString("id", data.getString("id"))

      var content: WritableMap = Arguments.createMap()
      var contentData: WritableMap = Arguments.createMap()

      try {
        data.remove("id");
        contentData = NumberlyUtils.convertJsonToMap(data)
      } catch (e: JSONException) {}

      content.putMap("data", contentData)
      wrapped.putMap("content", content)
      return wrapped
    }

    @ReactMethod
    public fun addListener(event: String) {
      NumberlyEventEmitter.addListener(event)
    }

    @ReactMethod
    public fun removeListeners(count: Double) {
      NumberlyEventEmitter.removeListeners(count)
    }
}
