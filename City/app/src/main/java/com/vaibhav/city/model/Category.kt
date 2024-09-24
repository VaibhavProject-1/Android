package com.vaibhav.city.model

import androidx.annotation.DrawableRes

data class Category(
    val id: Int,
    val name: String,
    @DrawableRes val imageResId: Int
)