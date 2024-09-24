package com.vaibhav.city.data

import com.vaibhav.city.R
import com.vaibhav.city.model.Category
import com.vaibhav.city.model.Recommendation

object DataProvider {

    val categories = listOf(
        Category(1, "Coffee Shops", R.drawable.coffee_shops),
        Category(2, "Restaurants", R.drawable.restaurants),
        Category(3, "Kid-Friendly Places", R.drawable.kid_friendly),
        Category(4, "Parks", R.drawable.parks),
        Category(5, "Shopping Centers", R.drawable.mall)
    )

    val recommendations = mapOf(
        1 to listOf(
            Recommendation(101, "Cafe Mocha", "Great coffee and desserts", R.drawable.cafe_mocha),
            Recommendation(102, "Java House", "Cozy place with amazing coffee", R.drawable.java_house)
        ),
        2 to listOf(
            Recommendation(201, "Bistro 21", "Delicious food with a cozy atmosphere", R.drawable.bistro_21),
            Recommendation(202, "Spice Avenue", "Authentic Indian cuisine", R.drawable.spice_avenue)
        ),
        3 to listOf(
            Recommendation(301, "Fun World", "A great place for kids to play", R.drawable.fun_world),
            Recommendation(302, "Dino Park", "Dinosaur-themed park for kids", R.drawable.dino_park)
        ),
        4 to listOf(
            Recommendation(401, "Green Park", "Beautiful park with lots of trees", R.drawable.green_park),
            Recommendation(402, "Sunset Gardens", "Perfect for an evening stroll", R.drawable.sunset_gardens)
        ),
        5 to listOf(
            Recommendation(501, "City Mall", "Shopping, food, and entertainment", R.drawable.mall),
            Recommendation(502, "Market Plaza", "All your shopping needs in one place", R.drawable.market_plaza)
        )
    )
}