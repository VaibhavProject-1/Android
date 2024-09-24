package com.vaibhav.city

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.windowsizeclass.ExperimentalMaterial3WindowSizeClassApi
import androidx.compose.material3.windowsizeclass.WindowSizeClass
import androidx.compose.material3.windowsizeclass.WindowWidthSizeClass
import androidx.compose.material3.windowsizeclass.calculateWindowSizeClass
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.window.layout.WindowMetricsCalculator
import com.vaibhav.city.ui.MyCityApp
import com.vaibhav.city.ui.theme.CityTheme

class MainActivity : ComponentActivity() {
    @OptIn(ExperimentalMaterial3WindowSizeClassApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CityTheme {
                // Calculate the window size class
                val windowSizeClass = calculateWindowSizeClass(this)

                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MyCityApp(
                        windowSize = windowSizeClass.widthSizeClass,
                        contentPadding = innerPadding
                    )
                }
            }
        }
    }
}

// Helper function to calculate the window size class
@Composable
fun calculateWindowSizeClass(activity: ComponentActivity): WindowWidthSizeClass {
    val windowMetrics = WindowMetricsCalculator.getOrCreate()
        .computeCurrentWindowMetrics(activity)
    val windowWidthDp = windowMetrics.bounds.width() / activity.resources.displayMetrics.density
    return when {
        windowWidthDp < 600 -> WindowWidthSizeClass.Compact
        windowWidthDp < 840 -> WindowWidthSizeClass.Medium
        else -> WindowWidthSizeClass.Expanded
    }
}