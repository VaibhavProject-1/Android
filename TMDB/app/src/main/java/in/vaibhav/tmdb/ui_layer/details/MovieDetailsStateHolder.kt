package `in`.vaibhav.tmdb.ui_layer.details

import `in`.vaibhav.tmdb.model.details.MovieDetails
import java.lang.Error

data class MovieDetailsStateHolder(
    val isLoading: Boolean = false,
    val data: MovieDetails? = null,
    val error: String = ""
)
