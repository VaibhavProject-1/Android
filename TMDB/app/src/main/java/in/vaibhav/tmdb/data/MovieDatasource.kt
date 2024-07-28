package `in`.vaibhav.tmdb.data

import `in`.vaibhav.tmdb.network.ApiService

class MovieDatasource(private val apiService: ApiService) {

    suspend fun getMovieList() = apiService.getMovieList(apiKey = "")
}