package com.vaibhav.flightsearch.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.flightsearch.data.Airport
import com.vaibhav.flightsearch.data.Favorite
import com.vaibhav.flightsearch.data.FlightDao
import com.vaibhav.flightsearch.datastore.DataStoreManager
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch

class FlightViewModel(
    private val flightDao: FlightDao,
    private val dataStoreManager: DataStoreManager
) : ViewModel() {

    // Search for airports by query (either IATA code or name)
    fun searchAirports(query: String): Flow<List<Airport>> {
        return flightDao.searchAirports("%$query%")
    }

    // Get flights that depart from a specific airport
    fun getFlightsFromAirport(departureCode: String): Flow<List<Airport>> {
        return flightDao.getFlightsFromAirport(departureCode)
    }



    // Load favorite routes and sync them with DataStore on startup
    init {
        viewModelScope.launch {
            dataStoreManager.favoriteRoutes.collect { savedFavorites ->
                savedFavorites.forEach { route ->
                    // Parse the route and save it into Room if it's not already present
                    val (departureCode, destinationCode) = route.split(" -> ")
                    val favorite = Favorite(0, departureCode, destinationCode)
                    flightDao.insertFavoriteRoute(favorite)
                }
            }
        }
    }



//    // Get all favorite routes from Room
//    fun getFavoriteRoutes(): Flow<List<Favorite>> {
//        return flightDao.getFavoriteRoutes()
//    }

    // Get favorite routes saved by the user (from Room)
    val favoriteRoutesFromDb: Flow<List<Favorite>> = flightDao.getFavoriteRoutes()

    // Get favorite routes saved by the user (from Room or DataStore)
    val favoriteRoutes: Flow<Set<String>> = dataStoreManager.favoriteRoutes

    // Save a favorite route into DataStore
    fun saveFavoriteRoute(departureCode: String, destinationCode: String) {
        viewModelScope.launch {
            dataStoreManager.saveFavoriteRoute("$departureCode -> $destinationCode")
        }
    }

    // Delete a favorite route from DataStore
    fun deleteFavoriteRoute(departureCode: String, destinationCode: String) {
        viewModelScope.launch {
            dataStoreManager.removeFavoriteRoute("$departureCode -> $destinationCode")
        }
    }

}
