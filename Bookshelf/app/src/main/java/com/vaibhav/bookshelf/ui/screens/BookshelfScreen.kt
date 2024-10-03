package com.vaibhav.bookshelf.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.vaibhav.bookshelf.BookshelfTopBar
import com.vaibhav.bookshelf.model.Book
import com.vaibhav.bookshelf.ui.screens.components.BookItem
import kotlinx.coroutines.launch

@Composable
fun BookshelfScreen(
    viewModel: BookshelfViewModel = hiltViewModel(),
    modifier: Modifier = Modifier
) {
    val uiState = viewModel.uiState.collectAsState().value
    val coroutineScope = rememberCoroutineScope()

    // Track the search query
    val searchQuery = remember { mutableStateOf("books") } // Default to "books"

    Column(
        modifier = modifier.fillMaxSize()
    ) {
        // Move the TopAppBar above the search bar
        BookshelfTopBar()

        // Search bar is below the TopAppBar
        SearchTopBar(onSearch = { query ->
            searchQuery.value = query
            coroutineScope.launch {
                viewModel.fetchBooks(query) // Fetch based on query
            }
        })

        // Show the book grid or other states
        when (uiState) {
            is BookshelfUiState.Loading -> LoadingScreen()
            is BookshelfUiState.Error -> ErrorScreen()
            is BookshelfUiState.Success -> BookGrid(books = uiState.books)
        }
    }
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchTopBar(onSearch: (String) -> Unit) {
    val searchQuery = remember { mutableStateOf("") }

    OutlinedTextField(
        value = searchQuery.value,
        onValueChange = { query ->
            searchQuery.value = query
            if (query.isNotBlank()) {
                onSearch(query)
            }
        },
        label = { Text("Search Books") },
        modifier = Modifier
            .fillMaxWidth() // Take full width
            .padding(8.dp), // Padding around the search bar
        textStyle = TextStyle(fontSize = 16.sp) // Adjust text size if needed
    )
}

@Composable
fun BookGrid(books: List<Book>, modifier: Modifier = Modifier) {
    LazyVerticalGrid(
        columns = GridCells.Fixed(2), // Two columns
        modifier = modifier.fillMaxSize()
    ) {
        items(books) { book ->
            BookItem(book) // Render each book item
        }
    }
}


@Composable
fun LoadingScreen() {
    CircularProgressIndicator(modifier = Modifier.fillMaxSize(), color = Color.Blue)
}

@Composable
fun ErrorScreen() {
    Text(text = "Error Loading Data", color = Color.Red, modifier = Modifier.fillMaxSize())
}