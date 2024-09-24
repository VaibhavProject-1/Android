package com.vaibhav.city.viewmodel

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import com.vaibhav.city.data.DataProvider
import com.vaibhav.city.model.Category
import com.vaibhav.city.model.Recommendation

class CityViewModel(private val savedStateHandle: SavedStateHandle) : ViewModel() {

    // Key to save and retrieve the selected category
    private val SELECTED_CATEGORY_KEY = "selectedCategory"

    // Retrieve saved state or use the first category by default
    var selectedCategory: Category?
        get() = savedStateHandle[SELECTED_CATEGORY_KEY] ?: DataProvider.categories.firstOrNull()
        private set(value) {
            savedStateHandle[SELECTED_CATEGORY_KEY] = value
        }

    // Function to change the selected category
    fun updateSelectedCategory(category: Category) {
        selectedCategory = category
    }

    // Retrieve recommendations for the selected category
    fun getRecommendations(): List<Recommendation> {
        return DataProvider.recommendations[selectedCategory?.id ?: 0] ?: emptyList()
    }
}
