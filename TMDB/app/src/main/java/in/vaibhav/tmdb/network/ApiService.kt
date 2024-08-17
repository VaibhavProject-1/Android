package `in`.vaibhav.tmdb.network

import `in`.vaibhav.tmdb.model.MovieListResponse
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import vaibhav.tmdb.model.details.MovieDetails

interface ApiService {

    // https://api.themoviedb.org/3/movie/popular?api_key=%3Capi_key%3E

    // https://api.themoviedb.org/3/movie/76600?api_key=

    @GET("3/movie/popular")
    suspend fun getMovieList(
        @Query("api_key") apiKey: String
    ): MovieListResponse

    @GET("3/movie/{id}")
    suspend fun getMovieDetails(
        @Path("id") id: String,
        @Query("api_key") apiKey: String,
    ): MovieDetails
}