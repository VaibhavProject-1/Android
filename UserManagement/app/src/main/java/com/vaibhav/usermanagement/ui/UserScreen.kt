import UserViewModel
import android.annotation.SuppressLint
import androidx.compose.foundation.layout.Column
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vaibhav.usermanagement.ui.EditUserDialog
import com.vaibhav.usermanagement.ui.UserDetails
import com.vaibhav.usermanagement.ui.UserForm
import com.vaibhav.usermanagement.ui.UserList

@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@Composable
fun UserScreen(viewModel: UserViewModel) {
    var showDialog by remember { mutableStateOf(false) }
    var showDetails by remember { mutableStateOf(false) } // State to track if details are shown

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(onClick = { showDialog = true }) {
                Icon(Icons.Filled.Add, contentDescription = "Add User")
            }
        }
    ) {
        if (showDialog) {
            AlertDialog(
                onDismissRequest = { showDialog = false },
                confirmButton = {
                    TextButton(onClick = { showDialog = false }) {
                        Text("Cancel")
                    }
                },
                title = { Text("Add New User") },
                text = {
                    UserForm(viewModel) {
                        showDialog = false
                    }
                }
            )
        }

        // Show Edit dialog when triggered
        if (viewModel.showEditDialog) {
            EditUserDialog(viewModel = viewModel, onDismiss = { viewModel.showEditDialog = false })
        }

        // Main UI content: User list and selected user details
        Column {
            UserList(viewModel) { selectedUser ->
                showDetails = true
                viewModel.selectUser(selectedUser)
            }
            if (showDetails) {
                UserDetails(viewModel = viewModel, onClose = { showDetails = false }) // Pass the onClose parameter
            }
        }
    }
}
