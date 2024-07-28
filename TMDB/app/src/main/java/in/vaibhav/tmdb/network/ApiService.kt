package `in`.vaibhav.tmdb.network

import `in`.vaibhav.tmdb.model.MovieListResponse
import retrofit2.http.GET
import retrofit2.http.Query

interface ApiService {

    // https://api.themoviedb.org/3/movie/popular?api_key=%3Capi_key%3E

    // https://api.themoviedb.org/3/movie/76600?api_key=

    @GET("3/movie/popular")
    suspend fun getMovieList(
        @Query("api_key") apiKey: String
    ): MovieListResponse
}