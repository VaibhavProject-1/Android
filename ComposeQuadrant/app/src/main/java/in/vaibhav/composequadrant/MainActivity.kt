package `in`.vaibhav.composequadrant

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.vaibhav.composequadrant.ui.theme.ComposeQuadrantTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ComposeQuadrantTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting()
                }
            }
        }
    }
}

@Composable
fun Greeting( modifier: Modifier = Modifier) {
    val r1head1 = stringResource(R.string.Row1head1)
    val r1head2 = stringResource(R.string.Row1head2)
    val r2head1 = stringResource(R.string.Row2head1)
    val r2head2 = stringResource(R.string.Row2head2)
    val r1para1 = stringResource(R.string.Row1para1)
    val r1para2 = stringResource(R.string.Row1para2)
    val r2para1 = stringResource(R.string.Row2para1)
    val r2para2 = stringResource(R.string.Row2para2)

    val Q1 = colorResource(id = R.color.Q1)
    val Q2 = colorResource(id = R.color.Q2)
    val Q3 = colorResource(id = R.color.Q3)
    val Q4 = colorResource(id = R.color.Q4)
    Column (modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally){
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.Center
        ) {
            Column(
                modifier = Modifier
                    .background(color = Q1)
                    .weight(1f)
                    .padding(horizontal = 16.dp, vertical = 8.dp) // Adjust padding to leave equal space
                    .fillMaxHeight(0.5f),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            )
            {
                Text(text = r1head1,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 16.dp))
                Text(text = r1para1,
                    textAlign = TextAlign.Justify)
            }
            Column(
                modifier = Modifier
                    .background(color = Q2)
                    .weight(1f)
                    .padding(horizontal = 16.dp, vertical = 8.dp) // Adjust padding to leave equal space
                    .fillMaxHeight(0.5f),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            )
            {
                Text(text = r1head2,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 16.dp))
                Text(text = r1para2,
                    textAlign = TextAlign.Justify)
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        )  {
            Column(
                modifier = Modifier
                    .background(color = Q3)
                    .weight(1f)
                    .padding(horizontal = 16.dp, vertical = 8.dp) // Adjust padding to leave equal space
                    .fillMaxHeight(1f),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            )
            {
                Text(text = r2head1,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 16.dp))
                Text(text = r2para1,
                    textAlign = TextAlign.Justify)
            }
            Column(
                modifier = Modifier
                    .background(color = Q4)
                    .weight(1f)
                    .padding(horizontal = 16.dp, vertical = 8.dp) // Adjust padding to leave equal space
                    .fillMaxHeight(1f),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            )
            {
                Text(text = r2head2,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 16.dp))
                Text(text = r2para2,
                    textAlign = TextAlign.Justify)
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    ComposeQuadrantTheme {
        Greeting()
    }
}