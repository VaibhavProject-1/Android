# Razorpay SDK rules
-keep class com.razorpay.** { *; }
-keepclassmembers class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep proguard.annotation package classes (if they're missing)
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers