package com.vaibhav.usermanagement.ui

import UserViewModel
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.vaibhav.usermanagement.data.User

@Composable
fun UserForm(viewModel: UserViewModel, onSave: () -> Unit) {
    var firstName by remember { mutableStateOf("") }
    var lastName by remember { mutableStateOf("") }
    var phoneNumber by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var address by remember { mutableStateOf("") }

    Column(modifier = Modifier.padding(16.dp)) {
        // Input fields
        TextField(value = firstName, onValueChange = { firstName = it }, label = { Text("First Name") })
        TextField(value = lastName, onValueChange = { lastName = it }, label = { Text("Last Name") })
        TextField(value = phoneNumber, onValueChange = { phoneNumber = it }, label = { Text("Phone Number") })
        TextField(value = email, onValueChange = { email = it }, label = { Text("Email") })
        TextField(value = address, onValueChange = { address = it }, label = { Text("Address") })

        Spacer(modifier = Modifier.height(8.dp))

        Button(onClick = {
            val user = User(firstName = firstName, lastName = lastName, phoneNumber = phoneNumber, email = email, address = address)
            viewModel.addUser(user)
            onSave() // Close the dialog
        }) {
            Text("Save")
        }
    }
}

@Composable
fun UserList(viewModel: UserViewModel, onUserClick: (User) -> Unit) {
    val users by viewModel.users.collectAsState()

    LazyColumn {
        items(users) { user ->
            UserItem(
                user = user,
                onEdit = {
                    viewModel.selectUser(user) // Select the user for editing
                    viewModel.showEditDialog = true // Show the edit dialog
                },
                onDelete = {
                    viewModel.deleteUser(user) // Delete the user
                },
                onClick = {
                    onUserClick(user) // Trigger when a user item is clicked
                }
            )
        }
    }
}



@Composable
fun EditUserDialog(viewModel: UserViewModel, onDismiss: () -> Unit) {
    val selectedUser by viewModel.selectedUser.collectAsState()

    selectedUser?.let { user ->
        var firstName by remember { mutableStateOf(user.firstName) }
        var lastName by remember { mutableStateOf(user.lastName) }
        var phoneNumber by remember { mutableStateOf(user.phoneNumber) }
        var email by remember { mutableStateOf(user.email) }
        var address by remember { mutableStateOf(user.address) }

        AlertDialog(
            onDismissRequest = onDismiss,
            confirmButton = {
                TextButton(onClick = {
                    val updatedUser = user.copy(
                        firstName = firstName,
                        lastName = lastName,
                        phoneNumber = phoneNumber,
                        email = email,
                        address = address
                    )
                    viewModel.updateUser(updatedUser) // Update user in the database
                    onDismiss() // Close the dialog
                }) {
                    Text("Save")
                }
            },
            dismissButton = {
                TextButton(onClick = onDismiss) {
                    Text("Cancel")
                }
            },
            title = { Text("Edit User") },
            text = {
                Column {
                    TextField(value = firstName, onValueChange = { firstName = it }, label = { Text("First Name") })
                    TextField(value = lastName, onValueChange = { lastName = it }, label = { Text("Last Name") })
                    TextField(value = phoneNumber, onValueChange = { phoneNumber = it }, label = { Text("Phone Number") })
                    TextField(value = email, onValueChange = { email = it }, label = { Text("Email") })
                    TextField(value = address, onValueChange = { address = it }, label = { Text("Address") })
                }
            }
        )
    }
}


@Composable
fun UserItem(user: User, onEdit: () -> Unit, onDelete: () -> Unit, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .padding(8.dp)
            .fillMaxWidth()
            .clickable(onClick = onClick), // Make the whole card clickable to trigger user details
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = "First Name: ${user.firstName}", style = MaterialTheme.typography.titleMedium)
            Text(text = "Last Name: ${user.lastName}", style = MaterialTheme.typography.titleMedium)

            Spacer(modifier = Modifier.height(8.dp))

            // Row for Edit and Delete buttons
            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                TextButton(onClick = onEdit) {
                    Text("Edit")
                }
                TextButton(onClick = onDelete) {
                    Text("Delete")
                }
            }
        }
    }
}





@Composable
fun UserDetails(viewModel: UserViewModel, onClose: () -> Unit) {
    val selectedUser by viewModel.selectedUser.collectAsState()

    selectedUser?.let { user ->
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight()
                .padding(16.dp),
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(text = "User Details", style = MaterialTheme.typography.titleMedium)
                    IconButton(onClick = onClose) {
                        Icon(Icons.Filled.Close, contentDescription = "Close")
                    }
                }
                Text(text = "First Name: ${user.firstName}", style = MaterialTheme.typography.titleMedium)
                Text(text = "Last Name: ${user.lastName}", style = MaterialTheme.typography.titleMedium)
                Text(text = "Phone Number: ${user.phoneNumber}", style = MaterialTheme.typography.bodyMedium)
                Text(text = "Email: ${user.email}", style = MaterialTheme.typography.bodyMedium)
                Text(text = "Address: ${user.address}", style = MaterialTheme.typography.bodyMedium)
            }
        }
    }
}
