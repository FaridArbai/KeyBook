package org.qtproject.example.EncrypTalkBeta3;

import android.util.Base64;
import android.util.Log;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

public class AndroidEncryptionUtils {
	private static final String TAG = "AndroidEncryptionUtils";

	private static final String PEM = "-----BEGIN PUBLIC KEY-----\n" +
									 "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA36F1ad/VQcnDRSuh95Lc\n" +
									 "xaiaMFz9KSuSDQZTKZV5wq3N2BVMhzbWFZhCexwVbGZNwlOrSLxVAzGQlmT3nRD8\n" +
									 "pef2gL90MSyuH9VRF+Wypq2XvKp48CScu6QruzeYkq9GJS/Ow55Ofei8TyKEz27j\n" +
									 "r3EdFIBQpQfNAytdOEkDIZQFryZwrtsAQ7D/TAsXbIlpsYPQETnS9FeqFiuyey96\n" +
									 "OnfDaiF0LgRaP44FyWPKh9PtTiMDAUVAapSNrK6mFZ29jfBNPKbOgRbS4CnxS6P6\n" +
									 "tUZ/O1/sYrEymwgp9EBdx62I4wl5I+uvzbt0Nld2qkETwLyDweenjTdSiz2IlB2L\n" +
									 "qwIDAQAB\n" +
									 "-----END PUBLIC KEY-----";

	private static PublicKey PUBLIC_KEY;


	public static void init(){
		try{
			AndroidEncryptionUtils.PUBLIC_KEY =
					AndroidEncryptionUtils.pemToPublicKey(AndroidEncryptionUtils.PEM);
		} catch(Exception ex) {
			ex.printStackTrace();
		}
	}

	private static PublicKey pemToPublicKey(String pem) throws Exception{
		PublicKey public_key = null;
		BufferedReader pem_reader;

		pem_reader = new BufferedReader(new InputStreamReader(
				new ByteArrayInputStream(pem.getBytes("UTF-8"))
		));

		StringBuffer content = new StringBuffer();
		String line = null;

		while((line=pem_reader.readLine())!=null){
			if(line.indexOf("-----BEGIN PUBLIC KEY-----")!=-1){
				while((line=pem_reader.readLine())!=null){
					if(line.indexOf("-----END PUBLIC KEY-----")!=-1){
						break;
					}
					content.append(line.trim());
				}
				break;
			}
		}

		if(line==null){
			Log.d(TAG, "pemToPublicKey: ERROR DE LECTURA: LINE==NULL");
		}
		else{
			Log.d(TAG, "pemToPublicKey: CONTENIDO : " + content.toString());

			KeyFactory factory = KeyFactory.getInstance("RSA");

			public_key = factory.generatePublic(
					new X509EncodedKeySpec(Base64.decode(content.toString(),
							Base64.DEFAULT)));
		}


		return public_key;
	}


	public static String rsaPublicEncrypt(String message){
		message = message + "\0";
		String encoded = null;

		try {
			Cipher cipher = Cipher.getInstance("RSA/NONE/PKCS1Padding");

			cipher.init(Cipher.ENCRYPT_MODE, PUBLIC_KEY);

			byte[] encrypted = cipher.doFinal(message.getBytes());

			encoded = Base64.encodeToString(encrypted, Base64.DEFAULT);

		}catch(Exception ex) {
			ex.printStackTrace();
		}

		return encoded;
	}


}
