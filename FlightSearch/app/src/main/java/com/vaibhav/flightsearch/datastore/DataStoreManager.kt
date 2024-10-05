package com.vaibhav.flightsearch.datastore

import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

// Create the DataStore extension property for the Context
val Context.dataStore by preferencesDataStore(name = "flight_search_prefs")

class DataStoreManager(private val context: Context) {

    companion object {
        private val SEARCH_QUERY_KEY = stringPreferencesKey("search_query")
        private val FAVORITES_KEY = stringSetPreferencesKey("favorites")
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

    // Save favorite route
    suspend fun saveFavoriteRoute(route: String) {
        context.dataStore.edit { preferences ->
            val currentFavorites = preferences[FAVORITES_KEY] ?: emptySet()
            preferences[FAVORITES_KEY] = currentFavorites + route
        }
    }

    // Remove favorite route
    suspend fun removeFavoriteRoute(route: String) {
        context.dataStore.edit { preferences ->
            val currentFavorites = preferences[FAVORITES_KEY] ?: emptySet()
            preferences[FAVORITES_KEY] = currentFavorites - route
        }
    }

    // Get all favorite routes
    val favoriteRoutes: Flow<Set<String>> = context.dataStore.data.map { preferences ->
        preferences[FAVORITES_KEY] ?: emptySet()
    }
}
