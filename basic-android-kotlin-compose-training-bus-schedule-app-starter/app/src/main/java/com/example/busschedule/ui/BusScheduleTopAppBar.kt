package com.example.busschedule.ui

import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.ui.res.stringResource
import com.example.busschedule.R

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BusScheduleTopAppBar(
    title: String,
    canNavigateBack: Boolean,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    if (canNavigateBack) {
        TopAppBar(
            title = { Text(title) },
            navigationIcon = {
                IconButton(onClick = onBackClick) {
                    Icon(
                        imageVector = Icons.Filled.ArrowBack,
                        contentDescription = stringResource(R.string.back)
                    )
                }
            },
            modifier = modifier
        )
    } else {
        TopAppBar(
            title = { Text(title) },
            modifier = modifier
        )
    }
}
