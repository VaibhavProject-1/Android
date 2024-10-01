package com.vaibhav.amphibians.di


import com.vaibhav.amphibians.network.AmphibianApiService
import com.vaibhav.amphibians.data.AmphibianRepository
import com.vaibhav.amphibians.data.AmphibianRepositoryImpl
import com.vaibhav.amphibians.network.AmphibianApi
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideApiService(): AmphibianApiService {
        return AmphibianApi.retrofitService
    }

    @Provides
    @Singleton
    fun provideRepository(apiService: AmphibianApiService): AmphibianRepository {
        return AmphibianRepositoryImpl(apiService)
    }
}
