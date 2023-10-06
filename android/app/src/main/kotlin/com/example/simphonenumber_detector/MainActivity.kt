import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sim_card_reader"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSimCardInfo") {
                val simCardInfo = getSimCardInfo()
                result.success(simCardInfo)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSimCardInfo(): Map<String, String> {
        val simInfo = mutableMapOf<String, String>()

        // Check if the app has permission to read phone state
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val phoneNumber = telephonyManager.line1Number ?: ""
            val carrierName = telephonyManager.simOperatorName ?: ""

            simInfo["phoneNumber"] = phoneNumber
            simInfo["carrierName"] = carrierName
        } else {
            // If permission is not granted, you should request it here or handle the lack of permission accordingly.
            // For example, you can request permission using the ActivityCompat.requestPermissions method.
            ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.READ_PHONE_STATE), PERMISSION_REQUEST_CODE)
        }

        return simInfo
    }

    companion object {
        const val PERMISSION_REQUEST_CODE = 123 // Use any unique code for your permission request
    }
}
