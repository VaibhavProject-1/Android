package com.vaibhav.usermanagement.ui

import UserScreen
import UserViewModel
import UserViewModelFactory
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vaibhav.usermanagement.utils.DatabaseProvider

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val userDao = DatabaseProvider.getDatabase(applicationContext).userDao()
        setContent {
            val viewModel: UserViewModel = viewModel(factory = UserViewModelFactory(userDao))
            UserScreen(viewModel)
        }
    }
}
