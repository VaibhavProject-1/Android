package com.example.busschedule.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.busschedule.data.BusSchedule
import java.text.SimpleDateFormat
import java.util.*

@Composable
fun FullScheduleScreen(
    busSchedules: List<BusSchedule>,
    onScheduleClick: (String) -> Unit,
    modifier: Modifier = Modifier,
    contentPadding: PaddingValues = PaddingValues(0.dp)
) {
    BusScheduleScreen(
        busSchedules = busSchedules,
        onScheduleClick = onScheduleClick,
        contentPadding = contentPadding,
        modifier = modifier
    )
}

@Composable
fun RouteScheduleScreen(
    stopName: String,
    busSchedules: List<BusSchedule>,
    modifier: Modifier = Modifier,
    contentPadding: PaddingValues = PaddingValues(0.dp)
) {
    BusScheduleScreen(
        busSchedules = busSchedules,
        modifier = modifier,
        contentPadding = contentPadding,
        stopName = stopName
    )
}

@Composable
fun BusScheduleScreen(
    busSchedules: List<BusSchedule>,
    modifier: Modifier = Modifier,
    contentPadding: PaddingValues = PaddingValues(0.dp),
    stopName: String? = null,
    onScheduleClick: ((String) -> Unit)? = null
) {
    val stopNameText = if (stopName == null) "Stop Name" else "$stopName Schedule"

    Column(modifier = modifier.padding(contentPadding)) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = stopNameText)
            Text(text = "Arrival Time")
        }
        Divider()
        LazyColumn {
            items(busSchedules) { busSchedule ->
                BusScheduleItem(
                    busSchedule = busSchedule,
                    onClick = onScheduleClick
                )
            }
        }
    }
}

@Composable
fun BusScheduleItem(
    busSchedule: BusSchedule,
    onClick: ((String) -> Unit)? = null
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick?.invoke(busSchedule.stopName) }
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = busSchedule.stopName,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.weight(1f)
        )
        Text(
            text = SimpleDateFormat("h:mm a", Locale.getDefault())
                .format(Date(busSchedule.arrivalTime * 1000L)),
            textAlign = TextAlign.End,
            modifier = Modifier.weight(1f)
        )
    }
}
