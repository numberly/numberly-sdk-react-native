package com.numberly.sdk.reactnative

import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.Arguments
import org.json.JSONObject
import org.json.JSONArray

object NumberlyUtils {

    fun convertJsonToMap(jsonObject: JSONObject): WritableMap {
      var map: WritableMap = Arguments.createMap()

      for ( key in jsonObject.keys() ) {
        var value: Any = jsonObject.get(key)

        if (value is JSONObject) {
          map.putMap(key, convertJsonToMap(value))
        } else if (value is JSONArray) {
          map.putArray(key, convertJsonToArray(value))
        } else if (value is Boolean) {
          map.putBoolean(key, value)
        } else if (value is Int) {
          map.putInt(key, value)
        } else if (value is Double) {
          map.putDouble(key, value)
        } else if (value is String) {
          map.putString(key, value)
        } else {
          map.putString(key, value.toString())
        }
      }

      return map
    }

    fun convertJsonToArray(jsonArray: JSONArray): WritableArray {
      var array: WritableArray = Arguments.createArray()

      for (i in 0 until jsonArray.length()) {
        var value: Any = jsonArray.get(i)

        if (value is JSONObject) {
          array.pushMap(convertJsonToMap(value))
        } else if (value is JSONArray) {
          array.pushArray(convertJsonToArray(value))
        } else if (value is Boolean) {
          array.pushBoolean(value)
        } else if (value is Int) {
          array.pushInt(value)
        } else if (value is Double) {
          array.pushDouble(value)
        } else if (value is String) {
          array.pushString(value)
        } else {
          array.pushString(value.toString())
        }
      }
      return array
    }
}
