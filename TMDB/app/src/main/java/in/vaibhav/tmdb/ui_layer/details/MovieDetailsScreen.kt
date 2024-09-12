package `in`.vaibhav.tmdb.ui_layer.details

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import coil.compose.AsyncImage
import `in`.vaibhav.tmdb.model.details.MovieDetails


@Composable
fun MovieDetailsScreen(modifier: Modifier = Modifier, viewModel: MovieDetailsViewModel = hiltViewModel(), movieId: String ) {
    val result = viewModel.movieDetails.value

    when {
        result.isLoading -> {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        }
        result.error.isNotBlank() -> {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text(text = result.error)
            }
        }
        result.data != null -> {
            MovieDetailsShow(movie = result.data!!)
        }
        else -> {
            // Handle unexpected state, if needed
        }
    }
}

@Composable
fun MovieDetailsShow(movie: MovieDetails) {
    Column(modifier = Modifier.padding(horizontal = 12.dp)) {
        AsyncImage(
            model = "https://image.tmdb.org/t/p/w500/${movie.poster_path}",
            contentDescription = null,
            modifier = Modifier
                .fillMaxWidth()
                .height(400.dp),
            contentScale = ContentScale.FillBounds
        )
        Spacer(modifier = Modifier.height(12.dp))
        Text(text = movie.original_title, style = MaterialTheme.typography.displayLarge)
        Spacer(modifier = Modifier.height(4.dp))
        Text(text = movie.tagline, style = MaterialTheme.typography.displaySmall)
        Spacer(modifier = Modifier.height(8.dp))
        Text(text = movie.overview, style = MaterialTheme.typography.titleMedium)
    }
}
