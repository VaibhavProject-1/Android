package com.vaibhav.city.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.city.data.DataProvider
import com.vaibhav.city.model.Recommendation
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class RecommendationViewModel : ViewModel() {

    private val _recommendations = MutableStateFlow<List<Recommendation>>(emptyList())
    val recommendations: StateFlow<List<Recommendation>> = _recommendations

    fun fetchRecommendations(categoryId: Int) {
        viewModelScope.launch {
            _recommendations.value = DataProvider.recommendations[categoryId] ?: emptyList()
        }
    }
}