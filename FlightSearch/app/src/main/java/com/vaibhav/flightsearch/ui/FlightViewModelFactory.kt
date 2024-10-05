package com.vaibhav.flightsearch.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.vaibhav.flightsearch.data.FlightDao

class FlightViewModelFactory(private val flightDao: FlightDao) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(FlightViewModel::class.java)) {
            return FlightViewModel(flightDao) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
