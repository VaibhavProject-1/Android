plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.jetbrains.kotlin.android)
}

android {
    namespace = "in.vaibhav.notesfirst"
    compileSdk = 34

    defaultConfig {
        applicationId = "in.vaibhav.notesfirst"
        minSdk = 25
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.1"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {

    val daggerHilt = "2.47"
    val coroutine = "1.7.3"
    val ktor_version = "2.2.3"
    val retrofit = "2.9.0"
    val okhttp = "4.10.0"
    val moshi = "1.13.0"

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.ui)
    implementation(libs.androidx.ui.graphics)
    implementation(libs.androidx.ui.tooling.preview)
    implementation(libs.androidx.material3)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.ui.test.junit4)
    debugImplementation(libs.androidx.ui.tooling)
    debugImplementation(libs.androidx.ui.test.manifest)

    //dagger hilt
    implementation("com.google.dagger:hilt-android:$daggerHilt")
    implementation("androidx.hilt:hilt-navigation-compose:1.1.0")

    //coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutine")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutine")

    //ktor
    implementation("io.ktor:ktor-client-android:$ktor_version")
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktor_version")
    implementation("io.ktor:ktor-client-content-negotiation:$ktor_version")
    implementation("io.ktor:ktor-client-logging:$ktor_version")
    implementation("io.ktor:ktor-client-gson:$ktor_version")
    implementation("io.ktor:ktor-serialization-gson:$ktor_version")

    //retrofit
    implementation ("com.squareup.retrofit2:retrofit:$retrofit")

    //moshi
    implementation ("com.squareup.moshi:moshi-kotlin:$moshi")
    implementation ("com.squareup.retrofit2:converter-moshi:$retrofit")

    implementation(platform("com.squareup.okhttp3:okhttp-bom:$okhttp"))

    // define any required OkHttp artifacts without version
    implementation("com.squareup.okhttp3:okhttp")
    implementation("com.squareup.okhttp3:logging-interceptor")
}