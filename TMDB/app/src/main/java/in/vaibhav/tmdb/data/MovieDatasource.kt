package `in`.vaibhav.tmdb.data

import `in`.vaibhav.tmdb.network.ApiService

class MovieDatasource(private val apiService: ApiService) {

    suspend fun getMovieList() = apiService.getMovieList(apiKey = "0cf3976ed55d8d58a4d5ee13ba843844")
}