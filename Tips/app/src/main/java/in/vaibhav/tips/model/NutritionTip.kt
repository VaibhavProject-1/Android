package `in`.vaibhav.tips.model

import android.annotation.SuppressLint
import androidx.annotation.StringRes

@SuppressLint("SupportAnnotationUsage")
data class NutritionTip(
    @StringRes val title: String,
    @StringRes val description: String,
    val imageRes: Int
)
