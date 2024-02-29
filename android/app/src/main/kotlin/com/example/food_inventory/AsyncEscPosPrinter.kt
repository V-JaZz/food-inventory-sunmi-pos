package com.suresh.foodinventory

import com.dantsu.escposprinter.EscPosPrinterSize
import com.dantsu.escposprinter.connection.DeviceConnection


class AsyncEscPosPrinter(val printerConnection: DeviceConnection, printerDpi: Int, printerWidthMM: Float, printerNbrCharactersPerLine: Int) : EscPosPrinterSize(printerDpi, printerWidthMM, printerNbrCharactersPerLine) {
    var textToPrint = ""
        private set

    fun setTextToPrint(textToPrint: String): AsyncEscPosPrinter {
        this.textToPrint = textToPrint
        return this
    }

}
