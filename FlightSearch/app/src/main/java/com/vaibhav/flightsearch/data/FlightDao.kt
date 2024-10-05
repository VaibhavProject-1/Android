package com.vaibhav.flightsearch.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface FlightDao {

    // Query to search airports by IATA code or name
    @Query("SELECT * FROM airport WHERE iata_code LIKE :query OR name LIKE :query ORDER BY passengers DESC")
    fun searchAirports(query: String): Flow<List<Airport>>

    // Query to get flights from a specific departure airport
    @Query("SELECT * FROM airport WHERE id != :departureCode")
    fun getFlightsFromAirport(departureCode: String): Flow<List<Airport>>

    // Query to get all favorite routes
    @Query("SELECT * FROM favorite")
    fun getFavoriteRoutes(): Flow<List<Favorite>>

    // Insert a favorite route
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertFavoriteRoute(favorite: Favorite)

    // Delete a favorite route by departure and destination code
    @Query("DELETE FROM favorite WHERE departure_code = :departureCode AND destination_code = :destinationCode")
    suspend fun deleteFavoriteRoute(departureCode: String, destinationCode: String)
}
