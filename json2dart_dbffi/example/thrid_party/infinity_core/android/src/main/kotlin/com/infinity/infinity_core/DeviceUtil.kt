package com.infinity.infinity_core

import android.annotation.SuppressLint
import android.content.Context
import android.net.wifi.WifiManager
import android.telephony.TelephonyManager
import android.text.TextUtils.isEmpty
import java.util.*


/**
 * @author:heinigger
 * 18/10/21  5:20 下午
 * @function:
 * */
object DeviceUtil {
    /**
     * deviceID的组成为：渠道标志+识别符来源标志+hash后的终端识别符
     *
     * 渠道标志为：
     * 1，andriod（a）
     *
     * 识别符来源标志：
     * 1， wifi mac地址（wifi）；
     * 2， IMEI（imei）；
     * 3， 序列号（sn）；
     * 4， id：随机码。若前面的都取不到时，则随机生成一个随机码，需要缓存。
     *
     * @param context
     * @return
     */
    @SuppressLint("MissingPermission")
    fun getDeviceId(context: Context): String {
        val deviceId = StringBuilder()
        // 渠道标志
        deviceId.append("a")
        try {
            //wifi mac地址
            val wifi = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val info = wifi.connectionInfo
            val wifiMac = info.macAddress
            if (!isEmpty(wifiMac)) {
                deviceId.append("wifi")
                deviceId.append(wifiMac)
                //PALog.e("getDeviceId : ", deviceId.toString())
                return deviceId.toString()
            }
            //IMEI（imei）
            val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val imei = tm.deviceId
            if (!isEmpty(imei)) {
                deviceId.append("imei")
                deviceId.append(imei)
                //PALog.e("getDeviceId : ", deviceId.toString())
                return deviceId.toString()
            }
            //序列号（sn）
            val sn = tm.simSerialNumber
            if (!isEmpty(sn)) {
                deviceId.append("sn")
                deviceId.append(sn)
                //PALog.e("getDeviceId : ", deviceId.toString())
                return deviceId.toString()
            }
            //如果上面都没有， 则生成一个id：随机码
            val uuid = getUUID()
            if (!isEmpty(uuid)) {
                deviceId.append("id")
                deviceId.append(uuid)
                //PALog.e("getDeviceId : ", deviceId.toString())
                return deviceId.toString()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            deviceId.append("id").append(getUUID())
        }
        //PALog.e("getDeviceId : ", deviceId.toString())
        return deviceId.toString()
    }

    /**
     * 得到全局唯一UUID
     */
    fun getUUID(): String {
        print("随机生成UUID")
        return UUID.randomUUID().toString()
    }
}