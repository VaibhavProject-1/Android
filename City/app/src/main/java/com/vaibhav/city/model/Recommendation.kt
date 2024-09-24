package com.vaibhav.city.model

import androidx.annotation.DrawableRes

data class Recommendation(
    val id: Int,
    val name: String,
    val description: String,
    @DrawableRes val imageResId: Int
)