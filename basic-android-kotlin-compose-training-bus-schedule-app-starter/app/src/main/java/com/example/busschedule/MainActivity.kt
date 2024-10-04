package com.example.busschedule

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.ViewModelProvider
import com.example.busschedule.data.BusScheduleDatabase
import com.example.busschedule.ui.BusScheduleApp
import com.example.busschedule.ui.BusScheduleViewModel
import com.example.busschedule.ui.theme.BusScheduleTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Get the BusScheduleDao from the Room database
        val busScheduleDao = BusScheduleDatabase.getDatabase(applicationContext).busScheduleDao()

        // Create the ViewModel using the BusScheduleDao
        val viewModelFactory = BusScheduleViewModel.provideFactory(busScheduleDao)
        val viewModel = ViewModelProvider(this, viewModelFactory)[BusScheduleViewModel::class.java]

        setContent {
            BusScheduleTheme {
                BusScheduleApp(viewModel)
            }
        }
    }
}
