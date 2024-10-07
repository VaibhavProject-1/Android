package com.vaibhav.usermanagement.utils

import android.content.Context
import androidx.room.Room
import com.vaibhav.usermanagement.data.AppDatabase

object DatabaseProvider {
    @Volatile
    private var INSTANCE: AppDatabase? = null

    fun getDatabase(context: Context): AppDatabase {
        return INSTANCE ?: synchronized(this) {
            val instance = Room.databaseBuilder(
                context.applicationContext,
                AppDatabase::class.java,
                "user_database"
            ).build()
            INSTANCE = instance
            instance
        }
    }
}
