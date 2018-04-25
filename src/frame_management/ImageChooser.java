package org.qtproject.example.EncrypTalkBeta3;

import org.qtproject.qt5.android.bindings.QtActivity;
import android.content.Intent;
import android.app.Activity;

public class ImagePicker extends QtActivity {
	 public static Intent imagePicker() {
		  Intent i = new Intent(Intent.ACTION_PICK);
		  i.setType( "image/*");
		  return Intent.createChooser(i, "Select Image");
	 }
}
