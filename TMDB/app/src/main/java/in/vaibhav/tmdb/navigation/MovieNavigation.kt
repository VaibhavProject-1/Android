package `in`.vaibhav.tmdb.navigation

import android.content.ContentValues.TAG
import android.util.Log
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import `in`.vaibhav.tmdb.ui_layer.MovieListScreen
import `in`.vaibhav.tmdb.ui_layer.details.MovieDetailsScreen

@Composable
fun MovieNavigation(modifier: Modifier = Modifier, navHostController: NavHostController, paddingValues: PaddingValues) {

    NavHost(navController = navHostController, startDestination = MovieNavigationItem.MovieList.route, modifier = modifier.padding(paddingValues) ){

        composable(MovieNavigationItem.MovieList.route){

            MovieListScreen(paddingValues = PaddingValues(4.dp), navController = navHostController)

        }

        composable(MovieNavigationItem.MovieDetails.route + "/{id}") {
            val id = it.arguments?.getString("id")
            Log.d("TAG", "MovieNavigation: ${id}")
            MovieDetailsScreen(movieId = id ?: "")
        }
    }
}