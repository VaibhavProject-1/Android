package `in`.vaibhav.tipsplitcalc

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Slider
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun TipCalculator(modifier: Modifier = Modifier) {

    val amount = remember {
        mutableStateOf("")
    }

    val personCounter = remember {
        mutableIntStateOf(1)
    }

    val tipPercentage = remember {
        mutableFloatStateOf(0f)
    }


    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally) {
        TotalHeader(amount = formatTwoDecimalPoint(getTotalHeaderAmount(amount.value,
            personCounter.intValue,
            tipPercentage.value)))
        UserInputArea(
            amount = amount.value,
            amountChange = {
                amount.value = it
            },
            personCounter = personCounter.intValue,
            onAddOrReducePerson = {
                if(it<0){
                    if (personCounter.intValue!= 1){
                        personCounter.intValue--
                    }
                }
                else{
                    personCounter.intValue++
                }
            },
            tipPercentage = tipPercentage.floatValue,
            tipPercentageChange = {
                tipPercentage.floatValue = it
            }
        )


    }
}

@Composable
fun TotalHeader(modifier: Modifier = Modifier, amount: String) {
    Surface (
        modifier
            .fillMaxWidth()
            .padding(24.dp), color = Color.Cyan, shape = RoundedCornerShape(8.dp)
    ) {
        Column (modifier= Modifier
            .fillMaxWidth()
            .padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = "Total Per Person",
                style = TextStyle(color = Color.Black, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "$ $amount",
                style = TextStyle(color = Color.Black, fontSize = 28.sp, fontWeight = FontWeight.Bold)
            )
        }
    }
}

@Composable
fun UserInputArea(modifier: Modifier = Modifier,
                  amount: String, amountChange:(String) -> Unit,
                  personCounter: Int,
                  onAddOrReducePerson:(Int) -> Unit,
                  tipPercentage: Float,
                  tipPercentageChange: (Float) -> Unit
) {

    val keyboardController = LocalSoftwareKeyboardController.current

    Surface(modifier = Modifier
        .fillMaxWidth()
        .padding(12.dp), shape = RoundedCornerShape(12.dp), shadowElevation = 12.dp) {
        Column (modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp), horizontalAlignment = Alignment.CenterHorizontally){
            OutlinedTextField(value = amount, onValueChange = {amountChange.invoke(it)},modifier = Modifier
                .fillMaxWidth(), placeholder = { Text(text = "Enter Your Amount") },
                keyboardOptions = KeyboardOptions(autoCorrect = true, keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(onDone = {
                    keyboardController?.hide()
                })
            )

            if(amount.isNotBlank()){

                Spacer(modifier = Modifier.height(4.dp))

                Row(modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(text = "Split", style = MaterialTheme.typography.titleLarge)

                    Spacer(modifier = Modifier.fillMaxWidth(.50f))

                    CustomButton(imageVector = Icons.Default.KeyboardArrowUp) {
                        onAddOrReducePerson.invoke(1)
                    }

                    Text(text = "$personCounter", style = MaterialTheme.typography.titleLarge, modifier = Modifier.padding(8.dp))


                    CustomButton(imageVector = Icons.Default.KeyboardArrowDown) {
                        onAddOrReducePerson.invoke(-1)
                    }

                }

                Spacer(modifier = Modifier.height(12.dp))

                Row(modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(text = "Tip" , style = MaterialTheme.typography.titleLarge)

                    Spacer(modifier = Modifier.fillMaxWidth(.70f))

                    Text(text = "$ ${formatTwoDecimalPoint(getTipAmount(amount,tipPercentage))}", style = MaterialTheme.typography.titleLarge)
                }

                Spacer(modifier = Modifier.height(8.dp))

                Text(text = "${formatTwoDecimalPoint(tipPercentage.toString()) }%" , style = MaterialTheme.typography.titleLarge)

                Spacer(modifier = Modifier.height(8.dp))

                Slider(value = tipPercentage, onValueChange = {
                    tipPercentageChange.invoke(it)
                }, valueRange = 0f..100f, modifier = Modifier
                    .padding(horizontal = 12.dp)
                    .fillMaxWidth())
            }


        }
    }
}