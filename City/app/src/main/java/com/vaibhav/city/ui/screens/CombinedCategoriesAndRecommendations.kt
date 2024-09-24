// File: app/src/main/java/com/vaibhav/city/ui/screens/CombinedCategoriesAndRecommendations.kt

package com.vaibhav.city.ui.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.vaibhav.city.data.DataProvider
import com.vaibhav.city.model.Category
import com.vaibhav.city.model.Recommendation

@Composable
fun CombinedCategoriesAndRecommendations(
    navController: NavHostController,
    contentPadding: PaddingValues = PaddingValues(0.dp)
) {
    var selectedCategory by remember { mutableStateOf(DataProvider.categories.firstOrNull()) }

    Row(
        modifier = Modifier
            .padding(contentPadding)
            .fillMaxSize()
    ) {
        // Categories Column
        Column(
            modifier = Modifier
                .weight(1f)
                .padding(16.dp)
        ) {
            LazyColumn {
                items(DataProvider.categories) { category ->
                    CombinedCategoryCard(category) {
                        // Update the selected category
                        selectedCategory = category
                    }
                }
            }
        }

        Spacer(modifier = Modifier.width(16.dp))

        // Recommendations Column
        Column(
            modifier = Modifier
                .weight(2f)
                .padding(16.dp)
        ) {
            selectedCategory?.let { category ->
                val recommendations = DataProvider.recommendations[category.id] ?: emptyList()
                LazyColumn {
                    items(recommendations) { recommendation ->
                        CombinedRecommendationCard(recommendation) {
                            // Navigate to recommendation details
                            navController.navigate("recommendationDetails/${recommendation.id}")
                        }
                    }
                }
            } ?: run {
                // Placeholder message
                Text(
                    text = "Please select a category to view recommendations.",
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.padding(16.dp)
                )
            }
        }
    }
}

@Composable
fun CombinedCategoryCard(category: Category, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
            .clickable { onClick() }
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
                painter = painterResource(id = category.imageResId),
                contentDescription = category.name,
                modifier = Modifier
                    .size(80.dp)
                    .padding(8.dp),
                contentScale = ContentScale.Crop
            )
            Text(
                text = category.name,
                modifier = Modifier.padding(16.dp),
                style = MaterialTheme.typography.titleMedium
            )
        }
    }
}

@Composable
fun CombinedRecommendationCard(recommendation: Recommendation, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
            .clickable { onClick() }
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
                painter = painterResource(id = recommendation.imageResId),
                contentDescription = recommendation.name,
                modifier = Modifier
                    .size(80.dp)
                    .padding(8.dp),
                contentScale = ContentScale.Crop
            )
            Text(
                text = recommendation.name,
                modifier = Modifier.padding(16.dp),
                style = MaterialTheme.typography.titleMedium
            )
        }
    }
}
