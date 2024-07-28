package `in`.vaibhav.tmdb.data

import `in`.vaibhav.tmdb.common.Resource
import `in`.vaibhav.tmdb.model.Movie

class MovieRepository(private val movieDatasource: MovieDatasource) {

    suspend fun getMovieList(): Resource<List<Movie>>{

        return try {
            Resource.Success(data = movieDatasource.getMovieList().results)
        }catch (e: Exception){
            Resource.Error(message = e.message.toString())
        }
    }
}