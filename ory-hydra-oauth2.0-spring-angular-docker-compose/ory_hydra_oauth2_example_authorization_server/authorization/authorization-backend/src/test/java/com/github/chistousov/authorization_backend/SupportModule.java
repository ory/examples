package com.github.chistousov.authorization_backend;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.AbstractMap.SimpleImmutableEntry;
import java.util.Base64;
import java.util.Random;

public class SupportModule {

  /**
   * <p>
   * Get query parameters from String
   * </p>
   *
   * @param it - String (query parameters)
   *
   * @return SimpleImmutableEntry - query parameters
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public static SimpleImmutableEntry<String, String> splitQueryParameter(String it) {
    final int idx = it.indexOf("=");
    final String key = idx > 0 ? it.substring(0, idx) : it;
    final String value = idx > 0 && it.length() > idx + 1 ? it.substring(idx + 1) : null;
    return new SimpleImmutableEntry<>(
        URLDecoder.decode(key, StandardCharsets.UTF_8),
        URLDecoder.decode(value, StandardCharsets.UTF_8));
  }

  /**
   * <p>
   * Generate random String
   * </p>
   *
   * @return random String
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public static String generateRandomStr() {
    int leftLimit = 97;
    int rightLimit = 122;
    int targetStringLength = 30;
    Random random = new Random();
    StringBuilder buffer = new StringBuilder(targetStringLength);
    for (int i = 0; i < targetStringLength; i++) {
      int randomLimitedInt = leftLimit + (int) (random.nextFloat() * (rightLimit - leftLimit + 1));
      buffer.append((char) randomLimitedInt);
    }
    return buffer.toString();
  }

  /**
   * <p>
   * Generate random Code Verifier (PKCE)
   * </p>
   *
   * @return code verifier
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public static String generateCodeVerifier() throws UnsupportedEncodingException {
    SecureRandom secureRandom = new SecureRandom();
    byte[] codeVerifier = new byte[32];
    secureRandom.nextBytes(codeVerifier);
    return Base64.getUrlEncoder().withoutPadding().encodeToString(codeVerifier);
  }

  /**
   * <p>
   * Generate random Code Challange (PKCE)
   * </p>
   *
   * @return code challange
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public static String generateCodeChallange(String codeVerifier)
      throws UnsupportedEncodingException, NoSuchAlgorithmException {
    byte[] bytes = codeVerifier.getBytes("US-ASCII");
    MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
    messageDigest.update(bytes, 0, bytes.length);
    byte[] digest = messageDigest.digest();
    return Base64.getUrlEncoder().withoutPadding().encodeToString(digest);
  }
}
