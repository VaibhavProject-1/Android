package com.vaibhav.bookshelf.network

import com.vaibhav.bookshelf.model.BookSearchResponse
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

interface GoogleBooksApiService {
    @GET("volumes")
    suspend fun searchBooks(@Query("q") query: String): BookSearchResponse

    @GET("volumes/{volumeId}")
    suspend fun getBookById(@Path("volumeId") volumeId: String): BookSearchResponse
}
