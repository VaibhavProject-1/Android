package `in`.vaibhav.tmdb.ui_layer

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import `in`.vaibhav.tmdb.common.Resource
import `in`.vaibhav.tmdb.data.MovieRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject



@HiltViewModel
class MovieViewModel @Inject constructor (private val movieRepository: MovieRepository): ViewModel() {

    var movieList = mutableStateOf(MovieStateHolder())

    init {
        movieList.value = MovieStateHolder(isLoading = true)
        getMovieList()
    }

    private fun getMovieList() = viewModelScope.launch(Dispatchers.IO){

        when(val result = movieRepository.getMovieList()){
            is Resource.Success ->{
                movieList.value = MovieStateHolder(data = result.data)
            }
            is Resource.Error ->{
                movieList.value = MovieStateHolder(error = result.message.toString())
            }
            else ->{

            }
        }
    }
}