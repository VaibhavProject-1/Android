package com.vaibhav.amphibians.ui

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.amphibians.data.AmphibianRepository
import com.vaibhav.amphibians.model.Amphibian
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AmphibianViewModel @Inject constructor(
    private val repository: AmphibianRepository
) : ViewModel() {

    var amphibianUiState by mutableStateOf<AmphibianUiState>(AmphibianUiState.Loading)
        private set

    init {
        fetchAmphibians()
    }

    private fun fetchAmphibians() {
        viewModelScope.launch {
            amphibianUiState = try {
                AmphibianUiState.Success(repository.getAmphibians())
            } catch (e: Exception) {
                AmphibianUiState.Error
            }
        }
    }
}

sealed class AmphibianUiState {
    object Loading : AmphibianUiState()
    data class Success(val amphibians: List<Amphibian>) : AmphibianUiState()
    object Error : AmphibianUiState()
}