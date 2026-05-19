plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")

    // Flutter
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "com.example.androidstudioprojects"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    compileOptions {

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // 🔥 NECESARIO PARA NOTIFICACIONES
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {

        applicationId = "com.example.androidstudioprojects"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
    }

    buildTypes {

        release {

            signingConfig =
                signingConfigs.getByName("debug")
        }
    }
}

dependencies {

    // 🔥 NECESARIO PARA flutter_local_notifications
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.2"
    )
}

flutter {
    source = "../.."
}