package `in`.vaibhav.tips

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Scaffold
import androidx.compose.ui.Modifier
import `in`.vaibhav.tips.data.DataSource
import `in`.vaibhav.tips.ui.theme.TipsTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TipsTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    // Call the NutritionTipScreen composable here

                    NutritionTipScreen(nutritionTips = DataSource().nutritionTips, innerPadding)
                }
            }
        }
    }
}

