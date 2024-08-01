//package `in`.vaibhav.tmdb.di
//
//import dagger.Module
//import dagger.Provides
//import dagger.hilt.InstallIn
//import dagger.hilt.components.SingletonComponent
//import `in`.vaibhav.tmdb.data.MovieDatasource
//import `in`.vaibhav.tmdb.data.MovieRepository
//import `in`.vaibhav.tmdb.network.ApiService
//import retrofit2.Retrofit
//import retrofit2.converter.gson.GsonConverterFactory
//
//
//@InstallIn(SingletonComponent::class)
//@Module
//object AppModule {
//
//    @Provides
//    fun provideRetrofit(): Retrofit{
//        return Retrofit.Builder().baseUrl("https://api.themoviedb.org/")
//            .addConverterFactory(GsonConverterFactory.create()).build()
//    }
//
//    @Provides
//    fun provideApiService(retrofit: Retrofit): ApiService{
//        return retrofit.create(ApiService::class.java)
//    }
//
//    @Provides
//    fun provideDataSource(apiService: ApiService): MovieDatasource{
//        return MovieDatasource(apiService)
//    }
//
//    @Provides
//    fun provideMovieRepo(datasource: MovieDatasource): MovieRepository{
//        return MovieRepository(datasource)
//    }
//}

package `in`.vaibhav.tmdb.di

import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import `in`.vaibhav.tmdb.data.MovieDatasource
import `in`.vaibhav.tmdb.data.MovieRepository
import `in`.vaibhav.tmdb.network.ApiService
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

@InstallIn(SingletonComponent::class)
@Module
object AppModule {

    @Provides
    fun provideOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(15, TimeUnit.SECONDS)
            .build()
    }

    @Provides
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://api.themoviedb.org/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    fun provideApiService(retrofit: Retrofit): ApiService {
        return retrofit.create(ApiService::class.java)
    }

    @Provides
    fun provideDataSource(apiService: ApiService): MovieDatasource {
        return MovieDatasource(apiService)
    }

    @Provides
    fun provideMovieRepo(datasource: MovieDatasource): MovieRepository {
        return MovieRepository(datasource)
    }
}
