plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.abudiyab.workshop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.abudiyab.workshop"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 6
        versionName = "1.0.3"
    }
    signingConfigs {
        create("release") {
            storeFile = file("F:/Abu-Diyab-Auto-Workshop/my-release-key.jks")
            storePassword = "workavsc"
            keyAlias = "my-key"
            keyPassword = "workavsc"
        }
    }
    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }

    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ في Kotlin DSL تكتب كده
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // Firebase services
    implementation("com.google.firebase:firebase-messaging")
}
