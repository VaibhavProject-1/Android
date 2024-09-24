package com.vaibhav.city.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class Recommendation(
    val id: Int,
    val name: String,
    val description: String,
    val imageResId: Int
) : Parcelable
