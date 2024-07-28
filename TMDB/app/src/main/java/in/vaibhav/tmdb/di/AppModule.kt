package `in`.vaibhav.tmdb.di

import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import `in`.vaibhav.tmdb.data.MovieDatasource
import `in`.vaibhav.tmdb.data.MovieRepository
import `in`.vaibhav.tmdb.network.ApiService
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


@InstallIn(SingletonComponent::class)
@Module
object AppModule {

    @Provides
    fun provideRetrofit(): Retrofit{
        return Retrofit.Builder().baseUrl("https://api.themoviedb.org/")
            .addConverterFactory(GsonConverterFactory.create()).build()
    }

    @Provides
    fun provideApiService(retrofit: Retrofit): ApiService{
        return retrofit.create(ApiService::class.java)
    }

    @Provides
    fun provideDataSource(apiService: ApiService): MovieDatasource{
        return MovieDatasource(apiService)
    }

    @Provides
    fun provideMovieRepo(datasource: MovieDatasource): MovieRepository{
        return MovieRepository(datasource)
    }
}