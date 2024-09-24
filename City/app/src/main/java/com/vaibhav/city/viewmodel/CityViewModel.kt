// File: app/src/main/java/com/vaibhav/city/viewmodel/CityViewModel.kt

package com.vaibhav.city.viewmodel

import androidx.lifecycle.ViewModel
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import com.vaibhav.city.data.DataProvider
import com.vaibhav.city.model.Category
import com.vaibhav.city.model.Recommendation

class CityViewModel : ViewModel() {

    // Mutable state to keep track of selected category, initialized with null
    var selectedCategory by mutableStateOf<Category?>(null)
        private set

    // Function to change the selected category
    fun updateSelectedCategory(category: Category) {
        selectedCategory = category
    }

    // Retrieve recommendations for the selected category
    fun getRecommendations(): List<Recommendation> {
        return DataProvider.recommendations[selectedCategory?.id ?: 0] ?: emptyList()
    }
}
