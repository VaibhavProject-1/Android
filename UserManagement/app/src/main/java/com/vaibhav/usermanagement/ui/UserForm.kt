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
import androidx.compose.ui.Alignment
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
        TextField(
            value = firstName,
            onValueChange = { firstName = it },
            label = { Text("First Name") },
            modifier = Modifier.fillMaxWidth()
        )
        TextField(
            value = lastName,
            onValueChange = { lastName = it },
            label = { Text("Last Name") },
            modifier = Modifier.fillMaxWidth()
        )
        TextField(
            value = phoneNumber,
            onValueChange = { phoneNumber = it },
            label = { Text("Phone Number") },
            modifier = Modifier.fillMaxWidth()
        )
        TextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("Email") },
            modifier = Modifier.fillMaxWidth()
        )
        TextField(
            value = address,
            onValueChange = { address = it },
            label = { Text("Address") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                val user = User(
                    firstName = firstName,
                    lastName = lastName,
                    phoneNumber = phoneNumber,
                    email = email,
                    address = address
                )
                viewModel.addUser(user)
                onSave() // Close dialog after saving
            },
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = MaterialTheme.colorScheme.onPrimary
            )
        ) {
            Text("Save User")
        }
    }
}


@Composable
fun UserList(viewModel: UserViewModel, onUserClick: (User) -> Unit) {
    val users by viewModel.users.collectAsState()

    if (users.isEmpty()) {
        // If there are no users, display a centered message
        Box(
            modifier = Modifier
                .fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = "No users found. Please add some users.",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
        }
    } else {
        // Display the list of users
        LazyColumn(
            contentPadding = PaddingValues(8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(users) { user ->
                UserItem(
                    user = user,
                    onEdit = {
                        viewModel.selectUser(user)
                        viewModel.showEditDialog = true
                    },
                    onDelete = {
                        viewModel.deleteUser(user)
                    },
                    onClick = {
                        onUserClick(user)
                    }
                )
            }
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
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(8.dp),
        elevation = CardDefaults.cardElevation(8.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface,
            contentColor = MaterialTheme.colorScheme.onSurface
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = "${user.firstName} ${user.lastName}", style = MaterialTheme.typography.headlineSmall)
            Text(text = "Phone: ${user.phoneNumber}", style = MaterialTheme.typography.bodyMedium)


            Spacer(modifier = Modifier.height(8.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                TextButton(onClick = onEdit) {
                    Text("Edit")
                }
                TextButton(onClick = onDelete) {
                    Text("Delete", color = MaterialTheme.colorScheme.error)
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
                .padding(16.dp),
            elevation = CardDefaults.cardElevation(8.dp),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant,
                contentColor = MaterialTheme.colorScheme.onSurface
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(text = "User Details", style = MaterialTheme.typography.headlineSmall)
                    IconButton(onClick = onClose) {
                        Icon(Icons.Filled.Close, contentDescription = "Close")
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                Text(text = "First Name: ${user.firstName}", style = MaterialTheme.typography.bodyLarge)
                Text(text = "Last Name: ${user.lastName}", style = MaterialTheme.typography.bodyLarge)
                Text(text = "Phone: ${user.phoneNumber}", style = MaterialTheme.typography.bodyLarge)
                Text(text = "Email: ${user.email}", style = MaterialTheme.typography.bodyLarge)
                Text(text = "Address: ${user.address}", style = MaterialTheme.typography.bodyLarge)
            }
        }
    }
}

