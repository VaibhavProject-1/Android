package com.vaibhav.bookshelf.repository

import com.vaibhav.bookshelf.model.Book

interface BooksRepository {
    suspend fun searchBooks(query: String): List<Book>
}
