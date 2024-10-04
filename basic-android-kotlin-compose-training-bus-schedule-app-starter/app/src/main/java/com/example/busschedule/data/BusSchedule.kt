package com.example.busschedule.data

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "Schedule")
data class BusSchedule(
    @PrimaryKey(autoGenerate = true) val id: Int,

    @ColumnInfo(name = "stop_name") // Ensures the column name in the DB matches
    val stopName: String,

    @ColumnInfo(name = "arrival_time") // Ensure column name matches DB
    val arrivalTime: Long
)
