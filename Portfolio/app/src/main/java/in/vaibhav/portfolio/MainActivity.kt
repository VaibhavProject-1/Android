package `in`.vaibhav.portfolio

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Divider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.vaibhav.portfolio.ui.theme.PortfolioTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            PortfolioTheme {
                Portfolio()
            }
        }
    }
}

@Composable
fun Portfolio(modifier: Modifier = Modifier) {
    Surface(
        shadowElevation = 8.dp,
        shape = RoundedCornerShape(12.dp),
        color = MaterialTheme.colorScheme.background,
        modifier = Modifier
            .fillMaxWidth()
            .padding(30.dp)
    ) {
        Column(modifier = Modifier, verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
            Image(painterResource(id =  R.drawable.profile) ,
                contentDescription = "",
                modifier = Modifier.size(60.dp))
            Spacer(
                Modifier
                    .fillMaxWidth()
            )
            Divider()

            Text(text = "Vaibhav Patel", style = TextStyle(color = Color.Green, fontSize = 20.sp, fontWeight = FontWeight.Bold))
            Spacer(
                Modifier
                    .fillMaxWidth()
                    .padding(2.dp)
            )
            Text(text = "Android Compose Developer", style = MaterialTheme.typography.bodySmall)
            Spacer(
                Modifier
                    .fillMaxWidth()
                    .padding(2.dp)
            )
            Row {
                Image(painter = painterResource(id = R.drawable.instagram), contentDescription = "", modifier = Modifier.size(18.dp).padding(end = 5.dp))
                Text(text = "/vaibhav7407", style = MaterialTheme.typography.bodySmall)
            }
        }
        }

}