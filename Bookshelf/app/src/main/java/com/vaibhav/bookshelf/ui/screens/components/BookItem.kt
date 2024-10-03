package com.vaibhav.bookshelf.ui.screens.components

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.vaibhav.bookshelf.model.Book

@Composable
fun BookItem(book: Book) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
    ) {
        AsyncImage(
            model = book.thumbnailUrl.replace("http://", "https://"),
            contentDescription = book.title,
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(0.75f)
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(text = book.title, maxLines = 1)
    }
}

@Preview
@Composable
fun BookItemPreview() {
    BookItem(
        book = Book(
            id = "1",
            title = "Sample Book",
            thumbnailUrl = "https://books.google.com/sample.jpg"
        )
    )
}