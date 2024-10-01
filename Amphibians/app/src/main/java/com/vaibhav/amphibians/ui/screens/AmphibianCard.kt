package com.vaibhav.amphibians.ui.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.rememberImagePainter
import com.vaibhav.amphibians.model.Amphibian

@Composable
fun AmphibianCard(amphibian: Amphibian) {
    Card(modifier = Modifier.padding(8.dp)) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = "${amphibian.name} (${amphibian.type})", fontSize = 20.sp, fontWeight = FontWeight.Bold)
            Image(
                painter = rememberImagePainter(amphibian.img_src),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(text = amphibian.description, fontWeight = FontWeight.SemiBold)
        }
    }
}