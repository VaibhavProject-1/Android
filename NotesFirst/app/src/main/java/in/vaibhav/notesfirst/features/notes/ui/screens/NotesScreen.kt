package `in`.vaibhav.notesfirst.features.notes.ui.screens

import android.widget.NumberPicker.OnValueChangeListener
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.HistoricalChange
import androidx.compose.ui.unit.dp
import `in`.vaibhav.notesfirst.ui.theme.ContentColor


@Composable
fun NotesScreen(){

    Scaffold (
        floatingActionButton = {
            FloatingActionButton(onClick = {

            }, Modifier.background(Color.White)) {
                Icon(imageVector = Icons.Default.Add, contentDescription = "", tint = Color.Red)
            }
        }
    ){paddingValues ->

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {

            AppSearchBar(search = "") {
                
            }
            
        }

    }

}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppSearchBar(
    search: String,
    modifier: Modifier = Modifier,
    onValueChange: (String) -> Unit
){


    TextField(value = search, onValueChange = onValueChange,
        modifier = modifier
            .fillMaxWidth()
            .padding(20.dp),
        shape = RoundedCornerShape(10.dp),
        colors = TextFieldDefaults.colors(
            focusedContainerColor = ContentColor,
            unfocusedContainerColor = Color.White,
            disabledContainerColor = Color.White,
            unfocusedLabelColor = ContentColor
        )
        ,
        leadingIcon = {
            Icon(imageVector = Icons.Default.Search, contentDescription = "")
        }
        )
    
}