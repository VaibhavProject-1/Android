package com.plcoding.cryptotracker.crypto.data.networking.dto

import kotlinx.serialization.Serializable
import kotlinx.serialization.Serializer

@Serializable
data class CoinDto(
    val id: String,
    val rank: Int,
    val name: String,
    val symbol: String,
    val marketCapUsd: Double,
    val priceUsd: Double,
    val changePercent24Hr: Double,
)
