package com.vaibhav.flightsearch

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.vaibhav.flightsearch.data.FlightDatabase
import com.vaibhav.flightsearch.datastore.DataStoreManager
import com.vaibhav.flightsearch.ui.FlightSearchScreen
import com.vaibhav.flightsearch.ui.theme.FlightSearchTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Get the FlightDao instance from the database
        val flightDao = FlightDatabase.getDatabase(applicationContext).flightDao()

        // Create an instance of DataStoreManager
        val dataStoreManager = DataStoreManager(applicationContext)

        setContent {
            FlightSearchTheme {
                // Pass both flightDao and dataStoreManager to the FlightSearchScreen
                FlightSearchScreen(
                    flightDao = flightDao,
                    dataStoreManager = dataStoreManager
                )
            }
        }
    }
}
