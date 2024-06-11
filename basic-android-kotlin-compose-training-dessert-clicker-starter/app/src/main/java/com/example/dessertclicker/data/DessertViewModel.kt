package com.example.dessertclicker.data

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.yourapp.ui.determineDessertToShow

class DessertViewModel : ViewModel() {
    private val _revenue = MutableLiveData(0)
    val revenue: LiveData<Int> = _revenue

    private val _dessertsSold = MutableLiveData(0)
    val dessertsSold: LiveData<Int> = _dessertsSold

    private val _currentDessert = MutableLiveData(Datasource.dessertList.first())
    val currentDessert: MutableLiveData<com.example.dessertclicker.model.Dessert> = _currentDessert

    fun onDessertClicked() {
        _revenue.value = _revenue.value?.plus(_currentDessert.value?.price ?: 0)
        _dessertsSold.value = _dessertsSold.value?.plus(1)

        _currentDessert.value = determineDessertToShow(Datasource.dessertList, _dessertsSold.value ?: 0)
    }

    private fun determineDessertToShow(desserts: List<Dessert>, dessertsSold: Int): Dessert {
        var dessertToShow = desserts.first()
        for (dessert in desserts) {
            if (dessertsSold >= dessert.startProductionAmount) {
                dessertToShow = dessert
            } else {
                break
            }
        }
        return dessertToShow
    }
}