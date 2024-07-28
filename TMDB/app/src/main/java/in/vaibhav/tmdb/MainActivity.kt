package `in`.vaibhav.tmdb

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Scaffold
import androidx.compose.ui.Modifier
import dagger.hilt.android.AndroidEntryPoint
import `in`.vaibhav.tmdb.ui.theme.TMDBTheme
import `in`.vaibhav.tmdb.ui_layer.MovieListScreen


@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TMDBTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MovieListScreen(paddingValues = innerPadding)
                }
            }
        }
    }
}
