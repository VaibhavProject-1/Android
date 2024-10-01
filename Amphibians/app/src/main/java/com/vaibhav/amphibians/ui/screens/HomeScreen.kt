import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.vaibhav.amphibians.R
import com.vaibhav.amphibians.model.Amphibian
import com.vaibhav.amphibians.ui.AmphibianUiState
import com.vaibhav.amphibians.ui.AmphibianViewModel
import com.vaibhav.amphibians.ui.screens.AmphibianCard

@Composable
fun HomeScreen(
    modifier: Modifier = Modifier,
    viewModel: AmphibianViewModel = hiltViewModel()
) {
    val uiState = viewModel.amphibianUiState

    when (uiState) {
        is AmphibianUiState.Loading -> LoadingScreen()
        is AmphibianUiState.Success -> AmphibianList(uiState.amphibians)
        is AmphibianUiState.Error -> ErrorScreen()
    }
}

/**
 * Display a loading screen with an image
 */
@Composable
fun LoadingScreen(modifier: Modifier = Modifier) {
    Image(
        painter = painterResource(id = R.drawable.loading_img),
        contentDescription = "Loading Image",
        modifier = modifier
            .fillMaxSize()
            .wrapContentSize(Alignment.Center)
    )
}

/**
 * Display an error screen with an image
 */
@Composable
fun ErrorScreen(modifier: Modifier = Modifier) {
    Image(
        painter = painterResource(id = R.drawable.ic_broken_image),
        contentDescription = "Error Image",
        modifier = modifier
            .fillMaxSize()
            .wrapContentSize(Alignment.Center)
    )
}

/**
 * Display a list of Amphibians using LazyColumn
 */
@Composable
fun AmphibianList(amphibians: List<Amphibian>, modifier: Modifier = Modifier) {
    Column {
        Text(text = "Amphibians", fontWeight = FontWeight.Bold, fontSize = 38.sp)
        LazyColumn(modifier = modifier.fillMaxSize()) {
            items(amphibians) { amphibian ->
                AmphibianCard(amphibian = amphibian)
            }
        }
    }

}

/**
 * AmphibianCard to display individual amphibian details.
 */

@Preview(showBackground = true)
@Composable
fun HomeScreenPreview() {
    HomeScreen(modifier = Modifier)
}
