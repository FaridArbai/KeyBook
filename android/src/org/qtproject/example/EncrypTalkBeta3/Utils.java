package org.qtproject.example.EncrypTalkBeta3;

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



	public static int measure(View root, View decor_view, Context context){
		Utils.DECOR_VIEW = decor_view;
		Utils.CONTEXT = context;
		Utils.ROOT = root;

		root.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener(){
			  public void onGlobalLayout(){
					if(Utils.KEYBOARD_HEIGHT<0){
						synchronized(Utils.OBJ){
							Rect rect = new Rect();

							Utils.DECOR_VIEW.getWindowVisibleDisplayFrame(rect);
							Utils.KEYBOARD_HEIGHT = rect.bottom - rect.top;

							Utils.OBJ.notify();
						}
						Log.i("MyApp","SE HA DETECTADO EL CAMBIO " + Utils.KEYBOARD_HEIGHT);
					}
				}
		});

		return 0;
	}

	public static int get(){
		int keyboard_height;

		synchronized(Utils.OBJ){

			InputMethodManager imm = (InputMethodManager)Utils.CONTEXT.getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);

			try{
				Log.i("MyApp","ESPERANDO");
				Utils.OBJ.wait();
			}catch(Exception ex){};
		}

		InputMethodManager imm = (InputMethodManager)Utils.CONTEXT.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(Utils.ROOT.getWindowToken(),0);

		keyboard_height = Utils.KEYBOARD_HEIGHT;

		return keyboard_height;
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






























