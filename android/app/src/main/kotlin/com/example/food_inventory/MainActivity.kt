package com.suresh.foodinventory

import android.annotation.SuppressLint
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.dantsu.escposprinter.connection.DeviceConnection
import com.dantsu.escposprinter.connection.tcp.TcpConnection
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.*


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.suresh.foodinventory/orderprint"
    var ipAddress = ""
    var portNumber = ""
    var restaurantName = ""
    var phoneNumber = ""
    var address = ""
    var quantity=""
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "print_order") {
                ipAddress = call.argument<String>("ip_address") ?: ""
                portNumber = call.argument<String>("port_number") ?: ""
                restaurantName = call.argument<String>("name")?: ""
                phoneNumber = call.argument<String>("phone")?: ""
                address = call.argument<String>("address")?: ""
                quantity = call.argument<String>("quantity")?: ""
                Log.e("", "obj1: $ipAddress")
                Log.e("", "obj1: $portNumber")
                Log.e("", "obj1: $restaurantName")
                Log.e("", "obj1: $phoneNumber")
                Log.e("", "obj1: $address")
                Log.e("", "obj1: $quantity")
                if (call.hasArgument("orderData")) {
                    val orderData = call.argument<String>("orderData") ?: ""
                    if (orderData.isNotEmpty()) {
                        val orderModel = JSONObject(orderData)
                        Log.e("", "Order Data: ${getOrderData(orderModel)}")
                        printTcp(orderModel,restaurantName,phoneNumber,address,quantity)
                        //disconnect()
                    }
                }
            }
        }
    }

    fun getOrderData(orderModel: JSONObject): String {

        val userJsonObj = orderModel.getJSONObject("userDetails")
        return """
                [L]
                [C]<u><font size='big'>ORDER ${orderModel["orderNumber"]}</font></u>
                [L]
                [C]<u type='double'>${orderModel["orderDateTime"]}</u>
                [C]
                [C]==========================================================
                [L]
                ${getOrderItemData(orderModel)}
                [C]----------------------------------------------------------
                [L]Delivery Charge :[R] ${getDelCharge(orderModel)}
                [L]Discount :[R]${orderModel["discount"]}
                [L]Tip :[R]${orderModel["tip"]}
                [C]---------------------------------------------------------- 
                [L]Grand Total :[R]€${orderModel["totalAmount"]}
                [C]==========================================================
                [L]
                [L]<u><font color='bg-black' size='tall'>Customer :</font></u>
                [L]${userJsonObj["firstName"]} ${userJsonObj["lastName"]} 
                [L]${userJsonObj["address"]}, ${userJsonObj["city"]}
                [L]Tel : ${userJsonObj["contact"]}
                [L]
                [L]
                [L]
                [L]
                
                """
    }

    fun printTcp(orderModel: JSONObject,name: String?,phone: String?,address: String?,quantity: String?) {
        if (ipAddress.isNotEmpty() && portNumber.isNotEmpty()) {
            try {
                AsyncTcpEscPosPrint(this)
                        .execute(this.getAsyncEscPosPrinter(TcpConnection(ipAddress, portNumber.toInt()), orderModel,name,phone,address,quantity))
            } catch (e: NumberFormatException) {
                e.printStackTrace()
            }
        }
    }

    fun getAsyncEscPosPrinter(printerConnection: DeviceConnection?, orderModel: JSONObject,name: String?,phone: String?,address: String?,quantity: String?): AsyncEscPosPrinter? {
        val userJsonObj = orderModel.getJSONObject("userDetails")
        val printer = AsyncEscPosPrinter(printerConnection!!, 350, 48f, 48)
        return printer.setTextToPrint(
                """
                [R]<font size='normal'>${orderModel["orderDateTime"]}</font>
                [C]
                [C]<b><font size='big'>$name</font></b>
                [C]<b><font size='normal'>$phone</font></b>
                [C]<b><font size='normal'>$address</font></b>
                [C]
                [C]<font size='medium'>Order - ${orderModel["orderNumber"]}</font>
                [C]<b><font size='normal'>Order Type - ${orderModel["deliveryType"]}</font></b>
                [C]<b><font size='normal'>Payment Mode - ${orderModel["paymentMode"]}</font></b>
                [C]
                [C]------------------------------------------------
                ${getOrderItemData(orderModel)}------------------------------------------------
                ${getDeliveryCharge(orderModel)}
                [L]Discount :[R]${orderModel["discount"]}
                [L]Tip :[R]${orderModel["tip"]}
                [C]------------------------------------------------
                [L]<b>Total :</b>[R]<b>€${orderModel["totalAmount"]}</b>
                [L]
                 ${getAddres(orderModel)}
                [C]
                [C]
                [C]
                [C]
                [C]            
                """.trimIndent()
        )
    }

    @SuppressLint("SimpleDateFormat", "NewApi")
    fun getOrderDate(createdDate: String?): String? {
        /*val simpleDateFormat = SimpleDateFormat()
        simpleDateFormat.timeZone = TimeZone.getTimeZone("UTC")
        val date = simpleDateFormat.parse(createdDate!!)*/
        val date = LocalDateTime
                .parse(createdDate)
                .toLocalDate()
                .format(
                        DateTimeFormatter
                                .ofLocalizedDate(FormatStyle.LONG)
                                .withLocale(Locale.US)
                )
        val formatter = SimpleDateFormat("'on' yyyy-MM-dd 'at' HH:mm:ss", Locale.getDefault())
        return formatter.format(date!!)
    }

    fun getOrderItemData(orderModel: JSONObject): String {

        var itemPrintData = ""
        var itemDicont=""
        val itemArray = orderModel.getJSONArray("itemDetails")
        for (i in 0 until itemArray.length()) {
            val itemJson = itemArray.getJSONObject(i)
            if(itemJson["discount"] != 0)
            {
                itemDicont= itemJson["discount"].toString()
            }
            else if(itemJson["catDiscount"] != 0)
            {
                itemDicont= itemJson["catDiscount"
                ].toString()
            }
            else if(itemJson["overallDiscount"] != 0)
            {
                itemDicont= itemJson["overallDiscount"].toString()
            }

            itemPrintData += "$itemDicont% OFF /n ${itemJson["quantity"]} ${itemJson["name"]}[R]${itemJson["price"]}${getItemExtraAddOns(itemJson)}" }
        return itemPrintData
    }

    fun getDelCharge(orderModel: JSONObject) :String {
       val delcharge =orderModel["deliveryCharge"]
        val zero  = "0"

        if(delcharge!=zero )
        {
            return "$delcharge"
        }
        else{
            return ""
        }
    }

    fun getDeliveryCharge(orderModel: JSONObject) :String {
        /*   [L]Delivery Charge :[R] ${getDelCharge(orderModel)}*/
       val delcharge =orderModel["deliveryCharge"]
        val zero  = "0"

        if(delcharge!=zero )
        {
            return  "  [L]Delivery Charge :[R] $delcharge"
        }
        else{
            return ""
        }


    }
    fun getAddres(orderModel: JSONObject) :String {
        var name=""
        var add=""
        var cont=""
        val userJsonObj = orderModel.getJSONObject("userDetails")
        val orderType=  orderModel["deliveryType"]
        val pickUP="PICKUP"
        Log.e("LogOrderData"," "+orderType)
        if(orderType == pickUP)
        {
            return "$name $add $cont"
        }
        else{
            name = """ [C] <b> ${userJsonObj["firstName"]} ${userJsonObj["lastName"]} </b>"""
            add= """ [C] <b> ${userJsonObj["address"]} </b> """
            cont= """ [C] <b> Tel : ${userJsonObj["contact"]} </b> """
            return "$name /n $add /n $cont"
        }

    }

    fun getAmountWithCurrency(price: String?): String {
        val princeDouble = price ?: "0".toDouble()
        val df = DecimalFormat("#.##")
        return "€ ${df.format(princeDouble)}"
    }

    fun getItemExtraAddOns(itemJsonObj: JSONObject): String {
        var optionTag = ""
        if (itemJsonObj["option"].toString().isNotEmpty()) {
            optionTag = "(${itemJsonObj["option"]})"
        }

        val toppingArray = itemJsonObj.getJSONArray("toppings")
        var toppingTag = ""
        val list: ArrayList<String> = ArrayList()
        if(!list.isEmpty())
        {
            list.clear()
        }
        for (i in 0 until toppingArray.length()) {
            val toppingJson = toppingArray.getJSONObject(i)
            var price = ""
            var quantity = ""
            price = " (€${toppingJson["price"]})"
            quantity=" (${toppingJson["toppingCount"]})"
            if (toppingJson != null) {
                    toppingTag  = "${toppingJson["name"]}${price}"
                list.add("""<b>++ ${toppingJson["name"]}${price}${quantity} </b> """)
            }
        }
        return if (toppingTag.isEmpty()) {
            optionTag
        } else {
            //"$optionTag [${toppingTag}]"
            "$optionTag ${list.toString().replace("\\[\\]", "")}"
        }
    }
}
