package `in`.vaibhav.lemonade

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.vaibhav.lemonade.ui.theme.LemonBackground
import `in`.vaibhav.lemonade.ui.theme.LemonadeTheme
import `in`.vaibhav.lemonade.ui.theme.TopAppBarBackground
import kotlin.random.Random

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            LemonadeTheme {
                LemonadeApp()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LemonadeApp(modifier: Modifier = Modifier) {
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(text = "Lemonade", color = Color.White)
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = TopAppBarBackground
                )
            )
        },
        containerColor = LemonBackground
    ) { innerPadding ->
        LemonadeContent(modifier = modifier.padding(innerPadding))
    }
}

@Composable
fun LemonadeContent(modifier: Modifier = Modifier) {
    var step by remember { mutableStateOf(1) }
    var squeezeCount by remember { mutableStateOf(0) }
    var randomSqueezeCount by remember { mutableStateOf(Random.nextInt(2, 5)) }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(LemonBackground)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        when (step) {
            1 -> {
                LemonStep(
                    text = "Tap the lemon tree to select a lemon",
                    imageResId = R.drawable.lemon_tree,
                    onImageClick = {
                        step = 2
                        randomSqueezeCount = Random.nextInt(2, 5)
                        squeezeCount = 0
                    }
                )
            }
            2 -> {
                LemonStep(
                    text = "Keep tapping the lemon to squeeze it",
                    imageResId = R.drawable.lemon_squeeze,
                    onImageClick = {
                        squeezeCount++
                        if (squeezeCount >= randomSqueezeCount) {
                            step = 3
                        }
                    }
                )
            }
            3 -> {
                LemonStep(
                    text = "Tap the lemonade to drink it",
                    imageResId = R.drawable.lemon_drink,
                    onImageClick = {
                        step = 4
                    }
                )
            }
            4 -> {
                LemonStep(
                    text = "Tap the empty glass to start again",
                    imageResId = R.drawable.lemon_restart,
                    onImageClick = {
                        step = 1
                    }
                )
            }
        }
    }
}

@Composable
fun LemonStep(text: String, imageResId: Int, onImageClick: () -> Unit) {
    Text(
        text = text,
        fontSize = 18.sp,
        modifier = Modifier.padding(16.dp)
    )
    Spacer(modifier = Modifier.height(16.dp))
    Image(
        painter = painterResource(id = imageResId),
        contentDescription = null,
        modifier = Modifier
            .size(200.dp)
            .clickable(onClick = onImageClick)
    )
}

@Preview(showBackground = true)
@Composable
fun LemonadeAppPreview() {
    LemonadeTheme {
        LemonadeApp()
    }
}