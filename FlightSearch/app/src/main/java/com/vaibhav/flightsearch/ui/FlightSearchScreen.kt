package com.vaibhav.flightsearch.ui

import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vaibhav.flightsearch.data.Airport
import com.vaibhav.flightsearch.data.FlightDao
import com.vaibhav.flightsearch.datastore.DataStoreManager

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FlightSearchScreen(flightDao: FlightDao, dataStoreManager: DataStoreManager) {
    val viewModel: FlightViewModel = viewModel(factory = FlightViewModelFactory(flightDao, dataStoreManager))
    var query by remember { mutableStateOf("") }
    val airports by viewModel.searchAirports(query).collectAsState(emptyList())
    val favoriteRoutes by viewModel.favoriteRoutes.collectAsState(emptySet()) // Collect favorites as Set<String>

    val favoriteRouteStrings = favoriteRoutes.toList()

    val context = LocalContext.current // Context for Toast messages

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Flight Search") },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors()
            )
        },
        content = { padding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp)
            ) {
                TextField(
                    value = query,
                    onValueChange = { query = it },
                    label = { Text("Search Airport") },
                    modifier = Modifier.fillMaxWidth(),
                )

                Spacer(modifier = Modifier.height(16.dp))

                if (query.isEmpty()) {
                    Text("Favorite Routes", style = MaterialTheme.typography.titleLarge)
                    FavoriteRoutesList(
                        favorites = favoriteRouteStrings,
                        onRemoveFavoriteClick = { favorite ->
                            // Parse the IATA code from the favorite string
                            val (iataCode, name) = favorite.split(" -> ")
                            viewModel.deleteFavoriteRoute(iataCode, name)
                            Toast.makeText(context, "$name removed from favorites", Toast.LENGTH_SHORT).show()
                        }
                    )
                } else {
                    Text("Search Results", style = MaterialTheme.typography.titleLarge)
                    AirportsList(
                        airports = airports,
                        onAirportClick = { /* Handle airport selection */ },
                        onFavoriteClick = { airport ->
                            val isFavorite = favoriteRouteStrings.any { it.startsWith(airport.iataCode) }
                            if (isFavorite) {
                                viewModel.deleteFavoriteRoute(airport.iataCode, airport.name)
                                Toast.makeText(context, "${airport.name} removed from favorites", Toast.LENGTH_SHORT).show()
                            } else {
                                viewModel.saveFavoriteRoute(airport.iataCode, airport.name)
                                Toast.makeText(context, "${airport.name} added to favorites", Toast.LENGTH_SHORT).show()
                            }
                        },
                        favorites = favoriteRouteStrings // Pass the converted List<String>
                    )
                }
            }
        }
    )
}





@Composable
fun AirportsList(
    airports: List<Airport>,
    onAirportClick: (Airport) -> Unit,
    onFavoriteClick: (Airport) -> Unit,
    favorites: List<String> // List of favorite airport codes
) {
    LazyColumn(modifier = Modifier.fillMaxSize()) {
        items(airports) { airport ->
            val airportIataCode = airport.iataCode.trim().lowercase()
            val isFavorite = favorites.any { favorite ->
                val favoriteIataCode = favorite.split(" -> ")[0].trim().lowercase()
                favoriteIataCode == airportIataCode
            }

            // Log for debugging
            Log.d("AirportsList", "Airport: ${airport.iataCode}, isFavorite: $isFavorite")

            Card(
                onClick = { onAirportClick(airport) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically // Ensure center alignment
                ) {
                    Column(
                        modifier = Modifier.weight(1f),
                        verticalArrangement = Arrangement.Center
                    ) {
                        Text("${airport.iataCode} - ${airport.name}", style = MaterialTheme.typography.bodyLarge)
                        Text("${airport.passengers} passengers/year", style = MaterialTheme.typography.bodyMedium)
                    }

                    // Spacer to ensure consistent padding between text and star
                    Spacer(modifier = Modifier.width(16.dp))

                    // Favorite Icon (Star) with fixed size for consistency
                    IconButton(onClick = { onFavoriteClick(airport) }) {
                        Icon(
                            imageVector = if (isFavorite) Icons.Filled.Favorite else Icons.Default.FavoriteBorder,
                            contentDescription = if (isFavorite) "Remove from favorites" else "Add to favorites",
                            modifier = Modifier.size(24.dp)
                        )
                    }
                }
            }
        }
    }
}







@Composable
fun FavoriteRoutesList(
    favorites: List<String>,
    onRemoveFavoriteClick: (String) -> Unit, // Pass a callback to remove the favorite
    modifier: Modifier = Modifier
) {
    LazyColumn(modifier = modifier.fillMaxSize()) {
        items(favorites) { favorite ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Text for the favorite route
                    Text(favorite)

                    // Favorite Icon to remove the route from favorites
                    IconButton(onClick = { onRemoveFavoriteClick(favorite) }) {
                        Icon(
                            imageVector = Icons.Filled.Favorite,
                            contentDescription = "Remove from favorites",
                            modifier = Modifier.size(24.dp)
                        )
                    }
                }
            }
        }
    }
}




@Preview(showBackground = true)
@Composable
fun FlightSearchScreenPreview() {
    // Provide sample data or mock flightDao for preview
}