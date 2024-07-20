package `in`.vaibhav.notesfirst.features.notes.ui.screens

import android.app.AlertDialog
import android.widget.NumberPicker.OnValueChangeListener
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AlertDialogDefaults.shape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.R
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.HistoricalChange
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.Placeholder
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.vaibhav.notesfirst.data.model.NotesResponse
import `in`.vaibhav.notesfirst.ui.theme.Background
import `in`.vaibhav.notesfirst.ui.theme.ContentColor
import `in`.vaibhav.notesfirst.ui.theme.Red


@Composable
fun NotesScreen(){

    var search by remember { mutableStateOf("") }

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
                .background(Background)
        ) {

            AppSearchBar(search = search, onValueChange = {search = it}
            , modifier = Modifier.padding(start = 15.dp, end = 15.dp, top = 50.dp)
            )
                

            
        }

    }

}

@Composable
fun NotesEachRow(
    notesresponse: NotesResponse,
    modifier: Modifier = Modifier,
    onDelete: () -> Unit
){

    Box(modifier = Modifier
        .fillMaxWidth()
        .background(color = ContentColor, shape = RoundedCornerShape(10.dp))){

        Column(
            modifier = Modifier.padding(15.dp)
        ) {
            Row (modifier = Modifier.fillMaxWidth()) {
                Text(text = notesresponse.title, style = TextStyle(
                    color = Color.Black,
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Bold
                ), modifier = Modifier.weight(0.7f))
                IconButton(onClick = {  } , modifier = Modifier
                    .weight(0.3f)
                    .align(Alignment.CenterVertically)) {
                    Icon(imageVector = Icons.Default.Delete, contentDescription = "", tint = Color.Red)
                }
            }
            Spacer(modifier = Modifier.height(10.dp))
            Text(text = notesresponse.description, style = TextStyle(
                color = Color.Black.copy(alpha = 0.6f),
                fontSize = 14.sp
            ))
            Spacer(modifier = Modifier.height(5.dp))
            Text(text = notesresponse.updated_at.split("T")[0], style = TextStyle(
                color = Color.Black.copy(alpha = 0.3f),
                fontSize = 10.sp
            ))
        }
    }

}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ShowDialogBox(
    title: String,
    description: String,
    onTitleChange: (String) -> Unit,
    onDescChange: (String) -> Unit,
){
    
    AlertDialog(onDismissRequest = {},
        buttons = {
                  Button(onClick = { }, modifier = Modifier
                      .fillMaxWidth()
                      .padding(15.dp),
                      colors = ButtonDefaults.buttonColors(
                          containerColor = Red,
                          contentColor = Color.White
                      ), contentPadding = PaddingValues(vertical = 15.dp)
                  ) {
                        Text(text = "Save")
                  }
        },
        shape = RoundedCornerShape(10.dp),
        backgroundColor = Background,
        title = {
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.TopEnd){

            }
        },
        text = {
            Column (
                modifier = Modifier.padding(horizontal = 10.dp)
            ){
                AppTextField(text = title,
                    placeholder = "Enter title",
                    onValueChange = onTitleChange)
                
                Spacer(modifier = Modifier.height(15.dp))

                AppTextField(text = description,
                    placeholder = "Enter Description",
                    onValueChange = onDescChange,
                    modifier = Modifier.height(300.dp))
            }
        }
    )

}


@Composable
fun AppTextField(
    text: String,
    modifier: Modifier = Modifier,
    placeholder: String,
    onValueChange: (String) -> Unit
){

    TextField(value = text, onValueChange = onValueChange,
        modifier = modifier.fillMaxWidth(),
        colors = TextFieldDefaults.colors(
            unfocusedLabelColor = ContentColor,
            unfocusedContainerColor = Color.White,
            focusedContainerColor = ContentColor,
        ),
        placeholder = {
            Text(text = placeholder, color = Color.Black.copy(alpha = 0.4f))
        }
    )




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
            Icon(imageVector = Icons.Default.Search, contentDescription = "", tint = Color.Red)
        },
        trailingIcon = {
            if(search.isNotEmpty()){
                IconButton(onClick = {
                    onValueChange("")
                }) {
                    Icon(imageVector = Icons.Default.Clear, contentDescription = )
                }
            }
        },
        placeholder = {
            Text(text = "Search Notes...", style = TextStyle(
                color = Color.Black.copy(alpha = 0.5f),
            ))
        }
        )
    
}