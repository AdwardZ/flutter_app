package com.example.flutterappdemo

import android.Manifest
import android.annotation.TargetApi
import android.app.AlertDialog
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.provider.Settings
import android.location.LocationManager
import android.content.Context
import android.widget.Toast
import android.location.Location
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.location.Criteria
import android.util.Log
import androidx.annotation.RequiresApi
import com.baidu.location.BDAbstractLocationListener
import com.baidu.location.BDLocation
import com.baidu.location.LocationClient
import com.baidu.location.LocationClientOption


class MainActivity : FlutterActivity() {

    private var result: MethodChannel.Result? = null
    private val CHANNEL = "Android/api"
    private var locationManager: LocationManager? = null

    /**
     * 判断是否需要检测，防止不停的弹框
     */
    private var isNeedCheck = true
    //是否需要检测后台定位权限，设置为true时，如果用户没有给予后台定位权限会弹窗提示
    private var needCheckBackLocation = false
    //如果设置了target > 28，需要增加这个权限，否则不会弹出"始终允许"这个选择框
    private val BACK_LOCATION_PERMISSION = "android.permission.ACCESS_BACKGROUND_LOCATION"
    /**
     * 需要进行检测的权限数组
     */
    protected var needPermissions = arrayOf(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.CAMERA,
            BACK_LOCATION_PERMISSION,
            Manifest.permission.SEND_SMS
    )
    private val PERMISSON_REQUESTCODE = 0
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

        if (isOPen()) {
            openGPSSettings(this)
        }

