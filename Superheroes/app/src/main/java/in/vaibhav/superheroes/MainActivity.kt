package `in`.vaibhav.superheroes

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import `in`.vaibhav.superheroes.model.HeroesRepository
import `in`.vaibhav.superheroes.ui.theme.SuperheroesTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            SuperheroesTheme {
                Scaffold(modifier = Modifier.fillMaxSize().height(48.dp), topBar = {
                    SuperHeroesTop()
                }) { innerPadding ->
                    SuperHeroes(
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun SuperHeroesTop(modifier: Modifier = Modifier.height(48.dp)){

}

@Composable
fun SuperHeroes(modifier: Modifier = Modifier) {
    val heroes = HeroesRepository.heroes

    LazyColumn(modifier = modifier) {
        items(heroes) { hero ->
            HeroCard(hero = hero)
        }
    }
}


