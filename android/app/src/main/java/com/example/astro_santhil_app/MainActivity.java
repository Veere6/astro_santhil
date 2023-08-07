package com.example.astro_santhil_app;

import static android.app.Activity.RESULT_OK;

import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.util.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "my_channel"; // Must match the Dart code

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("pickImage")) {
                        // Implement image picking logic here
                        // For example, start an image picker activity
//                         You can use result.success("Image picked successfully");
//                        result.success("Image picked successfully");


//                        if (call.method.equals("pickImage")) {
                            Intent pickImageIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                            startActivityForResult(pickImageIntent, 123); // Use a unique request code
//                        }

                    } else if (call.method.equals("pickContact")) {
                        // Implement contact picking logic here
                        // You can use result.success("Contact picked successfully");
//                        if (call.method.equals("pickContact")) {
                            Intent pickContactIntent = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI);
                            startActivityForResult(pickContactIntent, 456); // Use a unique request code
//                        }
                    } else {
                        if(call.method.equals("onImagePicked")){
                            result.success(result);
                        }
                    }
                });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        Log.e("TAG", "onActivityResult: "+requestCode );
        if (requestCode == 123) {
            Log.e("TAG", "onActivityResult: "+data );
            if (resultCode == RESULT_OK && data != null) {
                String imageUri = data.getData().toString();
                new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                        .invokeMethod("onImagePicked", imageUri);
                Log.e("TAG", "onActivityResult: "+imageUri );
            }
        } else if (requestCode == 456) {
            Log.e("TAG", "onActivityResult: "+resultCode);
            if (resultCode == RESULT_OK && data != null) {
                String contactUri = data.getData().toString();

                Log.e("TAG", "onActivityResult: "+contactUri );
                new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                        .invokeMethod("onContactPicked", contactUri);
            }
        }
    }



}
