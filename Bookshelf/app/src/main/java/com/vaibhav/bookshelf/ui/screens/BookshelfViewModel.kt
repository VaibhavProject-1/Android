package com.vaibhav.bookshelf.ui.screens

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.bookshelf.model.Book
import com.vaibhav.bookshelf.repository.BooksRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

sealed class BookshelfUiState {
    data object Loading : BookshelfUiState()
    data class Success(val books: List<Book>) : BookshelfUiState()
    data object Error : BookshelfUiState()
}

@HiltViewModel
class BookshelfViewModel @Inject constructor(
    private val booksRepository: BooksRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<BookshelfUiState>(BookshelfUiState.Loading)
    val uiState: StateFlow<BookshelfUiState> = _uiState

    init {
        fetchBooks("books") // Default query to load a broad set of books
    }

    // Function to fetch books dynamically
    fun fetchBooks(query: String) {
        _uiState.value = BookshelfUiState.Loading
        viewModelScope.launch {
            try {
                val books = booksRepository.searchBooks(query)
                _uiState.value = BookshelfUiState.Success(books)
            } catch (e: Exception) {
                _uiState.value = BookshelfUiState.Error
            }
        }
    }
}
