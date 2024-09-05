package com.example.calculator

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "calculator.flutter.dev/calculate"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "calculate") {
                val input = call.argument<String>("input") ?: "0"
                val output = calculateResult(input)
                result.success(output)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun calculateResult(input: String): String {
        // Logika sederhana untuk kalkulasi
        // Contoh: hanya menangani operasi dasar (+, -, *, /) dalam urutan yang diberikan
        try {
            val expression = input.replace("X", "*")
            val result = eval(expression)
            return result.toString()
        } catch (e: Exception) {
            return "Error"
        }
    }

    private fun eval(expression: String): Double {
        // Implementasi evaluasi ekspresi matematis
        // Hanya sebagai contoh sederhana
        return expression.toDouble()
    }
}