package com.vaibhav.amphibians.network

import com.vaibhav.amphibians.model.Amphibian
import retrofit2.http.GET

interface AmphibianApiService {
    @GET("amphibians")
    suspend fun getAmphibians(): List<Amphibian>
}

object AmphibianApi {
    private const val BASE_URL = "https://android-kotlin-fun-mars-server.appspot.com/"

    val retrofitService: AmphibianApiService by lazy {
        retrofit2.Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(retrofit2.converter.gson.GsonConverterFactory.create())
            .build()
            .create(AmphibianApiService::class.java)
    }
}