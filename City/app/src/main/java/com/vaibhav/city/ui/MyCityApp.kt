package com.vaibhav.city.ui

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.windowsizeclass.WindowWidthSizeClass
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.vaibhav.city.ui.screens.CategoryScreen
import com.vaibhav.city.ui.screens.CombinedCategoriesAndRecommendations
import com.vaibhav.city.ui.screens.RecommendationScreen
import com.vaibhav.city.ui.screens.RecommendationDetailsScreen

@Composable
fun MyCityApp(
    windowSize: WindowWidthSizeClass,
    contentPadding: PaddingValues = PaddingValues(0.dp)
) {
    val navController = rememberNavController()

    if (windowSize == WindowWidthSizeClass.Compact) {
        MobileLayout(navController = navController, contentPadding = contentPadding)
    } else {
        TabletLayout(navController = navController, contentPadding = contentPadding)
    }
}

// Mobile Layout Composable
@Composable
fun MobileLayout(navController: NavHostController, contentPadding: PaddingValues) {
    NavHost(navController = navController, startDestination = "categories") {
        composable("categories") {
            CategoryScreen(navController = navController, contentPadding = contentPadding)
        }
        composable("recommendations/{categoryId}") { backStackEntry ->
            val categoryId = backStackEntry.arguments?.getString("categoryId")?.toInt() ?: 0
            RecommendationScreen(
                categoryId = categoryId,
                navController = navController,
                contentPadding = contentPadding
            )
        }
        composable("recommendationDetails/{recommendationId}") { backStackEntry ->
            val recommendationId = backStackEntry.arguments?.getString("recommendationId")?.toInt() ?: 0
            RecommendationDetailsScreen(
                recommendationId = recommendationId,
                navController = navController,
                contentPadding = contentPadding
            )
        }
    }
}

// Tablet Layout Composable
@Composable
fun TabletLayout(navController: NavHostController, contentPadding: PaddingValues) {
    NavHost(navController = navController, startDestination = "categories_with_recommendations") {
        composable("categories_with_recommendations") {
            CombinedCategoriesAndRecommendations(
                navController = navController,
                contentPadding = contentPadding
            )
        }
    }
}