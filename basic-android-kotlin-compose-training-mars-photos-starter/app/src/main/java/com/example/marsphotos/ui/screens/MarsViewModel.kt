/*
 * Copyright (C) 2023 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.marsphotos.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.marsphotos.network.MarsApi
import com.example.marsphotos.network.MarsPhoto
import kotlinx.coroutines.launch
import kotlinx.serialization.SerializationException
import java.io.IOException

sealed interface MarsUiState {
    data class Success(val photos: List<MarsPhoto>, val message: String) : MarsUiState
    object Error : MarsUiState
    object Loading : MarsUiState
}


class MarsViewModel : ViewModel() {
    /** The mutable State that stores the status of the most recent request */
    var marsUiState: MarsUiState by mutableStateOf(MarsUiState.Loading)
        private set

    /**
     * Call getMarsPhotos() on init so we can display status immediately.
     */
    init {
        getMarsPhotos()
    }

    /**
     * Gets Mars photos information from the Mars API Retrofit service and updates the
     * [MarsPhoto] [List] [MutableList].
     */
    private fun getMarsPhotos() {
        viewModelScope.launch {
            try {
                val listResult = MarsApi.retrofitService.getPhotos()
                Log.d("MarsViewModel", "Photos retrieved: ${listResult.size}")
                listResult.forEach { Log.d("MarsViewModel", "Photo ID: ${it.id}, URL: ${it.imgSrc}") }
                marsUiState = MarsUiState.Success(
                    photos = listResult,
                    message = "Success: ${listResult.size} Mars photos retrieved"
                )
            } catch (e: IOException) {
                Log.e("MarsViewModel", "Failed to fetch photos due to network issue", e)
                marsUiState = MarsUiState.Error
            } catch (e: SerializationException) {
                Log.e("MarsViewModel", "Failed to deserialize response", e)
                marsUiState = MarsUiState.Error
            } catch (e: Exception) {
                Log.e("MarsViewModel", "An unexpected error occurred", e)
                marsUiState = MarsUiState.Error
            }
        }
    }

}