        initLocation()
        if (Build.VERSION.SDK_INT > 28 && applicationContext.applicationInfo.targetSdkVersion > 28) {
            needPermissions = arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.READ_PHONE_STATE,
                    Manifest.permission.CAMERA,
                    Manifest.permission.ACCESS_NETWORK_STATE,
                    Manifest.permission.SEND_SMS,
                    Manifest.permission.INTERNET,
                    Manifest.permission.WRITE_CONTACTS,
                    Manifest.permission.READ_CONTACTS,
                    BACK_LOCATION_PERMISSION)
            needCheckBackLocation = true
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        initLocation()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    this.result = result
                    if (call.method.equals("inspectionGPS")) {
                        val isOpen = isOPen()
                        if (isOpen) {        //检测GPS是否开启
                            result.success("GPS已开启")
                        }
                        result.success("GPS未开启")
                    } else if (call.method.equals("openGPS")) {    //打开GPS
                        openGPSSettings(this)
                    } else if (call.method.equals("getDate")) {
                        var pera = checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                        var perb = checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                        if ("".equals(localDate)) {
                            //显示经纬度
                            result.success("no gps")
                        } else {
                            //显示经纬度
                            result.success(localDate)
                        }
                    } else if (call.method.equals("initLoc")) {
                        initLocation()
                    }
                }

    }

    /**
     * @param
     * @since 2.5.0
     */
    @TargetApi(29)
    private fun checkPermissions(vararg permissions: String) {
        try {
            if (Build.VERSION.SDK_INT >= 29 && applicationInfo.targetSdkVersion >= 29) {
                val needRequestPermissonList = findDeniedPermissions(permissions as Array<String>)
                if (null != needRequestPermissonList && needRequestPermissonList.size > 0) {
                    try {
                        val array = needRequestPermissonList.toTypedArray()
                        val method = javaClass.getMethod("requestPermissions", *arrayOf<Class<*>>(Array<String>::class.java, Int::class.java))
                        method.invoke(this, array, 0)
                    } catch (e: Throwable) {

                    }

                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    var localDate = ""

    @TargetApi(Build.VERSION_CODES.M)
    private fun initLocation() {
        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return
        }
        val locationClient = LocationClient(getApplicationContext());
//声明LocationClient类实例并配置定位参数
        val locationOption = LocationClientOption()
        //注册监听函数
        locationClient.registerLocationListener { location ->
            // 20220321: adward
            //Log.d("gps","gps date "+location.longitude.toString() + " " + location.latitude.toString())
            // adward
            localDate = location.longitude.toString() + "," + location.latitude.toString()
            //Toast.makeText(applicationContext,localDate,Toast.LENGTH_SHORT).show()
        }
//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        locationOption.setLocationMode(LocationClientOption.LocationMode.Device_Sensors);
//可选，默认gcj02，设置返回的定位结果坐标系，如果配合百度地图使用，建议设置为bd09ll;
        locationOption.setCoorType("gcj02")
//可选，默认0，即仅定位一次，设置发起连续定位请求的间隔需要大于等于1000ms才是有效的
        locationOption.setScanSpan(5000)
//可选，设置是否需要地址信息，默认不需要
        locationOption.setIsNeedAddress(true)
//可选，设置是否需要地址描述
        locationOption.setIsNeedLocationDescribe(true)
//可选，设置是否需要设备方向结果
        locationOption.setNeedDeviceDirect(false)
//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        locationOption.setLocationNotify(true)
//可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死
        locationOption.setIgnoreKillProcess(true)
//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        locationOption.setIsNeedLocationDescribe(true)
//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        locationOption.setIsNeedLocationPoiList(true)
//可选，默认false，设置是否收集CRASH信息，默认收集
        locationOption.SetIgnoreCacheException(false)
//可选，默认false，设置是否开启Gps定位
        locationOption.setOpenGps(true)
//可选，默认false，设置定位时是否需要海拔信息，默认不需要，除基础定位版本都可用
        locationOption.setIsNeedAltitude(false)
//设置打开自动回调位置模式，该开关打开后，期间只要定位SDK检测到位置变化就会主动回调给开发者，该模式下开发者无需再关心定位间隔是多少，定位SDK本身发现位置变化就会及时回调给开发者
        locationOption.setOpenAutoNotifyMode()
//设置打开自动回调位置模式，该开关打开后，期间只要定位SDK检测到位置变化就会主动回调给开发者
        locationOption.setOpenAutoNotifyMode(3000, 1, LocationClientOption.LOC_SENSITIVITY_HIGHT);
//需将配置好的LocationClientOption对象，通过setLocOption方法传递给LocationClient对象使用
        locationClient.setLocOption(locationOption)
//开始定位
        locationClient.start()
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun isOPen(): Boolean {
        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return false
        }
        var locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        var gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
        var network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        /**确认GPS是否开启 */
        return if (gps || network) {
            true
        } else false
    }


    private fun checkGpsIsOpen(): Boolean {
        val isOpen: Boolean
        val locationManager = this.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        isOpen = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
        return isOpen
    }

    private fun openGPSSettings(context: Context) {
        if (checkGpsIsOpen()) {
            Toast.makeText(this, "true", Toast.LENGTH_SHORT).show()
        } else {
            AlertDialog.Builder(this).setTitle("open GPS")
                    .setMessage("go to open")
                    //  取消选项
                    .setNegativeButton("cancel") { dialogInterface, i ->
                        Toast.makeText(this@MainActivity, "close", Toast.LENGTH_SHORT).show()
                        // 关闭dialog
                        dialogInterface.dismiss()
                    }
                    //  确认选项
                    .setPositiveButton("setting") { dialogInterface, i ->
                        //跳转到手机原生设置页面
                        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                        startActivityForResult(intent, 1)
                    }
                    .setCancelable(false)
                    .show()
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == 10000) {
            //这里写回调方法
            this.result?.success(data!!.getStringExtra("photoPath"))
        }
    }

    var pro = ""
    /* 获取权限集中需要申请权限的列表
     *
     * @param permissions
     * @return
     * @since 2.5.0
     */
    @TargetApi(23)
    private fun findDeniedPermissions(permissions: Array<String>): List<String>? {
        try {
            val needRequestPermissonList = ArrayList<String>()
            if (Build.VERSION.SDK_INT >= 23 && applicationInfo.targetSdkVersion >= 23) {
                for (perm in permissions) {
                    if (checkMySelfPermission(perm) != PackageManager.PERMISSION_GRANTED || shouldShowMyRequestPermissionRationale(perm)) {
                        if (!needCheckBackLocation && BACK_LOCATION_PERMISSION == perm) {
                            continue
                        }
                        needRequestPermissonList.add(perm)
                    }
                }
            }
            return needRequestPermissonList
        } catch (e: Throwable) {
            e.printStackTrace()
        }

        return null
    }

    private fun checkMySelfPermission(perm: String): Int {
        try {
            val method = javaClass.getMethod("checkSelfPermission", *arrayOf<Class<*>>(String::class.java))
            return method.invoke(this, perm) as Int
        } catch (e: Throwable) {
        }

        return -1
    }

    private fun shouldShowMyRequestPermissionRationale(perm: String): Boolean {
        try {
            val method = javaClass.getMethod("shouldShowRequestPermissionRationale", *arrayOf<Class<*>>(String::class.java))
            return method.invoke(this, perm) as Boolean
        } catch (e: Throwable) {
        }

        return false
    }

    override fun onResume() {
        try {
            super.onResume()
            if (Build.VERSION.SDK_INT >= 23) {
                if (isNeedCheck) {
                    checkPermissions(*needPermissions)
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }

    }

    /**
     * 检测是否说有的权限都已经授权
     *
     * @param grantResults
     * @return
     * @since 2.5.0
     */
    private fun verifyPermissions(grantResults: IntArray): Boolean {
        try {
            for (result in grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    return false
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }

        return true
    }

    @TargetApi(23)
    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, paramArrayOfInt: IntArray) {
        try {
            if (Build.VERSION.SDK_INT >= 23) {
                if (requestCode == PERMISSON_REQUESTCODE) {
                    if (!verifyPermissions(paramArrayOfInt)) {
                        showMissingPermissionDialog()
                        isNeedCheck = false
                    }
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }

    }

    /**
     * 显示提示信息
     *
     * @since 2.5.0
     */
    private fun showMissingPermissionDialog() {
        try {
            val builder = AlertDialog.Builder(this)
            builder.setTitle("提示")
            builder.setMessage("当前应用缺少必要权限。请点击\"设置\"-\"权限\"-打开所需权限")

            // 拒绝, 退出应用
            builder.setNegativeButton("取消"
            ) { dialog, which ->
                try {
                    finish()
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            builder.setPositiveButton("设置"
            ) { dialog, which ->
                try {
                    startAppSettings()
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            builder.setCancelable(false)

            builder.show()
        } catch (e: Throwable) {
            e.printStackTrace()
        }


    }

    /**
     * 启动应用的设置
     *
     * @since 2.5.0
     */
    private fun startAppSettings() {
        try {
            val intent = Intent(
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            startActivity(intent)
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

}
