package com.example.busschedule

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.busschedule.data.BusScheduleDao

class BusScheduleViewModel(private val busScheduleDao: BusScheduleDao) : ViewModel() {

    // Fetch the full bus schedule from the database
    fun getFullSchedule() = busScheduleDao.getAllBusSchedules()

    // Fetch the bus schedule for a specific stop
    fun getScheduleFor(stopName: String) = busScheduleDao.getScheduleForStop(stopName)

    companion object {
        fun provideFactory(busScheduleDao: BusScheduleDao): ViewModelProvider.Factory {
            return object : ViewModelProvider.Factory {
                @Suppress("UNCHECKED_CAST")
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    if (modelClass.isAssignableFrom(BusScheduleViewModel::class.java)) {
                        return BusScheduleViewModel(busScheduleDao) as T
                    }
                    throw IllegalArgumentException("Unknown ViewModel class")
                }
            }
        }
    }
}
