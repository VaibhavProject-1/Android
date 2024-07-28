package `in`.vaibhav.tmdb.ui_layer

import `in`.vaibhav.tmdb.model.Movie

data class MovieStateHolder(
    val isLoading: Boolean = false,
    val data: List<Movie>? = null,
    val error: String = "",
)
