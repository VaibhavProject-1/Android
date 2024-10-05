package com.vaibhav.flightsearch.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.flightsearch.data.Airport
import com.vaibhav.flightsearch.data.FlightDao
import com.vaibhav.flightsearch.data.Favorite
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

class FlightViewModel(private val flightDao: FlightDao) : ViewModel() {

    // Search for airports by query (either IATA code or name)
    fun searchAirports(query: String): Flow<List<Airport>> {
        return flightDao.searchAirports("%$query%")
    }

    // Get flights that depart from a specific airport
    fun getFlightsFromAirport(departureCode: String): Flow<List<Airport>> {
        return flightDao.getFlightsFromAirport(departureCode)
    }

    // Get favorite routes saved by the user
    fun getFavoriteRoutes(): Flow<List<Favorite>> {
        return flightDao.getFavoriteRoutes()
    }

    // Save a favorite route
    fun saveFavoriteRoute(departureCode: String, destinationCode: String) {
        viewModelScope.launch {
            flightDao.insertFavoriteRoute(Favorite(0, departureCode, destinationCode))
        }
    }

    // Delete a favorite route by its ID
    fun deleteFavoriteRoute(id: Int) {
        viewModelScope.launch {
            flightDao.deleteFavoriteRoute(id)
        }
    }
}
