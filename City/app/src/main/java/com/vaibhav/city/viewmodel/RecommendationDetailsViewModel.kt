package com.vaibhav.city.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.city.data.DataProvider
import com.vaibhav.city.model.Recommendation
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class RecommendationDetailsViewModel : ViewModel() {

    private val _recommendation = MutableStateFlow<Recommendation?>(null)
    val recommendation: StateFlow<Recommendation?> = _recommendation

    fun fetchRecommendationDetails(recommendationId: Int) {
        viewModelScope.launch {
            _recommendation.value = DataProvider.recommendations.values.flatten()
                .find { it.id == recommendationId }
        }
    }
}