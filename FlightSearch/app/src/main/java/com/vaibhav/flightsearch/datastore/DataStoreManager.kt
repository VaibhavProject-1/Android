package com.vaibhav.flightsearch.datastore

import android.content.Context
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore by preferencesDataStore("flight_search_prefs")

class DataStoreManager(private val context: Context) {

    companion object {
        private val SEARCH_QUERY_KEY = stringPreferencesKey("search_query")
    }

    // Save the search query to DataStore
    suspend fun saveSearchQuery(query: String) {
        context.dataStore.edit { preferences ->
            preferences[SEARCH_QUERY_KEY] = query
        }
    }

    // Retrieve the search query from DataStore
    val searchQuery: Flow<String?> = context.dataStore.data.map { preferences ->
        preferences[SEARCH_QUERY_KEY]
    }
}
