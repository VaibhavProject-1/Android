package com.example.dessertclicker.ui.theme

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.dessertclicker.data.DessertViewModel
import com.example.yourapp.ui.determineDessertToShow
import com.example.yourapp.ui.shareSoldDessertsInformation

@Composable
fun DessertClickerApp(
    dessertViewModel: DessertViewModel = viewModel()
) {
    val revenue = dessertViewModel.revenue.observeAsState(0)
    val dessertsSold = dessertViewModel.dessertsSold.observeAsState(0)
    val currentDessert = dessertViewModel.currentDessert.observeAsState()

    Scaffold(
        topBar = {
            val intentContext = LocalContext.current
            val layoutDirection = LocalLayoutDirection.current
            DessertClickerAppBar(
                onShareButtonClicked = {
                    shareSoldDessertsInformation(
                        intentContext = intentContext,
                        dessertsSold = dessertsSold.value ?: 0,
                        revenue = revenue.value ?: 0
                    )
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(
                        start = WindowInsets.safeDrawing.asPaddingValues()
                            .calculateStartPadding(layoutDirection),
                        end = WindowInsets.safeDrawing.asPaddingValues()
                            .calculateEndPadding(layoutDirection),
                    )
                    .background(MaterialTheme.colorScheme.primary)
            )
        }
    ) { contentPadding ->
        currentDessert.value?.let { dessert ->
            DessertClickerScreen(
                revenue = revenue.value ?: 0,
                dessertsSold = dessertsSold.value ?: 0,
                dessertImageId = dessert.imageId,
                onDessertClicked = { dessertViewModel.onDessertClicked() },
                modifier = Modifier.padding(contentPadding)
            )
        }
    }
}