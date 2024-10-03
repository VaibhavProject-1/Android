package com.vaibhav.bookshelf.di

import com.vaibhav.bookshelf.network.GoogleBooksApiService
import com.vaibhav.bookshelf.repository.BooksRepository
import com.vaibhav.bookshelf.repository.DefaultBooksRepository
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
    fun provideGoogleBooksApiService(): GoogleBooksApiService {
        return Retrofit.Builder()
            .baseUrl("https://www.googleapis.com/books/v1/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(GoogleBooksApiService::class.java)
    }

    @Provides
    @Singleton
    fun provideBooksRepository(apiService: GoogleBooksApiService): BooksRepository {
        return DefaultBooksRepository(apiService)
    }
}
