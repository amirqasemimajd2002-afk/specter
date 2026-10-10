pluginManagement {
    // پیدا کردن مسیر SDK فلاتر بدون استفاده از import
    val localPropertiesFile = java.io.File(settingsDir, "local.properties")
    val localProperties = java.util.Properties()
    
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader().use { localProperties.load(it) }
    }
    
    // اگر در local.properties نبود، از متغیر محیطی یا مسیر پیش‌فرض استفاده کن
    val flutterSdkPath = localProperties.getProperty("flutter.sdk") 
        ?: System.getenv("FLUTTER_ROOT") 
        ?: "C:\\src\\flutter"
    
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.4.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        google()
        mavenCentral()
    }
}

rootProject.name = "specter"
include(":app")
