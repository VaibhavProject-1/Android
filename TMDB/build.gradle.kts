// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.1.4" apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false


    id ("com.android.library") version "8.1.4" apply false

    id ("com.google.dagger.hilt.android") version ("2.52") apply false
}

buildscript {
    repositories {
        mavenCentral()
        google()
    }
    dependencies {
        //noinspection GradlePluginVersion
        classpath (libs.gradle)
        classpath (libs.hilt.android.gradle.plugin)
    }
}
