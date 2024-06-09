package `in`.vaibhav.tips

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.vaibhav.tips.model.NutritionTip
import `in`.vaibhav.tips.ui.theme.Poppins

@Composable
fun NutritionTipScreen(nutritionTips: List<NutritionTip>, innerPadding: PaddingValues) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(innerPadding)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Box(modifier = Modifier,contentAlignment = Alignment.Center,){
                Text(
                    text = "Nutrition Tips",
                    style = TextStyle(fontSize = 20.sp, fontWeight = FontWeight.Bold),
                    modifier = Modifier.padding(bottom = 16.dp, start = 140.dp),
                    textAlign = TextAlign.Center
                )
            }

        }

        items(nutritionTips) { tip ->
            NutritionTipCard(tip = tip)
        }
    }
}



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NutritionTipCard(tip: NutritionTip) {
    // Remember whether the card is expanded (description shown) or collapsed
    val isExpanded = remember { mutableStateOf(false) }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 6.dp
        ),
        onClick = { isExpanded.value = !isExpanded.value } // Toggle expansion on click
    ) {
        Column(
            modifier = Modifier
                .padding(16.dp)
                .align(Alignment.CenterHorizontally)
        ) {
            Text(
                text = tip.title,
                style = TextStyle(fontSize = 20.sp, fontWeight = FontWeight.Bold, fontFamily = Poppins),
                modifier = Modifier
                    .padding(bottom = 8.dp)
                    .align(Alignment.CenterHorizontally)
            )
            Image(
                painter = painterResource(id = tip.imageRes),
                contentDescription = null,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .clip(shape = RoundedCornerShape(20.dp))
            )
            Spacer(modifier = Modifier.height(16.dp))

            // Animate the description visibility
            AnimatedVisibility(visible = isExpanded.value) {
                Text(text = tip.description, fontSize = 15.sp, fontFamily = Poppins, fontWeight = FontWeight.Light)
            }
        }
    }
}

