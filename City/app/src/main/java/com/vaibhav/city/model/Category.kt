package com.vaibhav.city.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class Category(
    val id: Int,
    val name: String,
    val imageResId: Int
) : Parcelable
