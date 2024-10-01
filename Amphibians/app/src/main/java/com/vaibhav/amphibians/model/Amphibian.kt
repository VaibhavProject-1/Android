package com.vaibhav.amphibians.model

import kotlinx.serialization.Serializable

@Serializable
data class Amphibian(
    val name: String,
    val type: String,
    val description: String,
    val img_src: String
)