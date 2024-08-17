package `in`.vaibhav.tmdb.ui_layer.details

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import `in`.vaibhav.tmdb.common.Resource
import `in`.vaibhav.tmdb.data.MovieRepository
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MovieDetailsViewModel @Inject constructor(private val movieRepository: MovieRepository, savedStateHandle: SavedStateHandle) : ViewModel() {

    val movieDetails = mutableStateOf(MovieDetailsStateHolder())

    init {

        movieDetails.value = MovieDetailsStateHolder(isLoading = true)

        viewModelScope.launch {
            savedStateHandle.getStateFlow("id", "0").collectLatest {
                getMovieDetails(it)
            }
        }


    }

    fun getMovieDetails(id: String) = viewModelScope.launch {


        val result = movieRepository.getMovieDetails(id)

        when(result){
            is Resource.Error ->{
                movieDetails.value = MovieDetailsStateHolder(error = result.message.toString())
            }
            is Resource.Success ->{
                movieDetails.value = MovieDetailsStateHolder(data = result.data)
            }

            is Resource.Loading -> {
                TODO()
            }
            else ->{

            }
        }
    }
}

