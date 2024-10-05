package com.vaibhav.flightsearch.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.vaibhav.flightsearch.data.FlightDao
import com.vaibhav.flightsearch.datastore.DataStoreManager

class FlightViewModelFactory(
    private val flightDao: FlightDao,
    private val dataStoreManager: DataStoreManager // Add this parameter
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(FlightViewModel::class.java)) {
            return FlightViewModel(flightDao, dataStoreManager) as T // Pass dataStoreManager
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
