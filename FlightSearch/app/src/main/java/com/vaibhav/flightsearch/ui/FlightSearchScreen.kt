package com.vaibhav.flightsearch.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vaibhav.flightsearch.data.Airport
import com.vaibhav.flightsearch.data.Favorite
import com.vaibhav.flightsearch.data.FlightDao

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FlightSearchScreen(flightDao: FlightDao) {
    val viewModel: FlightViewModel = viewModel(factory = FlightViewModelFactory(flightDao))
    var query by remember { mutableStateOf("") }
    val airports by viewModel.searchAirports(query).collectAsState(emptyList())
    val favorites by viewModel.getFavoriteRoutes().collectAsState(emptyList())
    var selectedAirport by remember { mutableStateOf<Airport?>(null) }

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
                    //colors = TextFieldDefaults.textFieldColors()
                )

                Spacer(modifier = Modifier.height(16.dp))

                if (query.isEmpty()) {
                    Text("Favorite Routes", style = MaterialTheme.typography.titleLarge)
                    FavoriteRoutesList(favorites)
                } else {
                    Text("Search Results", style = MaterialTheme.typography.titleLarge)
                    AirportsList(airports) { airport ->
                        selectedAirport = airport // Handle airport selection
                    }
                }

                selectedAirport?.let { airport ->
                    Text("Selected Airport: ${airport.name} (${airport.iataCode})")
                    Spacer(modifier = Modifier.height(8.dp))
                    Button(
                        onClick = {
                            selectedAirport = null // Clear selection
                        }
                    ) {
                        Text("Clear Selection")
                    }
                }
            }
        }
    )
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

@Composable
fun AirportsList(airports: List<Airport>, onAirportClick: (Airport) -> Unit) {
    LazyColumn(modifier = Modifier.fillMaxSize()) {
        items(airports) { airport ->
            Card(
                onClick = { onAirportClick(airport) }, // Handle flight click
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("${airport.iataCode} - ${airport.name}", style = MaterialTheme.typography.bodyLarge)
                    Text("${airport.passengers} passengers/year", style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun FlightSearchScreenPreview() {
    // Mock flightDao and provide sample data if necessary
}
