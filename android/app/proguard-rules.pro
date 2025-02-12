# Flutter optimizations
-keep class io.flutter.** { *; }
-keep class com.example.yourapp.** { *; } # Change `yourapp` to your actual package name
-keep class androidx.lifecycle.** { *; }

# Keep all Flutter engine classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Avoid obfuscating Dart classes used by Flutter
-keep class com.example.** { *; }

# Allow reflection
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
