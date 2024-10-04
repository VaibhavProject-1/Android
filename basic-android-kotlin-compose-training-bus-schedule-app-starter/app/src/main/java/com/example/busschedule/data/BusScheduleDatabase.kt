package com.example.busschedule.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [BusSchedule::class], version = 1, exportSchema = false)
abstract class BusScheduleDatabase : RoomDatabase() {

    abstract fun busScheduleDao(): BusScheduleDao

    companion object {
        @Volatile
        private var INSTANCE: BusScheduleDatabase? = null

        fun getDatabase(context: Context): BusScheduleDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    BusScheduleDatabase::class.java,
                    "bus_schedule.db"
                )
                    .createFromAsset("database/bus_schedule.db") // Load prepopulated database from assets
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
