package org.qtproject.example.EncrypTalkBeta3;

import android.app.Activity;
import android.view.View;
import android.view.Window;
import android.graphics.Rect;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.util.Log;
import android.view.ViewTreeObserver;
import java.lang.String;
import java.lang.Exception;
import java.lang.Thread;
import android.app.ProgressDialog;


public class Utils {
	static int KEYBOARD_HEIGHT = -1;
	static View DECOR_VIEW;
	static Context CONTEXT;
	static View ROOT;
	static String OBJ = "Algo";

	static int last_height;

	public static int getKeyboardHeight(View decor_view, Context context){
		Rect rect = new Rect();
		int diff;

		decor_view.getWindowVisibleDisplayFrame(rect);
		diff = rect.bottom-rect.top;

		return diff;
	}

	public static int getAppHeight(View decor_view){
		Rect rect = new Rect();
		int height;

		decor_view.getWindowVisibleDisplayFrame(rect);
		height = rect.bottom-rect.top;

		return height;
	}

	public static int getAppWidth(View decor_view){
		Rect rect = new Rect();
		int width;

		decor_view.getWindowVisibleDisplayFrame(rect);
		width = rect.right-rect.left;

		return width;
	}

	public static int measureVKeyboardHeight(int app_height, Activity activity){
		View decor_view = activity.getWindow().getDecorView();
		Rect rect = new Rect();
		decor_view.getWindowVisibleDisplayFrame(rect);

		int visible_height = rect.bottom - rect.top;
		int keyboard_height = app_height - visible_height;

		Utils.KEYBOARD_HEIGHT = keyboard_height;

		return keyboard_height;
	}

	public static void initOnGlobalLayoutListener(Activity activity){
		View root_view = activity.findViewById(android.R.id.content);
		final View decor_view = activity.getWindow().getDecorView();

		root_view.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener(){
			public void onGlobalLayout(){
				Rect rect = new Rect();
				decor_view.getWindowVisibleDisplayFrame(rect);

				int current_height = rect.bottom - rect.top;
				int diff = current_height - Utils.last_height;

				if(diff==Utils.KEYBOARD_HEIGHT){
					MyJavaNatives.notifyVKeyboardClosed();
				}

				Utils.last_height = current_height;
			}
		});
	}

	public static ProgressDialog dialog;

	public static void showProgressDialog(String message, Context context){
		if(dialog!=null){
			dialog.dismiss();
		}

		dialog = new ProgressDialog(context);
		dialog.setMessage(message);
		dialog.setCanceledOnTouchOutside(false);
		dialog.setCancelable(false);
		dialog.show();
	}

	public static void dismissProgressDialog(){
		if(dialog!=null){
			dialog.dismiss();
			dialog = null;
		}
	}

}

class MyJavaNatives{
	public static native void notifyVKeyboardClosed();
}




























