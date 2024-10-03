package com.vaibhav.bookshelf.repository

import com.vaibhav.bookshelf.model.Book
import com.vaibhav.bookshelf.network.GoogleBooksApiService
import javax.inject.Inject

class DefaultBooksRepository @Inject constructor(
    private val apiService: GoogleBooksApiService
) : BooksRepository {

    override suspend fun searchBooks(query: String): List<Book> {
        val response = apiService.searchBooks(query)
        return response.items.map {
            Book(
                id = it.id,
                title = it.volumeInfo.title,
                thumbnailUrl = it.volumeInfo.imageLinks?.thumbnail ?: ""
            )
        }
    }

    // Fetch the first book item from getBookById response
    suspend fun getBookDetails(volumeId: String): Book {
        val response = apiService.getBookById(volumeId)
        // Assuming the response contains an array with just one item
        val bookItem = response.items.first()
        return Book(
            id = bookItem.id,
            title = bookItem.volumeInfo.title,
            thumbnailUrl = bookItem.volumeInfo.imageLinks?.thumbnail ?: ""
        )
    }
}
