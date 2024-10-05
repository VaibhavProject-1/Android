package com.vaibhav.flightsearch.ui

import android.widget.Toast
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.outlined.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vaibhav.flightsearch.data.Airport
import com.vaibhav.flightsearch.data.Favorite
import com.vaibhav.flightsearch.data.FlightDao
import com.vaibhav.flightsearch.datastore.DataStoreManager

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FlightSearchScreen(flightDao: FlightDao, dataStoreManager: DataStoreManager) {
    val viewModel: FlightViewModel = viewModel(factory = FlightViewModelFactory(flightDao, dataStoreManager))
    var query by remember { mutableStateOf("") }
    val airports by viewModel.searchAirports(query).collectAsState(emptyList())
    val favorites by viewModel.favoriteRoutes.collectAsState(emptyList()) // List<Favorite>
    val context = LocalContext.current // Context for Toast

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
                    FavoriteRoutesList(favorites) // Pass List<Favorite>
                } else {
                    Text("Search Results", style = MaterialTheme.typography.titleLarge)
                    AirportsList(
                        airports = airports,
                        onAirportClick = { /* Handle airport selection */ },
                        onFavoriteClick = { airport ->
                            val isFavorite = favorites.any { it.departureCode == airport.iataCode }
                            if (isFavorite) {
                                viewModel.deleteFavoriteRoute(airport.iataCode, airport.name)
                                Toast.makeText(context, "${airport.name} removed from favorites", Toast.LENGTH_SHORT).show()
                            } else {
                                viewModel.saveFavoriteRoute(airport.iataCode, airport.name)
                                Toast.makeText(context, "${airport.name} added to favorites", Toast.LENGTH_SHORT).show()
                            }
                        },
                        favorites = favorites
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
    favorites: List<Favorite>
) {
    LazyColumn(modifier = Modifier.fillMaxSize()) {
        items(airports) { airport ->
            val isFavorite = favorites.any { it.departureCode == airport.iataCode }

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
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column {
                        Text("${airport.iataCode} - ${airport.name}", style = MaterialTheme.typography.bodyLarge)
                        Text("${airport.passengers} passengers/year", style = MaterialTheme.typography.bodyMedium)
                    }

                    IconButton(onClick = { onFavoriteClick(airport) }) {
                        Icon(
                            imageVector = if (isFavorite) Icons.Filled.Star else Icons.Outlined.Star,
                            contentDescription = if (isFavorite) "Remove from favorites" else "Add to favorites"
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun FavoriteRoutesList(favorites: List<Favorite>, modifier: Modifier = Modifier) {
    LazyColumn(modifier = modifier.fillMaxSize()) {
        items(favorites) { favorite ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp)
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("${favorite.departureCode} -> ${favorite.destinationCode}")
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