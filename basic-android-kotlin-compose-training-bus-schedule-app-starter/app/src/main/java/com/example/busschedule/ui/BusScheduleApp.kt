package com.example.busschedule.ui

import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.getValue
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.busschedule.R

enum class BusScheduleScreens {
    FullSchedule,
    RouteSchedule
}

@Composable
fun BusScheduleApp(viewModel: BusScheduleViewModel = viewModel()) {
    val navController = rememberNavController()
    val fullScheduleTitle = stringResource(R.string.full_schedule)
    var topAppBarTitle by remember { mutableStateOf(fullScheduleTitle) }
    val fullSchedule by viewModel.getFullSchedule().collectAsState(emptyList())

    Scaffold(
        topBar = {
            BusScheduleTopAppBar(
                title = topAppBarTitle,
                canNavigateBack = navController.previousBackStackEntry != null,
                onBackClick = {
                    topAppBarTitle = fullScheduleTitle
                    navController.navigateUp()
                }
            )
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = BusScheduleScreens.FullSchedule.name
        ) {
            composable(BusScheduleScreens.FullSchedule.name) {
                FullScheduleScreen(
                    busSchedules = fullSchedule,
                    contentPadding = innerPadding,
                    onScheduleClick = { busStopName ->
                        navController.navigate("${BusScheduleScreens.RouteSchedule.name}/$busStopName")
                        topAppBarTitle = busStopName
                    }
                )
            }

            composable(
                route = BusScheduleScreens.RouteSchedule.name + "/{busStop}",
                arguments = listOf(navArgument("busStop") { type = NavType.StringType })
            ) { backStackEntry ->
                val stopName = backStackEntry.arguments?.getString("busStop") ?: return@composable
                val routeSchedule by viewModel.getScheduleFor(stopName).collectAsState(emptyList())
                RouteScheduleScreen(
                    stopName = stopName,
                    busSchedules = routeSchedule,
                    contentPadding = innerPadding
                )
            }
        }
    }
}
