package com.vaibhav.amphibians.data

import com.vaibhav.amphibians.network.AmphibianApiService
import com.vaibhav.amphibians.model.Amphibian


interface AmphibianRepository {
    suspend fun getAmphibians(): List<Amphibian>
}

class AmphibianRepositoryImpl(private val apiService: AmphibianApiService) : AmphibianRepository {
    override suspend fun getAmphibians(): List<Amphibian> {
        return apiService.getAmphibians()
    }
}