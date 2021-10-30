package com.atv.gruas

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {

        
    //    // Handle the splash screen transition.
    //    val splashScreen = installSplashScreen()

    //    setContentView(R.layout.main_activity)



    // Aligns the Flutter view vertically with the window.
//TODO: TEST THIS FUNCTION... IS FOR THE NEW NATIVE SPLASH SCREEN ON ANDROID 12
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
    //   WindowCompat.setDecorFitsSystemWindows(getWindow(), false)
      // Disable the Android splash screen fade out animation to avoid
      // a flicker before the similar frame is drawn in Flutter.
      splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
    }

    super.onCreate(savedInstanceState)
  }
}
