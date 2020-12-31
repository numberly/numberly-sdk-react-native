package com.numberly.sdk.reactnative

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule;
import androidx.annotation.MainThread
import android.os.Handler;
import android.os.Looper;
import android.util.Log

object NumberlyEventEmitter {

  private var reactContext: ReactApplicationContext? = null

  private val pendingEvents: MutableList<Pair<String, WritableMap?>> = mutableListOf()
  private val knownEvents: MutableSet<String> = mutableSetOf()
  private var observersCount: Int = 0
  private val mainHandler: Handler = Handler(Looper.getMainLooper())

  fun setReactContext(context: ReactApplicationContext) {
    reactContext = context
    sendPendingEvents()
  }

  private fun sendPendingEvents() {
    synchronized (knownEvents) {
      for (event in pendingEvents.toList()) {
        if (knownEvents.contains(event.first)) {
            pendingEvents.remove(event)
            sendEvent(event.first, event.second)
        }
      }
    }
  }

  fun addListener(event: String) {
    synchronized(knownEvents) {
      observersCount++
      knownEvents.add(event)

      sendPendingEvents()
    }
  }

  fun removeListeners(count: Double) {
    synchronized(knownEvents) {
      observersCount = maxOf(observersCount - count.toInt(), 0)
      if (observersCount == 0) {
        knownEvents.clear()
      }
    }
  }

  fun sendEvent(event: String, params: WritableMap?) {
    val runnable = object: Runnable {
      override fun run() {
        synchronized(knownEvents) {
          if (observersCount == 0 || !knownEvents.contains(event) || !emit(event, params)) {
            pendingEvents.add(Pair(event, params));
          }
        }
      }
    }
    mainHandler.post(runnable)
  }

  @MainThread
  private fun emit(event: String, params: WritableMap?): Boolean {

    reactContext?.let {
      if (!it.hasActiveCatalystInstance()) {
        return false
      }
      try {
        it.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(event, params)
        return true
      } catch (e: Exception) {
        return false
      }
    }

    return false
  }
}
